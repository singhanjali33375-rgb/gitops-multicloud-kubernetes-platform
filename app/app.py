from flask import Flask, jsonify
import os
import socket


app = Flask(__name__)


@app.route("/")
def home():

    return jsonify({

        "message": "GitOps Multicloud Platform Application Running",

        "service": "Flask Microservice",

        "hostname": socket.gethostname(),

        "environment": os.getenv(
            "ENVIRONMENT",
            "development"
        )

    })


@app.route("/health")
def health():

    return jsonify({

        "status": "healthy"

    })


if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000
    )
