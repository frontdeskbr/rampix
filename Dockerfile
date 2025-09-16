FROM python:3.11-slim

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y     wget curl unzip gnupg xvfb libxi6 libgconf-2-4 libnss3 libxrandr2 libxss1 libxtst6 libasound2 fonts-liberation libappindicator3-1 libgbm-dev     && rm -rf /var/lib/apt/lists/*

# Instalar Google Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb     && apt-get install -y ./google-chrome-stable_current_amd64.deb     && rm google-chrome-stable_current_amd64.deb

# Dependências Python
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código
COPY . .

EXPOSE 8000
CMD ["uvicorn", "cripto:app", "--host", "0.0.0.0", "--port", "8000"]
