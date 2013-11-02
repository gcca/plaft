import unittest2

import gztest

class TestDeclaration(unittest2.TestCase):

    def setUp(self):
        gztest.qop_init()
        self.app = gztest.webtestApp()

    def tearDown(self):
        gztest.qop_end()

    def testRegisterDeclaration(self):
        get = self.app.get(self.API + '/customer',
                           expect_errors=True)
