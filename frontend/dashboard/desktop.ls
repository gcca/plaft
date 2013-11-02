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
   * @private
   */
  className: "#{gz.Css \large-100} #{gz.Css \medium-100} #{gz.Css \small-100}"

  /**
   * Event change desktop.
   * @param {!Object} Module
   * @param {Object=} opts
   * @private
   */
  changeDesktop: !(Module, opts = new Object) ->
    @uiSearch.destroyTooltip!
    module = new Module opts, @
    @el.innerHTML = ''
    @el.appendChild module.el
    @uiSearch.on (gz.Css \search), module.onSearch if module.onSearch?

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

    menuView.bind (gz.Css \change-desktop), @changeDesktop, @
    super!

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @el.style.paddingTop  = '1em'
    @el.style.paddingLeft = '0.3em'

  /** @private */ ui : null
