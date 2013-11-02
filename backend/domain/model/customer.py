# encoding: utf-8
"""Customer Specification """

from domain.shared import AbstractSpecification
from domain.model import Customer

class DocumentNumberSpecification(AbstractSpecification):

    def isSatisfiedBy(self, customer):
        """
        Args:
            customer: Customer entity.

        TODO(gcca): validate passport and alien card.
        """
        documentNumber = customer.documentNumber

        isPerson = customer.isPerson
        isBusiness = customer.isBusiness
        isDigit = documentNumber.isdigit()

        return (isPerson or isBusiness) and isDigit

class UniqueSpecification(AbstractSpecification):

    def isSatisfiedBy(self, customer):
        documentNumber = customer.documentNumber
        count = Customer.findAll(documentNumber=documentNumber).count()
        return not count
