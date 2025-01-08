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
    rm -rf /var/lib/apt/lists/*

# .NET SDK'yı manuel olarak indirin ve kurun
RUN wget https://download.visualstudio.microsoft.com/download/pr/ce6d4f61-bfbd-4db2-9a04-4790e028b34d/d6919fe4c74bc3c424d72a9ab8556ff5/dotnet-sdk-9.0.100-linux-x64.tar.gz && \
    tar -xvf dotnet-sdk-9.0.100-linux-x64.tar.gz && \
    sudo mv dotnet /usr/local/share/dotnet && \
    sudo ln -s /usr/local/share/dotnet/dotnet /usr/local/bin/dotnet && \
    rm dotnet-sdk-9.0.100-linux-x64.tar.gz

# SSH için gerekli ayarları yapın
RUN mkdir /var/run/sshd && \
    echo 'root:Docker!' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# DLL dosyasını doğru şekilde kopyalayın
COPY ./bin/Debug/net6.0/projedotv2.dll .

# Bağlantı noktalarını (portları) açın
EXPOSE 22 80

# .NET uygulamanızı çalıştırmaya yönelik komutları belirleyin
CMD service ssh start && dotnet Projedotv2.dll
