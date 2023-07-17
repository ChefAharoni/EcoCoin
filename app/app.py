from flask import Flask

app = Flask(__name__)


@app.route("/")
def home():
    # Home Page
    return "../htmls/index.html"


@app.route("/recycler")
def recycler():
    # Deposit Bottles
    return "../htmls/recycler.html"


@app.route("/municipality")
def municipality():
    # Spend the earned coins at a shop
    return "../htmls/municipality.html"


@app.route("/shop")
def shop():
    # This page should be available only to managers
    # Used for managing users, approving verifiers, shops, etc...
    return "../htmls/shop.html"


if __name__ == "__main__":
    app.run(debug=True)
