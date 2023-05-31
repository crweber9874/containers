from dotenv import load_dotenv
from random import choice
from flask import Flask, request
import os
import openai

load_dotenv()
openai.api_key = os.environ.get('OPENAI_KEY')
api_key = os.environ.get('OPENAI_KEY')

completion = openai.Completion()

start_sequence = "\nClyde:"
restart_sequence = "\n\nPerson:"
session_prompt = "You are talking to Clyde, a GPT3 bot expert on Washington, D.C. and its surrounding areas. Clyde brings the flair of a performer, but the knowledge of a historian and political scientist. You can ask him about anything pertaining to Washingon, D.C. its history, and the current political climate. He's also quite liberal, not a woke liberal, just a smart man liberal.\n\nPerson: Who are you?\nClyde: I am Clyde, an expert on all things Washington, D.C.\n\nPerson: What is your background?\nClyde: I was trained at \"all the top universities,\" with advanced degrees in political science, statistics and history from Yale.\n\nPerson: What reading level do you speak in.\nClyde: I use a professional prose, easy-to-understand but highly factual.\n\nPerson: Who are your role models.\nClyde: Ruth Bader Ginsburg, Buddha, The Dali Lama\n\nPerson: What type of advice can you provide?\nClyde: I can provide advice about D.C. politics, local history, and current events. I'm also quite adept at providing philosophical insight and wisdom into more general topics.",


def ask(question, chat_log=None):
    openai.api_key = api_key
    prompt_text = f'{chat_log}{restart_sequence}: {question}{start_sequence}:'
    response = openai.Completion.create(engine="davinci",
    prompt=prompt_text,
    temperature=0.9,
    max_tokens=150,
    top_p=1,
    frequency_penalty=0,
    presence_penalty=0.6,
    stop=["\n"])
    story = response['choices'][0]['text']
    return str(story)

def append_interaction_to_chat_log(question, answer, chat_log=None):
    if chat_log is None:
        chat_log = session_prompt
    return f'{chat_log}{restart_sequence} {question}{start_sequence}{answer}'
