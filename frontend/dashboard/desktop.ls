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
VOID-MODULE = free: ->


/** ----------
 *  Ui Desktop
 *  ----------
 * To manage and show modules. Add interaction with {@code UiSearch}.
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
   */
  changeModule: (Module) !~>
    @module.free!
    @$el._append (@newCustomized Module).render!.el

  /**
   * Add customized properties to constructed module.
   * @param {Object} Module Class.
   * @return {Object} Module Object.
   */
  newCustomized: (Module) ->
    @module = Module.New!
      ..ui.desktop._search = @_search
      @_search.setOnSearch ..onSearch

  /** @override */
  initialize: !-> @module = VOID-MODULE

  /**
   * Current module.
   * @private
   */
  module: VOID-MODULE

  /** @override */
  render: ->
    @$el.html "
      <ol class='#{gz.Css \breadcrumb} #{gz.Css \col-md-8}'>
        <li>
          <a>
            <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-home}'></i>
            &nbsp;
          </a>
        </li>
      </ol>"

    @_search = new Search
    @$el._append @_search.render!.el

    @$el._append "<div class='#{gz.Css \hidden}'></div>"
    super!


/** @export */
module.exports = Desktop
