import json
import cohere
from inputs import input
from cohere.classify import Example
from openAICategorizer import categorize_with_cohere

co = cohere.Client("<ENTER COHERE API KEY HERE>")


def train_and_execute_model(input):
    inputs = [input]
    examples = []
    data = None

    with open("./backend/app/data.json", "r") as json_file:
        data = json.load(json_file)

    for tag in data:
        for line in data[tag]:
            example = Example(line, tag)
            examples.append(example)

    response = co.classify(
        model = 'large',
        inputs = inputs,
        examples = examples
    )

    if response.classifications[0].confidence <= 0.85:
        return categorize_with_cohere(input)
    return response.classifications[0].prediction, response.classifications[0].confidence