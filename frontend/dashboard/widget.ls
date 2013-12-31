/** @module dashboard.widget */

/**
 * Global search.
 * Module must have {@code onSearch} method to catch event search
 * from this view.
 * @class SearchView
 *
 * @example
 * >>> class ExampleModuleView extends ModuleBaseView
 *       # @param {!string} query Query text.
 *       #
 *       # @param {function(string)} search Set color decorator
 *       #   to {@code searchView}.
 * ...   onSearch: !(queryText, searchState) ~>
 * ...     # {@code queryText} string in search {@code <input>}.
 * ...     ...
 * ...     searchState (gz.Css \success)
 * ...   ...
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
      # @trigger (gz.Css \search), evt.currentTarget.value if evt.keyCode is 13
      if evt.keyCode is 13
        a = @trigger (gz.Css \on-search), evt.currentTarget.value, @elState

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
   * Clear text.
   */
  elClear: !-> @el.value = ''

  /**
   * Show tooltip.
   * @param {string} value Tooltip HTML text.
   * @return {Object} Tooltip object
   */
  showTooltip: !(value = 'Buscar...') ->
    @tmplt.innerHTML = "
      <div class='#{gz.Css \content}' style='font-size:0.92em'
        style='text-align: justify;margin-right:1em'>#value</div>
      <gcca style='display:none'></gcca>"
    @ttip.'options'.'text' = \gcca
    @ttip.'tooltips'.0.'_makeTooltip'!
    setTimeout (~> @ttip.'tooltips'.0.'_removeTooltip'!), 3600

  /**
   * Destroy tooltip.
   */
  destroyTooltip: !->
    if @ttip?
      @off (gz.Css \search)
      @ttip
        ..'options'.'text' = ''
        ..'tooltips'[0].'_removeTooltip'!

  /**
   * Set state color.
   * @param {string} searchState String with state {@code css}:
   *   gz.Css \success, \warning, \error
   * @public
   */
  elState: !(searchState) ~>
    @el.style.cssText += '
      -webkit-transition: all 0s ease-out;
      -moz-transition: all 0s ease-out;
      -o-transition: all 0s ease-out;
      transition: all 0s ease-out;'
    @_controlGroup.classList.add searchState
    setTimeout ~>
      @el.style.cssText += '
        -webkit-transition: all 1.5s ease-out;
        -moz-transition: all 1.5s ease-out;
        -o-transition: all 1.5s ease-out;
        transition: all 1.5s ease-out;'
      @_controlGroup.classList.remove searchState
      setTimeout ~>
        @el.style.cssText += '
        -webkit-transition: all 0s ease-out;
        -moz-transition: all 0s ease-out;
        -o-transition: all 0s ease-out;
        transition: all 0s ease-out;'
      , 1500
    , 3000

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

    @_controlGroup = @$el.parents ".#{gz.Css \control-group}" .get 0
      ..classList.add (gz.Css \validation)

  /** @private */ ttip  : null
  /** @private */ tmplt : null

/**
 * Public widgets.
 * @type {Object}
 */
exports <<<
  GSearchView : SearchView
