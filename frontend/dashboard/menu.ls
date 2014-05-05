/** @module dashboard.menu */


/**
 * TODO(...): Base class for {@code Settings} and {@code Modules}.
 * @author cristHian Gz. (gcca)
 */

/**
 * Main module list.
 * To register new main modules.
 */
MODULES =
  Reception    = require './modules/reception'
  Register     = require './modules/register'
  Dispatches   = require './modules/dispatches'
  Declarations = require './modules/debug/declarations'
#  Numeration   = r equire './modules/numeration'
#  Alerts       = r equire './modules/alerts'
#  Anex6        = r equire './modules/anex6'
#  Anex2        = r equire './modules/anex2'

/**
 * Setting module list.
 * To register new setting modules.
 */
SETTINGS =
  Customs = require './settings/customs'
  User    = require './settings/user'


/**
 * Menu for setting modules.
 * @class UiSettings
 * @extends View
 */
class Settings extends App.View

  /** @override */
  _tagName: \ul

  /** @override */
  _className: "#{gz.Css \nav} #{gz.Css \nav-pills}"

  /**
   * Add new item module.
   * @param {Module} module
   * @param {string} elWidth
   * @return {HTMLElement} <LI> element for module.
   * @private
   */
  addItem: (module, elWidth) ->
    a = App.dom.newel \a
      ..module = module
      ..css._width = '100%'
      ..html "<span class='#{gz.Css \glyphicon} #{module._icon}'></span>"

    li = App.dom.newel \li
      .._append a
      ..Class = gz.Css \text-center
      ..css._width = elWidth

  /** @override */
  render: ->
    elWidth = "#{98 / SETTINGS._length}%"
    for module in SETTINGS
      @$el._append @addItem module, elWidth
    super!


/**
 * Menu for main modules.
 * @class UiModules
 * @extends View
 */
class Modules extends App.View

  /** @override */
  _tagName: \ul

  /** @override */
  _className: "#{gz.Css \nav} #{gz.Css \nav-pills} #{gz.Css \nav-stacked}"

  /**
   * Add new item module.
   * @param {Module} module
   * @return {HTMLElement} <LI> element for module.
   * @private
   */
  addItem: (module) ->
    a = App.dom.newel \a
      ..module = module
      ..html "<i class='#{gz.Css \glyphicon}
                      \ #{module._icon}'></i>
              \&nbsp; #{module._caption}"

    li = App.dom.newel \li
      .._append a

  /** @override */
  render: ->
    for module in MODULES
      @$el._append @addItem module
    super!


/**
 * Menu for setting and main modules.
 * @class UiMenu
 * @extends View
 */
class Menu extends App.View

  /** @override */
  _tagName: \div

  /** @override */
  _className: "#{gz.Css \hidden-print} #{gz.Css \affix-top}"

  /**
   * Events.
   * @type {Object}
   */
  events:
    /**
     * (Event) On click for module.
     * @param {Object} evt
     * @private
     */
    'click a': (evt) ->
      elm = evt.currentTarget
      @$prevItem._parent!.removeClass (gz.Css \active)
      @$prevItem = $ elm
      @$prevItem._parent!.addClass (gz.Css \active)
      @trigger (gz.Css \select), elm.module

  /** @override */
  initialize: !->
    @$el.attr 'role' 'complementary'

    /**
     * Default value to previous item module.
     * @type {Function}
     */
    @$prevItem = _parent: -> removeClass: !->

  /** @private */ $prevItem: null

  /** @override */
  render: ->
    App.dom._write ~> @el.css._font-size = '11px'

    settings = new Settings
    modules  = new Modules

    @$el._append settings.render!.el
    @$el._append "<hr style='margin-bottom:8px;
                             margin-top:8px;'>"
    @$el._append modules.render!.el

    super!


/** @export */
module.exports = Menu
