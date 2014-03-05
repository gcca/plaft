# --------------------------------------------------
# Don't modify, unless you need specific behavior !!
# --------------------------------------------------

# Almost useful

## _multiple = ->

## _input = ->

## _field = (e) ->
##   | e instanceof HTMLInputElement =>
##     if e.type is \text then e.value else _input e
##   | e instanceof HTMLSelectElement =>
##     if e.multiple then _multiple e else e.value
##   | e instanceof HTMLTextAreaElement => e.value

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
    ## @$formElements = @$form.querySelectorAll 'input, textarea, select'
    @$formElements = [.. for @$form.elements
                      when .. instanceof [HTMLInputElement,
                                          HTMLSelectElement,
                                          HTMLTextAreaElement]]
    @$formElements.length

  isDomNode: (n) -> typeof n is \object && \nodeType of n && n.nodeType is 1

  forEach: (arr, callback) !->
    return [].forEach.call arr, callback if [].forEach
    i = void
    [callback.call arr, arr[i] if Object::hasOwnProperty.call arr, i \
     for i of arr]

  addChild: (result, domNode, keys, value) ->
    if keys.length is 1
      if domNode.nodeName is \INPUT && domNode.type is \checkbox
        return result[keys] = domNode.checked
      if domNode.checked then return result[keys] = value \
        else return if domNode.nodeName is \INPUT && domNode.type is \radio
      ## if domNode.nodeName is \INPUT && domNode.type is \checkbox
        ## if domNode.checked
        ##   result[keys] = [] if not result[keys]
        ##   return result[keys].push value
        ## else
        ##   return
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


$\fn
  .._toJSON = -> new formToObject @0
     ## r = new Object
     ## es = @0.elements
     ## for e in es
     ##   r[e.name] = _field e if not e.disabled
     ## r

  .._fromJSON = (o) !->
    es = @0.elements
    k = new Array
    App.internals._flatten o, k, ''
    for [i, v] in k
      if (i.indexOf '.') > 0
        i = i.replace /\./, \[
        i = i.replace /\./g, ']['
        i += \]
      e = es[i]
      if e?
        if e.type is \checkbox
          e.checked = v
        else
          e.value = v
    ## for e in es
    ##   as = e.name.replace /]/g, '' .split \[
    ##   v = d
    ##   for k in as
    ##     w = v[k]
    ##     if w?
    ##       v = w
    ##     else
    ##       v = void
    ##       break
    ##   es[e.name].value = v if v?

# Maintain while HTML5 - bind not implemented (on testing)
(Function::bind = ->
  ((s, t, p) -> -> s.apply t, p)(@, [].shift.apply(&), &)) if not (->).bind

# Maintain while HTML5 - RadioNodeList not implemented yet
NodeList::=
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

((fastdom) ->
  raf = (window.requestAnimationFrame
         || window.webkitRequestAnimationFrame
         || window.mozRequestAnimationFrame
         || window.msRequestAnimationFrame
         || (cb) -> window.setTimeout cb, 1000 / 60)
  caf = (window.cancelAnimationFrame
         || window.cancelRequestAnimationFrame
         || window.mozCancelAnimationFrame
         || window.mozCancelRequestAnimationFrame
         || window.webkitCancelAnimationFrame
         || window.webkitCancelRequestAnimationFrame
         || window.msCancelAnimationFrame
         || window.msCancelRequestAnimationFrame
         || (id) -> window.clearTimeout id)
  class FastDom
    ->
      @frames = []
      @lastId = 0
      @raf = raf
      @batch =
        hash: {}
        read: []
        write: []
        mode: null

    _read: (fn, ctx) ~>
      job = @add 'read', fn, ctx
      id = job.id
      @batch.read.push job.id
      doesntNeedFrame = @batch.mode is 'reading' || @batch.scheduled
      return id if doesntNeedFrame
      @scheduleBatch!
      id

    _write: (fn, ctx) ~>
      job = @add 'write', fn, ctx
      mode = @batch.mode
      id = job.id
      @batch.write.push job.id
      doesntNeedFrame = mode is 'writing' || mode is 'reading' || @batch.scheduled
      return id if doesntNeedFrame
      @scheduleBatch!
      id
    defer: (frame, fn, ctx) ->
      if typeof frame is 'function'
        ctx = fn
        fn = frame
        frame = 1
      self = this
      index = frame - 1
      @schedule index, ->
        self.run {
          fn: fn
          ctx: ctx
        }
    clear: (id) ->
      return @clearFrame id if typeof id is 'function'
      job = @batch.hash[id]
      if not job then return
      list = @batch[job.type]
      index = list.indexOf id
      delete! @batch.hash[id]
      if ~index then list.splice index, 1
    clearFrame: (frame) ->
      index = @frames.indexOf frame
      @frames.splice index, 1 if ~index
    scheduleBatch: ->
      self = this
      @schedule 0, ->
        self.batch.scheduled = false
        self.runBatch!
      @batch.scheduled = true
    uniqueId: -> ++@lastId
    flush: (list) ->
      id = void
      while id = list.shift!
        @run @batch.hash[id]
    runBatch: ->
      try
        @batch.mode = 'reading'
        @flush @batch.read
        @batch.mode = 'writing'
        @flush @batch.write
        @batch.mode = null
      catch e
        @runBatch!
        throw e
    add: (type, fn, ctx) ->
      id = @uniqueId!
      @batch.hash[id] = {
        id: id
        fn: fn
        ctx: ctx
        type: type
      }
    run: (job) ->
      ctx = job.ctx || this
      fn = job.fn
      delete! @batch.hash[job.id]
      return fn.call ctx if not @onError
      (try
        fn.call ctx
      catch e
        @onError e)
    loop: ->
      self = this
      raf := @raf
      return  if @looping
      raf frame = ->
        fn = self.frames.shift!
        if not self.frames.length then self.looping = false else raf frame
        if fn then fn!
      @looping = true
    schedule: (index, fn) ->
      return @schedule index + 1, fn if @frames[index]
      @loop!
      @frames[index] = fn
  fdom = new FastDom
  document
    .._write = fdom._write
    .._read  = fdom._read)!

## Global Z-U
_
  ..zip      = ..\zip
  ..pick     = ..\pick
  ..uniqueId = ..\uniqueId
  .._zip     = ..\zip
  .._extend  = ..extend
  .._all     = ..all

$\fn
  ..html         = ..\html
  ..attr         = ..\attr
  ..on           = ..\on
  ..off          = ..\off
  ..trigger      = ..\trigger
  ..parents      = ..\parents
  ..addClass     = ..\addClass
  ..removeClass  = ..\removeClass
  ..first        = ..\first
  ..last         = ..\last
  ..css          = ..\css
  ..hide         = ..\hide
  ..post         = ..\post
  ..tooltip      = ..\tooltip
  .._show        = ..\show
  .._find        = ..\find
  .._append      = ..\append
  .._parent      = ..\parent
  .._children    = ..\children
  .._html        = ..\html
  .._attr        = ..\attr
  .._parents     = ..\parents
  .._addClass    = ..\addClass
  .._removeClass = ..\removeClass
  .._first       = ..\first
  .._last        = ..\last
  .._css         = ..\css
  .._hide        = ..\hide
  .._on          = ..\on
  .._off         = ..\off
  .._trigger     = ..\trigger
  .._remove      = ..\remove
  .._post        = ..\post
  .._click       = ..\click
