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
  createDeclaration : (declarationJSON, options) ->
      declarationJSON <<< \customer : @toJSON!
      declaration = new Declaration declarationJSON, parent : @
      declaration.save new Object, options

/**
 * Customer collection
 * @class Customers
 */
class Customers extends gz.GCollection
  url: \customer
  model : Customer

/**
 * Last declaration of {@code Customer} model
 * @class CustomerLastDeclaration
 */
class CustomerLastDeclaration extends GModel
  urlRoot: \customer/lastdeclaration

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
  url: \declaration
  model : Declaration

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
 * Dispatch collection
 * @class Dispatches
 */
class Dispatches extends gz.GCollection
  urlRoot: \dispatch
  model : Dispatch

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
