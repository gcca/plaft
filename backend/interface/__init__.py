import json
from webapp2 import RequestHandler

from domain.model import Model, User
from infraestructure.utils import check_secure, make_secure, json_dumps, \
                                  rc_factory, ct_factory, st_factory, po, \
                                  login_required


class BaseHandler(RequestHandler):

    rc = rc_factory()
    ct = ct_factory()

    def __init__(self, q, p):
        self.user = None
        self.status = st_factory(self.write_status, self.write_error)
        super(BaseHandler, self).__init__(q, p)

    def write(self, *a, **kw):
        self.response.out.write(*a, **kw)

    def write_json(self, ds, rc=None):
        self.write_ct(self.ct.JSON)
        if rc: self.status[rc](ValueError('RC JSON'))
        self.write(ds)

    def write_file(self, file):
        self.contt = self.ct.DOWN
        self.write(file)

    def write_ct(self, ct):
        self.response.headers['Content-Type'] = ct

    def write_status(self, rc):
        r, c = rc
        self.response.headers['Warning'] = r
        self.response.set_status(c)

    def write_error(self, e='...'):
        self.write_json('{"e":"%s"}' % e)

    def write_val(self, name, val):
        val = '%s=%s; Path=/' % (name, make_secure(val))
        self.response.headers.add_header('Set-Cookie', val)

    def read_val(self, name):
        val = self.request.cookies.get(name)
        return val and check_secure(val)

    def login(self, user):
        self.write_val('u', str(user.id))

    def logout(self):
        self.response.headers.add_header('Set-Cookie', 'u=; Path=/')

    def initialize(self, *a, **kw):
        super(BaseHandler, self).initialize(*a, **kw)
        self.response.headers[po.vd] = po.wd
        u = self.read_val('u')
        Model.user = self.user = u and User.find(int(u))

    def render_json(self, o, rc=None):
        json_txt = json_dumps(o)
        self.write_json(json_txt, rc)

    @property
    def request_dict(self):
        body = self.request.body
        return json.loads(body) if body else dict(self.request.GET)


class MetaSecurity(type):

    def __new__(self, n, b, dict):
        if 'require_login' in dict:
            base = b[0]
            for method in dict['require_login']:
                dict[method] = login_required(getattr(base, method))

        return super(MetaSecurity, self).__new__(self, n, b, dict)


class MetaNested(type):

    def __new__(self, n, b, dict):
        restful = super(MetaNested, self).__new__(self, n, b, dict)

        for nested in dict:
            if getattr(dict[nested], 'isnested', None):
                dict[nested].parent = restful

        return restful


class MetaRESTful(MetaSecurity, MetaNested): pass


class RESTfulNested(BaseHandler):

    __metaclass__ = MetaRESTful

    parent    = None
    reference = None
    isnested  = True

    def post(self, id=None):
        reference = self.parent.model.find(int(id))
        entity    = self.model.new(self.request_dict)
        entity.user = self.user
        setattr(entity, self.reference, reference.key)
        entity.store()
        self.write_json('{"id":%s,"%s":%s}'
                        % (entity.id, self.reference, reference.json))


class RESTful(BaseHandler):

    __metaclass__  = MetaRESTful

    login_required = staticmethod(login_required)
    require_login  = []
    methods        = ('get', 'post', 'put', 'delete')
    model          = None

    def get(self, id=None):
        dict = int(id) if id else self.request_dict
        if dict:
            entity = self.model.find(dict)
            if entity:
                self.render_json(entity)
            else:
                self.status.NOT_FOUND('Not found by: '
                                      + self.request.query_string)
        else:
            self.status.BAD_REQUEST('Need parameters')

    def post(self, id=None):
        entity = self.model.new(self.request_dict)
        entity.user = self.user
        entity.store()
        self.write_json('{"id":%s}' % entity.id)

    def put(self, id):
        entity = self.model.find(int(id))
        entity.user = self.user
        if entity:
            entity.update(self.request_dict)
            entity.store()
        self.write_json('{}')

    def delete(self, id):
        pass

    Nested = RESTfulNested


class RESTfulCollection(BaseHandler):

    def get(self):
        self.render_json(self.model.findAll())
