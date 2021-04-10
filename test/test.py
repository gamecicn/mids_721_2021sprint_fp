
import requests
import json
import base64


# BASE_URL = "http://3.93.216.62:80"

BASE_URL = "http://house-price-lb-925405325.us-east-1.elb.amazonaws.com"




def test_analysis_emotion():

    data = {
        'data'  :   [70,0,1,0,1,3,5],
    }

    header_dict = {"Content-Type": "application/json"}

    url = '{}/api/predict'.format(BASE_URL)

    res = requests.post(url=url, data=json.dumps(data), headers=header_dict)

    print(res.text.encode('utf-8'))

 
 
if __name__ == "__main__":

    for i in range(0, 10):
        test_analysis_emotion()
  