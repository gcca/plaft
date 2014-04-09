exports <<<
  settings:
    declaration:
      trackingLength    : 8
      reValidTracking   : /^[A-Z0-9]{8}$/
      reInvalidTracking : /[^A-Z0-9]+/
      reValidSingle     : /^[A-Z0-9]$/
  _error:
    _get: (_model, _xhr, _options) ->
      _json : _xhr\responseJSON
      _code : _xhr.status
      _name : _xhr.statusText
      _xhr  : _xhr
