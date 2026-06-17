using System.Collections.Generic;
using System.Linq;
using AlBaraaHR.Data;
using AlBaraaHR.Models;
using Microsoft.EntityFrameworkCore;

namespace AlBaraaHR.Services
{
    public class EmployeeService
    {
        private readonly AppDbContext _db;
        public EmployeeService(AppDbContext db)
        {
            _db = db;
        }

        public IEnumerable<Employee> GetAll() => _db.Employees.AsNoTracking().ToList();

        public Employee Add(Employee e)
        {
            _db.Employees.Add(e);
            _db.SaveChanges();
            return e;
        }

        public void Update(Employee e)
        {
            _db.Employees.Update(e);
            _db.SaveChanges();
        }

        public void Delete(int id)
        {
            var ent = _db.Employees.Find(id);
            if (ent != null)
            {
                _db.Employees.Remove(ent);
                _db.SaveChanges();
            }
        }
    }
}
