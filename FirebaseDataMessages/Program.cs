using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

var app = builder.Build();

FirebaseApp.Create(new AppOptions()
{
    Credential = GoogleCredential.FromFile(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "fakhravari-firebase-adminsdk-z3uy3-a30406c7d3.json")),
});

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
