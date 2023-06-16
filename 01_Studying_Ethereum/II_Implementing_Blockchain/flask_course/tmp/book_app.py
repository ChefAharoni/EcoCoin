from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return '<h1>Hello world!</h1>'



@app.route('/user/<name>')
def name():
    return f'Hello {name}! Welcome to our beautiful website!'


if __name__ == "__main__":
    app.run()