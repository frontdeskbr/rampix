# Cripto API no Railway

Este projeto sobe a API FastAPI + Selenium (com Chrome) no Railway.

## Como rodar local
```bash
pip install -r requirements.txt
uvicorn cripto:app --reload
```

## Como deployar no Railway
1. Suba esse repo no GitHub.
2. Conecte no Railway e escolha **Deploy from GitHub Repo**.
3. O Railway vai usar o Dockerfile para buildar a imagem (já vem com Chrome).

Pronto 🚀
