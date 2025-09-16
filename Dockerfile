FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    wget curl unzip gnupg xvfb xdg-utils libxi6 libnss3 libxrandr2 libxss1 libxtst6 libasound2 fonts-liberation libappindicator3-1 libgbm-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000
CMD ["sh", "-c", "uvicorn cripto:app --host 0.0.0.0 --port ${PORT:-8000}"]
