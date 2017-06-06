#!/usr/bin/python3

import json
import os
import requests
import sys

# Реализовано с помощью сервиса «Яндекс.Предиктор»
# https://tech.yandex.ru/predictor/

LANGUAGE = "en"
LIMIT = 3
API_KEY = os.environ["PREDICTOR_API_KEY"]

PREDICTOR_URL = "https://predictor.yandex.net/api/v1/predict.json"
PREDICTOR_LANGS_URL = f"{PREDICTOR_URL}/getLangs?key={API_KEY}"
PREDICTOR_COMPLETE_URL = (f"{PREDICTOR_URL}/complete?key={API_KEY}"
                          f"&lang={LANGUAGE}&limit={LIMIT}&q=")


def make_request(url):
    response = requests.get(url)
    return json.loads(response.text)


def check_language():
    languages = make_request(PREDICTOR_LANGS_URL)
    if LANGUAGE not in languages:
        sys.exit(f"Sorry, language {LANGUAGE} is not supported")


def print_completions(text):
    completions = make_request(PREDICTOR_COMPLETE_URL + text)
    pos = completions['pos']

    if pos < 0:
        text = text[:pos]

    for completion in completions['text']:
        print(text + pos * ' ' + completion)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(f"usage: {sys.argv[0]} <query>")
    check_language()
    query = ' '.join(sys.argv[1:])
    print_completions(query)
