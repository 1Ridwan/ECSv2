## Build Stage

# image with uvicorn and fastapi pre-installed
FROM tiangolo/uvicorn-gunicorn-fastapi AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/w -r requirements.txt
COPY . .

## Runtime Stage
FROM tiangolo/uvicorn-gunicorn-fastapi
WORKDIR /app

# update TABLE_NAME env variable in task definition
ENV TABLE_NAME=changeme
COPY --from=build /w /usr/local
COPY --from=build /app /app

## non-root user
USER 65532:65532

EXPOSE 8080
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]

# test pipeline again and again -