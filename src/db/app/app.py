import redis
import docker
import logging
import os

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s.%(msecs)03d %(levelname)s %(module)s - %(funcName)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger(__name__)

client = docker.from_env()

redis_client = redis.StrictRedis(host="h1ve-core-redis", port=6379, db=0)
channel = "h1ve"


def init():
    logger.info("Setting proper rights for mariadb root user")
    with open(os.environ["MARIADB_ROOT_PASSWORD_FILE"], "r") as f:
        pw = f.read()
    container = client.containers.get("h1ve-db-mariadb")
    _, stream = container.exec_run(
        cmd=f"mariadb -h h1ve-db-mariadb -P 3306 --protocol=tcp -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '{pw}';\"",
        stream=True,
    )
    for data in stream:
        logger.info(data.decode())


def listen():
    logger.info("Listening for events on channel h1ve")
    pubsub = redis_client.pubsub()
    pubsub.subscribe(channel)
    for message in pubsub.listen():
        if message["type"] == "message":
            logger.info(f"Received: {message['data'].decode('utf-8')}")


if __name__ == "__main__":
    logger.info("Starting db app")
    init()
    listen()
