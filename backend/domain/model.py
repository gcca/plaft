# encoding: utf-8

from __future__ import unicode_literals

from uuid import uuid1 as uuid
from c_gz import *


class Document(ValueObject):

    type_choices = ['DNI', 'RUC', 'Pasaporte', 'Carné de Extranjería']

    type   = TextProperty   (choices=type_choices)
    number = StringProperty ()


class Shareholder(ValueObject):

    document = StructuredProperty (Document)
    name     = TextProperty       ()


class Customer(Model):

    # Customer
    name         = StringProperty     ()
    document     = StructuredProperty (Document)

    address      = TextProperty       ()
    fiscal       = TextProperty       ()
    phone        = TextProperty       ()
    activity     = TextProperty       ()

    isobliged    = TextProperty       ()
    hasofficer   = TextProperty       ()
    category     = TextProperty       ()

    # Business
    social       = TextProperty       ()
    legal        = TextProperty       ()
    contact      = TextProperty       ()
    shareholders = StructuredProperty (Shareholder, repeated=True)

    # Person
    business     = TextProperty       ()
    birthday     = TextProperty       ()
    nationality  = TextProperty       ()
    mobile       = TextProperty       ()
    email        = TextProperty       ()
    status       = TextProperty       ()
    marital      = TextProperty       ()
    domestic     = TextProperty       ()
    public       = TextProperty       ()
    domestic     = TextProperty       ()


class Declaration(Model):

    tracking = StringProperty     ()
    source   = TextProperty       ()
    third    = TextProperty       ()
    customer = StructuredProperty (Customer)
    owner    = KeyProperty        (kind=Customer)

    def _pre_store(self):
        self.tracking = str(uuid()).upper().split('-')[0]


class Officer(ValueObject):

    name = TextProperty ()
    code = TextProperty ()


class Customs(Model):

    class Datastore(ValueObject):

        class _Dispatches(ValueObject):
            dispatches = KeyProperty (kind='Dispatch', repeated=True)

        pending = StructuredProperty (_Dispatches, default=_Dispatches())

    exclude = ['datastore']

    name      = StringProperty     ()
    code      = StringProperty     ()
    officer   = StructuredProperty (Officer)
    datastore = StructuredProperty (Datastore, default=Datastore())


class User(User):

    customs = KeyProperty (kind=Customs)


class CodeName(ValueObject):

    code = TextProperty ()
    name = TextProperty ()


class Dispatch(Model):

    order        = StringProperty     ()
    date         = DateStrProperty    ()
    operation    = StructuredProperty (CodeName)
    regime       = StructuredProperty (CodeName)
    jurisdiction = StructuredProperty (CodeName)
    third        = TextProperty       ()
    declaration  = KeyProperty        (kind=Declaration)
    customer     = KeyProperty        (kind=Customer)
    customs      = KeyProperty        (kind=Customs)

    def _post_store(self, future):
        customs = self.user.customs.get()
        customs.datastore.pending.dispatches.append(future.get_result())
        customs.store()


class Operation(Model):

    dispatches = KeyProperty (kind=Dispatch, repeated=True)
    customs    = KeyProperty (kind=Customs)
