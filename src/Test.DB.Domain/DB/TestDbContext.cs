using Microsoft.EntityFrameworkCore;
using TEST.ProductsApi.DB.Models;

namespace Test.DB.Domain.DB;

public class TestDbContext : DbContext
{
    public virtual DbSet<Product> Products { get; set; } = default!;

    public TestDbContext(DbContextOptions<TestDbContext> options) : base(options)
    {
    }
}
