#Dockerfile
FROM python:3.9-alpine3.18

WORKDIR /ai_api

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade -r requirements.txt 

COPY . . 

CMD ["uvicorn", "ai_api:app", "--host", "0.0.0.0", "--port", "80"] 