from flask import Blueprint, request, jsonify
from service.categorize_service import train_and_execute_model

categorize_route =  Blueprint('categorize_route', __name__)

@categorize_route.route("/")
def home():
    return "Hello World!"

@categorize_route.route("/api/categorize_note", methods=['POST'])
def categorize_note():
    input = request.json.get('note')
    category = train_and_execute_model(input)
    print(f'category is {category}')
    json_response = {"category":category}
    return jsonify(json_response), 200