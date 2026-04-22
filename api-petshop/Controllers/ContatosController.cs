using ApiPetshop.Data;
using ApiPetshop.Models;
using Microsoft.AspNetCore.Mvc;

namespace ApiPetshop.Controllers;

[ApiController]
[Route("api/contatos")]
public class ContatosController : ControllerBase
{
    private readonly AppDbContext _context;

    public ContatosController(AppDbContext context)
    {
        _context = context;
    }

    [HttpPost]
    public async Task<IActionResult> Criar([FromBody] Contato contato)
    {
        if (string.IsNullOrWhiteSpace(contato.Nome))
            return BadRequest(new { mensagem = "O nome é obrigatório." });

        if (string.IsNullOrWhiteSpace(contato.Email))
            return BadRequest(new { mensagem = "O e-mail é obrigatório." });

        if (string.IsNullOrWhiteSpace(contato.Mensagem))
            return BadRequest(new { mensagem = "A mensagem é obrigatória." });

        contato.DataCriacao = DateTime.UtcNow;

        _context.Contatos.Add(contato);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            mensagem = "Contato salvo com sucesso.",
            contato
        });
    }
}