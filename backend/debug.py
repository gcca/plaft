# -*- coding: utf-8 -*-
import webapp2
from datetime import date
from domain.gz import db
from infraestructure.utils import Dto
from domain.model import CustomsBrokerUser, CustomsBroker, Business, \
    Dispatch, Declaration, Datastore, Operation

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

    # Customs Broker Users
    cbu1 = CustomsBrokerUser.register('gcca@meil.io',
                                      '123',
                                      customsBroker=cb3)
    cbu1.store()

    # Customers
    customer1 = Business(
        name='cristHian Gz. (gcca)',
        documentType='RUC',
        documentNumber='12345678989')
    customer1.store()

    customer2 = Business(
        name='Massive Dynamic',
        documentType='RUC',
        documentNumber='12345678980')
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
        db.delete(v for m in (CustomsBrokerUser, CustomsBroker, Business,
                              Dispatch, Declaration, Datastore, Operation)
                  for v in m.all(keys_only=True))
        self.response.out.write('The End')
