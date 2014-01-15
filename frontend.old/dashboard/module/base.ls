/**
 * @module dashboard.module
 */

/**
 * Module Base
 * -----------
 * You need inherit from this class to add new modules in {@code dashboad.menu}
 * and {@ dashboard.dekstop}.
 * @class ModuleBaseView
 *
 * @example
 * >>> class ExampleModuleView extends from ModuleBaseView
 * ...   method1: -> ...
 * ...   ...
 * ...   methodN: -> ...
 * ...
 * ...   @menuCaption = 'Text on {@code menu view}'
 * ...   @menuIcon = gz.Css \icon-on-menu-view
 * ...   @menuTitle = 'Title on {@code topbar}'
 */
module.exports = class ModuleBaseView extends gz.GView

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
   * @static
   * @protected
   */
  @menuTitle = ''
