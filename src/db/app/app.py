import redis

redis_client = redis.StrictRedis(host='h1ve-core-redis', port=6379, db=0)
channel = 'h1ve'

if __name__ == '__main__':
    pubsub = redis_client.pubsub()
    pubsub.subscribe(channel)
    for message in pubsub.listen():
        if message['type'] == 'message':
            print(f"Received: {message['data'].decode('utf-8')}")
