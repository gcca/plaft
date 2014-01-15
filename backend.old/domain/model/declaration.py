# encoding: utf-8
"""Declaration Specification """

from domain.shared import AbstractSpecification

class TrackingIdSpecification(AbstractSpecification):

    def isSatisfiedBy(self, declaration):
        trackingId = declaration.trackingId
        return trackingId and (8 == len(trackingId)) and trackingId.isalnum()
