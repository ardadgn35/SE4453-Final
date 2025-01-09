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

<<<<<<< HEAD
# Expose SSH and HTTP ports
EXPOSE 22
EXPOSE 80

# Build application
=======
# Expose ports
EXPOSE 22    # SSH
EXPOSE 80    # HTTP

# Copy app files
>>>>>>> cd8320edaab0b6aee4d75346dab34d20318cc708
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the files and build
COPY . ./
RUN dotnet publish -c Release -o /app/publish

<<<<<<< HEAD
# Copy runtime files to base image
=======
# Build runtime image
>>>>>>> cd8320edaab0b6aee4d75346dab34d20318cc708
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .

<<<<<<< HEAD
# Add init.sh and give execute permission
COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh

# Entry point for the container
=======
# Start SSH and the app
COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh

>>>>>>> cd8320edaab0b6aee4d75346dab34d20318cc708
ENTRYPOINT ["/app/init.sh"]
