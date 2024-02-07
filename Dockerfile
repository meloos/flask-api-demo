# builder
FROM python:3.10 as builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN python -m venv /opt/venv

RUN apt-get update && apt-get install -y --no-install-recommends libxml2-dev && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/venv/bin:$PATH"

COPY src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt


# runtime
FROM python:3.10-slim

RUN apt-get update && apt-get install -y --no-install-recommends libxml2 && rm -rf /var/lib/apt/lists/*

RUN useradd -m straal

WORKDIR /home/straal/app

COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY src/ .

USER straal

# THIS IS NOT THE WAY! :) 
#ENV VERY_SECRET_SECRET Straal

CMD ["uwsgi", "--http", ":8000", "--module", "app:app"]