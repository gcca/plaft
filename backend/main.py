from webapp2 import WSGIApplication, Route
from webapp2_extras import routes

from interface.views import SignInView, CustomerFormView, DashboardView, \
    DeclarationPDFView
from interface.handlers import CustomerHandler, DeclarationHandler, \
    CustomerDeclarationHandler, CustomerLastDeclarationHandler, DispatchHandler

from debug import DebugView

API = '/api/v1'

def RESTful(prefix, handler, methods=tuple()):
    if type(prefix) is tuple: prefix = r'%s/<pid:\d+>/%s' % prefix
    return routes.PathPrefixRoute(API, [
            Route('/' + prefix, handler),
            Route(r'/%s/<id:\d+>' % prefix, handler)
            ] + [Route('/%s/%s' % (prefix, uri), controller) \
                     for (uri, controller) in methods])

app = WSGIApplication([

    ('/debug', DebugView),

    # Views
    ('/', SignInView),
    ('/customer-form', CustomerFormView),
    ('/dashboard', DashboardView),

    ('/declaration/(\\d+)/pdf', DeclarationPDFView),

    # Handlers
    RESTful('customer', CustomerHandler, [
                ('lastdeclaration', CustomerLastDeclarationHandler)
                ]),
    RESTful('declaration', DeclarationHandler),
    RESTful(('customer', 'declaration') , CustomerDeclarationHandler),
    RESTful('dispatch', DispatchHandler)
    # RESTful('/operation', OperationHandler),

], debug=True)
