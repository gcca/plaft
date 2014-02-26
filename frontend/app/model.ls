exports.Customer = \

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


exports.User = \

class User extends App.Model

  urlRoot: 'user'


exports.Customs = \

class Customs extends App.Model

  urlRoot: 'customs'

  @@pending =
    dispatches: (callback) !->
      App.internals._get "#{@@API}customs/pending/dispatches", null, callback


exports.Declaration = \

class Declaration extends App.Model

  urlRoot: 'declaration'


exports.Dispatch = \

class Dispatch extends App.Model

  urlRoot: 'dispatch'
