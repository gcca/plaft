/**
 * @module app.model
 *
 * _success : function(Model|Collection, Object, XMLHttpRequest)
 *   Model|Collection class
 *   Object Data Object or Array
 *   XMLHttpRequest xhr Object
 */

voidCodeName =
  \code : null
  \name : null


/** --------
 *  Customer
 *  --------
 * @typedef {Object}
 * @class Customer
 * @extends Model
 */
class Customer extends App.Model

  /** @override */
  urlRoot: 'customer'

  /**
   * Is business?
   * @return boolean
   * @public
   */
  isBusiness:~ -> @_attributes.'document'.'number'._length is 11

  /**
   * Is business?
   * @return boolean
   * @public
   */
  isPerson:~ -> not @isBusiness

  /**
   * Create new declaration from customer.
   * @param {Object.<string, string>} _data {third, source}.
   * @param {Function} callback
   * @public
   */
  newDeclaration: (_data, callback) ->
    dto =
      \third    : _data.third
      \source   : _data.source
      \customer : @_attributes
      \tracking : _data.tracking
      \owner    : _data.owner

    App.internals._post "#{@@API}customer/#{@_id}/declaration",
                        dto,
                        callback


/** ----
 *  User
 *  ----
 * @typedef {Object}
 * @class User
 * @extends Model
 */
class User extends App.Model

  /** @override */
  urlRoot: 'user'


/** -------
 *  Customs
 *  -------
 * @typedef {Object}
 * @class Customs
 * @extends Model
 */
class Customs extends App.Model

  /** @override */
  urlRoot: 'customs'

  /**
   * Functions for internal list about pending...
   */
  @@pending =
    /**
     * Dispatches to analyze.
     * @param {Function} callback
     */
    dispatches: (callback) !->
      App.internals._get "#{@@API}customs/pending/dispatches", null, callback


/** -----------
 *  Declaration
 *  -----------
 * @typedef {Object}
 * @class Declaration
 * @extends Model
 */
class Declaration extends App.Model

  /** @override */
  urlRoot: 'declaration'


/** --------
 *  Dispatch
 *  --------
 * @typedef {Object}
 * @class Dispatch
 * @extends Model
 */
class Dispatch extends App.Model

  /** @override */
  urlRoot: 'dispatch'

  /** @override */
  defaults:
    \regime       : voidCodeName
    \jurisdiction : voidCodeName
    \numeration   :
      \order    : null
      \signed   : null
      \supplier : null
      \importer : null
    \customer     :
      \name     : null
      \document : voidCodeName
    \declaration  :
      \tracking : null
      \signed   : null


/** -----------
 *  Stakeholder
 *  -----------
 * @typedef {Object}
 * @class Stakeholder
 * @extends Model
 */
class Stakeholder extends App.Model

  /** @override */
  urlRoot: 'stakeholder'


/** @export */
exports <<<
  Customer    : Customer
  User        : User
  Customs     : Customs
  Declaration : Declaration
  Dispatch    : Dispatch
  Stakeholder : Stakeholder


# vim: ts=2 sw=2 sts=2 et:
