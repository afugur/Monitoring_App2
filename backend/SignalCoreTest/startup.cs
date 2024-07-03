public void ConfigureServices(IServiceCollection services)
{
    services.AddCors(options =>
    {
        options.AddPolicy("CorsPolicy", builder => builder
            .AllowAnyMethod()
            .AllowAnyHeader()
            .WithOrigins("http://localhost:4200", "http://10.0.2.2:5033")
            .AllowCredentials());
    });

    services.AddSignalR();
}

public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.UseRouting();

    app.UseCors("CorsPolicy");

    app.UseEndpoints(endpoints =>
    {
        endpoints.MapHub<MyHub>("/myHub");
    });
}
