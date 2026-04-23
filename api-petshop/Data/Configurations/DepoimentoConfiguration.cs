using ApiPetshop.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ApiPetshop.Data.Configurations;

public class DepoimentoConfiguration : IEntityTypeConfiguration<Depoimento>
{
    public void Configure(EntityTypeBuilder<Depoimento> builder)
    {
        builder.HasKey(d => d.Id);

        builder.Property(d => d.NomeCliente)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(d => d.Texto)
            .IsRequired()
            .HasMaxLength(1000);

        builder.Property(d => d.CaminhoFoto)
            .IsRequired()
            .HasMaxLength(255);

        builder.Property(d => d.DataCriacao)
            .IsRequired();
    }
}