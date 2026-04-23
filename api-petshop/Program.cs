using ApiPetshop.Data;
using Microsoft.EntityFrameworkCore;

// Inicializa o criador (builder) da aplicação Web
var builder = WebApplication.CreateBuilder(args);

// Configuração do CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
    });
});

// String de conexão
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// Banco de dados MySQL
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseMySql(
        connectionString,
        new MySqlServerVersion(new Version(8, 0, 36)),
        mySqlOptions => mySqlOptions.EnableRetryOnFailure()
    )
);

// Controllers
builder.Services.AddControllers();

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new() { Title = "ApiPetshop", Version = "v1" });
});

var app = builder.Build();

// Swagger tradicional
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(); // ✅ AQUI É A TROCA PRINCIPAL
}

// HTTPS
app.UseHttpsRedirection();

// Arquivos estáticos
app.UseStaticFiles();

// CORS
app.UseCors("AllowAll");

// Autorização
app.UseAuthorization();

// Controllers
app.MapControllers();

// Banco + Seed
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate();
    SeedData.Seed(db);
}

// Run
app.Run();