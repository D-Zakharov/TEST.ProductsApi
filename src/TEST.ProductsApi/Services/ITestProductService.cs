using TEST.ProductsApi.DB.Models;
using TEST.ProductsApi.Models;

namespace TEST.ProductsApi.Services
{
    public interface ITestProductService
    {
        Guid CreateProduct(ProductCreation creationData);
        void DeleteProduct(Guid productID);
        IList<Product> GetProductsList(string? namePart);
        void UpdateProduct(Product product);
    }
}
