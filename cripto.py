# -- coding: utf-8 --
import asyncio, base64, io, os
from typing import Optional

from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse, JSONResponse
from starlette.concurrency import run_in_threadpool
import qrcode

# -------------------- Fluxo principal --------------------
def abrir_checkout(headless=True) -> Optional[str]:
    # ⚠️ Aqui você deve colar o fluxo Selenium real que já tem.
    # No final, essa função deve retornar a string PIX Copia-e-Cola extraída.
    raise Exception("abrir_checkout() não implementado. Cole aqui seu fluxo Selenium.")

def qrcode_png_bytes(payload: str, box_size=10, border=4) -> bytes:
    qr = qrcode.QRCode(
        version=None,
        error_correction=qrcode.constants.ERROR_CORRECT_M,
        box_size=box_size,
        border=border,
    )
    qr.add_data(payload.strip())
    qr.make(fit=True)
    img = qr.make_image()
    buf = io.BytesIO()
    img.save(buf, format="PNG")
    return buf.getvalue()

# -------------------- FastAPI --------------------
app = FastAPI(title="Cripto QR API", version="1.0.0")
GEN_LOCK = asyncio.Lock()

@app.get("/api/health")
async def health():
    return {"ok": True}

@app.get("/checkout{valor}", response_class=HTMLResponse)
async def checkout(valor: str):
    async with GEN_LOCK:
        try:
            payload = await asyncio.wait_for(
                run_in_threadpool(lambda: abrir_checkout(headless=True)),
                timeout=240
            )
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Erro no fluxo: {e}")

        if not payload or len(payload.strip()) < 20:
            raise HTTPException(status_code=500, detail="Não foi possível gerar o PIX.")

        png_bytes = qrcode_png_bytes(payload)
        data_url = "data:image/png;base64," + base64.b64encode(png_bytes).decode("ascii")

        html = f"""
        <!doctype html>
        <html lang="pt-BR">
        <head><meta charset="utf-8"><title>Checkout PIX</title></head>
        <body style="text-align:center;font-family:Arial;padding:40px;">
          <h1>Pagamento PIX - R$ {valor}</h1>
          <img src="{data_url}" width="260" height="260"/>
          <div style="margin-top:20px;">{payload}</div>
          <button onclick="navigator.clipboard.writeText('{payload}')">Copiar</button>
        </body>
        </html>
        """
        return HTMLResponse(html)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("cripto:app", host="0.0.0.0", port=8000, reload=True)
