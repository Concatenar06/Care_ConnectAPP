using GestorCuidado.Data; // Para el DbContext
using Microsoft.EntityFrameworkCore; // Para configurar la base de datos

var builder = WebApplication.CreateBuilder(args);

// Configurar el DbContext con la cadena de conexi�n
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Registrar los controladores en los servicios
builder.Services.AddControllers();

// Configurar Swagger (opcional, para documentaci�n de API)
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configuraci�n del pipeline de la aplicaci�n
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers(); // Aseg�rate de tener esta l�nea para que se mapeen los controladores

app.Run();
