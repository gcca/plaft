/**
 * @module dashboard.desktop
 *
 *  - - - - - - - - - -
 * |_ _ _ _ _ _ _ _ _ _|
 * |      |            |
 * | Menu |  Desktop   |
 * |      |            |
 * |      |            |
 * |______|____________|
 *
 * This module manages the desktop zone.
 * Connect events between views: menu, desktop, search, breadcrumbs.
 *
 * TODO(...): Breadcrumb for module on desktop.
 */


Search = require './desktop/search'

/**
 * Nothing function.
 * To doesn't write validation for null module.
 * @private
 */
VOID-MODULE =
  free : ->
  el   :
    _next : null
    css   : _display : 'none'

/** ----------
 *  Ui Desktop
 *  ----------
 * To manage and show modules. Add interaction with {@code UiSearch}.
 * Sub-modules working module stacking collection.
 * TODO(...): Pop methods maybe don't need implementation. They are write only
 *   for naming convention.
 * @class UiDesktop
 * @extends View
 */
class Desktop extends App.View

  /** @override */
  _tagName: \div

  /** @override */
  _className: gz.Css \row

  /**
   * Set current module. Can be used like an event.
   * @param {Object} Module Base module class.
   * @protected
   */
  changeModule: (@Module) !~>
    @clean-current-module!
    @$el._append (@newCustomized Module).render!.el
    @module.focus-first-field!
    @_search._focus! if @_search-get-focus

  /**
   * Clean current module and sub-modules.
   * @private
   * @see @changeModule
   */
  clean-current-module: ->
    _sub = @module.el._next
    while _sub?
      _tmp = _sub
      _sub = _sub._next
      $ _tmp ._remove!

    _sub = @breadcrumb._first._next
    while _sub?
      _tmp = _sub
      _sub = _sub._next
      $ _tmp ._remove!

    @module.el.css._display = ''
    @module.free!

  /**
   * Reload current module.
   * @protected
   */
  _reload: -> @changeModule @Module

  /**
   * Add customized properties to constructed module.
   * @param {Object} Module Class.
   * @return {Object} Module Object.
   */
  newCustomized: (Module) ->
    @module = Module.New!
      ..ui.desktop = @
      @_search.setOnSearch ..onSearch
      ..clean!
      @root-breadcrumb ..
        ## .._search       = @_search
        ## .._search-focus = @_search-focus
        ## .._reload       = @_reload
        ## ..push-sub      = @push-sub
        ## ..pop-sub       = @pop-sub

  /**
   * Push sub-module. Show sub-module on desktop.
   * @param {Module::} _Module
   * @param {Object} _options
   * @public
   */
  push-sub: (_Module, _options = null) ->
    ## $ @el._last ._hide!
    @breadcrumb-current._module.$el._hide!

    _module = _Module.New _options
      ..el.css._display = '' # Hack: Must be in sub-module constructor
    @el._append _module.render!.el

    @push-breadcrumb _module

  /**
   * Pop sub-module. Hide sub-module on desktop.
   * @public
   */
  pop-sub: ->

  /**
   * Push breadcrumb title-link.
   * @param {Module} _module
   * @private
   */
  push-breadcrumb: (_module) ->
    # Clean
    _li = @breadcrumb-current._next
    while _li?
      _li._module.free!
      _aux = _li
      _li = _li._next
      $ _aux ._remove!

    # Push
    _li = App.dom._new \li
      ..Class = gz.Css \active
      ..html "#{_module._constructor._caption}"
      .._module = _module
    @breadcrumb._append _li

    @breadcrumb-current
      ..Class = ''
      ..html "<a>#{..innerHTML}</a>"
      .._first.onClick @breadcrumb-change
    @breadcrumb-current = _li

  /**
   * (Event) Change between modules referenced by breadcrumb item.
   * @param {Object} evt
   * @private
   */
  breadcrumb-change: (evt) ~>
    @breadcrumb-current
      ..Class = ''
      ..html "<a>#{..innerHTML}</a>"
      .._first.onClick @breadcrumb-change
      .._module.$el._hide!
    @breadcrumb-current = evt._target._parent
      ..Class = gz.Css \active
      ..html .._first.innerHTML
      .._module.$el._show!

  /**
   * Pop breadcrumb title-link.
   * @private
   */
  pop-breadcrumb: ->

  /**
   * Set root breadcrumb title-link.
   * @param {Module} _module
   * @private
   */
  root-breadcrumb: (_module) ->
    @breadcrumb-current = @breadcrumb._first
      ..Class = gz.Css \active
      ..html "<i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-home}'></i>
              &nbsp;"
      .._module = _module

  /**
   * Search gets focos after load module.
   * @public
   */
  _search-focus: -> @_search-get-focus = true

  /** @override */
  initialize: !->
    /**
     * Pseudo-module with {@code free} void function. To match with
     * module interface and avoid {@code if} structure when change
     * current module on desktop.
     * @type {Object}
     */
    @module = VOID-MODULE

    /**
     * Used when need to reload the current module.
     * @see _reload
     * @type {Object?}
     */
    @Module = null

  /**
   * Current module.
   * @type {Object}
   * @private
   */
  module: VOID-MODULE

  /**
   * Current Module.
   * @type {Object?}
   * @private
   */
  Module: null

  /**
   * Breadcrumb.
   * @type {HTMLElement}
   * @private
   */
  breadcrumb: null

  /**
   * Breadcrumb currently active.
   * @type {HTMLElement}
   * @private
   */
  breadcrumb-current: null

  /** @private */ _search-get-focus: null

  /** @override */
  render: ->
    @$el.html "
      <ol class='#{gz.Css \breadcrumb} #{gz.Css \col-md-8}'>
        <li class='#{gz.Css \active}'>
          <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-home}'></i>
          &nbsp;
        </li>
      </ol>"

    @breadcrumb = @el._first

    @_search = new Search
    @$el._append @_search.render!.el

    @$el._append "<div class='#{gz.Css \hidden}'></div>"
    super!


/** @export */
module.exports = Desktop
