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
  _target   : get : -> @currentTarget
  _key      : get : -> @key
  _keyCode  : get : -> @keyCode
  _shiftKey : get : -> @shiftKey
  _ctrlKey  : get : -> @ctrlKey


## Global HTML-Element
Object.defineProperties Object::, do
  _constructor : get : -> @constructor
  toStr        : get : -> @toString!

document
  ..newel    = ..createElement
  .._new     = ..createElement
  ..query    = ..querySelector
  ..queryAll = ..querySelectorAll

HTMLElement::
  HTMLElement::=
    _append  : ..appendChild
    appendTo : (a)  -> a.appendChild @
    html     : (a) !-> @innerHTML = a
    _focus   : ..focus
    query    : ..querySelector
    queryAll : ..querySelectorAll
    onClick  : (e) !-> @onclick  = e
    onSubmit : (e) !-> @onsubmit = e
    onChange : (e) !-> @onchange = e
    onKeyUp  : (e) !-> @onkeyup  = e
    addEvent :     !-> @addEventListener ...

Object.defineProperties HTMLElement::, do
  css: get : -> @style

  Class: get : (-> @classList), set : (a) !-> @className = a

  _type: set: (a) !-> @type = a

  _first  : get : -> @firstElementChild
  _last   : get : -> @lastElementChild
  _parent : get : -> @parentElement
  _next   : get : -> @nextElementSibling

  _disabled : get : (-> @disabled), set : (x) -> @disabled = x
  _id : get : (-> @id), set : (x) -> @id = x

Object.defineProperties HTMLFormElement::, do
  _elements: get: -> @elements

fieldsProto =
  _value : get : (-> @value), set : (a) !-> @value = a
  _name  : get : (-> @name ), set : (a) !-> @name  = a

Object.defineProperties HTMLInputElement::, fieldsProto
Object.defineProperties HTMLSelectElement::, fieldsProto


HTMLInputElement::=
  _checked:~
    (a) -> @checked = a
    -> @checked
  _placeholder:~
    (a) -> @placeholder = a
    -> @placeholder

HTMLButtonElement::=
  _disabled:~
    (a) -> @disabled = a
    -> @disabled

HTMLAnchorElement::=
  _target:~
    (a) -> @target = a
    -> @target

Object.defineProperties HTMLSelectElement::, do
  _selected : get : -> @selectedIndex
  _length   : get : -> @length

HTMLInputElement::=
  withName  : (a) -> @name  = a ; @
  withValue : (a) -> @value = a ; @

Object.defineProperties HTMLCollection::, do
  _length: get: -> @length

Array::
  Array::=
    _push  : ..push
    _pop   : ..pop
    _join  : ..join
    _index : ..indexOf

Object.defineProperties Array::, do
  _length : get : (-> @length), set : (a) !-> @length = a

Object.defineProperties String::, do
  _length : get : -> @length

String::
  .._match = ..match

DOMTokenList::
  DOMTokenList::=
    _add    : ..add
    _remove : ..remove
    _toggle : ..toggle

history
  .._replace-state = ..replaceState

CSSProperties = CSS2Properties if CSS2Properties?
CSSProperties = CSSStyleDeclaration if CSSStyleDeclaration?
gsetter = (n) -> get: (-> @[n]), set: (a) !-> @[n] = a
Object.defineProperties CSSProperties::, do
  _margin-bottom             : gsetter \marginBottom
  _width                     : gsetter \width
  _height                    : gsetter \height
  _padding                   : gsetter \padding
  _padding-left              : gsetter \paddingLeft
  _padding-right             : gsetter \paddingRight
  _padding-bottom            : gsetter \paddingBottom
  _padding-top               : gsetter \paddingTop
  _margin-left               : gsetter \marginLeft
  _margin-right              : gsetter \marginRight
  _overflow                  : gsetter \overflow
  _overflowX                 : gsetter \overflowX
  _overflowY                 : gsetter \overflowY
  _border                    : gsetter \border
  _border-radius             : gsetter \borderRadius
  _border-top-left-radius    : gsetter \borderTopLeftRadius
  _border-bottom-left-radius : gsetter \borderBottomLeftRadius
  _font-size                 : gsetter \fontSize
  _display                   : gsetter \display
  _text-align                : gsetter \textAlign


## Global Backbone
Backbone = window\Backbone

NewPoolMixIn =
  New  : -> @Pool! if not @pool?; @New = @_New; @pool.allocate.apply @pool, &
  _New : -> @pool.allocate.apply @pool, &
  Pool :    !-> @pool = new builtins.ObjectPool @
  pool : null

FreePoolMixIn =
  free: !-> @_remove!; @_constructor.pool.free @

PoolMixIn =
  free: !-> @_constructor.pool.free @
implementsPool = (_self) -> _._extend _self, NewPoolMixIn

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
      ## options.\el = options.el
      @\el = options.el
      delete! options.el
    _._extend @, (_.pick options, viewOpts)
    @'_ensureElement'!
    @$el = @\$el
    @el  = @\el
    @initialize.apply @, &
    @'delegateEvents'!

  ## el:~
  ##   -> @\el
  ##   (a) -> @\el = a

  ## $el:~
  ##   -> @\$el
  ##   (a) -> @\$el = a

  inner: (c) !->
    if c._constructor is String
      @el.html c
    else
      @el.html null
      @el._append c

  initialize: !->

  # Const
  ::render  = ::\render
  ::on      = ::\on
  ::off     = ::\off
  ::trigger = ::\trigger
  ::_remove = ::\remove
  ::$       = ::\$

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
  ::on      = ::\on
  ::off     = ::\off
  ::trigger = ::\trigger
  ::_remove = ::\remove

  flatten: -> App.internals.flatten @_attributes

  _clean: (o) ->
    for k of o
      if o[k]? and o[k]._constructor is Object and o[k].'id'
        delete! o[k]

  _id:~ -> @id

  \url  : -> @_url ...
  \sync : -> @_sync ...


/**
 * _success : (model, dto, options)
 * _error   : (model, xhr, options)
 */
class Model extends BaseModel

  @@API = '/api/v1/'

  _url: ->
    if @_parent? then "#{@_parent._url!}/#{super!}" else "/api/v1/#{super!}"

  _sync: (t, m, o) ->
    if t is \read and not m._attributes.\id
      o.\url = m._url! + '?' + [..join '=' for @flatten m._attributes].join '&'
    else if t in <[ create update ]>
      a = m._toJSON!
      @_clean a
      o\attrs = a
    #a <<<< {[k,a[k]'id'] for k of a when a[k] instanceof Model and a[k]'id'?}
    #o.\attrs = a
    super ...

  _parent: null

  fetch: (opts = {}) -> super \success : opts._success, \error : opts._error

  _save: (keys, opts = {}) ->
    super keys, \success : opts._success, \error : opts._error

  store: (_data, opts = App._void._Object) ->
     App.internals._put "#{@@API}#{@urlRoot}/#{@id}", _data,
                         opts._success, opts._error


class BaseCollection extends Backbone\Collection

  (_, o = new Object) ->
    @_parent? = o._parent
    super ...
    @url = @_url
    @_attributes = @attributes

  ::fetch   = ::\fetch
  ::_fetch  = ::\fetch
  ::_save   = ::save
  ::_url    = ::url
  ::_get    = ::get
  ::_set    = ::set
  ::_sync   = ::\sync
  ::_toJSON = ::\toJSON
  ::on      = ::\on
  ::off     = ::\off
  ::trigger = ::\trigger
  ::_remove = ::\remove

  _parent: null
  urlRoot: null
  _id:~ -> @id

  _url  : -> @urlRoot  # @_url ...
  \sync : -> @_sync ...

class Collection extends BaseCollection

  @@API = '/api/v1/'

  _url: -> "/api/v1/#{super!}"

  fetch: (opts = {}) -> super \success : opts._success, \error : opts._error

  _save: (keys, opts = {}) ->
    super keys, \success : opts._success, \error : opts._error


## Global App
App <<<
  View       : View
  Model      : Model
  Collection : Collection
  ui         : new Object
  dom        : document
  win        : window
  _global    : require './app/global'
  builtins   : builtins
  shared     : require './app/shared'
  internals  : require './app/internals'
  storage    :
    local   : localStorage
    session : sessionStorage
  _void       :
    _Array    : new Array
    _Object   : new Object
    _Function : new Function
  _history   : history
  widget     : require './app/widget'

App.model = require './app/model'

module.exports = App
