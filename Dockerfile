# Ubuntu 20.04 tabanlı bir temel imaj kullanıyoruz
FROM ubuntu:20.04

# Çalışma dizinini belirliyoruz
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
    apt-get update && apt-get install -y \
    dotnet-sdk-6.0 \
    dotnet-sdk-9.0 && \
    rm -rf /var/lib/apt/lists/*

# SSH için gerekli ayarları yapın
RUN mkdir /var/run/sshd && \
    echo 'root:Docker!' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# DLL dosyasını doğru şekilde kopyalayın
COPY ./bin/Debug/net6.0/projedotv2.dll .

# .NET uygulamanızı çalıştırmaya yönelik komutları belirleyin
CMD ["/bin/bash", "-c", "service ssh start; dotnet Projedotv2.dll"]
