using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows;
using Microsoft.EntityFrameworkCore;
using AlBaraaHR.Data;
using AlBaraaHR.Models;
using AlBaraaHR.Services;

namespace AlBaraaHR
{
    public partial class MainWindow : Window
    {
        private readonly EmployeeService _service;
        private ObservableCollection<Employee> _employees = new();

        public MainWindow()
        {
            InitializeComponent();

            var db = new AppDbContext();
            db.Database.Migrate(); // ينشئ قاعدة البيانات والجداول عند التشغيل لأول مرة
            _service = new EmployeeService(db);

            LoadEmployees();
        }

        private void LoadEmployees()
        {
            var list = _service.GetAll().ToList();
            _employees = new ObservableCollection<Employee>(list);
            EmployeesGrid.ItemsSource = _employees;
        }

        private void BtnAdd_Click(object sender, RoutedEventArgs e)
        {
            var emp = new Employee { Name = "موظف جديد", Role = "وظيفة", Email = "example@domain.com" };
            _service.Add(emp);
            _employees.Add(emp);
        }

        private void BtnEdit_Click(object sender, RoutedEventArgs e)
        {
            if (EmployeesGrid.SelectedItem is Employee sel)
            {
                sel.Name += " (معدل)";
                _service.Update(sel);
                EmployeesGrid.Items.Refresh();
            }
        }

        private void BtnDelete_Click(object sender, RoutedEventArgs e)
        {
            if (EmployeesGrid.SelectedItem is Employee sel)
            {
                _service.Delete(sel.Id);
                _employees.Remove(sel);
            }
        }

        private void BtnExport_Click(object sender, RoutedEventArgs e)
        {
            var sb = new StringBuilder();
            sb.AppendLine("Id,Name,Role,Email");
            foreach (var e1 in _service.GetAll())
                sb.AppendLine($"{e1.Id},{Quote(e1.Name)},{Quote(e1.Role)},{Quote(e1.Email)}");

            File.WriteAllText("employees_export.csv", sb.ToString(), Encoding.UTF8);
            MessageBox.Show("تم التصدير إلى employees_export.csv", "تصدير", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        private static string Quote(string? s)
        {
            if (s == null) return "";
            return $"\"{s.Replace("\"", "\"\"")}\"";
        }
    }
}
