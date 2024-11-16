using GestorCuidado.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using GestorCuidado.Data;
using GestorCuidado.Models;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;

namespace GestorCuidado.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PacientesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        // Constructor que inyecta el DbContext
        public PacientesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // Método GET para obtener todos los pacientes
        [HttpGet]
        public ActionResult<List<Paciente>> GetPacientes()
        {
            // Obtiene todos los pacientes de la base de datos
            return _context.Pacientes.ToList();
        }
    }
}

