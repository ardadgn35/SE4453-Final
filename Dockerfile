# Temel .NET görüntüsünü kullan
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 2222  # SSH portu

# .NET SDK görüntüsünü kullan ve uygulamayı inşa et
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["projedotv2/projedotv2.csproj", "projedotv2/"]
RUN dotnet restore "projedotv2/projedotv2.csproj"
COPY . .
WORKDIR "/src/projedotv2"
RUN dotnet build "projedotv2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "projedotv2.csproj" -c Release -o /app/publish

# Web ve SSH'yi başlatacak betik ile son Docker imajını oluştur
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN apt-get update && apt-get install -y openssh-server
RUN echo "root:Docker!" | chpasswd   # root şifresi
RUN mkdir /var/run/sshd

# SSH ve Web sunucusunu başlatan başlangıç betiği
CMD service ssh start && dotnet projedotv2.dll
