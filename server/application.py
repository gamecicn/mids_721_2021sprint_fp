# Author Martin Guo


from flask import Flask, request, jsonify
import uuid

#SKLearn
from joblib import load

app = Flask(__name__)


model = load("../model/model.joblib")


def analysis(input):
    try:
        print("Input is {}".format(input))
        return int(model.predict([input])[0])
    except:
        return 56987


@app.route('/api/predict', methods=['POST'])
def predict():
    content = request.get_json()

    if (content is None) or ("data" not in content):
        response = {"id": str(uuid.uuid4()), "errors": "502 Input error"}
    else:

        price = analysis(content["data"])

        response = {"id": str(uuid.uuid4()),
                    "errors": "200",
                    "result" : price}

    return jsonify(response)




if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=5000)
























