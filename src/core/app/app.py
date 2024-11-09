from flask import Flask
import redis

app = Flask(__name__)

redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)
channel = 'h1ve'

@app.route("/")
def hello_world():
    redis_client.publish(channel, 'h1ve.net', magic=42)
    return "<p>Sent message: Hello, World!</p>"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
