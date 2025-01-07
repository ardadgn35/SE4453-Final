#!/bin/bash
# SSH server başlat
service ssh start

# Uygulamayı başlat
dotnet run --project Projedotv2.dll --urls http://*:80
