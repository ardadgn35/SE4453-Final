# Ubuntu 20.04 tabanlı bir temel imaj kullanıyoruz
FROM ubuntu:20.04

# Çalışma dizinini belirleyin
WORKDIR /app

# Gerekli paketleri yükleyin
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    sudo \
    apt-transport-https \
    openssh-server \
    libpq-dev && \
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && apt-get install -y --no-install-recommends \
    dotnet-sdk-6.0 && \
    rm -rf /var/lib/apt/lists/* packages-microsoft-prod.deb

# SSH için gerekli ayarları yapın
RUN mkdir /var/run/sshd && \
    echo 'root:Docker!' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Portları açın
EXPOSE 22 80 443

# Proje dosyasını kopyalayın
COPY Projedotv2.dll . 

# Uygulamayı çalıştırma komutları
CMD ["/bin/bash", "-c", "/usr/sbin/sshd && dotnet Projedotv2.dll"]
