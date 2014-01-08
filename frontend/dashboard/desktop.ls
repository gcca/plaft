/** @module dashboard */


class BreadcrumbsView extends gz.GView

  ## TODO (...): Better mmeory management.
  ## Use destroy! from view (Tip: Stack modules itno array).
  onReturn: (module, evt) -->
    tLi = evt.currentTarget.parentElement
    if tLi.className isnt \active
      module.el.style.\display = 'initial'
      while (tDiv = module.el.nextElementSibling)? then $ tDiv .remove!
      tLi.className = gz.Css \active
      while (tLi = tLi.nextElementSibling)? then $ tLi .remove!

  newLi: (module) ->
    tLi = gz.newel \li
    tA  = gz.newel \a
    # tA
    tA.onclick = @onReturn module
    tA.innerHTML = module@@menuCaption
    # tLi
    tLi.className = gz.Css \active
    tLi.appendChild tA
    tLi

  elRoot: !(module) ->
    tLi = gz.newel \li
    tA  = gz.newel \a
    tA.onclick = (evt) -> evt.preventDefault!
    tA.innerHTML = "<i class='#{gz.Css \icon-home}'></i>"
    tLi.appendChild tA
    @$el.html ''
    @$el.append tLi
    @elAdd module

  elAdd: (module) ->
    tLi = @newLi module
    @$el.append tLi
    while (tLi = tLi.previousElementSibling)? then tLi.className = ''


/** ------------
 *  Desktop View
 *  ------------
 * "Desktop" is main utility view for modules. When a module is loaded, it's
 * rendered over desktop view.
 * See {@code menu} module for more information about integration.
 *
 * Constructor requires menu view and search view.
 *
 * TODO(...): Integrate ModuleBaseView with 'DesktopPage'.
 *
 * @class DesktopView
 *
 * @example
 * >>> desktop = new DesktopView menu, search
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
      @el.innerHTML = ''

    @module = new Module opts, @
    @el.appendChild @module.el
    @uiBreadcrumbs.elRoot @module

    @uiSearch.off (gz.Css \on-search)
    @uiSearch.on (gz.Css \on-search), @module.onSearch if @module.onSearch?
    @uiTitle.setValue Module.menuTitle
    @trigger (gz.Css \on-appended)
    @module

  /**
   * Add new sub-desktop to frontend-desktop.
   * @param {Object} module
   * @public
   */
  pushPage: !(module) ->
    @el.lastElementChild.style.display = 'none'
    @el.appendChild module.el
    @uiBreadcrumbs.elAdd module

  popPage: !(module) ->
    $ @el.lastElementChild .remove!
    @el.lastElementChild.style.display = 'initial'

  /**
   * @param {Object} menuView
   * @param {Object} searchView
   * @param {Object} elNav
   * @constructor
   */
  !(menuView, searchView, elNav) ->

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

    # Breadcrumbs
    @uiBreadcrumbs = new BreadcrumbsView \el : elNav

    super!

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @el.style.\padding = '1em .4em 5em'

  /** @private */ uiSearch : null
  /** @private */ uiTitle  : null
