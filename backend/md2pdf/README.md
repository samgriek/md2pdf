# CONTENT MANAGER README

## build image
```
cd backend/md2pdf && \
docker build -t md2pdf-api:latest .
```

## run api in docker
```bash
docker run -p 81:81 md2pdf-api:latest
```
