using Microsoft.EntityFrameworkCore;
using AlBaraaHR.Models;
using System.IO;

namespace AlBaraaHR.Data
{
    public class AppDbContext : DbContext
    {
        public DbSet<Employee> Employees => Set<Employee>();

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            var folder = Directory.GetCurrentDirectory();
            var dbPath = Path.Combine(folder, "AlBaraaHR.db");
            optionsBuilder.UseSqlite($"Data Source={dbPath}");
        }
    }
}
