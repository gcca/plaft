"""Application Layer: Services

TODO(...): requestLastDeclaration, DispatchService
"""

from domain.gz import SpecificationError, NotFoundError, BadValueError
from domain.model import Customer, Person, Business, Declaration, Dispatch
from domain.model.customer import \
    DocumentNumberSpecification as CustomerDocumentNumberSpecification, \
    UniqueSpecification as CustomerUniqueSpecification
from domain.model.declaration import \
    TrackingIdSpecification as DeclarationTrackingIdSpecification


class BaseService(object):
    """Base for application services."""

    def __init__(self, user=None):
        """Constuctor.
        Needs user for use cases in domain layer.

        Args:
            user (CustomsBrokerUser)
        """
        self.user = user
        self.model = None

    def setModel(self, model):
        """Set service model."""
        self.model = model

    def storeCascade(self, _):
        """Store entties in cascade validation."""
        self.user = None
        return NotImplemented

    def deleteCascade(self, _):
        """Delete entties in cascade validation."""
        self.user = None
        return NotImplemented


class CustomerService(BaseService):
    """Customer Service."""

    def __init__(self):
        super(CustomerService, self).__init__(None)
        self.setModel(Customer)

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
        customer = self.model(documentNumber=documentNumber)
        documentNumberSpec = CustomerDocumentNumberSpecification()
        # (-o-) Need better validation for customer.documentType
        customer.documentType = 'RUC' if customer.isBusiness else 'DNI'

        if documentNumberSpec.isSatisfiedBy(customer):
            customer = self.model.find(documentNumber=documentNumber)
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
            StoreFailedError:
                A error occurred storing entity.
        """
        customer = self.model.new(dto)
        documentNumberSpec = CustomerDocumentNumberSpecification()
        uniqueSpec = CustomerUniqueSpecification()

        if documentNumberSpec.isSatisfiedBy(customer):
            if uniqueSpec.isSatisfiedBy(customer):
                customer = (Business.new(dto) if customer.isBusiness
                            else Person.new(dto))
                customer.store()
                return customer.id
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
            StoreFailedError:
                A error occurred storing entity.
        """
        customer = self.model.find(id)
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
        customer.store()

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
        customer = self.model.find(id)
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
        customer = self.model.find(dto)
        if customer:
            return customer.lastDeclaration
        raise NotFoundError('Customer not found')


class DeclarationService(BaseService):
    """Declaration Service."""

    def __init__(self):
        super(DeclarationService, self).__init__(None)
        self.setModel(Declaration)

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
            declaration = self.model.find(trackingId=trackingId)
            if not declaration:
                raise NotFoundError('Declaration not found: ' + trackingId)
            return declaration
        else:
            raise SpecificationError('Bad trackingId: ' + trackingId,
                                     DeclarationTrackingIdSpecification)


class DispatchService(BaseService):
    """Dispatch Service."""

    def __init__(self, user):
        super(DispatchService, self).__init__(user)
        self.setModel(Dispatch)

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
        dispatch = self.model.new(dto)
        dispatch.store()
        try:
            datastore = self.user.datastore
            datastore.pendingDispatches.append(dispatch.key())
            datastore.store()
        except StoreFailedError as ex:
            dispatch.delete()
            raise ex
        else:
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
        dispatch = self.model.find(id)
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
        """Fix disptach with register, unused or suspicious type.

        Args:
            id:
                Dispatch identifier.
            type:
                Must be in ('register', 'unusual', 'suspicious').
        """
        dispatch = self.model.by(id)
        if type not in ('register', 'unusual', 'suspicious'):
            raise BadValueError('Bad type: ' + type)
        self.user.fixDispatch(dispatch, type)
