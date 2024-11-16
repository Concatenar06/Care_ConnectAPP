using GestorCuidado.Data;
using GestorCuidado.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace GestorCuidado.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmpleadosController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        // Inyectamos el DbContext
        public EmpleadosController(ApplicationDbContext context)
        {
            _context = context;
        }

        // Obtener todos los empleados
        [HttpGet]
        public ActionResult<List<Empleado>> GetEmpleados()
        {
            return _context.Empleados.ToList(); 
        }

        // Obtener un empleado por ID
        [HttpGet("{id}")]
        public ActionResult<Empleado> GetEmpleado(int id)
        {
            var empleado = _context.Empleados.Find(id);
            if (empleado == null)
            {
                return NotFound();
            }
            return empleado;
        }

        // Crear un nuevo empleado
        [HttpPost]
        public ActionResult<Empleado> PostEmpleado(Empleado empleado)
        {
            _context.Empleados.Add(empleado);
            _context.SaveChanges();
            return CreatedAtAction(nameof(GetEmpleado), new { id = empleado.Id }, empleado);
        }

        // Actualizar un empleado existente
        [HttpPut("{id}")]
        public IActionResult PutEmpleado(int id, Empleado empleado)
        {
            if (id != empleado.Id)
            {
                return BadRequest();
            }

            _context.Entry(empleado).State = EntityState.Modified;
            _context.SaveChanges();

            return NoContent();
        }

        // Eliminar un empleado
        [HttpDelete("{id}")]
        public IActionResult DeleteEmpleado(int id)
        {
            var empleado = _context.Empleados.Find(id);
            if (empleado == null)
            {
                return NotFound();
            }

            _context.Empleados.Remove(empleado);
            _context.SaveChanges();

            return NoContent();
        }
    }
}

