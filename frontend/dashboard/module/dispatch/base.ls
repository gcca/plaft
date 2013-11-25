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
  className: "#{gz.Css \ink-form} #{gz.Css \ink-form-new}"

  /**
   * Get JSON fields form.
   * @return {Object}
   * @public
   */
  JSONFields: -> @$el.serializeJSON!

  /**
   * Initialize view.
   * @param {Object} sectionOptions
   * @private
   */
  initialize: !(sectionOptions) ->
    @kind = sectionOptions.kind if sectionOptions?

  /**
   * Render view.
   * @override
   * @protected
   */
  render: ->
    @$el.append "<input type='hidden' name='kind' value='#{@kind}'>"
    super!
