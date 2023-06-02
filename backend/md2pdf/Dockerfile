# FROM public.ecr.aws/docker/library/python:3.8.13
FROM python:3.8.13
WORKDIR /

COPY ./requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt
COPY ./app /app
COPY alembic.ini /

# If running behind a proxy like Nginx or Traefik add --proxy-headers
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "81", "--workers", "1", "--proxy-headers", "--access-log"]
