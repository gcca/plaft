flatten-loop = (cb, o, k, b) !-->
  for i of o
    v = o[i]
    if v?
      if v._constructor is Object
        flatten-loop cb, v, k, (b + "#i.")
      else
        cb k, (b + i), v

# Public
exports <<<
  _get: (_url, _data, _success, _error) ->
    ($\ajax do
      \url         : _url
      \data        : _data
      \success     : _success)
      ..\fail _error

  _post: (_url, _data, _success, _error) ->
    ($\ajax do
      \type        : \POST
      \url         : _url
      \data        : JSON.stringify _data
      \success     : _success
      \contentType : 'application/json'
      \dataType    : \json)
      ..\fail _error

  _put: (_url, _data, _success, _error) ->
    ($\ajax do
      \type        : \PUT
      \url         : _url
      \data        : JSON.stringify _data
      \success     : _success
      \contentType : 'application/json'
      \dataType    : \json)
      ..\fail _error

  _delete: (_url, _data, _success, _error) ->
    ($\ajax do
      \type        : \DELETE
      \url         : _url
      \success     : _success
      \contentType : 'application/json'
      \dataType    : \json)
      ..\fail _error

  difference: (_attrs, _keys) ->
    _data = new Object

    for k of _keys
      a = _attrs[k]
      v = _keys[k]

      if v._constructor is Object
        _data[k] = App.internals.difference a, v

      else
        _data[k] = v if a != v

    _data

  flatten: (o) ->
    new Array
      App.internals._flatten o, .., ''

  _flatten: flatten-loop (k, b, v) !-> k.push [b, v]

  flattened: (o) ->
    new Object
      App.internals._flattened o, .., ''

  _flattened: flatten-loop (k, b, v) !-> k[b] = v
