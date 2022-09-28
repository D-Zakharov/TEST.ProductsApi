using System;

namespace TEST.ProductsApi.ExceptionHandling;

public class ApiException : Exception
{
    public int StatusCode { get; init; }
    public string ErrorMessage { get; init; }
    public ExceptionCodes ExceptionCode { get; init; }

    public ApiException(string error, ExceptionCodes exceptionCode, int statusCode = 500)
    {
        (ExceptionCode, ErrorMessage, StatusCode) = (exceptionCode, error, statusCode);
    }

    public static ApiException ItemNotFoundException(object itemId)
    {
        return new ApiException(string.Format(ExceptionMessages.ItemNotFound, itemId), ExceptionCodes.ItemNotFound);
    }
}
