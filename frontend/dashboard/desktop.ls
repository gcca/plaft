Search = require './desktop/search'

/**
 * Nothing function.
 * To no write validation for null module.
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
   * @return {Object} Module object.
   */
  newCustomized: (Module) ->
    @module = Module.New!
      ..el.Class = gz.Css \col-md-12
      @_search.setOnSearch ..onSearch

  /** @override */
  initialize: !-> @module = VOID-MODULE

  /** @override */
  render: ->
    @$el.html "
      <ol class='#{gz.Css \breadcrumb} #{gz.Css \col-md-8}'>
        <li>
          <a href='#'>Despachos</a>
        </li>
        <li>
          <a href='#'>Edición</a>
        </li>
        <li class='active'>
          Alertas
        </li>
      </ol>"

    @_search = new Search
    @$el._append @_search.render!.el

    @$el._append "<div class='#{gz.Css \hidden}'></div>"
    super!

  # Attributes

  /**
   * Current module.
   * @private
   */
  module: VOID-MODULE

module.exports = Desktop
