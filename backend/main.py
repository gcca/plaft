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
    ('/dashboard', view.Dashboard),
    ('/declaration/(\\d+)/pdf', view.DeclarationPDF),

    # Handlers
    ('/api/v1/customer', handler.Customer),
    Route(r'/api/v1/customer/<id:\d+>', handler.Customer),
    Route(r'/api/v1/customer/<id:\d+>/declaration',
          handler.Customer.newDeclaration),
    ('/api/v1/customers', handler.Customers),

    ('/api/v1/user', handler.User),
    Route(r'/api/v1/user/<id:\d+>', handler.User),

    ('/api/v1/customs', handler.Customs),
    Route(r'/api/v1/customs/<id:\d+>', handler.Customs)


], debug=True)
