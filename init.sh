#!/bin/bash
# SSH server başlat
service ssh start

# Uygulamayı başlat
dotnet /app/projedotv2.dll --urls http://*:80
