from webapp2 import WSGIApplication, Route
from webapp2_extras import routes

from interface.views import SignInView, CustomerFormView, DashboardView, \
    DeclarationPDFView
from interface.handlers import CustomerHandler, DeclarationsHandler, \
    CustomerDeclarationHandler, CustomerLastDeclarationHandler, \
    DispatchHandler, SignInHandler, DispatchesHandler, DispatchFix

from debug import DebugView

API = '/api/v1'

def RESTful(prefix, handler, methods=tuple()):
    if type(prefix) is tuple: prefix = r'%s/<pid:\d+>/%s' % prefix
    return routes.PathPrefixRoute(API, [
        Route('/' + prefix, handler),
        Route(r'/%s/<id:\d+>' % prefix, handler)
    ] + [Route('/%s/%s' % (prefix, uri), ctrlr) for uri, ctrlr in methods])

app = WSGIApplication([
    ('/debug', DebugView),

    # Views
    ('/', SignInView),
    ('/customer-form', CustomerFormView),
    ('/dashboard', DashboardView),

    ('/declaration/(\\d+)/pdf', DeclarationPDFView),

    # Handlers
    RESTful('signin', SignInHandler),
    RESTful('customer', CustomerHandler, [
        ('lastdeclaration', CustomerLastDeclarationHandler)
    ]),
    RESTful('declarations', DeclarationsHandler),
    RESTful(('customer', 'declaration') , CustomerDeclarationHandler),
    RESTful('dispatch', DispatchHandler),
    ('/api/v1/dispatch/(\\d+)/fix', DispatchFix),
    RESTful('dispatches', DispatchesHandler)
], debug=True)
