/** @module dashboard.modules.alert */

List  = require './picker/list'
Panel = require './picker/panel'


/** ------
 *  Picker
 *  ------
 * @class UiPicker
 * @extends View
 */
class Picker extends App.View

  /** @override */
  _tagName: \div

  /** @override */
  _className: gz.Css \row

  /** @override */
  _toJSON: -> @_panel._toJSON!

  /** @override */
  initialize: (@_alerts = App._void._Array) ->

  /** @private */ _alerts : null
  /** @private */ _panel  : null
  /** @private */ _list   : null

  /** @override */
  render: ->
    @$el._append "<h4><em>Alertas</em></h4>"

    @_panel = new Panel @_alerts
    @_list  = new List  @_alerts

    @_list.on (gz.Css \add), @_panel.addControl

    @$el._append @_panel.render!.el
    @$el._append "<div class='#{gz.Css \col-md-12}'>&nbsp;</div>"
    @$el._append @_list.render!.el

    super!

module.exports = Picker
