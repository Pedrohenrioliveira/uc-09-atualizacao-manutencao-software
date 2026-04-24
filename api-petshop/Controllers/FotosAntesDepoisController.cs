using ApiPetshop.Data;
using ApiPetshop.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ApiPetshop.Controllers;

/// <summary>
/// A classe Controller define as rotas da API na web e quais métodos (endpoints)
/// serão executados dependendo da requisição HTTP (GET, POST, DELETE, etc.).
/// </summary>
[ApiController] // Identifica esta classe como um Controlador de API (habilita validações automáticas, etc.)
[Route("api/fotos")] // Define o caminho (URL) principal: ex. http://localhost:5000/api/fotos
public class FotosAntesDepoisController : ControllerBase
{
    // Variável para armazenar a instância da comunicação do banco de dados (Contexto)
    private readonly AppDbContext _context;

    // Construtor do Controller: O ASP.NET Injeta o "AppDbContext" automaticamente (Injeção de Dependências)
    public FotosAntesDepoisController(AppDbContext context)
    {
        _context = context;
    }

    /// <summary>
    /// Rota: GET /api/fotos
    /// Retorna uma lista em formato JSON com todas as fotos salvas no banco de dados.
    /// </summary>
    [HttpGet]
    public async Task<IActionResult> ObterTodas()
    {
        // Pede ao EntityFramework para buscar todos os registros da tabela "FotosAntesDepois"
        var fotos = await _context.FotosAntesDepois.ToListAsync();
        
        // Retorna o status HTTP 200 (Ok) junto com os dados encontrados
        return Ok(fotos);
    }

    /// <summary>
    /// Rota: POST /api/fotos/upload
    /// Rota responsável por receber a imagem do cachorro e as informações vindas do formulário HTML/JS.
    /// É o momento onde o arquivo é fisicamente salvo no servidor e seus dados no banco.
    /// </summary>
    [HttpPost("upload")]
    [Consumes("multipart/form-data")] // Assinatura obrigatória para recebimento de arquivos em formulários web!
    public async Task<IActionResult> UploadFoto([FromForm] UploadFotoDto request)
    {
        // 1. Validação básica: garante que recebemos os arquivos
        if (request.ArquivoAntes == null || request.ArquivoAntes.Length == 0 ||
            request.ArquivoDepois == null || request.ArquivoDepois.Length == 0)
            return BadRequest("Os dois arquivos (Antes e Depois) são obrigatórios.");

        // 2. Diretório físico: cria/encontra a pasta "wwwroot/uploads" no servidor/projeto onde vamos salvar as fotos
        var uploadsPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads");
        if (!Directory.Exists(uploadsPath))
            Directory.CreateDirectory(uploadsPath);

        // 3. Nomes seguros
        var fileNameAntes = $"{Guid.NewGuid()}_antes_{request.ArquivoAntes.FileName}";
        var fileNameDepois = $"{Guid.NewGuid()}_depois_{request.ArquivoDepois.FileName}";
        
        var filePathAntes = Path.Combine(uploadsPath, fileNameAntes);
        var filePathDepois = Path.Combine(uploadsPath, fileNameDepois);

        // 4. Salva os arquivos
        using (var streamAntes = new FileStream(filePathAntes, FileMode.Create))
        {
            await request.ArquivoAntes.CopyToAsync(streamAntes);
        }
        
        using (var streamDepois = new FileStream(filePathDepois, FileMode.Create))
        {
            await request.ArquivoDepois.CopyToAsync(streamDepois);
        }

        // 5. Prepara o objeto: Cria a entidade principal que será salva no banco de dados
        var foto = new FotoAntesDepois
        {
            NomeCachorro = request.NomeCachorro,
            CaminhoFotoAntes = $"uploads/{fileNameAntes}",
            CaminhoFotoDepois = $"uploads/{fileNameDepois}",
            DataCriacao = DateTime.UtcNow
        };
        
        // 6. Grava no banco e salva (Commit)
        _context.FotosAntesDepois.Add(foto);
        await _context.SaveChangesAsync();

        // 7. Retorna "Created" (HTTP 201)
        return CreatedAtAction(nameof(ObterTodas), new { id = foto.Id }, foto);
    }

    /// <summary>
    /// Rota: DELETE /api/fotos/{id}
    /// Deleta exclusivamente um item baseado em seu ID (ex. DELETE http://localhost:5000/api/fotos/3). 
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<IActionResult> Deletar(int id)
    {
        var foto = await _context.FotosAntesDepois.FindAsync(id);
        
        if (foto == null)
            return NotFound(new { mensagem = "Foto não encontrada." });

        var caminhoImagemAntes = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", foto.CaminhoFotoAntes.Replace("/", Path.DirectorySeparatorChar.ToString()));
        if (System.IO.File.Exists(caminhoImagemAntes))
            System.IO.File.Delete(caminhoImagemAntes);

        var caminhoImagemDepois = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", foto.CaminhoFotoDepois.Replace("/", Path.DirectorySeparatorChar.ToString()));
        if (System.IO.File.Exists(caminhoImagemDepois))
            System.IO.File.Delete(caminhoImagemDepois);

        _context.FotosAntesDepois.Remove(foto);
        await _context.SaveChangesAsync();

        return Ok(new { mensagem = "Fotos excluídas com sucesso." });
    }
}
