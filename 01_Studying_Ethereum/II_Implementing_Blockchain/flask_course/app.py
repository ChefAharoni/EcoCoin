from flask import Flask, render_template, request
from helper import recipes, descriptions, ingredients, instructions, add_ingredients, add_instructions, comments
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField

app = Flask(__name__)
app.config["SECRET_KEY"] = "mysecret"


#### Create form class here

@app.route("/", methods=["GET", "POST"])
def index():
    return render_template("index.html", template_recipes=recipes)


@app.route("/recipe/<int:id>", methods=["GET", "POST"])
def recipe(id):
    #### Instantiate form class here

    return render_template("recipe.html", template_recipe=recipes[id], template_description=descriptions[id],
                           template_ingredients=ingredients[id], template_instructions=instructions[id],
                           template_comments=comments[id], template_form=comment_form)


@app.route("/about")
def about():
    return render_template("about.html")
