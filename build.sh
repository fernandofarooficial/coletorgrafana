#!/bin/bash

set -e  # Exit on error

echo "==> Instalando dependências Python..."
pip install --no-cache-dir -r requirements.txt

echo "==> Instalando Chrome e dependências..."
apt-get update
apt-get install -y wget unzip curl gnupg ca-certificates fonts-liberation libasound2 \
    libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 \
    libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 \
    libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 \
    libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release \
    xdg-utils

echo "==> Baixando e instalando Chrome..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install -y ./google-chrome-stable_current_amd64.deb || true
rm google-chrome-stable_current_amd64.deb

# Verifica instalação
echo "==> Verificando instalação do Chrome..."
if command -v google-chrome &> /dev/null; then
    google-chrome --version
    echo "Chrome instalado com sucesso!"
else
    echo "ERRO: Chrome não foi instalado corretamente"
    exit 1
fi

# Verifica ChromeDriver
echo "==> Verificando ChromeDriver..."
python3 -c "from selenium import webdriver; print('Selenium funcionando!')" || echo "Aviso: Erro ao verificar Selenium"

echo "==> Build concluído com sucesso!"
