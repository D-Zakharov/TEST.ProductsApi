using Microsoft.EntityFrameworkCore;
using Moq;
using Test.DB.Domain.DB;
using TEST.ProductsApi.DB;
using TEST.ProductsApi.DB.Models;
using TEST.ProductsApi.ExceptionHandling;
using TEST.ProductsApi.Services;

namespace UnitTests
{
    public class Tests
    {
        private ITestProductService _productService;
        private TestDbContext _mockDbCtx;

        [SetUp]
        public void Setup()
        {
            var productsData = new List<Product>()
            {
                new Product() { ID = Guid.NewGuid(), Name = "Static product" }
            };

            var mockDbCtx = new Mock<TestDbContext>(new DbContextOptions<TestDbContext>());
            mockDbCtx.Setup(c => c.Products).Returns(CreateQueryableMockDbSet(productsData));
            _mockDbCtx = mockDbCtx.Object;

            _productService = new TestProductService(_mockDbCtx);
        }

        [Test]
        public void Delete_Product_Throws_NotExists()
        {
            var ex = Assert.Throws<ApiException>(delegate { _productService.DeleteProduct(Guid.Empty); });

            Assert.That(ex.ExceptionCode, Is.EqualTo(ExceptionCodes.ItemNotFound));
        }

        [Test]
        public void GetListByFilter_ReturnsOneItem()
        {
            var res = _productService.GetProductsList("Static");

            Assert.That(res.Count, Is.EqualTo(1));
        }

        private static DbSet<T> CreateQueryableMockDbSet<T>(List<T> sourceList) where T : class
        {
            var queryable = sourceList.AsQueryable();

            var dbSet = new Mock<DbSet<T>>();
            dbSet.As<IQueryable<T>>().Setup(m => m.Provider).Returns(queryable.Provider);
            dbSet.As<IQueryable<T>>().Setup(m => m.Expression).Returns(queryable.Expression);
            dbSet.As<IQueryable<T>>().Setup(m => m.ElementType).Returns(queryable.ElementType);
            dbSet.As<IQueryable<T>>().Setup(m => m.GetEnumerator()).Returns(() => queryable.GetEnumerator());
            dbSet.Setup(i => i.Add(It.IsAny<T>())).Callback<T>((j) => sourceList.Add(j));

            return dbSet.Object;
        }
    }
}