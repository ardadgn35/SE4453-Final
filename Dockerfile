# Base image 
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Set root password for SSH
RUN echo 'root:password123' | chpasswd

# Allow root login with SSH
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose SSH and HTTP ports
EXPOSE 22
EXPOSE 80

# Build application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the files and build
COPY . ./
RUN dotnet publish -c Release -o /app/publish

# Build runtime image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .

# Add init.sh and give execute permission
COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh

# Entry point for the container
ENTRYPOINT ["/app/init.sh"]
