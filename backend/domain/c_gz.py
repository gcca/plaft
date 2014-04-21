from datetime import datetime, timedelta
from collections import Iterable
from google.appengine.ext.ndb import *
from google.appengine.ext import ndb as db
from infraestructure import utils


class Error(Exception):
    """Base model error type. """

class StoreFailedError(Error):
    """Raised by repository store method when entity could not be stored. """

class NotFoundError(Error):
    """Raised by service when the requested entity is not found. """

class DuplicateError(Error):
    """Raised by service when the entity exists. """

class BadValueError(Error):
    """Raised by models when set bad values attributes. """

class ERROR:
    Error            = Error
    StoreFailedError = StoreFailedError
    NotFoundError    = NotFoundError
    DuplicateError   = DuplicateError
    BadValueError    = BadValueError


def readOnly(property):
    return type('ReadOnly' + property.__name__, (property,),
                { '_set_value': lambda *a: None })


class DateProperty(DateProperty):
    def _to_base_type(self, value):
        value = value - timedelta(hours=5)
        return value


class DateStrProperty(DateProperty):

    def _to_base_type(self, value):
        # TODO(...): Change to 're' for '-' and '/' support.
        if isinstance(value, basestring):
            value = (datetime(*map(int, reversed(value.split('-'))))
                     if value
                     else datetime.now())
        return value

    def _from_base_type(self, value):
        return value.strftime('%d-%m-%Y') if value else None


# Domain Layer
class Entity(object):

    @property
    def id(self): return self.key.id()


class Repository(Model):

    class MetaRepository(MetaModel):

        def __new__(self, n, b, dict):

            internal = {
                '_pre_store': '_pre_put_hook',
                '_post_store': '_post_put_hook' }

            for hook in internal:
                if hook in dict:
                    dict[internal[hook]] = dict[hook]

            return super(MetaModel, self).__new__(self, n, b, dict)

    __metaclass__ = MetaRepository

    @classmethod
    def findAll(self, dto=None, **filters):
        if dto: filters = dto
        return self.query().filter(*(self.filter_node(*item)
                                     for item in filters.items()))

    @classmethod
    def find(self, dto_or_id=None, **filters):
        return (self.by(dto_or_id) if isinstance(dto_or_id, (int, long))
                else self.findAll(dto_or_id, **filters).get())

    def store(self):
        # try:
        key = self.put()
        # except TransactionFailedError as ex:
        #     raise SystemError()
        return key

    def delete(self):
        self.key.delete()

    @classmethod
    def by(self, id): return self.get_by_id(id)

    filter_node = staticmethod(
        lambda prop, val: db.query.FilterNode(
            prop, *(('=', val) if not val or '\\' != val[0]
                    else ((val[1:2], val[3:]) if '\\' == val[2]
                          else ((val[1:3], val[4:]) if '\\' == val[3]
                                else (val, None))))))


class Model(Entity, Repository):

    ReadOnlyDateTimeProperty = readOnly(DateTimeProperty)

    created = ReadOnly(DateTimeProperty(auto_now_add=True))
    last_modified = ReadOnlyDateTimeProperty(auto_now=True)

    exclude = []
    user = None

    @property
    def dict(self):
        dict = self.to_dict(exclude=self.exclude)
        if self.key: dict['id'] = self.id
        return dict

    @property
    def json(self):
        return utils.json_dumps(self.dict)

    @classmethod
    def from_dict(self, dict):  # parent_key=None):
        properties = {}
        _properties = self._properties
        for property in _properties:
            if property in dict:
                prop_type = _properties[property]
                if type(prop_type) is KeyProperty:
                    value = dict[property]
                    if value is None: continue
                    value = Key(prop_type._kind, value)
                else:
                    value = dict[property]
                properties.update({property: value})
        # if 'id' in dict: properties['id'] = dict['id']  # if new entity
        # properties['parent'] = parent_key
        return properties

    def update(self, dict): self.populate(**self.from_dict(dict))

    @classmethod
    def new(self, dict): return self(**self.from_dict(dict))


class Expando(Model, Expando):

    slug = StringProperty()
    _default_indexed = False


class ValueObject(Repository):
    pass


class User(Model):

    email = StringProperty(required=True)
    password = StringProperty(required=True)

    def __init__(self, email=None, password=None, **kw):
        password = utils.make_pw_hash(email, password)
        super(User, self).__init__(email=email, password=password, **kw)

    @property
    def dict(self):
        dict = super(User, self).dict
        del dict['password']
        return dict

    @classmethod
    def authenticate(self, email, password):
        user = User.find(email=email)
        if user and utils.valid_pw(email, password, user.password): return user


class Singleton(Repository.MetaRepository):

    def __init__(self, *a):
        self._instance = None
        super(MetaModel, self).__init__(*a)

    def __call__(self, *a, **k):
        if self._instance is None:
            self._instance = super(MetaModel, self).__call__(*a, **k)
        return self._instance
