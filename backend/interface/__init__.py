import json
from webapp2 import RequestHandler

from infraestructure.utils import check_secure, make_secure, json_dumps, \
                                  rc_factory, ct_factory, st_factory, po
from domain.model import User


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
        # if rc: self.status[rc](ValueError('RC JSON'))
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
        self.write_val('u', str(user.key().id()))

    def logout(self):
        self.response.headers.add_header('Set-Cookie', 'u=; Path=/')

    def initialize(self, *a, **kw):
        super(BaseHandler, self).initialize(*a, **kw)
        self.response.headers[po.vd] = po.wd
        u = self.read_val('u')
        self.user = u and User.find(int(u))

    def render_json(self, o, rc=None):
        json_txt = json_dumps(o)
        self.write_json(json_txt, rc)

    @property
    def request_dict(self):
        body = self.request.body
        return json.loads(body) if body else dict(self.request.GET)
