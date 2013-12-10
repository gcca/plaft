# encoding: utf-8
"""
domain.model
"""

import infraestructure.utils as utils
from domain.gz import Entity, PolyEntity, ReferenceProperty, StringProperty, \
    EmailProperty, BooleanProperty, DateProperty, TextProperty, \
    JsonProperty, BadValueError, Key, ListProperty, StoreFailedError

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

    protected = ['id', 'password']

    @classmethod
    def register(self, email, password, **k):
        password = utils.make_pw_hash(email, password)
        return self(email=email, password=password, **k)

    @classmethod
    def login(self, email, password):
        user = User.find(email=email)
        if user and utils.valid_pw(email, password, user.password): return user

# ---------
# Datastore
# ---------
class Datastore(Entity):

    pendingDispatches    = ListProperty (Key)
    registerOperations   = ListProperty (Key)
    unusualOperations    = ListProperty (Key)
    suspiciousOperations = ListProperty (Key)

    @property
    def operationsBy(self):
        return {
            'register'   : self.registerOperations,
            'unusual'    : self.unusualOperations,
            'suspicious' : self.suspiciousOperations
        }

# -----------
# Declaration
# -----------
class Declaration(Entity):
    """Declaration Entity

    Declaraciones Juradas

    Attributes:
        trackingId: Código autogenerado por declaración jurada.
        source: Origen de los fondos.
        references: Referencias del cliente.
        customer: Referencia hacia el cliente que genera la declaración jurada.
        thirdName: Nombre o razón social del tercero.
        thirdDocumentNumber: Número del documento de identificación del tercero.
    """

    trackingId          = StringProperty       ()
    source              = TextProperty         ()
    references          = TextProperty         ()
    customer            = JsonProperty         ()
    thirdName           = TextProperty         ()
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

    name            = StringProperty ()
    documentNumber  = StringProperty ()
    documentType    = TextProperty   ()
    address         = TextProperty   ()
    officialAddress = TextProperty   ()
    isObliged       = TextProperty   ()
    hasOfficier     = TextProperty   ()
    activity        = TextProperty   ()
    phone           = TextProperty   ()
    lastDeclaration = ReferenceProperty (Declaration)

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
        birthday: Fecha de nacimiento.
        nationality: Nacionalidad.
        businessNumber: RUC de la persona, si la tiene.
        publicOffice: Cargo o función pública
    """

    birthday        = TextProperty ()
    nationality     = TextProperty ()
    businessNumber  = TextProperty ()
    martialPartner  = TextProperty ()
    domesticPartner = TextProperty ()
    mobile          = TextProperty ()
    email           = TextProperty ()
    civilStatus     = TextProperty ()
    publicOffice    = TextProperty ()

class Business(Customer):
    """Business Entity

    Customer business (legal entity).

    Attributes:
        socialObject: Objecto social.
        legal: Identificación del representante legal.
        contactPhone: Teléfono de contacto de la empresa.
        shareholders: Lista de accionistas en formato JSON.
    """

    socialObject    = TextProperty ()
    legal           = TextProperty ()
    contact         = TextProperty ()
    shareholders    = JsonProperty ()

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
    code           = StringProperty (default='')
    officierName   = TextProperty   ()
    officierCode   = StringProperty ()
    datastore      = ReferenceProperty(Datastore)

    protected = ['datastore']

    def store(self, *a, **k):
        """Store.
        Assert datastore.
        """
        if not self.datastore:
            datastore = Datastore()
            datastore.store()
            self.datastore = datastore
        super(CustomsBroker, self).store(*a, **k)

    def pendingDispatches(self):
        """Returns pending dispatches query."""
        return Dispatch.get(self.datastore.pendingDispatches)

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

    aModel = CustomsBroker
    customsBroker = ReferenceProperty(CustomsBroker, collection_name='users')

    @classmethod
    def register(self, name, password, customsBroker, **_):
        return super(CustomsBrokerUser, self).register(
            name, password, customsBroker=customsBroker)

    @property
    def datastore(self): return self.customsBroker.datastore

    def createDispatch(self, dto):
        """
        TODO(...): DOCs and Exceptions.
        """
        try:
            dispatch = Dispatch.new(dto)
            key = dispatch.store()
        except:
            raise Exception()
        else:
            try:
                self.datastore.pendingDispatches.append(key)
                self.datastore.store()
            except:
                dispatch.delete()
                raise Exception()

    def fixDispatch(self, disptach, type):
        """TODO(...): """

        if not type in ('register', 'unusual', 'suspicious'):
            raise BadValueError(
                'type not in (\'register\', \'unusual\', \'suspicious\')')

        operation = Operation()
        operation.store()

        disptach.operation = operation
        try:
            disptach.store()
        except StoreFailedError as ex:
            operation.delete()
            raise ex
        else:
            disptachKey = disptach.key()
            self.datastore.pendingDispatches.remove(disptachKey)
            try:
                self.datastore.store()
            except StoreFailedError as ex:
                operation.delete()
                disptach.operation = None
                disptach.store()
                raise ex
            else:
                self.datastore.operationsBy[type].append(disptachKey)
                self.datastore.store()


# ---------
# Operation
# ---------
class Operation(Entity):
    """
    Attributes:
        customsBroker
        dispatches

    TODO(...): Create doc.
    """

    customsBroker = ReferenceProperty(CustomsBroker,
                                      collection_name='operations')

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

    orderNumber                = StringProperty ()
    customsBrokerCode          = TextProperty   ()
    dateReceived               = DateProperty   ()
    customerReferences         = TextProperty   () # Esto no debería esta acá
    customsRegime              = TextProperty   ()
    customsCode                = TextProperty   ()
    businessName               = TextProperty   ()
    invoiceNumber              = TextProperty   ()
    invoiceAddress             = TextProperty   ()
    invoiceValue               = TextProperty   ()
    invoiceAdjustment          = TextProperty   ()
    invoiceCurrencyValue       = TextProperty   ()
    invoiceCurrencyAdjustment  = TextProperty   ()
    register                   = JsonProperty   ()
    alerts                     = JsonProperty   ()
    operation = ReferenceProperty(Operation, collection_name='dispatches')
    declaration = ReferenceProperty(Declaration, collection_name='dispatches')
