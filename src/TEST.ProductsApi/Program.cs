using Microsoft.EntityFrameworkCore;
using Serilog;
using Test.DB.Domain.DB;
using TEST.ProductsApi.ExceptionHandling;
using TEST.ProductsApi.Services;

var webApplicationOptions = new WebApplicationOptions()
{
    Args = args,
    ContentRootPath = AppContext.BaseDirectory,
    ApplicationName = System.Diagnostics.Process.GetCurrentProcess().ProcessName
};
var builder = WebApplication.CreateBuilder(webApplicationOptions);
builder.Host.UseWindowsService();

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateBootstrapLogger();
Log.Information("Starting up");

// Add services to the container.
builder.Host.UseSerilog((ctx, lc) => lc
    .WriteTo.Console()
    .ReadFrom.Configuration(ctx.Configuration));

builder.Services.AddDbContextFactory<TestDbContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetValue<string>("ConnectionString"),
        serverDbContextOptionsBuilder =>
        {
            serverDbContextOptionsBuilder.EnableRetryOnFailure();
        });
});

builder.Services.AddScoped<ITestProductService, TestProductService>();
builder.Services.AddScoped<ExceptionFilter>();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapControllers();

app.Run();
