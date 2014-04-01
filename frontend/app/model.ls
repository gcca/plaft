/**
 * @module app.model
 *
 * _success : function(Model|Collection, Object, XMLHttpRequest)
 *   Model|Collection class
 *   Object Data Object or Array
 *   XMLHttpRequest xhr Object
 */


class Customer extends App.Model

  urlRoot: 'customer'

  isBusiness :~ -> @_attributes.'document'.'number'._length is 11
  isPerson   :~ -> @_attributes.'document'.'number'._length is 8

  newDeclaration: (_data, callback) ->
    dto =
      \third    : _data.third
      \source   : _data.source
      \customer : @_attributes

    App.internals._post "#{@@API}customer/#{@_id}/declaration",
                        dto,
                        callback


class User extends App.Model

  urlRoot: 'user'


class Customs extends App.Model

  urlRoot: 'customs'

  @@pending =
    dispatches: (callback) !->
      App.internals._get "#{@@API}customs/pending/dispatches", null, callback


class Declaration extends App.Model

  urlRoot: 'declaration'


class Dispatch extends App.Model

  urlRoot: 'dispatch'


class Stakeholder extends App.Model

  urlRoot: 'stakeholder'


exports <<<
  Customer    : Customer
  User        : User
  Customs     : Customs
  Declaration : Declaration
  Dispatch    : Dispatch
  Stakeholder : Stakeholder
