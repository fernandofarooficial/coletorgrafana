#!/bin/bash

echo "==> Instalando dependências Python..."
pip install -r requirements.txt

echo "==> Instalando Chrome e dependências..."
apt-get update
apt-get install -y wget unzip curl gnupg

# Adiciona repositório do Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

# Atualiza e instala Chrome
apt-get update
apt-get install -y google-chrome-stable

# Verifica instalação
echo "==> Verificando instalação do Chrome..."
google-chrome --version

echo "==> Build concluído!"
