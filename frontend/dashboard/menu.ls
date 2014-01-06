/** @module dashboard */

/**
 * Module list.
 * @private
 */
modules = [
  ReceptionView    = require './module/reception'
  DispatchView     = require './module/dispatch'
  DispatchesView   = require './module/dispatches'
  MainView         = require './module/main'
  DeclarationsView = require './module/declarations'
]

/** ---------
 *  Menu View
 *  ---------
 * Vista que controla el menú de módulos. Cada elemento de la lista es un
 * módulo que se carga al hacer clic.
 *
 * @class MenuView
 */
module.exports = class MenuView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \nav

  /**
   * Style.
   * @type {string}
   * @private
   */
  className: gz.Css \ink-navigation

  /**
   * View events.
   * @type {Object}
   * @private
   */
  events:
    /**
     * Click menu link.
     * @param {Object} evt Event object.
     * @private
     */
    'click a': !(evt) ->
      evt.preventDefault!
      @trigger (gz.Css \change-desktop), evt.currentTarget.module
      el = evt.currentTarget.parentElement
      @disableCurrent!
      @prevEl = el
      el.classList.add gz.Css \active

  disableCurrent: !->
    @prevEl.classList.remove gz.Css \active if @prevEl?

  /**
   * Set current item-module.
   * @param {!number} indexItem
   * @public
   */
  currentModule: (indexItem) !->
    a = ($ @tUl .find 'a')[indexItem]
    a.click! if a?

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @tUl = gz.newel \ul
    @tUl.className = "#{gz.Css \menu}
                   \ #{gz.Css \vertical}
                   \ #{gz.Css \grey}
                   \ #{gz.Css \rounded}
                   \ #{gz.Css \shadowed}"
    for module in modules
      tLi = gz.newel \li
      tA  = gz.newel \a

      tA.innerHTML = "<i class='#{module.menuIcon}'></i>&nbsp;&nbsp;
                          #{module.menuCaption}"
      tA.module = module

      if module.menuHelp?
        tA.className = "#{gz.Css \helpme-tooltip}
                      \ #{gz.Css \right}
                      \ #{gz.Css \hm-large} jojo"
        $ tA .append "<span>#{module.menuHelp}</span>"

      tLi.appendChild tA
      @tUl.appendChild tLi

    @el.appendChild @tUl

  /** @private */ prevEl : null
  /** @private */ tUl    : null
