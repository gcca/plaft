##captions = requirsse './captions'
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
  render: ->
    @$el._append "<h4><em>Alertas</em></h4>"

    _panel = new Panel
    _list  = new List

    _list.on (gz.Css \add), _panel.addControl

    @el._append _panel.render!.el
    @el._append _list.render!.el

    $button = $ "<button class='#{gz.Css \btn}
                              \ #{gz.Css \btn-default}
                              \ #{gz.Css \pull-right}' style='margin-top:1em'>
                   Guardar
                 </button>"
    $button.on \click ->
      console.log \rwee

    @$el._append $button

    super!

module.exports = Picker
