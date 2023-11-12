from flask import Flask 
from flask_cors import CORS
from api.categorize import categorize_route

app = Flask(__name__)
app.register_blueprint(categorize_route)
CORS(app)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
