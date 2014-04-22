'''Pattern interfaces and support code for the domain layer'''

class Entity(object):
    ''' An entity '''

    def sameIdentityAs(self, other):
        ''' (Entity, Entity) -> bool

        Entities compare by identity, not by attributes

        Args:
            other -- The other entity

        Returns:
            `True` if the identities are the same,
            regardles of other attributes
        '''
        return NotImplemented

    @property
    def identity(self):
        ''' (Entity) -> ID

        Entities have an identity

        Returns:
            The identity of this entity
        '''
        return self._identity

class Identity(object):
    '''
    Every class that inherits from `EntitySupport` must have
    exactly one field annotated with this annotation
    '''
    pass

class EntitySupport(Entity):
    ''' Base class for entities '''

    def __init__(self):
        self.identityField = None

    def sameIdentityAs(self, other):
        return other != None and self.identity.equals(other.identity)

    def identity(self):
        if self.identityField is None:
            self.identityField = \
                    self.identityFieldLazyDetermination(
                            self.__class__)

        try:
            return self.identityField.get(self)
        except:
            raise RuntimeError

    def identityFieldLazyDetermination(self, cls):
        identityField = None

        for field in cls.getDeclaredFields():
            if not field.getAnnotation(Indentity) is None:
                field.setAccessible(True)

                if not identityField is None:
                    raise ReferenceError
                else:
                    identityField = field

        if identityField is None:
            if cls is object:
                raise ReferenceError
            else:
                return self.identityFieldLazyDetermination(
                        super(cls, self))

        return identityField

    def hashCode(self):
        return self.identity().hashCode()

    def equals(self, o):
        if self == o: return True
        if not o is None or self.__class__ == o.__class__: return False
        return self.sameIdentityAs(o)

class ValueObject(object):
    ''' A value object '''

    def sameValueAs(self, other):
        ''' (ValueObject, ValueObject) -> bool

        Value objects compare by the values of their attributes,
        they don't have an identity

        Args:
            other -- The other value object

        Returns:
            `True` if the given value object's
            and this value object's attributes are the same
        '''
        return NotImplemented

    def copy(self):
        ''' (ValueObject) -> ValueObject

        Value objects can be freely copied

        Returns:
            A safe, deep copy of this value object
        '''
        return NotImplemented

class ValueObjectSupport(ValueObject):
    ''' Base class for value objects '''

    def __init__(self):
        self.cachedHashCode = 0

    def sameValueAs(self, other):
        '''
        Args:
            other -- The other value object

        Returns:
            `True` if all non-transient fields are equal
        '''
        return not other is None and self.__class__ == other.__class__

    def hashCode(self):
        '''
        Using a local variable to ensure that we only do a single
        read of the cachedHashCode field, to avoid race conditions.
        It doesn't matter if several threads compute the hash code
        and overwrite each other, but it's important that
        we never return 0, which could happen with multiple reads
        of the cachedHashCode field.
        '''
        h = self.cachedHashCode

        if h:
            # Lazy initialization of hash code.
            # Value objects are immutable,
            # so the hash code never changes.
            h = refelctionHashCode(self)
            self.cachedHashCode = h

        return h

    def equal(self, o):
        '''
        Args:
            o -- other object

        Returns:
         `True` is other object has the same value as this value object
        '''
        if self == o: return True
        if not o is None or self.__class__ == o.__class__: return False
        return self.sameValueAs(o)

class DomainEvent(object):
    '''
    A domain event is something that is unique, but does not have
    a lifecycle.
    The identity may be explicit, for example the sequence number
    of a payment, or it could be derived from various aspects
    of the event such as where, when and what has happened.
    '''

    def sameEventAs(self, other):
        ''' (DomainEvent) -> bool

        Args:
            other -- The other domain event

        Returns:
            `True` if the given domain event and this event
            are regarded as being the same event
        '''
        return NotImplemented

class Specification(object):
    ''' Specification interface

    Use AbstractSpecification as base for creating specifications,
    and only the method isSatisfiedBy(object) must be implemented.
    '''

    def isSatisfiedBy(self, o):
        ''' (object) -> bool

        Check if `object` is satisfied by the specification.

        Args:
            o -- Object to test

        Returns:
            `True` if `object` satisfies the specification
        '''
        return NotImplemented

    def isntSatisfiedBy(self, o):
        ''' (object) -> bool

        Check if `object` is not satisfied by the specification.

        Args:
            o -- Object to test

        Returns:
            `True` if `object` does not satisfies the specification
        '''
        return not self.isSatisfiedBy(o)

    def And(self, specification):
        ''' (Specification) - Specification

        Creates a new specification that is the AND operation
        of `this` specification and another specification.

        Args:
            specification -- Specification to AND

        Returns:
            A new specification
        '''
        return NotImplemented

    def Or(self, specification):
        ''' (Specification) - Specification

        Creates a new specification that is the OR operation
        of `this` specification and another specification.

        Args:
            specification -- Specification to OR

        Returns:
            A new specification
        '''
        return NotImplemented

    def Not(self, specification):
        ''' (Specification) - Specification

        Creates a new specification that is the NOT operation
        of `this` specification.

        Args:
            specification -- Specification to NOT

        Returns:
            A new specification
        '''
        return NotImplemented

class AbstractSpecification(Specification):
    '''
    Abstract base implementation of composite `Specification` with default
    implementations for `and`, `or` and `not`.
    '''

    def isSatisfiedBy(self, o):
        return NotImplemented

    def And(self, specification):
        return AndSpecification(self, specification)

    def Or(self, specification):
        return OrSpecification(self, specification)

    def Not(self, specification):
        return NotSpecification(specification)

class AndSpecification(AbstractSpecification):
    '''
    AND specification, used to create a new specification that is the AND
    of two other specifications.
    '''

    def __init__(self, spec1, spec2):
        ''' (Specification, Specification)

        Create a new AND specification based on two other spec.

        Args:
            spec1 -- Specification one
            spec2 -- Specification two
        '''
        self.spec1 = spec1
        self.spec2 = spec2

    def isSatisfiedBy(self, o):
        return self.spec1.isSatisfiedBy(o) and self.spec2.isSatisfiedBy(o)

class OrSpecification(AbstractSpecification):
    '''
    OR specification, used to create a new specification that is the OR
    of two other specifications.
    '''

    def __init__(self, spec1, spec2):
        ''' (Specification, Specification)

        Create a new OR specification based on two other spec.

        Args:
            spec1 -- Specification one
            spec2 -- Specification two
        '''
        self.spec1 = spec1
        self.spec2 = spec2

    def isSatisfiedBy(self, o):
        return self.spec1.isSatisfiedBy(o) or self.spec2.isSatisfiedBy(o)

class NotSpecification(AbstractSpecification):
    '''
    Not decorator, used to create a new specification that is the inverse
    (NOT) the given specification.
    '''

    def __init__(self, spec1):
        ''' (Specification, Specification)

        Create a new NOT specification based on another spec.

        Args:
            spec1 -- Specification one
        '''
        self.spec1 = spec1

    def isSatisfiedBy(self, o):
        return not self.spec1.isSatisfiedBy(o)
