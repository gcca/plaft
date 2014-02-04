# encoding: utf-8

from __future__ import unicode_literals

from domain.model import Document, Customer, Shareholder, User, Customs, \
                         Officer
from interface import BaseHandler
from domain.c_gz import db


def create():
    customs = Customs(name    = 'SCharff',
                      code    = '789',
                      officer = Officer(name='John Connor', code='1212'))
    customs.store()

    u1 = User(email    = 'gcca@hub.io',
              password = '123',
              customs  = customs.key)
    u1.store()

    c1 = Customer(
        name     = 'Massive Dynamics',
        document = Document(type='RUC', number='12345678989'),
        social   = 'Innovation',
        activity = 'Xploit the world',
        legal    = 'Nina Sharp',
        address  = 'Fringe',
        shareholders = [
            Shareholder(
                document = Document(type='DNI',
                                    number='12345678'),
                name     = 'William Bell'),
            Shareholder(
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


class Debug(BaseHandler):

    def get(self):
        create()
        self.write('Don\'t worry... Be happy.')

    def post(self):
        db.delete_multi(v for m in [Customer, User, Customs]
                        for v in m.query().fetch(keys_only=True))
        self.write('The End.')
