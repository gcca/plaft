/** @module dashboard.module */


/**
 * Base class for modules.
 * Only for module inheritance.
 *
 * TODO(...): desktop breadcrumb.
 *
 * @class UiModule
 * @extends View
 */
class Module extends App.View

  /** @override */
  _tagName: \div

  /**
   * External desktop attributes.
   * ui: {
   *   desktop: {
   *     search
   *   }
   * }
   * @type {Object}
   */
  ui:
    desktop:
      _search     : null
      breadcrumbs : null

  /** @protected */ @@_caption = ''
  /** @protected */ @@_icon    = gz.Css \glyphicon-tower


/** @export */
module.exports = Module
