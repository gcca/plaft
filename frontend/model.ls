/** ------------
 *  Domain Layer
 *  ------------
 * @fileoverview Utilities for hadnling remote services. {@code GModel}
 *     and {@code Collection}for managing entities.
 * @author gcca@gcca.tk (cristHian Gz)
 */

# ------
# Basics
# ------
GModel = gz.GModel
GCollection = gz.GCollection

# -----------
# Shareholder
# -----------
/**
 * Shareholder model
 * @class Shareholder
 */
class Shareholder extends GModel
  urlRoot: \shareholder
  defaults:
    \documentType   : ''
    \documentNumber : ''
    \name           : ''

/**
 * Shareholder collection
 * @class Shareholders
 */
class Shareholders extends GCollection
  model: Shareholder

# --------
# Customer
# --------
/**
 * Customer model
 * @class Customer
 */
class Customer extends GModel
  urlRoot: \customer

  /** Customer creates a new declaration.
   *
   * @param {!Object} declarationJSON JSON with declaration data.
   *     (Attributes of declaration.)
   * @param {Object} options JSON callbacks success and error.
   * @return {undefined}
   *
   * @example
   * >>> customer = new Customer id : 666
   * >>> declarationJSON
   * ...     references : '123,456,789'
   * ...     amount     : 0.0666
   * ...     ...
   * >>> options =
   * ...     \sucess : (declarationModel) ->
   * ...         ...  # Declaration created
   * ...     \error : ->
   * ...         ...  # Error creating declaration
   * >>> customer.createDeclaration declarationJSON, options
   */
  createDeclaration: (declarationJSON, options) ->
    declarationJSON <<< \customer : @toJSON!
    declaration = new Declaration declarationJSON, mRoot : @
    declaration.save new Object, options

  /**
   * Check if customer is a business.
   * @return {boolean}
   */
  isBusiness: -> (@get \documentNumber).length is 11

/**
 * Customer collection
 * @class Customers
 */
class Customers extends GCollection
  url: \customer
  model: Customer

# -----------
# Declaration
# -----------
/**
 * Declaration model
 * @class Declaration
 */
class Declaration extends GModel
  urlRoot: \declaration

/**
 * Declaration collection
 * @class Declarations
 */
class Declarations extends GCollection
  urlRoot: \declarations
  model: Declaration

# --------------------
# Customer Declaration
# --------------------
/**
 * Last declaration of {@code Customer} model
 * @class CustomerLastDeclaration
 */
class CustomerLastDeclaration extends Declaration
  urlRoot: \customer/lastdeclaration

# --------
# Dispatch
# --------
/**
 * Dispatch model
 * @class Dispatch
 */
class Dispatch extends GModel
  urlRoot: \dispatch

  /**
   * Generic fix dispatch POST Request.
   * @param {string} type
   * @param {Function} mCallback
   * @private
   */
  _fix: (type, mCallback) !->
    $.post "#{@API.path}dispatch/#{@id}/fix/#type" mCallback

  /** @see __fix */ fixRegister   : (mCallback) !-> @_fix \register   mCallback
  /** @see __fix */ fixUnusual    : (mCallback) !-> @_fix \unusual    mCallback
  /** @see __fix */ fixSuspicious : (mCallback) !-> @_fix \suspicious mCallback

/**
 * Dispatch collection
 * @class Dispatches
 *
 * register
 *   operation
 *     obligedCode
 *     officierCode
 *     rowCode
 *     operationCode
 *     internalCode
 * internalCode
 * kind
 * obligedCode
 * officierCode
 * operationCode
 * operationDate
 * operationMode
 * operationsNumber
 * rowCode
 */
class Dispatches extends GCollection
  urlRoot: \dispatches
  model: Dispatch

/**
 * Customs Broker model
 * @class CustomsBroker
 */
class CustomsBroker extends GModel
  urlRoot: \customsbroker

/**
 * @type {Object}
 */
exports <<<
  Shareholder             : Shareholder
  Shareholders            : Shareholders
  Customer                : Customer
  Customers               : Customers
  Declaration             : Declaration
  Declarations            : Declarations
  Dispatch                : Dispatch
  Dispatches              : Dispatches
  CustomerLastDeclaration : CustomerLastDeclaration
  CustomsBroker           : CustomsBroker
