import json
import falcon
import pytest
from falcon import testing

from src.api.app import api


@pytest.fixture
def client():
    return testing.TestClient(api)


def test_get_root(client):
    response = client.simulate_get('/')
    assert response.status == falcon.HTTP_200
    assert json.loads(response.content) == {"message": "Api up and Running!"}


# def test_post_root_valid(client):
#     payload = {
#         "name": "John",
#         "country": "USA"
#     }
#     response = client.simulate_post(
#         '/',
#         body=json.dumps(payload),  # Explicitly dump JSON payload to body
#         headers={"Content-Type": "application/json"}  # Set content-type header
#     )
#     assert response.status == falcon.HTTP_200
#     assert json.loads(response.content) == payload


# def test_post_root_invalid_json(client):
#     response = client.simulate_post('/', body='invalid json')
#     assert response.status == falcon.HTTP_400
#     assert json.loads(response.content) == {"title": "400 Bad Request", "description": "Invalid JSON format"}


def test_get_hello_world(client):
    response = client.simulate_get('/hello-world')
    assert response.status == falcon.HTTP_200
    assert json.loads(response.content) == {"message": "Hello World!"}


def test_get_person(client):
    response = client.simulate_get('/person')
    expected = {"name": "Robinson", "country": "Brazil", "city": "São Paulo"}
    assert response.status == falcon.HTTP_200
    assert json.loads(response.content) == expected
