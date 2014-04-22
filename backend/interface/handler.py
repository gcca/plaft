# encoding: utf-8
from __future__ import unicode_literals

from StringIO import StringIO
import xlsxwriter
from interface import BaseHandler, RESTful, RESTfulCollection
from domain import model


class Customer(RESTful):

    model = model.Customer

    class Declaration(RESTful.Nested):

        model     = model.Declaration
        reference = 'owner'

        def post_after_store(self):
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

        require_login = ['get']

        def get(self):
            customs = self.user.customs.get()
            self.render_json(customs.datastore.pending.dispatches)


class Declaration(RESTful):

    model         = model.Declaration
    require_login = ['put']


class Declarations(RESTfulCollection):

    model         = model.Declaration

    def post_after_store(self):
        ds = model.Datastore()
        da.pending.declarations.append(self.entity.key)
        ds.store()


class Dispatch(RESTful):

    model         = model.Dispatch
    require_login = RESTful.methods

    # TODO(...):  batch validate for Specification class.
    def _validate(self):
        ds = model.Datastore()
        if (self.entity.declaration
            and self.entity.declaration not in ds.pending.declarations):
            raise model.BadValueError('La declaración %s ya fue usada.'
                                      % self.entity.declaration.get().tracking)

    def post_before_store(self):
        self.entity.customs = self.user.customs

    def post_after_store(self):
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

    class report_register(RESTful.Nested):

        def get(self):
            out = StringIO()

            workbook = xlsxwriter.Workbook(out, {'in_memory': True})
            worksheet = workbook.add_worksheet()

            row = 0
            col = 0
            for  dispatch in model.Dispatch.query().fetch(600):
                worksheet.write(row, col,     dispatch.order)
                worksheet.write(row, col + 1, str(dispatch.created))
                worksheet.write(row, col + 2, dispatch.type.name)
                worksheet.write(row, col + 3, dispatch.customer.get().name)
                row += 1

            workbook.close()
            out.seek(0)
            self.write_file(out.read(), 'Registro de Operaciones.xlsx')


class Stakeholder(RESTful):

  model = model.Stakeholder
