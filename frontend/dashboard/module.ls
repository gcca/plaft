/** @module dashboard.module */

builders = require './module/builders'


/** ------
 *  Module
 *  ------
 * Base class for modules.
 * Only for module inheritance.
 *
 * TODO(...): desktop breadcrumbs.
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

  /** @override */
  initialize: !->
    App.dom._write ~>
      @el.Class._add gz.Css \col-md-12
      @el.Class._add gz.Css \no-select

  /**
   * External desktop attributes.
   * ui: {
   *   desktop: {
   *     _search       : Search widget.
   *     _search-focus : Search gets focus after loaded module.
   *     _reload       : Reload current module with new environment-context.
   *     push-sub      : Load a new sub-module.
   *   }
   * }
   * @type {Object}
   */
  ui:
    desktop:
      _search       : null
      _search-focus : null
      breadcrumbs   : null
      _reload       : null
      push-sub      : null

  /** @protected */ @@_caption = ''
  /** @protected */ @@_icon    = gz.Css \glyphicon-tower

  /** @public */ @@builder = builders

/** @export */
module.exports = Module


# vim: ts=2 sw=2 sts=2 et:
