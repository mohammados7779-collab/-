namespace AlBaraaHR.Models
{
    public class Employee
    {
        public int Id { get; set; }
        public required string Name { get; set; }
        public string? Role { get; set; }
        public string? Email { get; set; }
    }
}
