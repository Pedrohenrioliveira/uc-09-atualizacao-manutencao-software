using Microsoft.AspNetCore.Http;

namespace ApiPetshop.Models;

public class UploadDepoimentoDto
{
    public string NomeCliente { get; set; } = string.Empty;

    public string Texto { get; set; } = string.Empty;

    public IFormFile? Arquivo { get; set; }
}