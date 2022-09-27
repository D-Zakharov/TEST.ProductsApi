using System.ComponentModel.DataAnnotations;

namespace TEST.ProductsApi.Models
{
    public class ProductCreation
    {
        public string ProductName { get; set; } = default!;
        public string? Description { get; set; }
    }
}
