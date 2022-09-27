namespace TEST.ProductsApi.ExceptionHandling;

/// <summary>
/// Универсальный ответ об ошибке
/// </summary>
public class ApiError
{
    public string? Error { get; set; }

    public ExceptionCodes? ExceptionCode { get; set; }

    public string? ExceptionStack { get; set; }
}
