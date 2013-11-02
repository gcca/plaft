/**
 * @module dashboard.widget
 */

/**
 * @class
 */
class SearchView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \input

  /**
   * View events.
   * @type {?Object}
   * @private
   */
  events:
    /**
     * On key up.
     * @param {Object} evt Event object.
     * @private
     */
    'keyup': !(evt) ->
      @trigger (gz.Css \search), evt.currentTarget.value \
        if evt.keyCode is 13

  /**
   * Set input placeholder.
   * @param {!string} value Placeholder text.
   */
  elPlaceholder: !(value) -> @el.placeholder = value

  /**
   * Focus input search.
   */
  elFocus: !-> @el.focus!

  /**
   * Show tooltip.
   * @param {string} value Tooltip HTML text.
   * @return {Object} Tooltip object
   */
  showTooltip: !(value = 'Buscar...') ->
    @tmplt.innerHTML = "
      <div class='#{gz.Css \content}'
        style='text-align: justify;margin-right:1em'>#value</div>
      <gcca style='display:none'></gcca>"
    @ttip.'options'.'text' = \gcca
    @ttip.'tooltips'[0].'_makeTooltip'!

  /**
   * Destroy tooltip.
   */
  destroyTooltip: !->
    if @ttip?
      @ttip
        ..'options'.'text' = ''
        ..'tooltips'[0].'_removeTooltip'!

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @tmplt = gz.newel \div
    @tmplt.className = gz.Css \ink-tooltip
    @ttip = new gz.Ink.UI.Tooltip @el, do
      \text : ''
      \where : gz.Css \down
      \spacing : 12
      \template : @tmplt
      \templatefield : \gcca

  /** @private */ ttip  : null
  /** @private */ tmplt : null

/**
 * Public widgets.
 * @type {Object}
 */
exports <<<
  GSearchView : SearchView
