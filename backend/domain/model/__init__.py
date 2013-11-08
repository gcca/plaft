# encoding: utf-8
"""
domain.model
"""

import infraestructure.utils as utils
from domain.gz import Entity, PolyEntity, ReferenceProperty, StringProperty, \
    EmailProperty, BooleanProperty, DateProperty, TextProperty, \
    DocumentTypeProperty, JsonProperty, BadValueError

# ----
# User
# ----
class User(PolyEntity):
    """User Entity

    Basic user manager: register and authentication.

    Attributes:
        email: Username.
        password: encrypted password.

    TODO(gcca): User Authorization.
    """

    email    = EmailProperty  (required = True)
    password = StringProperty (required = True)

    @classmethod
    def register(self, email, password, **k):
        password = utils.make_pw_hash(email, password)
        return self(email=email, password=password, **k)

    @classmethod
    def login(self, email, password):
        user = User.find(email=email)
        if user and utils.valid_pw(email, password, user.password):
            return user

# -----------
# Declaration
# -----------
class Declaration(Entity):
    """Declaration Entity

    Declaraciones Juradas

    Attributes:
        trackingId: Código autogenerado por declaración jurada.
        source: Origen del dinero.
        references: Referencias del cliente.
        customer: Referencia hacia el cliente que genera la declaración jurada.
        third: ¿Existe un tercero? (Beneficiario final.)
        thirdType: ¿...?
        thirdName: Nombre o razón social del tercero.
        thirdDocumentType: Tipo de documento de identidad del tercero.
        thirdDocumentNumber: Número del documento de identificación del tercero.
    """

    trackingId          = StringProperty       ()
    source              = TextProperty         ()
    references          = TextProperty         ()
    customer            = JsonProperty         ()
    third               = BooleanProperty      ()
    thirdType           = TextProperty         ()
    thirdName           = TextProperty         ()
    thirdDocumentType   = DocumentTypeProperty ()
    thirdDocumentNumber = TextProperty         ()

    def _nextTrackingId(self):
        """() -> str
        Invoke before store.
        Returns: Unique identifier. Eight length alphanumeric string.
        """
        random = str(self.uuid()).upper()
        return random[:random.index('-')]

    def store(self):
        if not self.trackingId: self.trackingId = self._nextTrackingId()
        return super(Declaration, self).store()

# --------
# Customer
# --------
class Customer(PolyEntity):
    """Customer Entity

    Base class for customer person and business.

    Attributes:
        name: Nombre de la persona o razón social de la empresa.
        documentNumber: Número del documento de identificación.
        documentType: Tipo de documento: DNI, RUC, CA, PA.
        address: Domicilio declarado.
        officialAddress: Domicilio fiscal.
        isObliged: ¿Es sujeto obligado?
        hasOfficier: ¿Tiene oficial de cumplimiento designado?
        activity: Actividad profesional de la persona natural
                  o actividad económica de la persona jurídica.
        lastDeclaration: Última declaración jurada emitida por el cliente.
    """

    name            = StringProperty       ()
    documentNumber  = StringProperty       ()
    documentType    = DocumentTypeProperty ()
    address         = TextProperty         ()
    officialAddress = TextProperty         ()
    isObliged       = BooleanProperty      ()
    hasOfficier     = BooleanProperty      ()
    activity        = TextProperty         ()
    lastDeclaration = ReferenceProperty    (Declaration)

    protected = ['lastDeclaration']

    @property
    def isPerson(self):
        """Eval person customer. """
        return not self.isBusiness

    @property
    def isBusiness(self):
        """Eval business customer.

        TODO(gcca): Improve check business or person.
        """
        return self._isBusinessDocument(self.documentType, self.documentNumber)

    @classmethod
    def _isBusinessDocument(self, documentType='', documentNumber='', **_):
        try:
            isLen = 11 == len(documentNumber)
        except (TypeError, ValueError):
            raise BadValueError(
                'Invalid attribute documentNumber: (%s) %s'
                % (type(documentNumber), documentNumber))
        return isLen or ('RUC' == documentType and isLen)

    def __new__(self, *a, **k):
        return super(Customer, self).__new__(self.factory(*a, **k), *a, **k)

    @classmethod
    def factory(self, *_, **k):
        return Business if self._isBusinessDocument(**k) else Person

class Person(Customer):
    """Person Entity

    Customer natural person.

    Attributes:
        birthPlace: Lugar de nacimiento.
        birthday: Fecha de nacimiento.
        nationality: Nacionalidad.
        role: TODO(gcca): ¿What's role?
        businessNumber: RUC de la persona, si la tiene.
    """

    birthPlace         = TextProperty ()
    birthday           = DateProperty ()
    nationality        = TextProperty ()
    role               = TextProperty ()
    businessNumber     = TextProperty ()
    partnerName        = TextProperty ()
    organization       = TextProperty ()
    adressPersonLegal  = TextProperty ()
    adressPersonFiscal = TextProperty ()

    #phone          = StringProperty()
    #mobile         = StringProperty()
    #email          = EmailProperty()
    #civilStatus    = CategoryProperty()
    #partnerName    = StringProperty()
    #occupation     = StringProperty()       # Cargo público
    #organization   = StringProperty()       # Organismo público/extranjero

class Business(Customer):
    """Business Entity

    Customer business (legal entity).

    Attributes:
        socialObject: Objecto social.
        legalName: Nombre del representante legal.
        legalDocumentType: Tipo de documento del representante legal.
        legalDocumentNumber: Número de identificación del representante legal.
        addressCityCode: Código de la ciudad.
        phone: Teléfono.
        contact: Nombre de la persona de contacto.
        shareholders: Lista de accionistas en formato JSON.
    """

    socialObject        = TextProperty         ()
    legalName           = TextProperty         ()
    legalDocumentType   = DocumentTypeProperty ()
    legalDocumentNumber = TextProperty         ()
    addressCityCode     = TextProperty         ()
    contactPhone        = TextProperty         ()
    officePhone         = TextProperty         ()
    contact             = TextProperty         ()
    shareholders        = JsonProperty         ()
    activityEconomic    = TextProperty         ()

    def __init__(self, *a, **k):
        """Init Business """
        self.documentType = 'RUC'
        super(Business, self).__init__(*a, **k)

# -------------
# CustomsBroker
# -------------
class CustomsBroker(Entity):
    """Customs Broker Entity

    Agencia de aduanas.

    Attributes:
        name: Razón social.
        documentNumber: Número RUC.
    """

    name           = StringProperty ()
    documentNumber = StringProperty ()

# -------------------
# Customs Broker User
# -------------------
class CustomsBrokerUser(User):
    """Customs Broker User Entity

    Users of Customs Broker

    Attributes:
        customsBroker: Referecia a la agencia de aduana a la que
                       el usuario pertenece.
    """

    customsBroker = ReferenceProperty(CustomsBroker, collection_name='users')

    @classmethod
    def register(self, name, password, customsBroker, **_):
        return super(CustomsBrokerUser, self).register(
            name, password, customsBroker=customsBroker)

# --------
# Dispatch
# --------
class Dispatch(Entity):
    """Dispatch Entity

    Attributes:
        orderNumber: Código generado por recepcionista para cada despacho.
        customsBrokerCode: Codigo de Agente de Aduana.
        dateReceived: Fecha de Recepción.
        customerReferences: Referencias del cliente.
        customsRegime: Regimen Aduanero.
        customsCode: Codigo de Aduana.
        numberInvoice: Número de Factura Comercial.
        businessName: Razón Social.
        invoiceAddress: Dirección.
        invoiceValue: Valor / Importe.
        invoiceCurrencyValue : Moneda Valor / Importe.
        invoiceAdjustment: Ajuste Valor.
        invoiceCurrencyAdjustment: Moneda Ajuste Valor.

        TODO(...): Update doc.
    """

    orderNumber                = TextProperty ()
    customsBrokerCode          = TextProperty ()
    dateReceived               = DateProperty ()
    customerReferences         = TextProperty () # Esto no debería esta acá
    customsRegime              = TextProperty ()
    customsCode                = TextProperty ()
    businessName               = TextProperty ()
    invoiceNumber              = TextProperty ()
    invoiceAddress             = TextProperty ()
    invoiceValue               = TextProperty ()
    invoiceAdjustment          = TextProperty ()
    invoiceCurrencyValue       = TextProperty ()
    invoiceCurrencyAdjustment  = TextProperty ()
    alerts = JsonProperty ()
    declaration = ReferenceProperty(Declaration, collection_name='dispatches')
