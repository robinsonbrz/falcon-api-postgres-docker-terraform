import json
import logging

import falcon
from mangum import Mangum

logging.basicConfig(level=logging.ERROR)


class RequestHelloWorld:
    def on_get(self, req, resp):
        resp.body = json.dumps({"message": "Hello World!"})
        resp.status = falcon.HTTP_200


class RequestPerson:
    def on_get(self, req, resp):
        content = {
            "name": "Robinson",
            "country": "Brazil",
            "city": "São Paulo",
        }
        resp.body = json.dumps(content)
        resp.status = falcon.HTTP_200


class RequestRoot:
    def on_get(self, req, resp):
        resp.body = json.dumps({"message": "Api up and Running!"})
        resp.status = falcon.HTTP_200

    def on_post(self, req, resp):
        try:
            data = json.loads(req.stream.read())
            name = data.get("name")
            country = data.get("country")
            print(f"Name: {name}, Country: {country}")

            content = {"name": name, "country": country}
            resp.status = falcon.HTTP_200
            resp.body = json.dumps(content)

        except json.JSONDecodeError:
            logging.error("Failed to decode JSON")
            raise falcon.HTTPBadRequest(description="Invalid JSON format")

        except Exception as e:
            logging.error(f"An error occurred: {e}")
            resp.status = falcon.HTTP_500
            resp.body = json.dumps({"error": "Internal Server Error"})


api = falcon.API()
api.add_route("/", RequestRoot())

api.add_route("/hello-world", RequestHelloWorld())
api.add_route("/person", RequestPerson())


handler = Mangum(api, lifespan="off")
