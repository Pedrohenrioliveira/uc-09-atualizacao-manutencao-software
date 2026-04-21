using ApiPetshop.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ApiPetshop.Data.Configurations;

public class AgendamentoConfiguration : IEntityTypeConfiguration<Agendamento>
{
    public void Configure(EntityTypeBuilder<Agendamento> builder)
    {
        builder.HasKey(a => a.Id);

        builder.Property(a => a.NomeTutor)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(a => a.NomePet)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(a => a.Servico)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(a => a.DataAgendamento)
            .IsRequired();

        builder.Property(a => a.Telefone)
            .IsRequired()
            .HasMaxLength(20);

        builder.Property(a => a.DataCriacao)
            .IsRequired();
    }
}