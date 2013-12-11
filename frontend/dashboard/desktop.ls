/**
 * @module dashboard
 */

module.exports = class DesktopView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \div

  /**
   * Style.
   * @type {Object}
   * @private
   */
  className: "#{gz.Css \large-100} #{gz.Css \medium-100} #{gz.Css \small-100}"

  /**
   * Event change desktop.
   * @param {!Object} Module
   * @param {Object=} opts
   * @private
   */
  changeDesktop: (Module, opts = new Object) ->
    @uiSearch.destroyTooltip!
    if @module?
      @module.remove!
      delete @module
    @module = new Module opts, @
    ## style
    @module.el.style.marginTop = '1em'
    ## @el.innerHTML = ''
    @el.appendChild @module.el
    @uiSearch.on (gz.Css \search), @module.onSearch if @module.onSearch?
    @uiTitle.setValue Module.menuTitle
    @trigger (gz.Css \on-appended)
    @module

  /**
   * @param {Object} menuView GView.
   * @constructor
   */
  !(menuView, searchView) ->
    /**
     * Search view.
     * @type {Object}
     * @protected
     */
    @uiSearch = searchView
    /**
     * Topbar title.
     * @type {Object}
     * @protected
     */
    @uiTitle =
      /**
       * Set title text.
       * @param {string} titleText
       */
      setValue: !(titleText = '...') -> @$elTitle.html titleText
      /**
       * DOM element title.
       * @type {Object}
       * @private
       */
      $elTitle: $ "##{gz.Css \topbar-title}"
    # end @uiTitle
    menuView.bind (gz.Css \change-desktop), @changeDesktop, @
    super!

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @el.style
      ..paddingLeft = '0.3em'
      ..paddingBottom = '5em'

  /** @private */ ui : null
