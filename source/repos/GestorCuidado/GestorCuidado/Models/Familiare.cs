using System;
using System.Collections.Generic;

namespace GestorCuidado.Models;

public partial class Familiare
{
    public int Id { get; set; }

    public string Nombre { get; set; } = null!;

    public string? Parentesco { get; set; }

    public string? Telefono { get; set; }

    public int? PacienteId { get; set; }

    public virtual Paciente? Paciente { get; set; }
}
