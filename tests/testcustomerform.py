import unittest2

import gztest

from domain.model import Customer, Movement, CustomsBroker

class TestCustomerForm(unittest2.TestCase):

    def setUp(self):
        gztest.qop_init()
        self.app = gztest.webtestApp()
        self.API = self.app.main.API

        customsBroker = CustomsBroker(name='Massive Dynamic (TM)',
                                      documentNumber='96385207410')
        customsBroker.put()
        self.broker = customsBroker

    def tearDown(self):
        self.broker.delete()
        from google.appengine.ext import db
        # (-o-) Dangerous - Collect id's
        db.delete(Customer.all(keys_only=True))
        gztest.qop_end()

    def testRegisterMovement(self):
        rget = self.app.get(
                self.API + '/customer?documentNumber=12345678',
                expect_errors=True)

        self.assertEqual(rget.status_code, 404)

        customerJson = {
            'name' : 'cristHian Gz. (gcca)',
            'documentNumber' : '12346578'
        }

        rpost = self.app.post_json(self.API + '/customer', customerJson)

        customerJson['id'] = rpost.json['id']

        movementJson = {
            'amount' : '666',
            'customer' : customerJson['id'],
            'customsBroker' : self.broker.id
        }

        res = self.app.post_json(self.API + '/movement', movementJson)

        movement = Movement.by_id(int(res.json['id']))

        self.assertIsNotNone(movement.customer)
        self.assertIsNotNone(movement.customsBroker)

        self.assertIsInstance(movement.customer, Customer)
        self.assertIsInstance(movement.customsBroker, CustomsBroker)

        self.assertEqual(movement.amount, 666.0)
        self.assertEqual(movement.customer.id, customerJson['id'])
        self.assertEqual(movement.customsBroker.id, self.broker.id)
