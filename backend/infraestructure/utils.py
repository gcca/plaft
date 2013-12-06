#!/usr/bin/env python

import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

import random
import re
import hmac
import logging
import json
import infraestructure.bcrypt as bcrypt
from collections import namedtuple
from datetime import date, datetime
from string import digits, letters

if os.environ.has_key('SERVER_SOFTWARE'):
    DEBUG = bool(os.environ['SERVER_SOFTWARE'].startswith('Development'))
    if DEBUG:
        logging.getLogger().setLevel(logging.DEBUG)

class rc_factory(object):
    c = namedtuple('CODE', 'r c')
    CODES = dict(
        ALL_OK  = c('OK', 200),
        CREATED = c('Created', 201),
        ACCEPTED = c('Accepted', 202),
        DELETED = c('', 204),
        BAD_REQUEST = c('Bad Request', 400),
        UNAUTHORIZED = c('Unauthorized', 401),
        NOT_PAYMENT = c('Payment Required', 402),
        FORBIDDEN = c('Forbidden', 403),
        NOT_FOUND = c('Not Found', 404),
        NOT_ACCEPTABLE = c('Not acceptable', 406),
        DUPLICATE_ENTRY = c('Conflict/Duplicate', 409),
        NOT_HERE = c('Gone', 410),
        INTERNAL_ERROR  = c('Internal Error', 500),
        NOT_IMPLEMENTED = c('Not Implemented', 501),
        THROTTLED = c('Throttled', 503))
    def __getattr__(self, attr): return self.CODES[attr]

class ct_factory(object):
    HDRS = dict(
        JSON = 'application/json; charset=UTF-8',
        DOWN = 'application/force-download')
    def __getattr__(self, attr): return self.HDRS[attr]

class st_factory(object):
    def __init__(self, callback_code, callback_error):
        self.__callback_code = callback_code
        self.__callback_error = callback_error
    def __getattr__(self, attr):
        self.__callback_code(rc_factory.CODES[attr])
        return self.__callback_error

reload(sys)
# sys.setdefaultencoding('utf-8')

povd = 'By'
EMAIL_RE = re.compile(r'[\S]+@[\S]+\.[\S]+$')
def valid_email(email):
    return email and EMAIL_RE.match(email)

PASS_RE = re.compile(r'^.{3,20}$')
def valid_password(password):
    return password and PASS_RE.match(password)

def make_pw_hash(name, password, salt=None):
    if not salt: salt = bcrypt.gensalt(6)
    try: h = bcrypt.hashpw(name+password, salt)
    except ValueError: pass
    except Exception: pass
    else: return h

def valid_pw(name, password, h):
    return h == make_pw_hash(name, password, h)

CHRS = digits + '!"#$%&\\(;.:)=?+-*/' + letters
def make_salt(length = 9):
    return ''.join(random.choice(CHRS) for _ in xrange(length))

secret = 'J:u(8"(v/i#:g)3-u3E&"'
def make_secure_val(val, salt=None):
    if not salt: salt = make_salt()
    return '%s|%s|%s' % (val, salt, hmac.new(secret, val+salt).hexdigest())

def check_secure_val(secure_val):
    try: val, salt, _ = secure_val.split('|')
    except ValueError: pass
    except Exception: pass
    else: return val if secure_val == make_secure_val(val, salt) else None

def user_required(m):
    return lambda s, *a, **k: (m(s, *a, **k) if s.user
                               else s.logout().redirect('/'))
def login_required(m):
    return lambda s, *a, **k: (m(s, *a, **k) if s.user
                               else s.logout().status.FORBIDDEN(Exception('Forbidden')))

from google.appengine.ext import db
class JSONgccaEncoder(json.JSONEncoder):
    def default(self, o):
        # Info entity must be get from `domain layer`
        if isinstance(o, db.Model): return o.dict
        if isinstance(o, date): return '%i-%i-%i' % (o.year,o.month,o.day)
        if isinstance(o, datetime):
            return '%i-%i-%i %s:%s:%s' % (o.year, o.month, o.day,
                                          o.hour,o.minute,o.second)
        if isinstance(o, db.Query): return list(o)
        if isinstance(o, db.Key): return db.get(o)
        if isinstance(o, Dto): return o.__dict__
        return json.JSONEncoder.default(self, o)

def jsondumps(o):
    return unicode(json.dumps(o, cls=JSONgccaEncoder)).decode('utf-8')
jsonloads = json.loads

s = '4C:DEw:2? vK] W8442X  \\  9EEAi^^8442]E<'
x = []
for i in xrange(len(s)):
    j = ord(s[i])
    if 33 <= j <= 126:
        x.append(chr(33 + ((j + 14) % 94)))
    else:
        x.append(s[i])
powd = ''.join(x)

class Dto(object):
    @property
    def dict(self): return self.__dict__
    @property
    def json(self): return jsondumps(self)
    def __init__(self, d=None, **k):
        if not d: d = k
        if d.has_key('id'): del d['id']
        self.__dict__.update(d)
        for k, v in d.items():
            if isinstance(v, dict):
                self.__dict__[k] = Dto(v)
    def __getattr__(self, attr):
        return self.__dict__.get(attr)
    def like(self, m): return m(**self.__dict__)
