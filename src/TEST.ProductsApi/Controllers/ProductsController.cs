using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using TEST.ProductsApi.DB.Models;
using TEST.ProductsApi.ExceptionHandling;
using TEST.ProductsApi.Models;
using TEST.ProductsApi.Services;

namespace TEST.ProductsApi.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]
    public class ProductsController : ControllerBase
    {
        private readonly ITestProductService _dictService;

        public ProductsController(ITestProductService dictService)
        {
            _dictService = dictService;
        }

        [HttpGet]
        [ServiceFilter(typeof(ExceptionFilter))]
        public IList<Product> GetList(string? NamePart = null)
        {
            return _dictService.GetProductsList(NamePart);
        }

        [HttpDelete]
        [ServiceFilter(typeof(ExceptionFilter))]
        public IActionResult Delete([Required] Guid ProductID)
        {
            _dictService.DeleteProduct(ProductID);
            return Ok();
        }

        [HttpPut]
        [ServiceFilter(typeof(ExceptionFilter))]
        public Guid Put([FromBody] ProductCreation creationData)
        {
            return _dictService.CreateProduct(creationData);
        }

        [HttpPatch]
        [ServiceFilter(typeof(ExceptionFilter))]
        public IActionResult Patch([FromBody] Product product)
        {
            _dictService.UpdateProduct(product);
            return Ok();
        }
    }
}
