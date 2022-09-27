using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Logging;
using System;

namespace TEST.ProductsApi.ExceptionHandling;

/// <summary>
/// Перехватывает исключения в контроллерах, необходмо в явном виде указывать, в каких методах требуется перехватить
/// </summary>
public class ExceptionFilter : ExceptionFilterAttribute
{
    private const int DefaultErrorStatus = 500;

    private readonly ILogger<ExceptionFilter> _logger;

    public ExceptionFilter(ILogger<ExceptionFilter> logger)
    {
        _logger = logger;
    }

    public override void OnException(ExceptionContext context)
    {
        ApiError? apiError = null;
        if (context.Exception is ApiException ex)
        {
            string? stack = null;
#if DEBUG
            stack = ex?.StackTrace;
#endif
            context.HttpContext.Response.StatusCode = ex is null ? DefaultErrorStatus : ex.StatusCode;
            apiError = new ApiError()
            {
                Error = ex?.ErrorMessage,
                ExceptionStack = stack,
                ExceptionCode = ex?.ExceptionCode
            };

            _logger.LogError(apiError.Error);
        }
        else
        {
            var msg = context.Exception.GetBaseException().Message;
#if !DEBUG
            string? stack = null;
#else
            string? stack = context.Exception.StackTrace;
#endif
            apiError = new ApiError()
            {
                Error = msg,
                ExceptionStack = stack, 
                ExceptionCode = ExceptionCodes.System
            };
            context.HttpContext.Response.StatusCode = DefaultErrorStatus;

            _logger.LogError(context.Exception.GetBaseException().Message);
        }

        context.Result = new JsonResult(apiError);

        base.OnException(context);
    }
}
