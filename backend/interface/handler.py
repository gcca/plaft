from interface import BaseHandler
from domain import model


class RESTfulModel(BaseHandler):

    model = None

    def get(self):
        dict = self.request_dict
        if dict:
            entity = self.model.find(dict)
            if entity:
                self.render_json(entity)
            else:
                self.status.NOT_FOUND('Not found by: '
                                      + self.request.query_string)
        else:
            self.status.BAD_REQUEST('Need parameters')

    def post(self, id=None):
        entity = self.model.new(self.request_dict)
        entity.store()
        self.write_json('{"id":%s}' % entity.id)

    def put(self, id):
        entity = self.model.find(int(id))
        if entity:
            entity.update(self.request_dict)
            entity.store()
        self.write_json('{}')


class RESTfulCollection(BaseHandler):

    model = None

    def get(self):
        self.render_json(self.model.findAll())




class Customer(RESTfulModel):

    model = model.Customer


    class newDeclaration(RESTfulModel):

        model = model.Declaration


class Customers(RESTfulCollection):

    model = model.Customer


class User(RESTfulModel):

    model = model.User


class Customs(RESTfulModel):

    model = model.Customs
