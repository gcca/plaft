exports <<<
  Enum : class Enum
    (objKeys, i = 0) ->
      Object.getOwnPropertyNames objKeys .forEach (prop) !~>
        objKeys[prop] = ++i
        Object.defineProperty @, prop,
          Object.getOwnPropertyDescriptor objKeys, prop
      Object.freeze @

  Types :
    Field : new Enum do
      kLineEdit   : null
      kComboBox   : null
      kTextEdit   : null
      kCheckBox   : null
      kRadioGroup : null
      kView       : null

  Pool : class Pool
    (objects) ->
      @queue = new Array
      @objects = object

    _add: (object) ->
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

  ObjectPool : class ObjectPool
    (Cls) ->
      @cls = Cls
      @metrics = new Object
      @_clearMetrics!
      @_objpool = new Array

    allocate: (a) ->
      if 0 == @_objpool._length
        obj = new @cls a
        @metrics.totalalloc++
      else
        obj = @_objpool._pop!
        @metrics.totalfree--
        obj.initialize.apply obj, &
      obj

    free: (obj) !->
      @_objpool._push obj
      @metrics.totalfree++
      for k in obj then delete! obj[k]
      ## obj.initialize.call obj

    preAllocate: ->

    collect: (cls) !->
      @_objpool = new Array
      inUse = @metrics.totalalloc - @metrics.totalfree
      @_clearMetrics inUse

    _clearMetrics: (allocated) !->
      @metrics.totalalloc = allocated || 0
      @metrics.totalfree = 0
