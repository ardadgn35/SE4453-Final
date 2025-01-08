# Ubuntu 20.04 tabanlı bir temel imaj kullanıyoruz
FROM ubuntu:20.04

WORKDIR /app

# Gerekli paketleri yükleyin
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    sudo \
    apt-transport-https \
    openssh-server \
    libpq-dev && \
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && apt-get install -y dotnet-sdk-6.0 && \
    rm -rf /var/lib/apt/lists/*

# .NET SDK 9.0'ı manuel olarak kurun
RUN wget https://download.visualstudio.microsoft.com/download/pr/8b42532d-43fc-40e0-a5b4-272f36d544ed/eea05a98768831e0c0c089be0496232a/dotnet-sdk-9.0.100-linux-x64.tar.gz && \
    mkdir -p /usr/share/dotnet && \
    tar -zxf dotnet-sdk-9.0.100-linux-x64.tar.gz -C /usr/share/dotnet && \
    rm dotnet-sdk-9.0.100-linux-x64.tar.gz && \
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# SSH için gerekli ayarları yapın
RUN mkdir /var/run/sshd && \
    echo 'root:Docker!' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# DLL dosyasını konteynıra kopyalayın
COPY bin/Debug/net9.0/projedotv2.dll .

# Uygulamayı çalıştırma komutları
CMD ["/bin/bash", "-c", "service ssh start; dotnet Projedotv2.dll"]
