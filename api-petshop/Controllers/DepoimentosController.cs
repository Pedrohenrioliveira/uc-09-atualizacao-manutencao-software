using ApiPetshop.Data;
using ApiPetshop.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ApiPetshop.Controllers;

[ApiController]
[Route("api/depoimentos")]
public class DepoimentosController : ControllerBase
{
    private readonly AppDbContext _context;

    public DepoimentosController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> Listar()
    {
        var depoimentos = await _context.Depoimentos
            .OrderByDescending(d => d.DataCriacao)
            .ToListAsync();

        return Ok(depoimentos);
    }

    [HttpPost("upload")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> Upload([FromForm] UploadDepoimentoDto request)
    {
        if (string.IsNullOrWhiteSpace(request.NomeCliente))
            return BadRequest(new { mensagem = "O nome do cliente é obrigatório." });

        if (string.IsNullOrWhiteSpace(request.Texto))
            return BadRequest(new { mensagem = "O texto do depoimento é obrigatório." });

        if (request.Arquivo == null || request.Arquivo.Length == 0)
            return BadRequest(new { mensagem = "A foto do depoimento é obrigatória." });

        var uploadsPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads", "depoimentos");

        if (!Directory.Exists(uploadsPath))
            Directory.CreateDirectory(uploadsPath);

        var fileName = $"{Guid.NewGuid()}_{request.Arquivo.FileName}";
        var filePath = Path.Combine(uploadsPath, fileName);

        using (var stream = new FileStream(filePath, FileMode.Create))
        {
            await request.Arquivo.CopyToAsync(stream);
        }

        var depoimento = new Depoimento
        {
            NomeCliente = request.NomeCliente,
            Texto = request.Texto,
            CaminhoFoto = $"uploads/depoimentos/{fileName}",
            DataCriacao = DateTime.UtcNow
        };

        _context.Depoimentos.Add(depoimento);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            mensagem = "Depoimento cadastrado com sucesso.",
            depoimento
        });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Atualizar(int id, [FromBody] AtualizarDepoimentoDto request)
    {
        var depoimento = await _context.Depoimentos.FindAsync(id);

        if (depoimento == null)
            return NotFound(new { mensagem = "Depoimento não encontrado." });

        if (string.IsNullOrWhiteSpace(request.NomeCliente))
            return BadRequest(new { mensagem = "O nome do cliente é obrigatório." });

        if (string.IsNullOrWhiteSpace(request.Texto))
            return BadRequest(new { mensagem = "O texto do depoimento é obrigatório." });

        depoimento.NomeCliente = request.NomeCliente;
        depoimento.Texto = request.Texto;

        await _context.SaveChangesAsync();

        return Ok(new
        {
            mensagem = "Depoimento atualizado com sucesso.",
            depoimento
        });
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Excluir(int id)
    {
        var depoimento = await _context.Depoimentos.FindAsync(id);

        if (depoimento == null)
            return NotFound(new { mensagem = "Depoimento não encontrado." });

        var caminhoImagem = Path.Combine(
            Directory.GetCurrentDirectory(),
            "wwwroot",
            depoimento.CaminhoFoto.Replace("/", Path.DirectorySeparatorChar.ToString())
        );

        if (System.IO.File.Exists(caminhoImagem))
        {
            System.IO.File.Delete(caminhoImagem);
        }

        _context.Depoimentos.Remove(depoimento);
        await _context.SaveChangesAsync();

        return Ok(new { mensagem = "Depoimento excluído com sucesso." });
    }
}