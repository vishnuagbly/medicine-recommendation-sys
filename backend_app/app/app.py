from flask import Flask, jsonify
from flask import request
from flask_cors import CORS
from model import Model
import firebase_admin
from firebase_admin import auth
from firebase_admin import credentials
app = Flask(__name__)
cors = CORS(app)
# app.config['CORS_HEADERS'] = 'Content-Type'
SERVICE_ACCOUNT_KEY = 'assets/medicine-service-account.json'
cred = credentials.Certificate(SERVICE_ACCOUNT_KEY)
firebase_admin.initialize_app(cred)

model = Model()


def _response(response: dict, status: int = 200):
    res = jsonify(response)
    # res.headers["Access-Control-Allow-Origin"] = "*"
    return res


@app.route("/")
def home():
    return "Nothing Here"


@app.route("/api/search", methods=['POST'])
def search():
    assert request.method == 'POST'
    err = authorize(request)
    if err != None:
        return _response({
            "error": "Cannot authorize",
            "details": err,
        }, 403)
    data = request.get_json(force=True)
    values = data['values']
    return _response({
        "data": model.search(values),
    }, 200)


def authorize(request):
    token = request.headers.get('token')
    try:
        auth.verify_id_token(token)
    except Exception as e:
        return str(e)
    return None


@app.route("/api/predict_sentiment", methods=['POST'])
def predict():
    assert request.method == 'POST'
    err = authorize(request)
    if err != None:
        return _response({
            "error": "Cannot authorize",
            "details": err,
        }, 403)
    data = request.get_json(force=True)
    values = data['values']
    return _response({
        "data": model.predict(values).tolist()
    }, 200)


if __name__ == '__main__':
    from waitress import serve
    serve(app, host='0.0.0.0', port=80)
