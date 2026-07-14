# Deployment (free)

Hugging Face **Docker** Spaces are paid. Use the **free split**:

| Part | Platform | Guide |
|------|----------|--------|
| Frontend (UI) | Hugging Face **Static** Space | [deploy/HUGGINGFACE.md](deploy/HUGGINGFACE.md) |
| Backend (API) | Render free | [deploy/HUGGINGFACE.md](deploy/HUGGINGFACE.md) |

**Order:** Deploy Render backend first → build static UI → push to HF Static Space.

Single-service option (Render only, UI + API together): [deploy/RENDER.md](deploy/RENDER.md) — uses full `Dockerfile`, 512 MB RAM limit.

## Required secrets (Render backend)

| Variable | Value |
|----------|--------|
| `GROQ_API_KEY` | From [console.groq.com/keys](https://console.groq.com/keys) |
| `LLM_PROVIDER` | `groq` |
| `FRONTEND_URL` | Your Hugging Face Static Space URL |
| `JWT_SECRET` | Random string (Render can auto-generate) |
| `SERVE_FRONTEND` | `false` (set in `render.yaml`) |

Never commit `.env` — it is gitignored.
