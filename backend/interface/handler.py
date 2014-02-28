from interface import BaseHandler, RESTful, RESTfulCollection
from domain import model


class Customer(RESTful):

    model = model.Customer

    class Declaration(RESTful.Nested):

        model     = model.Declaration
        reference = 'owner'


class Customers(RESTfulCollection):

    model = model.Customer


class User(RESTful):

    model         = model.User
    require_login = ['put']


class Customs(RESTful):

    model         = model.Customs
    require_login = RESTful.methods

    class pending_dispatches(RESTful.Nested):

        def get(self):
            customs = self.user.customs.get()
            self.render_json(customs.datastore.pending.dispatches)


class Declaration(RESTful):

    model         = model.Declaration
    require_login = ['put']


class Declarations(RESTfulCollection):

    model         = model.Declaration


class Dispatch(RESTful):

    model         = model.Dispatch
    require_login = RESTful.methods
