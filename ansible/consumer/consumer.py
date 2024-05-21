import pika
import json
import io
from conexoes import connect_rabbitmq, connect_redis
from gera_relatorio import gera_relatorio

queue_name = "fraud-validator_queue"
first_uf = None

channel = connect_rabbitmq()
redis_conn = connect_redis()
channel.queue_declare(queue=queue_name)
channel.queue_bind(exchange="amq.fanout", queue=queue_name)

def consume_transaction(channel, method_frame, header_frame, body):
    global first_uf
    transaction = json.loads(body.decode('utf-8') )
    print("Transacao: ", transaction)
    ac_number = transaction['ac_number']
    uf_transaction = transaction['uf']
    old_transaction = redis_conn.get(ac_number)

    if old_transaction is None:
        all_transactions = [transaction]
        redis_conn.set(ac_number, json.dumps(all_transactions))
    else:
        old_transactions = json.loads(old_transaction)
        old_transactions.append(transaction)
        redis_conn.set(ac_number, json.dumps(old_transactions))

    if first_uf is None:
        first_uf = uf_transaction
    else:
        if uf_transaction != first_uf:
            print("Alerta! Possível Fraude detectada")
            gera_relatorio(ac_number, old_transactions, transaction)

channel.basic_consume(queue=queue_name, on_message_callback=consume_transaction, auto_ack=True)

print("Esperando por mensagens. Para sair pressione CTRL+C")
channel.start_consuming()