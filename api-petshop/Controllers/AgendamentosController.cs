using ApiPetshop.Data;
using ApiPetshop.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ApiPetshop.Controllers;

[ApiController]
[Route("api/agendamentos")]
public class AgendamentosController : ControllerBase
{
    private readonly AppDbContext _context;

    public AgendamentosController(AppDbContext context)
    {
        _context = context;
    }

    [HttpPost]
    public async Task<IActionResult> Criar([FromBody] Agendamento agendamento)
    {
        if (string.IsNullOrWhiteSpace(agendamento.NomeTutor))
            return BadRequest(new { mensagem = "O nome do tutor é obrigatório." });

        if (string.IsNullOrWhiteSpace(agendamento.NomePet))
            return BadRequest(new { mensagem = "O nome do pet é obrigatório." });

        if (string.IsNullOrWhiteSpace(agendamento.Servico))
            return BadRequest(new { mensagem = "O serviço é obrigatório." });

        if (string.IsNullOrWhiteSpace(agendamento.Telefone))
            return BadRequest(new { mensagem = "O telefone é obrigatório." });

        if (agendamento.DataAgendamento == default)
            return BadRequest(new { mensagem = "A data do agendamento é obrigatória." });

        agendamento.DataCriacao = DateTime.UtcNow;

        _context.Agendamentos.Add(agendamento);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            mensagem = "Agendamento salvo com sucesso.",
            agendamento
        });
    }

    [HttpGet]
    public async Task<IActionResult> Listar()
    {
        var agendamentos = await _context.Agendamentos
            .OrderByDescending(a => a.DataAgendamento)
            .ToListAsync();

        return Ok(agendamentos);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Excluir(int id)
    {
        var agendamento = await _context.Agendamentos.FindAsync(id);

        if (agendamento == null)
            return NotFound(new { mensagem = "Agendamento não encontrado." });

        _context.Agendamentos.Remove(agendamento);
        await _context.SaveChangesAsync();

        return Ok(new { mensagem = "Agendamento excluído com sucesso." });
    }
}