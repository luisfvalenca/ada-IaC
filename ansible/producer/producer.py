import datetime
import json
import pika
import os
import time

connection = pika.BlockingConnection(pika.ConnectionParameters(host="rabbitmq", port=5672, virtual_host="/", credentials=pika.PlainCredentials("admin","admin")))

channel = connection.channel()

properties = pika.BasicProperties(app_id="producer.py", content_type="application/json")

trasactions_file = open("transactions.json")

transactions = json.load(trasactions_file)

trasactions_file.close()

time.sleep(5)

for transaction in transactions:
    transaction["data"] = str(datetime.datetime.now())

    channel.basic_publish(exchange="amq.fanout", routing_key="", body=json.dumps(transaction), properties=properties)
    print(f"[x] Sent '{json.dumps(transaction)}'")

    time.sleep(2)

channel.close()