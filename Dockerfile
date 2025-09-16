FROM python:3.11-slim

# Instalar dependências do sistema (agora incluindo xdg-utils)
RUN apt-get update && apt-get install -y \
    wget curl unzip gnupg xvfb xdg-utils libxi6 libnss3 libxrandr2 libxss1 libxtst6 libasound2 fonts-liberation libappindicator3-1 libgbm-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar Google Chrome (última versão estável)
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb

# Definir pasta de trabalho
WORKDIR /app

# Copiar e instalar dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código
COPY . .

# Expor a porta da API
EXPOSE 8000

# Comando para iniciar a aplicação FastAPI
CMD ["uvicorn", "cripto:app", "--host", "0.0.0.0", "--port", "8000"]
