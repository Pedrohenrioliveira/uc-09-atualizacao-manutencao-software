namespace ApiPetshop.Models;

public class Agendamento
{
    public int Id { get; set; }

    public string NomeTutor { get; set; } = string.Empty;

    public string NomePet { get; set; } = string.Empty;

    public string Servico { get; set; } = string.Empty;

    public DateTime DataAgendamento { get; set; }

    public string Telefone { get; set; } = string.Empty;

    public DateTime DataCriacao { get; set; } = DateTime.UtcNow;
}