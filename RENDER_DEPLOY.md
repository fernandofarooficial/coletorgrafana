# Guia de Deploy no Render

## Configuração do Web Service no Render

### 1. Criar Web Service

1. Acesse https://dashboard.render.com/
2. Clique em **"New +"** → **"Web Service"**
3. Conecte seu repositório Git

### 2. Configurações Básicas

- **Name**: `coletor-grafana` (ou qualquer nome de sua escolha)
- **Region**: Escolha a região mais próxima
- **Branch**: `main` ou `master`
- **Root Directory**: deixe em branco
- **Environment**: `Python 3`
- **Build Command**:
  ```bash
  chmod +x build.sh && ./build.sh
  ```
- **Start Command**:
  ```bash
  gunicorn app:app
  ```

### 3. Configurar Variáveis de Ambiente

Adicione as seguintes variáveis de ambiente:

| Key | Value |
|-----|-------|
| `DB_USER` | `fefa_dev` |
| `DB_PASSWORD` | `Fd7493dt` |
| `DB_HOST` | `72.60.58.241` |
| `DB_PORT` | `3306` |
| `DB_NAME` | `bufunfa` |
| `DB_TIMEZONE` | `-03:00` |
| `PORT` | `10000` (Render define automaticamente) |

### 4. Plano e Recursos

- **Instance Type**: Free ou Starter (mínimo)
  - **Nota**: O Chrome consome bastante memória. Se tiver problemas, considere upgrade para Starter.
- **Auto-Deploy**: Ativado (recomendado)

### 5. Deploy

Clique em **"Create Web Service"**

O Render irá:
1. Clonar seu repositório
2. Executar `build.sh` para instalar Chrome e dependências
3. Iniciar a aplicação com Gunicorn
4. A thread de coleta iniciará automaticamente em background

## Verificando o Deploy

### 1. Logs de Build

Durante o build, você deve ver:

```
==> Instalando dependências Python...
==> Instalando Chrome e dependências...
==> Baixando e instalando Chrome...
==> Verificando instalação do Chrome...
Google Chrome 120.x.xxxx.xxx
Chrome instalado com sucesso!
==> Build concluído com sucesso!
```

### 2. Logs de Aplicação

Após o deploy, nos logs da aplicação você deve ver:

```
[INFO] Thread de coleta iniciada em background
======================================================================
COLETA GRAFANA - VERSÃO WEB - 10 MINUTOS
SALVANDO NO BANCO DE DADOS
======================================================================

[DD/MM/YYYY HH:MM:SS] Iniciando coleta...
  URL: https://zions.grafana.net/public-dashboards/...
  Inicializando Chrome...
  Chrome inicializado com sucesso
  Acessando URL: ...
```

### 3. Verificar Status

Acesse: `https://seu-app.onrender.com/status`

Você deve ver:

```json
{
  "status": "online",
  "database": "conectado",
  "thread_coleta": "ativa",
  "timestamp": "2026-01-07T16:00:00.000000"
}
```

### 4. Verificar Página Principal

Acesse: `https://seu-app.onrender.com/`

A página deve exibir "Nenhum dado disponível" inicialmente. Após a primeira coleta (10 minutos), os dados aparecerão.

## Problemas Comuns

### Chrome não instalado

**Sintoma**: Erro "chromedriver executable needs to be in PATH"

**Solução**:
1. Verifique se o Build Command está correto: `chmod +x build.sh && ./build.sh`
2. Revise os logs de build para ver se houve erros
3. Se o plano Free não tiver permissões, considere Starter

### Thread não está ativa

**Sintoma**: `/status` mostra `"thread_coleta": "inativa"`

**Solução**:
- Isso não deve acontecer com o código atual
- Verifique os logs para ver se há erros ao iniciar a thread
- Reinicie o serviço manualmente

### Banco de dados não conecta

**Sintoma**: `/status` mostra `"database": "desconectado"`

**Solução**:
1. Verifique se as variáveis de ambiente estão corretas
2. Teste conexão manual do seu computador para o banco
3. Verifique se o firewall do MySQL permite IP do Render

### Timeout ao acessar Grafana

**Sintoma**: Logs mostram "Timeout waiting for page to load"

**Solução**:
1. Verifique se a URL do Grafana está acessível
2. Aumente o timeout em `WebDriverWait` (atualmente 15s)
3. Plano Free pode ter rede mais lenta - considere Starter

### Out of Memory

**Sintoma**: Serviço crasha com erro de memória

**Solução**:
1. Upgrade para plano Starter (mais memória)
2. Reduza `--window-size` nas opções do Chrome
3. Considere reduzir frequência de coleta (atualmente 10 min)

## Monitoramento

### Logs em Tempo Real

No Dashboard do Render:
1. Clique no seu serviço
2. Vá em **"Logs"**
3. Os logs aparecem em tempo real

### Reiniciar Serviço

Se necessário reiniciar:
1. Dashboard do Render → Seu serviço
2. Menu "Manual Deploy" → **"Clear build cache & deploy"**

## Atualizações

Quando fizer alterações no código:

1. Commit e push para o repositório:
   ```bash
   git add .
   git commit -m "Atualização"
   git push
   ```

2. Se Auto-Deploy estiver ativo, Render fará deploy automaticamente
3. Caso contrário, clique em **"Manual Deploy"** → **"Deploy latest commit"**

## Custos

- **Free Tier**:
  - Serviço "dorme" após 15 min de inatividade
  - Memória limitada (pode não ser suficiente para Chrome)
  - 750 horas/mês grátis

- **Starter ($7/mês)**:
  - Sempre ativo
  - Mais memória (recomendado para Selenium)
  - Melhor performance

## Suporte

Para problemas específicos do Render, consulte:
- https://render.com/docs
- https://community.render.com/