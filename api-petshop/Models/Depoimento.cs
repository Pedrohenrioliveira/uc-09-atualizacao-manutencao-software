namespace ApiPetshop.Models;

public class Depoimento
{
    public int Id { get; set; }

    public string NomeCliente { get; set; } = string.Empty;

    public string Texto { get; set; } = string.Empty;

    public string CaminhoFoto { get; set; } = string.Empty;

    public DateTime DataCriacao { get; set; } = DateTime.UtcNow;
}