/**
 * @module dashboard.module
 */

/**
 * @class ModuleBaseView
 */
module.exports = class ModuleBaseView extends gz.GView

  ```` # CC

  /**
   * @static
   * @protected
   */
  @menuCaption = 'Module'

  /**
   * @static
   * @protected
   */
  @menuIcon = ''

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \div

  /**
   * @param {?Object} _ Unused.
   * @param {!Object} desktop Desktop view.
   * @constructor
   */
  (_, @desktop) -> super ...
