/**
 * Domain Layer
 *
 * @fileoverview Utilities for hadnling remote services. {@code GModel}
 *     and {@code Collection}for managing entities.
 * @author gcca@gcca.tk (cristHian Gz)
 */

# ------
# Basics
# ------
GModel = gz.GModel

# -----------
# Shareholder
# -----------
/**
 * Shareholder model
 * @class Shareholder
 */
class Shareholder extends GModel
  urlRoot: \shareholder

/**
 * Shareholder collection
 * @class Shareholders
 */
class Shareholders extends gz.GCollection
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
 * Customer collection
 * @class Customers
 */
class Customers extends gz.GCollection
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
class Declarations extends gz.GCollection
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

  fix: ->
    $.post "/api/v1/dispatch/#{@id}/fix"

/**
 * Dispatch collection
 * @class Dispatches
 */
class Dispatches extends gz.GCollection
  urlRoot: \dispatches
  model: Dispatch

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
