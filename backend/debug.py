# encoding: utf-8
from __future__ import unicode_literals
import webapp2
from datetime import date
from domain.gz import db
from infraestructure.utils import Dto
from domain.model import CustomsBrokerUser, CustomsBroker, Business, \
    Dispatch, Declaration, Datastore, Operation, Person, Customer

def main():
    # Customs Brokers
    cb1 = CustomsBroker(name='SkyNet (J)',
                        documentNumber='666-666-69')
    cb1.store()

    cb2 = CustomsBroker(name='OPC',
                        documentNumber='123-789-99')
    cb2.store()

    cb3 = CustomsBroker(name='Cyberdine',
                        documentNumber='85236987456',
                        code='999SDS',
                        officierName='John Connor',
                        officierCode='AVG2013')
    cb3.store()

    jurisdictions = [Dto({"code": "118", "name": "MAR\u00cdTIMA DEL CALLAO"}),
                     Dto({"code": "046", "name": "PAITA"}),
                     Dto({"code": "019", "name": "TUMBES"}),
                     Dto({"code": "235", "name": "A\u00c9REA DEL CALLAO"}),
                     Dto({"code": "154", "name": "AREQUIPA"}),
                     Dto({"code": "172", "name": "TACNA"}),
                     Dto({"code": "082", "name": "SALAVERRY"}),
                     Dto({"code": "145", "name": "MOLLENDO - MATARANI"}),
                     Dto({"code": "163", "name": "ILO"}),
                     Dto({"code": "127", "name": "PISCO"}),
                     Dto({"code": "181", "name": "PUNO"}),
                     Dto({"code": "028", "name": "TALARA"}),
                     Dto({"code": "262", "name": "DESAGUADERO"}),
                     Dto({"code": "244", "name": "POSTAL DE LIMA"}),
                     Dto({"code": "992", "name": "LIMA METROPOLITANA"})]
    cb4 = CustomsBroker(name='Scharff Logistica Integrada S.A.',
                        documentNumber='20463958590',
                        code='7053',
                        officierName='John Connor',
                        officierCode='AVG2013',
                        jurisdictions=jurisdictions)
    cb4.store()

    # Customs Broker Users
    cbu1 = CustomsBrokerUser.register('gcca@meil.io',
                                      '123',
                                      customsBroker=cb4)
    cbu1.store()

    # Customers
    customer1 = Business(
        name='Massive Dynamic',
        socialObject='El objeto',
        activity='Venta de Fringes',
        legal='William Bell',
        address='Florida',
        officialAddress='UE',
        phone='564-8879',
        contact='Nina Sharp',
        isObliged='Sí',
        hasOfficier='No',
        shareholders=[
            Dto({
                'documentType': 'PA',
                'name': 'Cyberdine',
                'documentNumber': '12345678989'}),
            Dto({
                'documentType': 'CE',
                'name': 'Al adjua mllds j',
                'documentNumber': '998-7878-788-8'})],
        documentType='RUC',
        documentNumber='12345678989')
    customer1.store()

    customer2 = Person(
        name='cristHian Gz. (gcca)',
        documentType='DNI',
        documentNumber='12345678')
    customer2.store()

    # Declarations
    declaration1 = Declaration(
        trackingId          = 'GGGGG666',
        source              = '',
        references          = '',
        customer            = Dto(customer1.dict),
        third               = True,
        thirdType           = 'person',
        thirdName           = 'TM Fire on Sky',
        thirdDocumentType   = 'RUC',
        thirdDocumentNumber = '963963852789')
    declaration1.put()
    customer1.lastDeclaration = declaration1
    customer1.store()

    declaration2 = Declaration(
        trackingId          = '666GGGGG',
        source              = '',
        references          = '',
        customer            = Dto(customer2.dict),
        third               = True,
        thirdType           = 'person',
        thirdName           = 'Hell Bells',
        thirdDocumentType   = 'RUC',
        thirdDocumentNumber = '12211112129')
    declaration2.put()

    # Dispatches
    cbu1.createDispatch(Dto(
        orderNumber                = '2013-05',
        customsBrokerCode          = '',
        dateReceived               = '2013-05-12',
        customerReferences         = '',
        customsRegime              = '',
        customsCode                = '',
        businessName               = '',
        invoiceNumber              = '',
        invoiceAddress             = '',
        invoiceValue               = '',
        invoiceAdjustment          = '',
        invoiceCurrencyValue       = '',
        invoiceCurrencyAdjustment  = '',
        declaration = declaration1.id))

    cbu1.createDispatch(Dto(
        orderNumber                = '2013-11',
        customsBrokerCode          = '',
        dateReceived               = '2013-11-12',
        customerReferences         = '',
        customsRegime              = '',
        customsCode                = '',
        businessName               = '',
        invoiceNumber              = '',
        invoiceAddress             = '',
        invoiceValue               = '',
        invoiceAdjustment          = '',
        invoiceCurrencyValue       = '',
        invoiceCurrencyAdjustment  = '',
        declaration = declaration2.id))


# Debug View
class DebugView(webapp2.RequestHandler):
    def get(self):
        main()
        self.response.out.write('Don\'t worry. Be happy')

    def post(self):
        db.delete(v for m in (CustomsBrokerUser, CustomsBroker, Customer,
                              Dispatch, Declaration, Datastore, Operation)
                  for v in m.all(keys_only=True))
        self.response.out.write('The End')
