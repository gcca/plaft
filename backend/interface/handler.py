from interface import BaseHandler, RESTful, RESTfulCollection
from domain import model


class Customer(RESTful):

    model = model.Customer

    class Declaration(RESTful.Nested):

        model     = model.Declaration
        reference = 'owner'

        def _post_post_store(self):
            ds = model.Datastore()
            ds.pending.declarations.append(self.entity.key)
            ds.store()


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

    def _post_post_store(self):
        ds = model.Datastore()
        da.pending.declarations.append(self.entity.key)
        ds.store()


class Dispatch(RESTful):

    model         = model.Dispatch
    require_login = RESTful.methods

    def _post_pre_store(self):
        self.entity.customs = self.user.customs

    def _post_post_store(self):
        declaration = self.entity.declaration
        if declaration:
            self.entity.customer = declaration.get().owner
            self.entity.store()

            ds = model.Datastore()
            ds.pending.declarations.remove(declaration)
            ds.store()

        customs = self.user.customs.get()
        customs.datastore.pending.dispatches.append(self.entity.key)
        customs.store()
