using System.ComponentModel.DataAnnotations.Schema;

namespace TEST.ProductsApi.DB.Models;

[Table("Product", Schema = "Prd")]
public class Product
{
    public Guid ID { get; set; }
    
    public string Name { get; set; } = default!;
    
    public string? Description { get; set; }
}
