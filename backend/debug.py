# -*- coding: utf-8 -*-
import webapp2
from datetime import date
from domain.gz import db
from domain.model import CustomsBrokerUser, CustomsBroker, Business, \
    Dispatch, Declaration

def main():
    # Customs Brokers
    cb1 = CustomsBroker(name='SkyNet (J)',
                        documentNumber='666-666-69')
    cb1.store()

    cb2 = CustomsBroker(name='Massive Dynamic',
                        documentNumber='123-789-99')
    cb2.store()

    cb3 = CustomsBroker(name='Cyberdine',
                        documentNumber='12-12-12')
    cb3.store()

    # Customs Broker Users
    cbu1 = CustomsBrokerUser.register('gcca@meil.io',
                                      '123',
                                      customsBroker=cb3)
    cbu1.store()

    # Customers
    p1 = Business(name='cristHian Gz. (gcca)',
                  documentType='RUC',
                  documentNumber='12345678989')
    p1.store()

    p2 = Business(name='Máximo Décimo',
                  documentType='RUC',
                  documentNumber='12345678980')
    p2.store()

    # Dispatches
    d1 = Dispatch(
        orderNumber                = '2013-05',
        customsBrokerCode          = '',
        dateReceived               = date(2013, 05, 12),
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
        customer = p1)
    d1.store()
    d2 = Dispatch(
        orderNumber                = '2013-11',
        customsBrokerCode          = '',
        dateReceived               = date(2013, 11, 12),
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
        customer = p2)
    d2.store()


# Debug View
class DebugView(webapp2.RequestHandler):
    def get(self):
        main()
        self.response.out.write('Don\'t worry. Be happy')

    def post(self):
        db.delete(v for m in (CustomsBrokerUser, CustomsBroker, Business,
                             Dispatch, Declaration)
                  for v in m.all(keys_only=True))
        self.response.out.write('The End')
