from domain.shared import AbstractSpecification

from domain.model import Customer

class BecomesOperationSpecification(AbstractSpecification):

	def isSatisfiedBy(self, movement):

		# (-o-)
		# conversion to $

		multipleAmount = 50000

		return movement.amount >= 10000 or multipleAmount >= 50000
