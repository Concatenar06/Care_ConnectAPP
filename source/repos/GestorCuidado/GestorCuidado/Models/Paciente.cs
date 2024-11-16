using System;
using System.Collections.Generic;

namespace GestorCuidado.Models;

public partial class Paciente
{
    public int Id { get; set; }

    public string Nombre { get; set; } = null!;

    public string? Direccion { get; set; }

    public string? Telefono { get; set; }

    public string? Estado { get; set; }

    public virtual ICollection<Familiare> Familiares { get; set; } = new List<Familiare>();
}
