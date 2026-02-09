# Phase 2: Containerization
# - Reproducible runtime with python:3.10-slim
# - Deterministic dependency install
# - Env-driven config for K8s/CI compatibility

FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    VIRTUAL_ENV=/venv \
    PATH="/venv/bin:$PATH"

WORKDIR /app

# Create venv
RUN python -m venv /venv \
 && /venv/bin/pip install --upgrade pip

# Install dependencies first for better layer caching
COPY requirements.txt /app/requirements.txt
RUN /venv/bin/pip install -r /app/requirements.txt

# Copy only the application code
COPY app /app/app

# Non-root user (recommended for enterprise; required later)
RUN useradd --create-home --shell /bin/bash appuser \
 && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Phase 2: standard entrypoint. Later (prod) add: --proxy-headers --forwarded-allow-ips="*"
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
