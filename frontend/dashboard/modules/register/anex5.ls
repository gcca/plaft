/** @module dashboard.modules.register */

CustomerPerson   = require '../../../customer/person'
CustomerBusiness = require '../../../customer/business'


/** ------
 *  Anex 5
 *  ------
 * TODO(...): Remove old module customer. Move modules for customer, business
 *   and person, here.
 * @class UiAnex5
 * @extends View
 */
class Anex5 extends App.View implements App.builtins.Serializable

  /** @override */
  _toJSON: -> @ui-customer._toJSON!

  /**
   * Get customer and declaration dto's.
   * @return Array.<Object, Object>
   * @public
   */
  customer-declaration-dto: -> @ui-customer.customer-declaration-dto!

  /** @override */
  initialize: ({@customer}) !-> super!

  /**
   * Current customer for dispatch.
   * @type {Model}
   * @protected
   */
  customer: null

  /**
   * Customer view for business or person.
   * @type {View}
   * @protected
   */
  ui-customer: null

  /** @override */
  render: ->
    UiCustomer = if @customer.isBusiness then CustomerBusiness
                 else if @customer.isPerson then CustomerPerson
                 else null

    @ui-customer = UiCustomer.New model: @customer
    @inner @ui-customer.render!.el

    super!


/** @export */
module.exports = Anex5


# vim: ts=2 sw=2 sts=2 et:
