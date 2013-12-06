# encoding: utf-8
"""Gz """

import datetime
import uuid
from google.appengine.ext.db import TransactionFailedError, Text
from google.appengine.ext.db.polymodel import _ClassKeyProperty
from google.appengine.ext import db
from infraestructure.utils import jsondumps, jsonloads, logging, Dto
from domain.shared import Entity as BaseEntity, AbstractSpecification

StringProperty = db.StringProperty
EmailProperty = db.EmailProperty
DateTimeProperty = db.DateTimeProperty
DateProperty = db.DateProperty
BlobProperty = db.BlobProperty
GeoPtProperty = db.GeoPtProperty
CategoryProperty = db.CategoryProperty
ReferenceProperty = db.ReferenceProperty
BooleanProperty = db.BooleanProperty
TextProperty = db.TextProperty
ListProperty = db.ListProperty
IntegerProperty = db.IntegerProperty
FloatProperty = db.FloatProperty
StringListProperty = db.StringListProperty
UnindexedProperty = db.UnindexedProperty
Key = db.Key

# ----------
# Exceptions
# ----------
class Error(Exception):
    """Base model error type. """

class StoreFailedError(Error):
    """Raised by repository store method when entity could not be stored. """

class SpecificationError(Error):
    """Raised by specification when is not satisfied at domain layer. """

    def __init__(self, msg, specification=AbstractSpecification, *a, **k):
        self._specification = specification
        super(SpecificationError, self).__init__(msg, *a, **k)

    def doesntSatisfies(self, specification):
        return specification == self._specification

class NotFoundError(Error):
    """Raised by service when the requested entity is not found. """

class DuplicateError(Error):
    """Raised by service when the entity exists. """

class BadValueError(Error):
    """Raised by models when set bad values attributes. """

# ------
# Entity
# ------
class EntityMixIn(object):
    ''' Base Model '''

    @property
    def id(self):
        ''' ()  -> int '''
        return self.key().id()

    @property
    def className(self):
        '''() -> str

        Return class name from internal user hierarchy

        >>> exporterObject.classname
        'Exporter'
        >>> customsbrokerObject.classname
        'CustomsBroker'
        >>> customsWarehouseObject.classname
        'CustomsWarehouse'
        >>> ...
        '''
        return self.class_name()

    @property
    def dict(self):
        '''() -> User like dict

        To serialize and template context

        >>> user = User(email = 'gcca@gcca.tk',
        ...             password = 'cristHian Gz. (gcca)')
        >>> user.dict
        {
        email: 'gcca@gcca.tk',
        password: 'cristHian Gz. (gcca)'
        }
        '''
        # MOD INFORMATION HOLE! on handler: be careful
        dict = { p.name: mdlmap(getattr(self, p._attr_name())) for p in \
                 self.properties().values() }
        if self.is_saved(): dict['id'] = self.id
        return dict

    @staticmethod
    def jsonparse(str): return jsonloads(str)

    @property
    def json(self):
        '''() -> str

        Object to JSON str

        >>> exporter = Exporter(
        ...     email = 'gcca@gcca.tk',
        ...     password='cristHian Gz. (gcca)')
        >>> exporter.json
        '{"email": "gcca@gcca.tk", "password": "cristHian Gz. (gcca)"}'
        '''
        return jsondumps(self.dict)

    @staticmethod
    def cast(value, p):
        t = type(p)
        if t is DateProperty or type(t) is DateTimeProperty:
            value = datetime.date(*(int(v) for v in value.split('-')))
        elif t is ReferenceProperty:
            c = p.reference_class
            id = value
            value = c.by(id)
            # if value is None:
            #     raise NotFoundError('Reference `%s`: %s' % (c.__name__, id))
        elif t is FloatProperty:
            value = float(value)
        return value

    @classmethod
    def _sandict(self, dict):
        # (-o-) improve perfomance with filtering-loop
        p = self.properties()
        dict = { k: v for k, v in dict.items() }
        for k, v in dict.items():
            q = p.get(k)
            if v is None or not q:
                del dict[k]
            else:
                dict[k] = self.cast(v, q)
        return dict

    @classmethod
    def new(self, object):
        ''' (request_object) -> Model

        Creates new model from request object
        '''
        return self(**self._sandict(object.__dict__))

    def update(self, object):
        ''' (request_object) -> Model

        Updates model from request object
        '''
        p = self.properties()
        try:
            for k, v in object.__dict__.items():
                q = p.get(k)
                if type(q) is ReferenceProperty and type(v) is Dto: continue
                if not v is None and q:
                    setattr(self, k, self.cast(v, q))
        except db.BadValueError as ex:
            raise BadValueError(ex)
        return self

    @classmethod
    def uuid(self):
        return uuid.uuid1()

class Repository(db.Model):
    @classmethod
    def by(self, id):
        '''(int) -> Model '''
        return self.get_by_id(id)

    def store(self):
        try:
            key = self.put()
        except TransactionFailedError as e:
            logging.error('DataStore Error: ' + e.message)
            raise StoreFailedError('Error storing %s: %s'
                                   % (self.__class__, e.message))
        else:
            return key

    @classmethod
    def findAll(self, dto=None, **filters):
        if dto: filters = dto.__dict__
        cursor = self.all()
        for property, value in filters.items():
            if not property.isalpha():  # find in model properties
                raise ValueError('Bad property name')
            if type(value) is tuple:
                operator, value = value
                if not operator in ('=', '!=', '<', '<=', '>', '>=', 'IN'):
                    raise ValueError('Bad filter operator')
            else:
                operator = '='
            cursor.filter('%s %s' % (property, operator), value)
        return cursor

    @classmethod
    def find(self, dto=None, **filters):
        return (self.by(dto) if type(dto) in (int, long)
                else self.findAll(dto, **filters).get())

class Entity(EntityMixIn, BaseEntity, Repository):

    created = DateTimeProperty(auto_now_add=True)
    last_modified = DateTimeProperty(auto_now=True)

    protected = []

    @property
    def dict(self):
        dict = super(Entity, self).dict
        del dict['created']
        del dict['last_modified']
        if dict.has_key('class'): del dict['class']
        for p in self.protected: del dict[p]
        return dict

mdlmap = lambda v: v.dict if isinstance(v, Entity) else v

# ----------
# PolyEntity
# ----------
_class_map = {}

class PolyClass(db.PropertiedClass):
    def __init__(self, name, bases, dct):
        if name == 'PolyEntity':
            super(PolyClass, self).__init__(name, bases, dct, map_kind=False)
            return
        elif PolyEntity in bases:
            if getattr(self, '__class_hierarchy__', None):
                raise db.ConfigurationError(
                    ('%s cannot derive from PolyEntity as '
                     '__class_hierarchy__ is already defined.') % self.__name__)
            self.__class_hierarchy__ = [self]
            self.__root_class__ = self
            super(PolyClass, self).__init__(name, bases, dct)
        else:
            super(PolyClass, self).__init__(name, bases, dct, map_kind=False)
            self.__class_hierarchy__ = [c for c in reversed(self.mro())
                    if issubclass(c, PolyEntity) and c != PolyEntity]
            if self.__class_hierarchy__[0] != self.__root_class__:
                raise db.ConfigurationError(
                    '%s cannot be derived from both root classes %s and %s' %
                    (self.__name__,
                     self.__class_hierarchy__[0].__name__,
                     self.__root_class__.__name__))
        _class_map[self.class_key()] = self

class PolyEntity(Entity):
    __metaclass__ = PolyClass
    _class = _ClassKeyProperty(name='class')

    def __new__(self, *a, **k):
        if self is PolyEntity: raise NotImplementedError()
        return super(PolyEntity, self).__new__(self, *a, **k)

    @classmethod
    def kind(self):
        if self is self.__root_class__: return super(PolyEntity, self).kind()
        else: return self.__root_class__.kind()

    @classmethod
    def class_key(self):
        if not hasattr(self, '__class_hierarchy__'):
            raise NotImplementedError(
                'Cannot determine class key without class hierarchy')
        return tuple(self.class_name() for self in self.__class_hierarchy__)

    @classmethod
    def class_name(self): return self.__name__

    @classmethod
    def from_entity(self, entity):
        if ('class' in entity
            and tuple(entity['class']) != self.class_key()):
            key = tuple(entity['class'])
            try:
                poly_class = _class_map[key]
            except KeyError:
                raise db.KindError(
                    'No implementation for class \'%s\'' % (key,))
            return poly_class.from_entity(entity)
        return super(PolyEntity, self).from_entity(entity)

    @classmethod
    def all(self, **k):
        q = super(PolyEntity, self).all(**k)
        if self != self.__root_class__:
            q.filter('class' + ' =', self.class_name())
        return q

    @classmethod
    def gql(self, q_str, *a, **k):
        if self == self.__root_class__:
            return super(PolyEntity, self).gql(q_str, *a, **k)
        else:
            from google.appengine.ext import gql
            q = db.GqlQuery('SELECT * FROM %s %s' % (self.kind(), q_str))
            q_filter = [('nop', [gql.Literal(self.class_name())])]
            q._proto_query.filters()[('class', '=')] = q_filter
            q.bind(*a, **k)
            return q

# -----------------
# Custom Properties
# -----------------
class DocumentType(unicode):
    def __new__(self, value):
        if value is None: value = ''
        return unicode.__new__(self, value)

    documentTypeNameMap = {
        'DNI' : 'Documento Nacional de Identidad',
        'RUC' : 'Registro Único de Contribuyente',
        'PA'  : 'Pasaporte',
        'CE'  : 'Carné de Extranjería',
        ''    : '' }

    documentTypeCodeStrMap = {
        # (-o-) Revisar
        'DNI' : '001',
        'RUC' : '002',
        'PA'  : '003',
        'CE'  : '004',
        ''    : '' }

    @property
    def toName(self):
        return DocumentType.documentTypeNameMap[self]

class DocumentTypeProperty(TextProperty):
    data_type = DocumentType

    def get_value_for_datastore(self, m):
        value = super(DocumentTypeProperty, self).get_value_for_datastore(m)
        return unicode(value)

    def make_value_from_datastore(self, value):
        return DocumentType(value)

    def validate(self, value):
        if type(value) is not DocumentType:
            value = DocumentType(value)
        if value in ['DNI', 'RUC', 'PA', 'CE', '', None]:
            return DocumentType(value)
        raise ValueError('Document type must be DNI, RUC, PA, CE or avoid')

class ValueObjectProperty(TextProperty):
    data_type = Entity

    def __init__(self, model, *a, **k):
        self.model = model
        super(ValueObjectProperty, self).__init__(*a, **k)

    def get_value_for_datastore(self, m):
        model = super(ValueObjectProperty, self).get_value_for_datastore(m)
        if model: return Text(model.json)

    def make_value_from_datastore(self, value):
        return self.model(**jsonloads(value))

    def validate(self, value): return value

class JsonProperty(UnindexedProperty):
    data_type = Dto

    def get_value_for_datastore(self, m):
        obj = super(JsonProperty, self).get_value_for_datastore(m)
        if not obj is None: return Text(jsondumps(obj))

    def _2Dto(self, o):
        if type(o) is dict: return Dto(o)
        elif type(o) is list: return [self._2Dto(d) for d in o]
        else: raise TypeError('Incorrect type for parsing Dto')

    def make_value_from_datastore(self, value):
        if value: return self._2Dto(jsonloads(value))

    def validate(self, value): return value
