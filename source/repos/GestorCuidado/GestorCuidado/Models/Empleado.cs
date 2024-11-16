using System;
using System.Collections.Generic;

namespace GestorCuidado.Models;

public partial class Empleado
{
    public int Id { get; set; }

    public string Nombre { get; set; } = null!;

    public string Rol { get; set; } = null!;

    public string Correo { get; set; } = null!;

    public string? Contraseña { get; set; }

    public string? Telefono { get; set; }

    public DateTime? FechaRegistro { get; set; }
}
