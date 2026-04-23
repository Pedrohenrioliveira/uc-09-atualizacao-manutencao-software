using ApiPetshop.Models;
using Microsoft.EntityFrameworkCore;

namespace ApiPetshop.Data;

/// <summary>
/// A classe AppDbContext é o "coração" do Entity Framework Core.
/// Ela gerencia a conexão com o banco de dados e mapeia nossas classes (Models) para tabelas no banco.
/// </summary>
public class AppDbContext : DbContext
{
    // Construtor que recebe as opções de configuração (como a string de conexão)
    // e repassa para a classe base (DbContext)
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    // O DbSet representa uma tabela no banco de dados.
    // Neste caso, a tabela armazenará objetos do tipo "FotoAntesDepois".
    public DbSet<FotoAntesDepois> FotosAntesDepois { get; set; }
    public DbSet<Contato> Contatos { get; set; }
    public DbSet<Agendamento> Agendamentos { get; set; }
    public DbSet<Depoimento> Depoimentos { get; set; }

    /// <summary>
    /// Este método é chamado quando o modelo de banco de dados está sendo criado.
    /// Usamos ele para aplicar configurações extras às tabelas, mapeamentos específicos e regras de validação.
    /// </summary>
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Aplica as configurações definidas na classe FotoAntesDepoisConfiguration (restrições, tamanho de campos, etc.)
        modelBuilder.ApplyConfiguration(new Configurations.FotoAntesDepoisConfiguration());
        modelBuilder.ApplyConfiguration(new Configurations.ContatoConfiguration());
        modelBuilder.ApplyConfiguration(new Configurations.AgendamentoConfiguration());
        modelBuilder.ApplyConfiguration(new Configurations.DepoimentoConfiguration());
        // Chama o comportamento padrão da classe base
        base.OnModelCreating(modelBuilder);
    }
}
