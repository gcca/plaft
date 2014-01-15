# --------------------------------------------------
# Don't modify, unless you need specific behavior !!
# --------------------------------------------------


# Almost useful
# -------
# to JSON
# -------
class formToObject
  (formRef) ->
    return false if not formRef
    @formRef = formRef
    @keyRegex = //[^\[\]]+//g
    @$form = null
    @$formElements = []
    @formObj = {}
    if not @setForm! then return false
    if not @setFormElements! then return false
    return @setFormObj!

  setForm: ->
    switch typeof @formRef
      case \string
        @$form = document.getElementById @formRef
      case \object
        @$form = @formRef if @isDomNode @formRef
    @$form

  setFormElements: -> # .elements HTML5 support
    @$formElements = @$form.querySelectorAll 'input, textarea, select'
    @$formElements.length

  isDomNode: (n) -> typeof n is \object && \nodeType of n && n.nodeType is 1

  forEach: (arr, callback) !->
    return [].forEach.call arr, callback if [].forEach
    i = void
    [callback.call arr, arr[i] if Object::hasOwnProperty.call arr, i \
     for i of arr]

  addChild: (result, domNode, keys, value) ->
    if keys.length is 1
      if domNode.checked then return result[keys] = value \
        else return if domNode.nodeName is \INPUT && domNode.type is \radio
      if domNode.nodeName is \INPUT && domNode.type is \checkbox
        if domNode.checked
          result[keys] = [] if not result[keys]
          return result[keys].push value
        else
          return
      if domNode.nodeName is \SELECT && domNode.type is \select-multiple
        result[keys] = []
        DOMchilds = domNode.querySelectorAll 'option[selected]'
        @forEach DOMchilds,
                 (child) -> result[keys].push child.value if DOMchilds
        return
      result[keys] = value
    if keys.length > 1
      result[keys.0] = {} if not result[keys.0]
      return (@addChild result[keys.0], domNode,
                        (keys.splice 1, keys.length), value)
    result

  setFormObj: ->
    test = void
    i = 0
    while i < @$formElements.length
      if @$formElements[i].name && not @$formElements[i].disabled
        test = @$formElements[i].name.match @keyRegex
        @addChild @formObj, @$formElements[i], test, @$formElements[i].value
      i++
    @formObj

$.fn.serializeJSON = -> new formToObject @0

$.fn.populateJSON = !(json) ->
  f = (@get 0).elements
  for l of json
    i = f[l]
    if i
      if i.type is \checkbox
        i.checked = json[l]
      else
        i.value = json[l]

# Maintain while HTML5 - bind not implemented (on testing)
(Function::bind = ->
  ((s, t, p) -> -> s.apply t, p)(@, [].shift.apply(&), &)) if not (->).bind

# Maintain while HTML5 - RadioNodeList not implemented yet
NodeList ::=
  value:~
    ->
      for node in @
        if node.checked is yes
          return node.value
      ''
    !(value) ->
      for node in @
        if value == node.value
          node.checked = yes
          break


# --------------
# Global Context
# --------------
class Pool
  (objects) ->
    @queue = new Array
    @objects = object

  add: (object) ->
    @objects.push object
    @call!

  call: ->
    if @objects.length and @queue.length
      fn = @queue.shift!
      obj = @objects.shift!
      fn obj, @
    @

  act: (fn) ->
    @queue.push fn
    @call!


class ObjectPool
  (Cls) ->
    @cls = Cls
    @metrics = new Object
    @_clearMetrics!
    @_objpool = new Array

  alloc: ->
    if 0 == @_objpool.length
      obj = new @cls!
      @metrics.totalalloc++
    else
      obj = @_objpool.pop!
      @metrics.totalfree--
    obj.init.apply obj, &
    obj

  free: (obj) ->
    @_objpool.push obj
    @this.metrics.totalfree++
    for k in obj then delete! obj[k]
    obj.init.call obj

  collect: (cls) ->
    @_objpool = new Array
    inUse = @metrics.totalalloc - @metrics.totalfree
    @_clearMetrics inUse

  _clearMetrics: (allocated) ->
    @metrics.totalalloc = allocated || 0
    @metrics.totalfree = 0


GBase = API : _path : '/api/v1/'

GAPI =
   _path: '/api/v1/'

class GModel extends window .\Backbone .\Model implements GBase
  on      : ::\on
  trigger : ::\trigger
  bind    : ::\bind
  fetch   : ::\fetch
  save    : ::\save
  (_, o = new Object) ->
    @mRoot? = o.mRoot
    super ...

  url: ->
    if @mRoot? then "#{@mRoot.url!}/#{super!}" else "#{@API._path}#{super!}"

  sync: (t, m, o) ->
    if t is \read
      a = m.attributes
      o.url = m.url! + '?' + (["#k=#{a[k]}" for k of a].join '&')
    else if t is \create or t is \update
      a = m.toJSON!
      a <<<< {[k,a[k].id] for k of a when a[k] instanceof GModel and a[k].id?}
      o.\attrs = a
    super ...


class GCollection extends window .\Backbone .\Collection implements GBase
  on      : ::\on
  trigger : ::\trigger
  bind    : ::\bind
  fetch   : ::\fetch
  save    : ::\save
  url: ->
    if @mRoot? then "#{@mRoot.url!}/#{super!}" else "#{@API._path}#{@urlRoot}"

gviewOptions = <[ model collection el id attributes className tagName events ]>
class GView extends window .\Backbone .\View
  initialize : ::\initialize
  render     : ::\render
  on         : ::\on
  off        : ::\off
  trigger    : ::\trigger
  bind       : ::\bind

  (options = {}) !->
    @\events     = @events
    @\render     = @render
    @\el         = @el if @el?
    @\cid = _\uniqueId 'view'
    if options.el?
      options.\el = options.el
      delete! options.el
    _\extend @, (_\pick options, gviewOptions)
    @'_ensureElement'!
    @$el = @\$el
    @el  = @\el
    @initialize.apply @, &
    @'delegateEvents'!

$.\fn
  ..trigger = ..\trigger
  ..show    = ..\show
  ..hide    = ..\hide
  ..toggle  = ..\toggle
  ..on      = ..\on
  ..off     = ..\off
  ..trigger = ..\trigger
  ..bind    = ..\bind
  ..html    = ..\html
  ..parent  = ..\parent
  ..parents = ..\parents

exports <<<
  tie         : (sf, fn) -> fn.bind sf
  newel       : window.document.createElement.bind window.document
  G           : window .\Backbone
  GEvents     : window .\Backbone .\Events
  GView       : GView
  GModel      : GModel
  GCollection : GCollection
  GAPI        : GAPI
window .\Ink .\UI
  exports <<<
    Ink:
      UI:
        Sticky     : ..\Sticky
        Tabs       : ..\Tabs
        DatePicker : ..\DatePicker
        Modal      : ..\Modal
        Table      : ..\Table
        Toggle     : ..\Toggle
        Tooltip    : class extends ..\Tooltip
          destroy: !-> for t in @'tooltips' then t.'_removeTooltip'!
exports <<<< window.gz if window.gz?
gz = exports


# --------------------
# Loading info spinner
# --------------------
Gsync = gz.G.sync
isSpinning = true
gz.G.sync = ->
  document.body.appendChild spinner if isSpinning
  isSpinning := false
  Gsync ...

$ document
  ..on \ajaxBeforeSend, !->
    setTimeout !->
      if spinner.parentNode?
        spin.classList.add gz.Css \espin-mn-show
    , 100

  ..on \ajaxComplete, !->
    setTimeout !->
      spinner.classList.remove gz.Css \espin-mn-show
      document.body.removeChild spinner if document.body.contains spinner
      isSpinning := true
    , 10

  ..on \ajaxError, (_, xhr) !->
    if xhr.status is 0
      base = document.createElement \nav

      base.className = gz.Css \ink-navigation

      base.style
        ..padding         = \13px
        ..backgroundColor = 'rgba(0,0,0,0.69)' # ;)
        ..borderRadius    = \7px
        ..position        = \fixe2
        ..top             = \49px
        ..left            = \0
        ..width           = \100%
        ..textAlign       = \center
        ..marginTop       = \0

      ale = document.createElement \div
      tx = document.createElement \p

      ale.className = "#{gz.Css \ink-alert}
                     \ #{gz.Css \basic}
                     \ #{gz.Css \error}"

      tx.style.margin = \0
      tx.innerHTML = '<b>Error:</b> &nbsp; Sin conexión.'

      ale.appendChild tx

      base.appendChild ale

      document.body.appendChild base

spinner = gz.newel \div
spinner.style
  ..position = 'fixed'
  ..width    = '100%'
  ..height   = '100%'
  ..top      = '0'
  ..bottom   = '0'
  ..right    = '0'
  ..left     = '0'
  ..zIndex   = '6969' # ;)
  #..user-select: none;
  ..backgroundColor = 'transparent'

spin = gz.newel \div
spin.className = gz.Css \espin-mn

bonk =
  gz.Css \espin-a-666_1
  gz.Css \espin-a-666_2
  gz.Css \espin-a-666_3
  gz.Css \espin-a-666_4
  gz.Css \espin-a-666_5
  gz.Css \espin-a-666_6
  gz.Css \espin-a-666_7
  gz.Css \espin-a-666_8

for boni in bonk
  bon = gz.newel \div
  bon.className = "#{boni} #{gz.Css \espin-a}"
  spin.appendChild bon

spinner.appendChild spin
