FROM ubuntu:20.04

WORKDIR /app

RUN apt-get update && apt-get install -y \
    wget \
    sudo \
    apt-transport-https \
    openssh-server \
    libpq-dev \
    curl

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update

RUN apt-get install -y dotnet-sdk-6.0

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd && \
    echo 'root:Docker!' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

COPY ./bin/Debug/net6.0/projedotv2.dll .

CMD ["/bin/bash", "-c", "service ssh start; dotnet Projedotv2.dll"]
