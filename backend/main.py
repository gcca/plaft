from webapp2 import WSGIApplication, Route
from webapp2_extras import routes

from interface.views import SignInView, CustomerFormView, DashboardView, \
    DeclarationPDFView, SignOutView, CustomerView
from interface.handlers import CustomerHandler, DeclarationHandler, \
    CustomerDeclarationHandler, CustomerLastDeclarationHandler, \
    DispatchHandler, SignInHandler, DispatchesHandler, DispatchFix, \
    CustomsBrokerHandler, DeclarationsHandler, DeclarationsTopHandler

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
    ('/signout', SignOutView),
    ('/customer-form', CustomerFormView),
    ('/customer', CustomerView),
    ('/dashboard', DashboardView),

    ('/declaration/(\\d+)/pdf', DeclarationPDFView),

    # Handlers
    RESTful('signin', SignInHandler),
    RESTful('customsbroker', CustomsBrokerHandler),
    RESTful('customer', CustomerHandler, [
        ('lastdeclaration', CustomerLastDeclarationHandler)
    ]),
    RESTful('declaration', DeclarationHandler),
    RESTful('declarations', DeclarationsHandler, [
        ('top', DeclarationsTopHandler)
    ]),
    RESTful(('customer', 'declaration') , CustomerDeclarationHandler),

      # Dispatch
    RESTful('dispatch', DispatchHandler),
    Route(r'/api/v1/dispatch/<id:\w+>/fix/<type:\w+>', DispatchFix),

    RESTful('dispatches', DispatchesHandler)
], debug=True)
