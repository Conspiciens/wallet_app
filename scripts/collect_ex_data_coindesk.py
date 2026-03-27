import os
import json
import requests

from typing import Optional
from dotenv import load_dotenv

load_dotenv() 

def api_request(link: str) -> Optional[str]: 
    tries = 0 
    
    while tries < 5: 
        try: 
            response = requests.get(link)
            return response
        except Exception as e: 
            print(f"Exception occured: ${e}") 
            tries += 1 

    return None

def store_in_json(link: str) -> None: 
    if link == "":
        return 
    print(f"Link: {link}") 
    response = api_request(link) 
    data = json.loads(response.text) 

    file = open('test.json', 'w') 
    json.dump(data, file, indent=4) 
    
    

if __name__ == '__main__': 
    key = os.getenv("COINDESK_KEY") 
    link = '''https://data-api.coindesk.com/spot/v1/historical/days?market=kraken&instrument=ETH-USD&limit=10&aggregate=1&fill=true&apply_mapping=true&response_format=JSON''' + f'&{key}'
    store_in_json(link) 
