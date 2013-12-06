# --------------------------------------------------
# Don't modify, unless you need specific behavior !!
# --------------------------------------------------

# Almost useful
# Set `.fnIsJSON = true` if need parse to JSON
$.fn.serializeJSON = ->
  s = (@get 0).elements
  (_ s).reduce (ax, f) ->
    if f instanceof [HTMLInputElement, HTMLSelectElement, HTMLTextAreaElement]
      if f.name
        if f.type is \checkbox
          ax[f.name] = f.checked
        else if f.type is \radio
          ax[f.name] = s[f.name].value
        else
          value = f.value
          value = if value != '' then value else null
          ax[f.name] = if f.fnIsJSON then JSON.parse value else value
    ax
  , new Object

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
  ((s,t,p) -> -> s.apply t, p)(@, [].shift.apply(&), &)) if not (->).bind

# Maintain while HTML5 - RadioNodeList not implemented yet
NodeList ::=
  value:~
    ->
      for node in @
        if node.checked is yes
          return node.value
      new Object
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

GBase = API : path : '/api/v1/'

class GModel extends window .\Backbone .\Model implements GBase
  (_, o = new Object) ->
    @mRoot? = o.mRoot
    super ...

  url: ->
    if @mRoot? then "#{@mRoot.url!}/#{super!}" else "#{@API.path}#{super!}"

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
  url: ->
    if @mRoot? then "#{@mRoot.url!}/#{super!}" else "#{@API.path}#{@urlRoot}"

exports <<<
  tie         : (sf, fn) -> fn.bind sf
  newel       : window.document.createElement.bind window.document
  G           : window .\Backbone
  GView       : window .\Backbone .\View
  GModel      : GModel
  GCollection : GCollection
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

bonk = [
  gz.Css \espin-a-666_1
  gz.Css \espin-a-666_2
  gz.Css \espin-a-666_3
  gz.Css \espin-a-666_4
  gz.Css \espin-a-666_5
  gz.Css \espin-a-666_6
  gz.Css \espin-a-666_7
  gz.Css \espin-a-666_8
]

for boni in bonk
  bon = gz.newel \div
  bon.className = "#{boni} #{gz.Css \espin-a}"
  spin.appendChild bon

spinner.appendChild spin
