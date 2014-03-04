# encoding: utf-8

from __future__ import unicode_literals

from uuid import uuid1 as uuid
from c_gz import *


class Document(ValueObject):
    """Identification document.

    Use value object for entities with identification document.

    Attributes:
        type: A string document type (RUC, DNI, etc).
        number: A string document number.
    """

    type_choices = ['DNI', 'RUC', 'Pasaporte', 'Carné de Extranjería']

    type   = TextProperty   (choices=type_choices)
    number = StringProperty ()


class Shareholder(ValueObject):
    """Customer shareholder.

    Attributes:
        document: A Document value object.
        name: A string shareholder name.
    """

    document = StructuredProperty (Document)
    name     = TextProperty       ()


class Customer(Model):
    """Cliente (de la agencia de aduanas).

    Attributes:
        name: Nombre y apellido o razón social.
        document: .

    """

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
    """Declaración Jurada.

    Attributes:
        tracking: A string identification code.
        source: Origen de los fondos.
        third: Identificación del tercero.
        customer: Datos histórcios del cliente.
        owner: Customer key.
    """

    tracking = StringProperty     ()
    source   = TextProperty       ()
    third    = TextProperty       ()
    customer = StructuredProperty (Customer)
    owner    = KeyProperty        (kind=Customer)

    def _pre_store(self):
        self.tracking = str(uuid()).upper().split('-')[0]


class Officer(ValueObject):
    """Oficial de Cumplimiento.

    Attributes:
        name: Nombre del oficial de cumplimiento.
        code: Código otorgado por la UIF.
    """

    name = TextProperty ()
    code = TextProperty ()


class Customs(Model):
    """Agencia de Aduanas.

    Attributes:
        name: Nombre de la agencia.
        code: Código otorgado por aduanas.
        officier: A Officier value object.
        datastore: A Datastore value object.
    """

    class Datastore(ValueObject):

        class _Dispatches(ValueObject):
            dispatches   = KeyProperty (kind='Dispatch'   , repeated=True)
            declarations = KeyProperty (kind='Declaration', repeated=True)

        pending = StructuredProperty (_Dispatches, default=_Dispatches())

    exclude = ['datastore']

    name      = StringProperty     ()
    code      = StringProperty     ()
    officer   = StructuredProperty (Officer)
    datastore = StructuredProperty (Datastore, default=Datastore())


class User(User):
    """Usuario.

    Attributes:
        email: A string e-mail.
        password: A string password.
        customs: A key Customs.

    TODO(...): Implement hierarchy.
    """

    customs = KeyProperty (kind=Customs)


class CodeName(ValueObject):
    """Para 'value objects' con esquema código - nombre."""

    code = TextProperty ()
    name = TextProperty ()


class Dispatch(Model):
    """Despacho.

    Attributes:
        order: Número de orden.
        date: Fecha de registro.
        type: Tipo de operación.
        regime: Régimen aduanero.
        jurisdiction: Jurisdicción de aduana.
        third: Identificación del tercero.
        declaration: A Declaration Key.
        customer: A Customer Key.
        customs: A Customs Key.
    """

    order        = StringProperty     ()
    date         = DateStrProperty    ()
    type         = StructuredProperty (CodeName)
    regime       = StructuredProperty (CodeName)
    jurisdiction = StructuredProperty (CodeName)
    third        = TextProperty       ()
    declaration  = KeyProperty        (kind=Declaration)
    customer     = KeyProperty        (kind=Customer)
    customs      = KeyProperty        (kind=Customs)
    operation    = KeyProperty        (kind='Operation')

    def _pre_store(self):
        self.customs = self.user.customs

    def _post_store(self, future):
        customs = self.user.customs.get()
        customs.datastore.pending.dispatches.append(future.get_result())
        customs.store()


class Operation(Model):
    """Operación (Registro de operaciones).

    Attributes:
        dispatches: A Dispatch Key list.
        customs: A Customs Key.
    """

    dispatches = KeyProperty (kind=Dispatch, repeated=True)
    customs    = KeyProperty (kind=Customs)
