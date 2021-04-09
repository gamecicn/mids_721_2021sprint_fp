
import requests
import json
import base64


BASE_URL = "http://127.0.0.1:5000"
 
def test_analysis_emotion():

    data = {
        'data'  :   [59.10,0,0,1,0,3,1],
    }

    header_dict = {"Content-Type": "application/json"}

    url = '{}/api/predict'.format(BASE_URL)

    res = requests.post(url=url, data=json.dumps(data), headers=header_dict)

    print(res.text.encode('utf-8'))

 
 
if __name__ == "__main__":
    test_analysis_emotion()
  
