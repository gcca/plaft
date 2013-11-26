"""Application Layer: Services

TODO(...): requestLastDeclaration, DispatchService
"""

from domain.gz import SpecificationError, NotFoundError, StoreFailedError, \
    BadValueError
from domain.model import Customer, Person, Business, Declaration, Dispatch
from domain.model.customer import \
    DocumentNumberSpecification as CustomerDocumentNumberSpecification, \
    UniqueSpecification as CustomerUniqueSpecification
from domain.model.declaration import \
    TrackingIdSpecification as DeclarationTrackingIdSpecification


class BaseService(object):

    def __init__(self, user=None):
        self.user = user

class CustomerService(object):
    """Customer Service."""

    def requestCustomer(self, documentNumber):
        """Fetch customer from datastore.

        Retrieve a customer entity, given the identification document number.

        Args:
            documentNumber:
                Identification document number (DNI, RUC, PA, CA, ...)

        Returns:
            A customer entity to the corresponding document number provided.

        Raises:
            SpecificationError:
                A error occurred unsatisfying domain specification.
                The requests raises when the document number is invalid.
            NotFoundError:
                An error occurred searching a customer by document number.
        """
        customer = Customer(documentNumber=documentNumber)
        documentNumberSpec = CustomerDocumentNumberSpecification()
        customer.documentType = self._inferDocumentType(customer)

        if documentNumberSpec.isSatisfiedBy(customer):
            customer = Customer.find(documentNumber=documentNumber)
        else:
            raise SpecificationError('Invalid number: ' + documentNumber)
        if not customer:
            raise NotFoundError('Customer not found: ' + documentNumber)
        return customer

    def newCustomer(self, dto):
        """Create a customer.

        Create new customer from data transfer object.

        Args:
            dto:
                Customer data transfer object.

        Returns:
            A customer identifier from datastore.

        Raises:
            SpecificationError:
                A error occurred unsatisfying domain specification.
                When customer exists in datastore or provided a invalid
                document number.
            BadValueError:
                A error ocurred creating a customer with bad attributes
                value or types.
        """
        customer = Customer.new(dto)
        documentNumberSpec = CustomerDocumentNumberSpecification()
        uniqueSpec = CustomerUniqueSpecification()

        if documentNumberSpec.isSatisfiedBy(customer):
            if uniqueSpec.isSatisfiedBy(customer):
                customer = self._specificCustomer(customer, dto)
                return self._storeCustomer(customer)
            else:
                raise SpecificationError('Customer already exists',
                                         CustomerUniqueSpecification)
        else:
            raise SpecificationError('Invalid document number: '
                                     + customer.documentNumber)

    def updateCustomer(self, id, dto):
        """Update customer.

        Update customer info

        Args:
            id:
                Customer identifier.
            dto:
                Customer data transfer object.

        Returns:
            None.

        Raises:
            SpecificationError:
                A error occurred providing a invalid document number,
                updating a nonexistent customer.
            NotFoundError:
                A error occurred searching for nonexistent customer.
            BadArgumentError:
                `id` isn't integer.
            BadValueError:
                A error ocurred updating a customer with bad attributes
                value or types.
        """
        customer = Customer.find(id)
        documentNumberSpec = CustomerDocumentNumberSpecification()
        uniqueSpec = CustomerUniqueSpecification()

        if not customer:
            raise NotFoundError('Customer does not exists: %s' % id)

        customer.update(dto)

        if documentNumberSpec.isntSatisfiedBy(customer):
            raise SpecificationError('Invalid document number: '
                                     + customer.documentNumber)
        if uniqueSpec.isSatisfiedBy(Customer.new(dto)):
            raise SpecificationError('Customer does not exists',
                                     CustomerUniqueSpecification)

        self._storeCustomer(customer)

    def createDeclaration(self, id, declaration_dto):
        """Customer creates new delcaration.

        When customer creates a declaration, last declaration attribute
        of customer must be updated with the declaration reference.

        Args:
            id:
                Customer identifier.
            declaration_dto:
                Declaration data transfer object.

        Returns:
            A declaration entity.

        Raises:
            StoreFailedError:
                Storing the declaration.
            BadArgumentError:
                `id` isn't integer.
            BadValueError:
                A error ocurred creating a declaration with bad attributes
                value or types.
        """
        declaration = Declaration.new(declaration_dto)
        declaration.store()
        customer = Customer.find(id)
        customer.lastDeclaration = declaration
        customer.store()
        return declaration

    def requestLastDeclaration(self, dto):
        """Fetch lastDeclaration attribute from Customer entity.

        Args:
            dto:
                Customer data transfer object. It's use like a filter by
                attributes with exactly match.

        Returns:
            A declaration entity.

        Raises:
            NotFoundError:
                Searching customer.
        """
        customer = Customer.find(dto)
        if customer: return customer.lastDeclaration
        raise NotFoundError('Customer not found')

    def _inferDocumentType(self, customer):
        """Infer passport and alien card from customer entitty.

        Args:
            customer:
                Customer entity.

        Returns:
            A document type string.

        TODO(gcca): Replace by isBusiness, isPerson of customer object.
        """
        documentNumber = customer.documentNumber
        documentType = None
        if 11 == len(documentNumber):
            documentType = 'RUC'
        elif 8 == len(documentNumber):
            documentType = 'DNI'
        return documentType

    def _storeCustomer(self, customer):
        """Common store customer method.

        Args:
            customer:
                Customer entity.

        Returns:
            None.

        Raises:
            StoreFailedError:
                A error occurred storing entity.
        """
        try:
            customer.store()
        except StoreFailedError as storeFailed:
            raise storeFailed
        else:
            return customer.id

    def _specificCustomer(self, customer, dto):
        """Retrieve specific customer: person or business.

        >>> # If dto is Business
        >>> customer = Customer.new(dto_business)
        >>> self._specificCustomer(customer, dto_business)
        ... <object Business at 0x...>
        >>> # If dto is Person
        >>> customer = Customer.new(dto_person)
        >>> self._specificCustomer(customer, dto_person)
        ... <object Person at 0x...>
        """
        return Business.new(dto) if customer.isBusiness else Person.new(dto)

class DeclarationService(object):
    """Declaration Service. """

    def requestDeclaration(self, trackingId):
        """Fetch declaration from datastore.

        Retrieve a declaration entity, given a tracking identifier.

        Args:
            trackingId:
                Declaration tracking identifier.

        Returns:
            A declaration entity to the corresponding tracking identifier.

        Raises:
            SpecificationError:
                A error occurred creating declaration with bad tracking
                identifier.
            NotFoundError:
                An error occurred searching a declaration by tracking
                identifier.
        """
        trackingIdSpec = DeclarationTrackingIdSpecification()
        if trackingIdSpec.isSatisfiedBy(Declaration(trackingId=trackingId)):
            declaration = Declaration.find(trackingId=trackingId)
            if not declaration:
                raise NotFoundError('Declaration not found: ' + trackingId)
            return declaration
        else:
            raise SpecificationError('Bad trackingId: ' + trackingId,
                                     DeclarationTrackingIdSpecification)

class DispatchService(BaseService):

    def newDispatch(self, dto):
        """Create new disptach.

        Args:
            dto:
                Dispatch data transfer object.

        Returns:
            A dispatch entity.

        Raises:
            StoreFailedError:
                A error occurred storing entity.
            NotFoundError:
                A error occurred searching for nonexistent reference like
                customer.
            BadValueError:
                A error ocurred creating a dispatch with bad attributes
                value or types.
        """
        dispatch = Dispatch.new(dto)
        dispatch.store()
        return dispatch

    def updateDispatch(self, id, dto):
        """Update disptach.

        Args:
            id:
                Disptach integer identifier.
            dto:
                Dispatch data transfer object.

        Returns:
            A dispatch entity.

        Raises:
            StoreFailedError:
                A error occurred storing entity.
            NotFoundError:
                A error occurred searching for nonexistent dispatch.
            BadValueError:
                A error ocurred creating a dispatch with bad attributes
                value or types.
        """
        dispatch = Dispatch.find(id)
        if dispatch:
            dispatch.update(dto)
            dispatch.store()
        else:
            raise NotFoundError('Dispatch not found: %s' % id)

    def pendingDispatches(self):
        """List dispaches.

        Returns:
            Pendings dispatche list.
        """
        return self.user.customsBroker.pendingDispatches()

    def fixDispatch(self, id, type):
        """
        """
        dispatch = Dispatch.by(id)
        if type not in ('register', 'unusual', 'suspicious'):
            raise BadValueError('Bad type: ' + type)
        # self.user.fixDispatch(dispatch, type)
