/**
 * @module dashboard.module
 */

form   = require '../../form'
widget = require '../../widget'
ModuleBaseView = require './base'

/**
 * @class DispatchView
 */
module.exports = class DispatchView extends ModuleBaseView

  /**
   * On search from searchView event.
   * @param {!string} query Query text: orderNumber.
   * @private
   */
  onSearch: !(query) ~>
    if query.match /\d+-\d+/
      console.log query
    else
      (new widget.GAutoAlert (gz.Css \error),
                             "<b>ERROR:</b> Número de orden incorrecto:
                             \ <em>#query</em>").show!

  /**
   * Initialize view.
   * @private
   */
  initialize: !-> @render!

  /**
   * Render view.
   * @return {Object}
   */
  render: ->
    @desktop.uiSearch.showTooltip '<b>Buscar por <em>número de orden</em></b>'
    @desktop.uiSearch.elFocus!
    super!

  /** @private */ @menuCaption = 'Despacho'
  /** @private */ @menuIcon    = gz.Css \icon-file

  /**
   * Template (Dispatch).
   * @param {!Object} dispatch
   * @return {string}
   * @private
   */
  template: (dispatch) -> "
  <div></div>"
