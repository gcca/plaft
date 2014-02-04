builtins = require './app/builtins'
helpers = require './app/helpers'

App = new Object

$'Event'::
  ..prevent = ..preventDefault

Event::
  ..prevent = ..preventDefault

Object.defineProperties $'Event'::, do
  _target: get: -> @currentTarget

Object.defineProperties Event::, do
  _target: get: -> @currentTarget


## Global HTML-Element
Object.defineProperties Object::, do
  _constructor : get : -> @constructor
  toStr        : get : -> @toString!

document
  ..newel = ..createElement

HTMLElement::
  HTMLElement::=
    _append  : ..appendChild
    html     : (a) !-> @innerHTML = a
    _focus   : ..focus
    onClick  : (e) !-> @onclick = e
    onSubmit : (e) !-> @onsubmit = e
    addEvent :     !-> @addEventListener ...

Object.defineProperties HTMLElement::, do
  css: get: -> @style

  Class:
   get: -> @classList
   set: (a) !-> @className = a

  _type: set: (a) !-> @type = a

Object.defineProperties HTMLFormElement::, do
  _elements: get: -> @elements

Object.defineProperties HTMLInputElement::, do
  _value: get: -> @value

Object.defineProperties HTMLCollection::, do
  _length: get: -> @length

Array::
  Array::=
    _push : ..push
    _pop  : ..pop
    _join : ..join

Object.defineProperties Array::, do
  _length: get: -> @length

Object.defineProperties String::, do
  _length: get: -> @length

DOMTokenList::
  DOMTokenList::=
    _add    : ..add
    _remove : ..remove
    _toggle : ..toggle

gsetter = (n) -> get: (-> @[n]), set: (a) !-> @[n] = a
Object.defineProperties CSS2Properties::, do
  _marginBottom: gsetter \marginBottom
  _width: gsetter \width


## Global Backbone
Backbone = window\Backbone

NewPoolMixIn =
  New: (o) -> @pool.allocate o
  Pool: !-> @pool = new builtins.ObjectPool @

FreePoolMixIn =
  Free: !-> @_constructor.pool.free @


viewOpts =
  model      : null
  collection : null
  el         : null
  id         : null
  attributes : null
  className  : null
  tagName    : null
  events     : null

viewOpts = [k for k of viewOpts]

class View extends Backbone\View implements FreePoolMixIn

  (options = new Object) !->
    @\events = @events
    @\render = @render
    @\tagName = @_tagName
    @\className = @_className
    @\el     = @el if @el?
    @\cid = _.uniqueId 'cris-gz'
    if options.el?
      options.\el = options.el
      delete! options.el
    _._extend @, (_.pick options, viewOpts)
    @'_ensureElement'!
    @$el = @\$el
    @el  = @\el
    @initialize.apply @, &
    @'delegateEvents'!

  initialize: !->

  # Const
  ::render  = ::\render
  ::on      = ::\on
  ::off     = ::\off
  ::trigger = ::\trigger
  ::_remove = ::\remove

  _._extend @@, NewPoolMixIn


class BaseModel extends Backbone\Model

  (_, o = new Object) ->
    @_parent? = o._parent
    @\urlRoot = @urlRoot
    super ...
    @_attributes = @attributes

  ::fetch   = ::\fetch
  ::_fetch  = ::\fetch
  ::_save   = ::save
  ::_url    = ::url
  ::_get    = ::get
  ::_set    = ::set
  ::_sync   = ::\sync
  ::_toJSON = ::\toJSON

  flatten: -> App.internals.flatten @_attributes

  _id:~ -> @id

  \url  : -> @_url ...
  \sync : -> @_sync ...


class Model extends BaseModel

  @@API = '/api/v1/'

  _url: ->
    if @_parent? then "#{@_parent._url!}/#{super!}" else "/api/v1/#{super!}"

  _sync: (t, m, o) ->
    if t is \read
      o.\url = m._url! + '?' + [..join '=' for @flatten m._attributes].join '&'
    ## else if t is \create or t is \update
    ##   a = m.'toJSON'!
    ##   a <<<< {[k,a[k]'id'] for k of awhen a[k] instanceof Model and a[k]'id'?}
    ##   o.\attrs = a
    super ...

  _parent: null

  fetch: (opts = {}) ->
    super \success : opts._success, \error : opts._error

  _save: (keys, opts = {}) ->
    _keys  = keys
    _attrs = @_attributes
    _data  = App.internals.difference _attrs, _keys
    super null, \success : opts._success, \error : opts._error, \attrs : _data


## Global App
App <<<
  View      : View
  Model     : Model
  ui        : new Object
  dom       : document
  win       : window
  _global   : new Object
  builtins  : builtins
  shared    : require './app/shared'
  internals : require './app/internals'

App.model = require './app/model'

module.exports = App
