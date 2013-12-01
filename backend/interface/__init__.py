#!/usr/bin/env python
# -*- coding: utf-8 -*-

import webapp2

from infraestructure.utils import rc_factory, ct_factory, st_factory, json, \
    Dto, povd, powd, make_secure_val, check_secure_val, jsondumps, logging
from webapp2_extras import jinja2
from google.appengine.ext.db import TransactionFailedError
from domain.gz import Error
from domain.model import User, CustomsBrokerUser


class BaseHandler(webapp2.RequestHandler):
    ''' Base Handler '''

    rc = rc_factory()
    ct = ct_factory()

    model = None
    collection = None

    @staticmethod
    def jinja_factory(app):
        jinja = jinja2.Jinja2(app, {
            'template_path': 'interface/templates',
            'compiled_path': None,
            'force_compiled': False,
            'environment_args': {
                'autoescape': True,
                'trim_blocks': True,
                'extensions': [
                    'jinja2.ext.autoescape',
                    'jinja2.ext.with_',
                    ],},
            'globals': None,
            'filters': None })
        jinja.environment.newline_sequence = ''
        return jinja

    @webapp2.cached_property
    def jinja2(self):
        return jinja2.get_jinja2(app = self.app,
            factory = BaseHandler.jinja_factory)

    def __init__(self, q, p):
        self.userModel = CustomsBrokerUser
        self.user = None
        self.status = st_factory(self.write_status, self.write_error)
        super(BaseHandler, self).__init__(q, p)

    def write(self, *a, **kw):
        self.response.out.write(*a, **kw)

    def write_json(self, ds, rc=None):
        self.contt = self.ct.JSON
        if rc: self.status[rc](ValueError('RC JSON'))
        self.write(ds)

    def write_file(self, file):
        self.contt = self.ct.DOWN
        self.write(file)

    def write_status(self, rc):
        r, c = rc
        self.response.headers['Warning'] = r
        self.response.set_status(c)

    def write_content_type(self, ct):
        self.response.headers['Content-Type'] = ct
    contt = property(fset = write_content_type)

    def write_error(self, e):
        self.write_json('{"e":"%s"}' % e.message)

    @property
    def request_json(self):
        body = self.request.body
        return json.loads(body) if body else dict(self.request.GET)

    @property
    def request_dto(self):
        return Dto(self.request_json)

    def render_str(self, template, **params):
        params['user'] = self.user
        return self.jinja2.render_template(template, **params)

    def render(self, template, **kw):
        self.write(self.render_str(template+'.html', **kw))

    def render_json(self, o, rc=None):
        json_txt = self._2json(o)
        self.write_json(json_txt, rc)

    def render_file(self, f):
        self.write_file(f.data)

    def set_secure_cookie(self, name, val):
        cookie_val = make_secure_val(val)
        self.response.headers.add_header('Set-Cookie', '%s=%s; Path=/'
                                         % (name, cookie_val))

    def read_secure_cookie(self, name):
        cookie_val = self.request.cookies.get(name)
        return cookie_val and check_secure_val(cookie_val)

    def login(self, user):
        self.set_secure_cookie('ud', str(user.key().id()))

    def logout(self):
        self.response.headers.add_header('Set-Cookie', 'ud=; Path=/')

    def initialize(self, *a, **kw):
        webapp2.RequestHandler.initialize(self, *a, **kw)
        self.response.headers[povd] = powd
        uid = self.read_secure_cookie('ud')
        self.user = uid and User.by(int(uid))

    def _2json(self, o):
        return jsondumps(o)

    # better `put`
    def safe_put(self, model):
        ''' (Model) -> db.Key or NoneType
        If exception, return `None`
        '''
        try:
            key = model.put() # BUG (mb)
            #key = 666
        except TransactionFailedError as ex:
            logging.error('DataStore Error: ' + ex.message)
            self.status.INTERNAL_ERROR(ex)
        else:
            return key

class RESTfulHandler(object):
    class RESTfulBase(BaseHandler):
        def __init__(self, a, b):
            if self.model:
                return super(RESTfulHandler.RESTfulBase, self).__init__(a, b)
            raise Error(self.__class__.__name__ + ' needs a model')

    class Collection(RESTfulBase):
        def get(self):
            self.render_json(self.model.findAll(self.request_dto))

    class Model(RESTfulBase):
        def get(self, q=None):
            if q: self.render_json(self.model.find(id=q))
            else:
                dto = self.request_dto
                model = self.model.find(dto) if dto.dict else None
                if model:
                    self.render_json(model)
                else:
                    self.status.NOT_FOUND(Error('Not found: ' + dto.json))
