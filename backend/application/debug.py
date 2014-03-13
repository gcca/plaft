# encoding: utf-8

from __future__ import unicode_literals

from domain.model import Customer, User, Customs, Officer, Declaration, \
                         Document, Dispatch, Datastore
from interface import BaseHandler
from domain.c_gz import db


def create():
    cs1 = Customs(name    = 'Cyberdine',
                  code    = '888',
                  officer = Officer(name='Mail', code='1255'))
    cs1.store()

    cs2 = Customs(name    = 'SCharff',
                  code    = '789',
                  officer = Officer(name='John Connor', code='1212'))
    cs2.store()

    u1 = User(email    = 'gcca@hub.io',
              password = '789',
              customs  = cs1.key)
    u1.store()

    c1 = Customer(
        name     = 'Massive Dynamics',
        document = Document(type='RUC', number='12345678989'),
        social   = 'Innovation',
        activity = 'Xploit the world',
        legal    = 'Nina Sharp',
        address  = 'Fringe',
        category = 'Importador frecuente',
        shareholders = [
            Customer.Shareholder(
                document = Document(type='DNI',
                                             number='12345678'),
                name     = 'William Bell'),
            Customer.Shareholder(
                document = Document(type='Carné de Extranjería',
                                             number='123456'),
                name     = 'Walter Bishop')])
    c1.store()

    c2 = Customer(
        name     = 'cristHian Gz. (gcca)',
        document = Document(type='DNI', number='12345678'),
        activity = 'Ing. Software',
        address  = 'Atrás del mar',
        phone    = '666-5555',
        nationality = 'Peruana'
    )
    c2.store()

    ds = Datastore()

    d1 = Dispatch(
        order = '2014-02',
        customer = c1.key,
        customs = cs1.key
    )
    d1.store()
    cs1.datastore.pending.dispatches.append(d1.key)
    cs1.store()


class Debug(BaseHandler):

    def get(self):
        create()
        self.write('Don\'t worry... Be happy.')

    def post(self):
        db.delete_multi(v for m in [Customer, User, Customs, Declaration,
                                    Dispatch]
                        for v in m.query().fetch(keys_only=True))
        self.write('The End.')
