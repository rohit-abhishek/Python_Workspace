""" Demo program for Flask """

from flask import Flask, request

# give the name of the program to flask for execution
app = Flask(__name__)

data_store = {
    "COBOL" : {"name" : "COBOL", "publication_year": 1960, "contribution": "record data"}, 
    "ALGOL" : {"name" : "ALGOL", "publication_year": 1958, "contribution": "scoping and nested functions"},
    "APL" : {"name" : "APL", "publication_year": 1962, "contribution": "array processing"}, 
    "PL"  : {"name" : "PL", "publication_year": 1964, "contribution": "constants, function overloading, and pointers"}, 
    "SIMULA67" : {"name" : "SIMULA67", "publication_year": 1967, "contribution": "class/object split, subclassing, protected attributes"}, 
    "PASCAL" : {"name" : "PASCAL", "publication_year": 1970, "contribution": "modern unary and binary assignment operators"}, 
    "CLU" :  {"name" : "COBOL", "publication_year": 1975, "contribution": "iterator, abstract data, generics, checked exceptions"}, 
}

@app.route("/programming_lanugage", methods=["GET", "POST"])
def programming_language_route():
    if request.method == "GET":
        return list_programming_languages()
    elif request.method == "POST": 
        json_sent = request.get_json(force=True)
        return create_programming_language(json_sent)
    
def list_programming_languages():
    before_year = request.args.get("before_year") or "30000"
    after_year = request.args.get("after_year") or "0" 
    qualifying_data = list(
        filter(lambda pl: int(before_year) > pl["publication_year"] > int(after_year), data_store.values())
    )
    return {"programming_languages": qualifying_data}

def create_programming_language(new_lanugage):
    language_name = new_lanugage["name"]
    data_store[language_name] = new_lanugage
    return new_lanugage


@app.route('/programming_lanugages/<programming_language_name>', methods=["GET", "PUT", "DELETE"])
def programming_languages_route(programming_language_name):
    if request.method == "GET":
        return get_programming_language(programming_language_name)
    elif request.method == "PUT": 
        return update_programming_language(programming_language_name, request.get_json(force=True))
    elif request.method == "DELETE":
        return delete_programming_language(programming_language_name)
    

def get_programming_language(programming_language_name):
    return data_store[programming_language_name]

def update_programming_language(programming_language_name, new_language_attributes):
    language_getting_update = data_store[programming_language_name]
    language_getting_update.update(new_language_attributes)
    return language_getting_update

def delete_programming_language(programming_language_name):
    deleting_language = data_store[programming_language_name]
    del data_store[programming_language_name]
    return deleting_language

if __name__ == "__main__":
    app.run(debug=True)