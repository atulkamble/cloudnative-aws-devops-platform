from flask import Flask, render_template
import socket
import os
import datetime
import platform

app = Flask(__name__)

@app.route('/')
def home():

    hostname = socket.gethostname()

    return render_template(
        "index.html",
        hostname=hostname,
        environment=os.getenv("ENV", "Production"),
        current_time=datetime.datetime.now(),
        platform_name=platform.system()
    )

@app.route('/health')
def health():

    return {
        "status": "UP"
    }

@app.route('/metrics')
def metrics():

    return {
        "cpu": "Healthy",
        "memory": "Healthy"
    }

if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000
    )
