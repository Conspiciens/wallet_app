import json
from flask import Flask

app = Flask(__name__) 

@app.route("/spot/v1/historical/days")
def fetch_test_data(): 
    file = open("test.json", "r") 
    data = file.read()  

    return data 
     
if __name__ == '__main__': 
    app.run(debug=True) 
