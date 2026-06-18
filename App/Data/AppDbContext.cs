using Microsoft.EntityFrameworkCore;
using AlBaraaHR.Models;
using System.IO;
using System.Text.Json;

namespace AlBaraaHR.Data
{
    public class AppDbContext : DbContext
    {
        public DbSet<Employee> Employees => Set<Employee>();

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (optionsBuilder.IsConfigured) return;

            // Default to LocalDB connection. Try to read appsettings.json for an override.
            string defaultConn = "Server=(localdb)\\MSSQLLocalDB;Database=AlBaraaHR;Trusted_Connection=True;";
            try
            {
                var jsonPath = Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json");
                if (File.Exists(jsonPath))
                {
                    using var stream = File.OpenRead(jsonPath);
                    using var doc = JsonDocument.Parse(stream);
                    if (doc.RootElement.TryGetProperty("ConnectionStrings", out var cs) &&
                        cs.TryGetProperty("DefaultConnection", out var def))
                    {
                        var conn = def.GetString();
                        if (!string.IsNullOrWhiteSpace(conn))
                        {
                            defaultConn = conn!;
                        }
                    }
                }
            }
            catch
            {
                // If anything fails, fall back to the default LocalDB connection.
            }

            optionsBuilder.UseSqlServer(defaultConn);
        }
    }
}
