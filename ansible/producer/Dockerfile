FROM python:3.11.9-alpine3.19

WORKDIR /app-producer

COPY producer.py transactions.json requirements.txt ./

RUN pip install -r requirements.txt

ENTRYPOINT [ "/usr/local/bin/python3" ]

