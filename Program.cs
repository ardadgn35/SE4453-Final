using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Npgsql;

var builder = WebApplication.CreateBuilder(args);

// Veritabanı bağlantı bilgilerini doğrudan buraya yazabilirsiniz
string dbHost = "finalpsql.postgres.database.azure.com";  // Veritabanı sunucusu adresi
string dbUser = "ardadgn35";                  // PostgreSQL kullanıcı adı
string dbPassword = "Sh@zzyofficial2";                     // PostgreSQL şifresi
string dbName = "postgres";                                  // Veritabanı adı

// Bağlantı dizesini oluştur
var connectionString = $"Host={dbHost};Database={dbName};Username={dbUser};Password={dbPassword}";

// Build the app
var app = builder.Build();

app.MapGet("/hello", async () =>
{
    // PostgreSQL'e bağlan
    using var connection = new NpgsqlConnection(connectionString);
    await connection.OpenAsync();

    // Örnek bir sorgu çalıştır
    using var command = new NpgsqlCommand("SELECT NOW()", connection);
    var result = await command.ExecuteScalarAsync();

    return $"Connected to PostgreSQL! Current Time: {result}";
});

// Uygulamayı çalıştır
app.Run();
