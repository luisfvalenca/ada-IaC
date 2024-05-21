FROM python:3.11.9-alpine3.19

WORKDIR /app-consumer

COPY consumer.py gera_relatorio.py conexoes.py requirements.txt ./

RUN pip install -r requirements.txt

ENTRYPOINT [ "/usr/local/bin/python3" ]

