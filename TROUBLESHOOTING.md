# Troubleshooting - Coletor Grafana

## Problemas Comuns e Soluções

### 1. Erro de Conexão com o Banco de Dados

**Sintoma**: Mensagem "Erro ao conectar ao banco de dados"

**Soluções**:
- Verifique se o servidor MySQL está acessível
- Confirme as credenciais (DB_USER, DB_PASSWORD, DB_HOST, DB_PORT)
- Teste a conexão: `telnet 72.60.58.241 3306`
- Verifique se o firewall permite conexões do Render para o MySQL

### 2. Chrome/ChromeDriver não encontrado no Render

**Sintoma**: Erro "selenium.common.exceptions.WebDriverException: Message: 'chromedriver' executable needs to be in PATH"

**Soluções**:
- Use o arquivo `build.sh` como Build Command no Render
- Ou adicione este comando no Build Command:
  ```bash
  chmod +x build.sh && ./build.sh
  ```
- Verifique os logs de build para confirmar instalação do Chrome

### 3. Selenium Timeout

**Sintoma**: "Timeout waiting for page to load" ou "WebDriverWait timeout"

**Soluções**:
- Aumente o timeout em `WebDriverWait` (atualmente 15 segundos)
- Verifique se a URL do Grafana está acessível
- Teste manualmente: `curl https://zions.grafana.net/public-dashboards/...`

### 4. Página HTML não carrega dados

**Sintoma**: Página mostra "Nenhum dado disponível"

**Soluções**:
- Verifique se a primeira coleta já foi executada (aguarde 10 minutos)
- Confira os logs do servidor: procure por "Dados salvos no banco de dados"
- Verifique se há dados no banco: `SELECT * FROM grafana ORDER BY quando DESC LIMIT 5`

### 5. A página não atualiza automaticamente

**Sintoma**: Dados não mudam mesmo após 60 segundos

**Soluções**:
- Limpe o cache do navegador (Ctrl + Shift + R)
- Verifique se a tag `<meta http-equiv="refresh" content="60">` está presente no HTML
- Force atualização manual (F5)

### 6. Deploy falha no Render

**Sintoma**: Build ou deploy falham

**Soluções**:

**Build Command deve ser**:
```bash
chmod +x build.sh && ./build.sh
```

**Start Command deve ser**:
```bash
python app.py
```

**Variáveis de ambiente obrigatórias**:
- DB_USER
- DB_PASSWORD
- DB_HOST
- DB_PORT
- DB_NAME
- DB_TIMEZONE

### 7. Coleta não acontece a cada 10 minutos

**Sintoma**: Logs mostram coletas irregulares ou ausentes

**Soluções**:
- Verifique se a thread de coleta iniciou: procure por "COLETA GRAFANA - VERSÃO WEB - 10 MINUTOS" nos logs
- Verifique se não há erros no Selenium que estão travando a coleta
- Reinicie o serviço no Render

### 8. Memória insuficiente no Render

**Sintoma**: Serviço crasha com "Out of Memory" ou similar

**Soluções**:
- Upgrade para um plano Render com mais memória
- Reduza `--window-size` nas opções do Chrome
- Adicione `options.add_argument("--disable-extensions")`

### 9. Dados aparecem como "None" ou "-" na tabela

**Sintoma**: Campos mostram "-" em vez de valores

**Soluções**:
- Verifique se o scraping está capturando os dados corretamente
- Confira os logs: procure por "campos encontrados: X"
- Verifique se o layout do Grafana mudou (pode precisar atualizar os regex)

### 10. Render mostra "Service Unavailable"

**Sintoma**: Ao acessar a URL do Render, aparece erro 503

**Soluções**:
- Verifique se o serviço está rodando no Dashboard do Render
- Confira os logs para erros de inicialização
- Verifique se a porta está correta (variável PORT)

## Logs Importantes

### Para verificar logs no Render:
1. Acesse o Dashboard do Render
2. Clique no seu serviço
3. Vá em "Logs"

### Logs de sucesso esperados:
```
COLETA GRAFANA - VERSÃO WEB - 10 MINUTOS
SALVANDO NO BANCO DE DADOS
[DD/MM/YYYY HH:MM:SS] Iniciando coleta...
Processando Prompt 1...
Dados salvos no banco de dados:
✓ Prompt 1: CPU=XX% RAM=XX% GPU=XX% HD=XX%
```

## Comandos Úteis para Debug Local

```bash
# Testar conexão com banco
python -c "import mysql.connector; conn = mysql.connector.connect(user='fefa_dev', password='Fd7493dt', host='72.60.58.241', port=3306, database='bufunfa'); print('Conectado!' if conn.is_connected() else 'Falhou')"

# Verificar versão do Chrome
google-chrome --version

# Testar Selenium localmente
python -c "from selenium import webdriver; driver = webdriver.Chrome(); driver.get('https://google.com'); print(driver.title); driver.quit()"
```

## Contato

Para problemas não listados aqui, abra uma issue no repositório com:
- Descrição detalhada do problema
- Logs relevantes
- Passos para reproduzir
