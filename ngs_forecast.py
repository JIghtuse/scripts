#!/usr/bin/python3

import appdirs
import json
import os
import requests
import sys
import time
import unidecode


FORECAST_CACHE = os.path.join(appdirs.user_cache_dir(), "ngs_forecast.cache")
WEATHER_URL = 'http://weather.ngs.ru/json'
CACHE_INVALIDATION_TIME = 600  # s


def cached(fname):
    try:
        cache = json.load(open(fname, 'r'))
    except IOError:
        cache = {}

    def cache_invalidated():
        cur_time = time.time()

        upd_time = int(cache[city]["result"].get("cache_update_time", 0))
        cache_invalidated = cur_time - upd_time > CACHE_INVALIDATION_TIME
        if cache_invalidated:
            print("[данные устарели]")
        return cache_invalidated

    def decorator(function):
        def new_function(city):
            if (city not in cache) or cache_invalidated():
                # Triying to get new forecast
                result = function(city)
                if "error" not in result:
                    # Ok, update cache
                    print("[данные получены]")
                    cache[city] = result
                    cache[city]["result"]["cache_update_time"] = time.time()
                    json.dump(cache, open(fname, 'w'))
                else:
                    # If we have no cached forecast, return error
                    if city not in cache:
                        return result
            return cache[city]
        return new_function
    return decorator


def make_request(method, params):
    headers = {'content-type': 'application/json'}
    data = {'method': method, 'params': params}

    response = requests.post(WEATHER_URL,
                             data=json.dumps(data),
                             headers=headers)
    return json.loads(response.text)


def get_all():
    response = requests.get(WEATHER_URL)
    return json.loads(response.text)


def get_dict():
    return make_request('getDictionary', {})


def get_cities():
    return make_request('getCities', {})


@cached(FORECAST_CACHE)
def get_forecast(city):
    params = {'name': 'current', 'city': city}
    return make_request('getForecast', params)


def dump_forecast(city):
    data = get_forecast(city)
    if "error" in data:
        sys.exit("[ошибка] не могу получить погоду в {}".format(city))
    print(json.dumps(data["result"], sort_keys=True, indent=4))


def print_forecast(city):
    data = get_forecast(city)
    if "error" in data:
        sys.exit("[ошибка] не могу получить погоду в {}".format(city))

    result = data["result"]
    upd_time = time.localtime(int(result["cache_update_time"]))
    date = "{} {}:{}".format(result["date"], upd_time.tm_hour, upd_time.tm_min)
    temperature = float(result["temp_current_c"].replace(",", "."))

    print("Прогноз получен: {}".format(date))
    print("Облачность:      {}".format(result["cloud_title"]))
    print("Температура:     {:+.1f} C".format(temperature))
    print("Ветер:           {} м/с {}".format(
          result["wind_avg"],
          result["wind_ru_full"]))
    print("Давление:        {}".format(result["pressure_avg"]))


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("usage: {} city".format(sys.argv[0]))
    city = unidecode.unidecode(sys.argv[1].lower())
    print_forecast(city)
