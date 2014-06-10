/** @module dashboard.module */


/** ------
 *  Module
 *  ------
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

  /** @override */
  _className: "#{gz.Css \col-md-12} #{gz.Css \no-select}"

  /**
   * Clean before new render.
   * @protected
   */
  clean: -> @el.html ''

  /**
   * Focus the first field to input.
   * @public
   */
  focus-first-field: ->

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
      _reload     : null
      push-sub    : null
      pop-sub     : null

  /** @protected */ @@_caption = ''
  /** @protected */ @@_icon    = gz.Css \glyphicon-tower


/** @export */
module.exports = Module
