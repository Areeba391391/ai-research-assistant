# Deploy free: Hugging Face Static + Render

Hugging Face **Docker** Spaces are paid. Use this **100% free** split:

| Part | Platform | Cost |
|------|----------|------|
| **Frontend** (React UI) | Hugging Face **Static** Space | Free |
| **Backend** (API + agent) | Render **free** web service | Free |

---

## Part A — Deploy the backend on Render (~15 min)

### 1. Open Render

Go to [render.com](https://render.com) and sign in with GitHub.

### 2. Create from Blueprint

1. **New** → **Blueprint**
2. Connect repo: **`afreen-gul/ai-research-assistant`**
3. Render reads `render.yaml` (uses `Dockerfile.api` — API only, no UI)

### 3. Set environment secrets

When prompted, add:

| Key | Value |
|-----|--------|
| `GROQ_API_KEY` | Your key from [console.groq.com/keys](https://console.groq.com/keys) |
| `FRONTEND_URL` | Leave blank for now — fill in after Part B |

### 4. Deploy and copy your backend URL

1. Click **Apply** and wait for the build (~10–15 min)
2. When status is **Live**, copy the URL, e.g.  
   `https://ai-research-assistant.onrender.com`

### 5. Update `FRONTEND_URL` on Render

1. Render → your service → **Environment**
2. Set `FRONTEND_URL` to your Hugging Face URL (from Part B), e.g.  
   `https://afreen-gul-ai-research-assistant.hf.space`
3. Save (service will restart)

Test backend: open `https://YOUR-APP.onrender.com/api/health` — should return `"status": "ok"`.

---

## Part B — Deploy the frontend on Hugging Face Static (~10 min)

### 1. Create a Static Space

1. Go to [huggingface.co/new-space](https://huggingface.co/new-space)
2. Settings:
   - **Space name:** `ai-research-assistant` (or any name)
   - **SDK:** **Static**
   - **Visibility:** **Public**
3. Click **Create Space**

### 2. Build the static files on your PC

In PowerShell (replace with your Render URL from Part A):

```powershell
cd "d:\Projects\ai research assistant"
.\scripts\prepare-hf-static.ps1 -BackendUrl "https://ai-research-assistant.onrender.com"
```

This creates a `hf-static/` folder with `index.html`, assets, and a Space `README.md`.

### 3. Push to your Hugging Face Space

```powershell
cd hf-static
git init
git add .
git commit -m "Deploy static frontend"
git remote add origin https://huggingface.co/spaces/afreen-gul/ai-research-assistant
git push -u origin main --force
```

Replace `afreen-gul/ai-research-assistant` with your username and Space name.

Use a **Hugging Face access token** with write access if Git asks for a password:  
[Settings → Access Tokens](https://huggingface.co/settings/tokens)

### 4. Open your app

Your UI URL: `https://afreen-gul-ai-research-assistant.hf.space`

Send a test chat message.

### 5. Finish Render CORS setup

Go back to Render → **Environment** → set `FRONTEND_URL` to your exact HF Space URL → Save.

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Chat fails / CORS error | Set `FRONTEND_URL` on Render to your exact `*.hf.space` URL |
| “GROQ_API_KEY not configured” | Add secret on Render, restart service |
| Backend build OOM on Render | Free tier has 512 MB RAM — chat may work; PDF/RAG may fail |
| HF Static shows old UI | Re-run `prepare-hf-static.ps1` and push again |
| Slow first request | Render free tier sleeps after ~15 min idle |

---

## Notes

- **No Docker on Hugging Face** — Static SDK is free
- **Groq** stays free for LLM calls
- **Data** (sessions, notes) is ephemeral on Render free tier — resets on redeploy
- To rebuild UI after backend URL changes, re-run the script and push to HF
