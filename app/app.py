from flask import Flask

app = Flask(__name__)


@app.route("/")
def home():
    # Home Page
    return "../htmls/index.html"


@app.route("/deposit")
def deposit():
    # Deposit Bottles
    return "../htmls/deposit.html"


@app.route("/spend")
def spend():
    # Spend the earned coins at a shop
    return "../htmls/spend.html"


@app.route("/manage")
def manage():
    # This page should be available only to managers
    # Used for managing users, approving verifiers, shops, etc...
    return "../htmls/manage.html"


if __name__ == "__main__":
    app.run(debug=True)
