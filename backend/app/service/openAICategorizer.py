import openai
import json
import os
from dotenv import load_dotenv

openai.api_key = os.getenv('OPENAI_KEY')


def categorize_random_note(note: str):

    data = None
    with open("./backend/app/tags.json", "r") as json_file:
        data = json.load(json_file)
    
    tags = ""
    for tag in data:
        tags += tag + " "

    init_prompt = "I am going to give you some text and I want you to map it to only one of the following tags:\n"
    tags += "\n\n"
    init_prompt += tags + '\nIf none of the tags are feasible, create a new tag for the text.\n'
    init_prompt += note +' \n\n'
    init_prompt += "Respond in the format: <tag-name>"

    response = openai.Completion.create(
        model="text-davinci-003",
        prompt=init_prompt,
        temperature=0.7,
        max_tokens=3196,
        n=1,
        stop=None
    )

    tag = response["choices"][0]["text"]
    tag = tag.strip()

    # IF TAG IS IN DATA, CREATE NEW DATA ANYWAY AND APPEND IT ONTO THE EXISTING VALUES IN KEY
    if tag in tags:
        return tag
    
    else:
        update_dict = {tag:[]}
        data.update(update_dict)
        json.dump(data, open("./backend/app/tags.json", "w"))
        return tag


def categorize_with_cohere(note: str):
    init_prompt = "Which general category does this text fall under? Give me only one specific response.\n"
    init_prompt += note

    response = openai.Completion.create(
        model="text-davinci-003",
        prompt=init_prompt,
        temperature=0.7,
        max_tokens=3196,
        n=1,
        stop=None
    )
    tag = response["choices"][0]["text"]
    tag = tag.strip()
    tag = tag.strip(",.")


    data = None
    with open("./backend/app/data.json", "r") as json_file:
        data = json.load(json_file)

    # IF TAG IS IN DATA, CREATE NEW DATA ANYWAY AND APPEND IT ONTO THE EXISTING VALUES IN KEY
    if tag in data:
        return tag
    
    init_prompt = f"Generate 10 more notes like {note} but shorter in length."
    response = openai.Completion.create(
        model="text-davinci-003",
        prompt=init_prompt,
        temperature=0.7,
        max_tokens=3196,
        n=1,
        stop=None
    )

    generated_prompts = response["choices"][0]["text"]
    
    unclean_training_data = generated_prompts.split('\n')
    training_data = [x for x in unclean_training_data if x != '']

    update_dict = {}
    update_dict[tag] = training_data
    data = None

    with open("./backend/app/data.json", "r") as json_file:
        data = json.load(json_file)
    
    data.update(update_dict)
    json.dump(data, open("./backend/app/data.json", "w"))

    return tag
