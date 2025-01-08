# Ubuntu 20.04 bazlı image kullanıyoruz
FROM ubuntu:20.04

# Çalışma dizini oluştur
WORKDIR /app

# Gerekli sistem bağımlılıklarını yükle
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    sudo \
    apt-transport-https \
    openssh-server \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# .NET SDK'yı manuel olarak kopyala
# Eğer SDK dosyasını host bilgisayarınıza indirdiyseniz, buraya Docker context'ten (örneğin ./dotnet-sdk-9.0.100-linux-x64.tar.gz) kopyalayabilirsiniz.
COPY dotnet-sdk-9.0.100-linux-x64.tar.gz /tmp/dotnet-sdk.tar.gz

# SDK dosyasını çıkart ve uygun dizine taşı
RUN tar -xvf /tmp/dotnet-sdk.tar.gz -C /tmp/ && \
    sudo mv /tmp/dotnet /usr/local/share/dotnet && \
    sudo ln -s /usr/local/share/dotnet/dotnet /usr/local/bin/dotnet && \
    rm -rf /tmp/dotnet-sdk.tar.gz

# SSH servisini başlatmak için entrypoint ekleyelim
CMD service ssh start && tail -f /dev/null
