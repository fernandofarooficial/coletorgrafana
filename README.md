# Coletor Grafana - Monitor em Tempo Real

Sistema de monitoramento em tempo real que coleta dados de três servidores (Prompt 1, Prompt 2 e Prompt 3) a cada 10 minutos e exibe as últimas 50 coletas em uma interface web.

## Funcionalidades

- Coleta automática de dados a cada 10 minutos
- Armazenamento em banco de dados MySQL
- Interface web com atualização automática a cada 60 segundos
- Exibição das últimas 50 coletas
- Dados agrupados por servidor (Prompt 1, 2 e 3)

## Métricas Coletadas

- CPU (%)
- RAM (%)
- HD (%)
- GPU (%)
- SWAP (%)
- Total de Câmeras
- Câmeras Online
- Câmeras Offline
- Câmeras Ociosas

## Deploy no Render

### Opção 1: Deploy Automático (Recomendado)

1. Faça push do código para um repositório Git (GitHub, GitLab, etc.)
2. Acesse [Render Dashboard](https://dashboard.render.com/)
3. Clique em "New +" → "Web Service"
4. Conecte seu repositório
5. Configure:
   - **Name**: coletor-grafana
   - **Environment**: Python 3
   - **Build Command**:
     ```bash
     pip install -r requirements.txt
     ```
   - **Start Command**:
     ```bash
     python app.py
     ```

6. Adicione as variáveis de ambiente:
   - `DB_USER`: fefa_dev
   - `DB_PASSWORD`: Fd7493dt
   - `DB_HOST`: 72.60.58.241
   - `DB_PORT`: 3306
   - `DB_NAME`: bufunfa
   - `DB_TIMEZONE`: -03:00

7. Clique em "Create Web Service"

### Opção 2: Deploy via render.yaml

1. O arquivo `render.yaml` já está configurado
2. No Render Dashboard, clique em "New +" → "Blueprint"
3. Conecte seu repositório
4. O Render detectará automaticamente o arquivo `render.yaml`
5. Clique em "Apply"

### Instalação do Chrome/ChromeDriver no Render

O Render precisa ter o Chrome instalado para o Selenium funcionar. Adicione este script no **Build Command**:

```bash
pip install -r requirements.txt && \
apt-get update && \
apt-get install -y wget unzip && \
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
apt-get install -y ./google-chrome-stable_current_amd64.deb
```

## Estrutura do Projeto

```
ColetorGrafana/
├── app.py                 # Aplicação principal
├── templates/
│   └── index.html        # Template da interface web
├── requirements.txt      # Dependências Python
├── render.yaml          # Configuração para deploy no Render
└── README.md            # Este arquivo
```

## Execução Local

1. Instale as dependências:
   ```bash
   pip install -r requirements.txt
   ```

2. Configure as variáveis de ambiente (opcional):
   ```bash
   export DB_USER=fefa_dev
   export DB_PASSWORD=Fd7493dt
   export DB_HOST=72.60.58.241
   export DB_PORT=3306
   export DB_NAME=bufunfa
   export DB_TIMEZONE=-03:00
   ```

3. Execute a aplicação:
   ```bash
   python app.py
   ```

4. Acesse http://localhost:5000

## Banco de Dados

A aplicação usa MySQL e grava os dados na tabela `grafana`. Cada coleta gera uma linha com dados dos três servidores.

### Estrutura da Tabela

- `quando`: Data/hora da coleta
- `p1_*`: Dados do Prompt 1
- `p2_*`: Dados do Prompt 2
- `p3_*`: Dados do Prompt 3

Onde `*` pode ser:
- `cpu`, `ram`, `hd`, `gpu`, `swap`
- `total_cam`, `cam_on`, `cam_off`, `cam_idle`

## Tecnologias Utilizadas

- **Flask**: Framework web
- **Selenium**: Automação de navegador para coleta de dados
- **MySQL Connector**: Conexão com banco de dados
- **Threading**: Execução de coleta em background

## Suporte

Para problemas ou dúvidas, abra uma issue no repositório.
