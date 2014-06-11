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


class Customer(Model):
    """Cliente (de la agencia de aduanas).

    Attributes:
        name: Nombre y apellido o razón social.
        document: .

    """

    class Shareholder(ValueObject):
        """Customer shareholder.

        Attributes:
            document: A Document value object.
            name: A string shareholder name.
        """

        name     = TextProperty       ()
        document = StructuredProperty (Document)

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

    @property
    def isbusiness(self):
        return len(self.document.number) == 11

    @property
    def isperson(self):
        return not self.isbusiness


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

    def before_store(self):
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


class Stakeholder(Expando):
    """Involucrados en los Anexos 6 y 2."""

    # Business
    name    = TextProperty ()
    address = TextProperty ()
    city    = TextProperty ()
    country = TextProperty ()
    phone   = TextProperty ()

    # Person
    surname1    = TextProperty ()
    surname2    = TextProperty ()
    name        = TextProperty ()
    nationality = TextProperty ()


class Dispatch(Model):
    """Despacho.

    Attributes:
        order: Número de orden.
        type: Tipo de operación.
        regime: Régimen aduanero.
        jurisdiction: Jurisdicción de aduana.
        third: Identificación del tercero.
        declaration: A Declaration Key.
        customer: A Customer Key.
        customs: A Customs Key.
    """

    class CodeName(ValueObject):
        """Para 'value objects' con esquema código - nombre."""

        code = TextProperty ()
        name = TextProperty ()

    class Alert(ValueObject):

        code      = TextProperty    ()
        text      = TextProperty    ()
        source    = TextProperty    ()
        other     = TextProperty    ()
        third     = TextProperty    ()
        comment   = TextProperty    ()
        iscorrect = BooleanProperty ()
        correct   = TextProperty    ()

    class Numeration(ValueObject):

        number   = StringProperty  ()
        date     = DateStrProperty ()
        type     = TextProperty    ()
        amount   = TextProperty    ()
        exchange = TextProperty    ()
        currency = TextProperty    ()
        items    = TextProperty    (repeated=True)
        supplier = JsonProperty    ()
        importer = JsonProperty    ()

    class Anex6(Expando):

        stakeholders = JsonProperty()
        # StructuredProperty (Stakeholder, repeated=True)

    class Anex2(Expando):

        stakeholders = JsonProperty()
        # StructuredProperty (Stakeholder, repeated=True)

    order        = StringProperty     ()
    type         = StructuredProperty (CodeName)
    regime       = StructuredProperty (CodeName)
    jurisdiction = StructuredProperty (CodeName)
    third        = TextProperty       ()
    alerts       = StructuredProperty (Alert, repeated=True)
    numeration   = StructuredProperty (Numeration)
    declaration  = KeyProperty        (kind=Declaration)
    customer     = KeyProperty        (kind=Customer)
    customs      = KeyProperty        (kind=Customs)
    operation    = KeyProperty        (kind='Operation')
    verifies     = BooleanProperty    (repeated=True)
    anex6        = StructuredProperty (Anex6)
    anex2        = StructuredProperty (Anex2)


class Operation(Model):
    """Operación (Registro de operaciones).

    Attributes:
        dispatches: A Dispatch Key list.
        customs: A Customs Key.
    """

    dispatches = KeyProperty (kind=Dispatch, repeated=True)
    customs    = KeyProperty (kind=Customs)


class Datastore(Model):
    """Datos globales de la aplicación."""

    class DSingleton(Singleton):

        def __call__(self, *a, **k):
            if self._instance is None:
                self._instance = self.query().get()
                if self._instance is None:
                    self._instance = super(Singleton, self).__call__(*a, **k)
                    self._instance.store()
            return self._instance

    __metaclass__ = DSingleton

    class _Meta(ValueObject):

        declarations = KeyProperty(kind=Declaration, repeated=True)

    pending = StructuredProperty (_Meta, default=_Meta())
