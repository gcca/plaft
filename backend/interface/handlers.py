# -*- coding: utf-8 -*-
'''Handlers '''

from interface import BaseHandler, RESTfulHandler
from infraestructure.utils import login_required
from domain.model import Declaration, User, Dispatch  # (-o-) DBG
from domain.gz import SpecificationError, NotFoundError, DuplicateError, \
    StoreFailedError, BadValueError, Error
from application.service import CustomerService, DeclarationService, \
    DispatchService

# -------
# Sign In
# -------
class SignInHandler(BaseHandler):

    def post(self):
        username = self.request.get('username')
        password = self.request.get('password')
        user = User.login(username, password)
        if user:
            self.login(user)
            self.write_json('{}')
        else:
            self.status.UNAUTHORIZED(Error('Sign in'))


# --------
# Customer
# --------
class CustomerHandler(BaseHandler):
    '''Customer Handler '''

    Service = CustomerService

    def get(self):
        '''
        RESTful - find
        Validate documentNumber
        Raise: BAD_REQUEST, NOT_FOUND
        By id not implemented
        '''
        documentNumber = self.request.get('documentNumber')
        service = CustomerService()
        try:
            customer = service.requestCustomer(documentNumber)
        except SpecificationError as e:
            self.status.BAD_REQUEST(e)
        except NotFoundError as e:
            self.status.NOT_FOUND(e)
        else:
            self.render_json(customer)

    def post(self):
        '''
        RESTful - create
        Check unique document number
        Raise: BAD_REQUEST, DUPLICATE_ENTRY
        Returns JSON with `id` if success
        '''
        service = CustomerService()
        try:
            customerId = service.newCustomer(self.request_dto)
        except SpecificationError as e:
            self.status.BAD_REQUEST(e)
        except DuplicateError as e:
            self.status.DUPLICATE_ENTRY(e)
        except StoreFailedError as e:
            self.status.INTERNAL_ERROR(e)
        except BadValueError as e:
            self.status.BAD_REQUEST(e)
        else:
            self.write_json('{"id":%s}' % customerId)

    def put(self, id):
        '''
        RESTful - update
        '''
        service = CustomerService()
        try:
            service.updateCustomer(int(id), self.request_dto)
        except SpecificationError as e:
            self.status.BAD_REQUEST(e)
        except NotFoundError as e:
            self.status.NOT_FOUND(e)
        except ValueError, TypeError:
            self.status.BAD_REQUEST(Error('Bad identifier number: ' + id))
        except BadValueError as e:
            self.status.BAD_REQUEST(e)
        else:
            self.write_json('{}')


class CustomerDeclarationHandler(BaseHandler):

    Service = CustomerService

    def post(self, pid):
        '''
        RESTful - create
        Args:
            Declaration
            -------------------
            customer      - int        (id)
            (model...)
        Returns: declaration ID - int
        '''
        service = CustomerService()
        try:
            declaration = service.createDeclaration(int(pid), self.request_dto)
        except SpecificationError as e:
            self.status.BAD_REQUEST(e)
        except StoreFailedError as e:
            self.status.INTERNAL_ERROR(e)
        except ValueError, TypeError:
            self.status.BAD_REQUEST(Error('Bad identifier number: ' + id))
        else:
            self.write_json('{"id":"%s"}' % declaration.id)


class CustomerLastDeclarationHandler(BaseHandler):

    Service = CustomerService

    def get(self):
        service = CustomerService()
        try:
            declaration = service.requestLastDeclaration(self.request_dto)
        except NotFoundError as e:
            self.status.NOT_FOUND(e)
        else:
            self.render_json(declaration)


# -----------
# Declaration
# -----------
class DeclarationHandler(BaseHandler):

    Service = DeclarationService

    def get(self):
        trackingId = self.request.get('trackingId')
        service = DeclarationService()
        try:
            declaration = service.requestDeclaration(trackingId)
        except SpecificationError as e:
            self.status.BAD_REQUEST(e)
        except NotFoundError as e:
            self.status.NOT_FOUND(e)
        else:
            self.render_json(declaration)


class DeclarationsHandler(BaseHandler):

    Service = DeclarationService

    def get(self):
        self.render_json(Declaration.all()) # (-o-) DBG


# --------
# Dispatch
# --------
class DispatchHandler(RESTfulHandler.Model):
    model = Dispatch

    def post(self):
        '''
        RESTful - create
        Args:
            Movement
            -------------------
            customer      - int        (id)
            customsBroker - int        (id)
            (model...)
        Returns: movement ID - int
        '''
        service = DispatchService(self.user)
        try:
            dispatch = service.newDispatch(self.request_dto)
        except StoreFailedError as e:
            self.status.INTERNAL_ERROR(e)
        except BadValueError as e:
            self.status.BAD_REQUEST(e)
        except NotFoundError as e:
            self.status.NOT_FOUND(e)
        else:
            self.write_json('{"id":%s}' % dispatch.id)

    def put(self, id):
        service = DispatchService(self.user)
        try:
            service.updateDispatch(int(id), self.request_dto)
        except StoreFailedError as e:
            self.status.INTERNAL_ERROR(e)
        except BadValueError as e:
            self.status.BAD_REQUEST(e)
        except NotFoundError as e:
            self.status.NOT_FOUND(e)
        except ValueError, TypeError:
            self.status.BAD_REQUEST(Error('Bad identifier number: ' + id))
        else:
            self.write_json('{}')


class DispatchesHandler(RESTfulHandler.Collection):
    model = Dispatch
    Service = DispatchService

    @login_required
    def get(self):
        service = DispatchService(self.user)
        dispatches = service.pendingDispatches()
        self.render_json(dispatches)


class DispatchFix(BaseHandler):
    Service = DispatchService

    def post(self, id, type):
        service = DispatchService(self.user)
        try:
            service.fixDispatch(int(id), type)
        except BadValueError as ex:
            self.status.BAD_REQUEST(ex)
        except ValueError, TypeError:
            self.status.BAD_REQUEST(Error('Bad id: ' + id))
        else:
            self.write_json('{}')


# --------------
# Customs Broker
# --------------
class CustomsBrokerHandler(BaseHandler):

    def get(self):
        self.render_json(self.user.customsBroker)

    def put(self, id):
        try:
            self.user.customsBroker.update(self.request_dto)
            self.user.customsBroker.store()
        except BadValueError as ex:
            self.status.BAD_REQUEST(ex)
        except StoreFailedError as ex:
            self.status.INTERNAL_ERROR(ex)
        else:
            self.write_json('{}')
