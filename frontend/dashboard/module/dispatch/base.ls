/**
 * @module dashboard.module.dispatch
 */

module.exports = class SectionBaseView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \form

  /**
   * Style.
   * @type {string}
   * @private
   */
  className: gz.Css \ink-form

  /**
   * Get JSON form.
   * @return {Object}
   * @public
   */
  JSONControls: -> @$el.serializeJSON!
