using GestorCuidado.Models;
using Microsoft.EntityFrameworkCore;

namespace GestorCuidado.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

        public DbSet<Paciente> Pacientes { get; set; }
        public DbSet<Familiare> Familiares { get; set; }
        public DbSet<Empleado> Empleados { get; set; }
    }
}
