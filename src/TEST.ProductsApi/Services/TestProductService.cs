using Microsoft.EntityFrameworkCore;
using Test.DB.Domain.DB;
using TEST.ProductsApi.DB.Models;
using TEST.ProductsApi.ExceptionHandling;
using TEST.ProductsApi.Models;

namespace TEST.ProductsApi.Services
{
    public class TestProductService : ITestProductService
    {
        private readonly TestDbContext _dbCtx;

        public TestProductService(TestDbContext dbCtx)
        {
            _dbCtx = dbCtx;
        }

        public Guid CreateProduct(ProductCreation creationData)
        {
            var newItem = new Product() { ID = new Guid(), Name = creationData.ProductName, Description = creationData.Description };
            _dbCtx.Products.Add(newItem);
            _dbCtx.SaveChanges();
            return newItem.ID;
        }

        public void DeleteProduct(Guid productID)
        {
            var item = _dbCtx.Products.Find(productID);
            if (item is null)
                throw new ApiException(string.Format(ExceptionMessages.ItemNotFound, productID), ExceptionCodes.ItemNotFound);

            _dbCtx.Products.Remove(item);
            _dbCtx.SaveChanges();
        }

        public IList<Product> GetProductsList(string? namePart)
        {
            return _dbCtx.Products.Where(i => namePart == null || i.Name.Contains(namePart)).AsNoTracking().ToList();
        }

        public void UpdateProduct(Product product)
        {
            if (_dbCtx.Products.Any(i => i.ID == product.ID) == false)
                throw new ApiException(string.Format(ExceptionMessages.ItemNotFound, product.ID), ExceptionCodes.ItemNotFound);

            _dbCtx.Products.Update(product);
            _dbCtx.SaveChanges();
        }
    }
}
