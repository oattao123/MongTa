from flask import Flask
from routes import setup_routes

app = Flask(__name__)

# Setup routes from the routes.py file
setup_routes(app)

if __name__ == '__main__':
    app.run(debug=True, port=7000)