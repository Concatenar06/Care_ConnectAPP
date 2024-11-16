using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace GestorCuidado.Models;

public partial class GestorCuidadoContext : DbContext
{
    public GestorCuidadoContext(DbContextOptions<GestorCuidadoContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Empleado> Empleados { get; set; }

    public virtual DbSet<Familiare> Familiares { get; set; }

    public virtual DbSet<Paciente> Pacientes { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Empleado>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Empleado__3214EC076EFD51C7");

            entity.HasIndex(e => e.Correo, "UQ__Empleado__60695A19000C4062").IsUnique();

            entity.Property(e => e.Contraseña).HasMaxLength(256);
            entity.Property(e => e.Correo).HasMaxLength(100);
            entity.Property(e => e.FechaRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Nombre).HasMaxLength(100);
            entity.Property(e => e.Rol).HasMaxLength(50);
            entity.Property(e => e.Telefono).HasMaxLength(15);
        });

        modelBuilder.Entity<Familiare>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Familiar__3214EC072C768367");

            entity.Property(e => e.Nombre).HasMaxLength(100);
            entity.Property(e => e.Parentesco).HasMaxLength(50);
            entity.Property(e => e.Telefono).HasMaxLength(15);

            entity.HasOne(d => d.Paciente).WithMany(p => p.Familiares)
                .HasForeignKey(d => d.PacienteId)
                .HasConstraintName("FK__Familiare__Pacie__3F466844");
        });

        modelBuilder.Entity<Paciente>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Paciente__3214EC07A7C3D81A");

            entity.Property(e => e.Direccion).HasMaxLength(255);
            entity.Property(e => e.Estado)
                .HasMaxLength(50)
                .HasDefaultValue("Activo");
            entity.Property(e => e.Nombre).HasMaxLength(100);
            entity.Property(e => e.Telefono).HasMaxLength(15);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
