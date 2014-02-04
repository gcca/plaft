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

    # Business
    social       = TextProperty       ()
    legal        = TextProperty       ()
    contact      = TextProperty       ()
    shareholders = StructuredProperty (Shareholder, repeated=True)

    # Person
    business    = TextProperty        ()
    birthday    = TextProperty        ()
    nationality = TextProperty        ()
    mobile      = TextProperty        ()
    email       = TextProperty        ()
    status      = TextProperty        ()
    marital     = TextProperty        ()
    domestic    = TextProperty        ()
    public      = TextProperty        ()
    domestic    = TextProperty        ()


class Declaration(Model):

    tracking = ComputedProperty   (lambda _: str(uuid()).upper().split('-')[0])
    source   = TextProperty       ()
    third    = TextProperty       ()
    customer = StructuredProperty (Customer)


class Officer(ValueObject):

    name = TextProperty ()
    code = TextProperty ()


class Customs(Model):

    name    = StringProperty     ()
    code    = StringProperty     ()
    officer = StructuredProperty (Officer)


class User(User):

    customs = KeyProperty (kind=Customs)
