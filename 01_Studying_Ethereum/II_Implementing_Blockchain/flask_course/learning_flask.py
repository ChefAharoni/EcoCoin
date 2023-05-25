from flask import Flask
from helper import pets

app = Flask(__name__)


@app.route('/')
def index():
    return '''
  <h1>Adopt a Pet!</h1>
  <p>Browse through the links below to find your new furry friend:</p>
  <ul>
      <li><a href="/animals/Dogs">Dogs</a></li>
      <li><a href="/animals/Cats">Cats</a></li>
      <li><a href="/animals/Rabbits">Rabbits</a></li>
  </ul>'''


@app.route('/animals/<pet_type>')
def animals(pet_type):
    html = f'''<h1>List of {pet_type}</h1>'''
    html += '<ul>'
    for pet_id, pet in enumerate(pets[pet_type.lower()]):
        html += f"""
    <li><a href='/animals/{pet_type}/{pet_id}'>{pet['name']}</a></li>
    """
    html += '</ul>'
    return html


@app.route('/animals/<pet_type>/<int:pet_id>')
def pet(pet_type, pet_id: int):
    pet = pets[pet_type.lower()][pet_id]
    return f"""<h1>{pet['name']}</h1> """
