from webapp2 import WSGIApplication, Route
from interface import view, handler
from application.debug import Debug


API = '/api/v1'

app = WSGIApplication([
    ('/debug', Debug),

    # Views
    ('/', view.SignIn),
    ('/signout', view.SignOut),
    ('/customer', view.Customer),
    ('/dashboard.*', view.Dashboard),
    ('/declaration/(\\d+)/pdf', view.DeclarationPDF),

    # Handlers
    ('/api/v1/customer', handler.Customer),
    Route(r'/api/v1/customer/<id:\d+>', handler.Customer),
    Route(r'/api/v1/customer/<id:\d+>/declaration',
          handler.Customer.Declaration),
    ('/api/v1/customers', handler.Customers),

    ('/api/v1/user', handler.User),
    Route(r'/api/v1/user/<id:\d+>', handler.User),

    ('/api/v1/declaration', handler.Declaration),
    ('/api/v1/declarations', handler.Declarations),

    ('/api/v1/customs', handler.Customs),
    Route('/api/v1/customs/pending/dispatches',
          handler.Customs.pending_dispatches),

    ('/api/v1/dispatch', handler.Dispatch),
    Route(r'/api/v1/dispatch/<id:\d+>', handler.Dispatch),

    ('/api/v1/stakeholder', handler.Stakeholder),
    Route(r'/api/v1/dispatch/<id:\d+>', handler.Stakeholder)

], debug=True)
