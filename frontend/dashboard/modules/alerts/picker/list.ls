captions = require '../captions'


/** ----
 *  Item
 *  ----
 * @class UiItem
 * @extends View
 */
class Item extends App.View

  /** @override */
  _tagName: \div

  /** @override */
  _className: "#{gz.Css \row}
             \ #{gz.Css \dashboard-picker-item}
             \ #{gz.Css \parent-toggle}"

  /**
   * (Event) Button Add: on click.
   */
  onAdd: !~>
    @el.Class._add (gz.Css \hidden)
    @trigger (gz.Css \add), @_alert

  /**
   * @param {Object} _alert {@code {_code, _text, _tip}}.
   * @override
   */
  initialize: (@_alert) !->
    @_alert._showItem = ~> @el.Class._remove (gz.Css \hidden)

  /** @override */
  render: ->
    @el.html "
      <span class='#{gz.Css \col-md-10}' style='text-align:justify'>
        <span class='#{gz.Css \pull-left}'
            style='font-size:18px;margin-right:.5em'>
          #{@_alert._code}
        </span>

        #{@_alert._text}

        <div style='padding-left:3.5em;
                    padding-top:.7em'>
          <em>#{@_alert._tip}</em>
        </div>
      </span>

      <span class='#{gz.Css \col-md-2} #{gz.Css \col-sm-12}'>
        <button class='#{gz.Css \btn}
                     \ #{gz.Css \btn-default}
                     \ #{gz.Css \pull-right}
                     \ #{gz.Css \toggle}'>
          Agregar
          &nbsp;
          <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-plus}'></i>
        </button>
      </span>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
        <hr style='margin:5px 0 -5px'>
      </div>"
    @el.query \button .onClick @onAdd
    super!


/** ----
 *  List
 *  ----
 * @class UiList
 * @extends View
 */
class List extends App.View

  /** @override */
  _tagName: \div

  /** @override */
  _className: gz.Css \col-md-12

  /** @override */
  render: ->
    App.dom._write ~>
      @el.css
        .._height        = '239px'
        .._overflowY     = 'scroll'
        .._border        = '1px solid #eee'
        .._border-radius = '9px'

    for [_code, _text, _tip] in captions.i.captions
      _item = new Item _code: _code, _text: _text, _tip: _tip, _showItem: null
      _item.on (gz.Css \add), (_alert) ~> @trigger (gz.Css \add), _alert
      @el._append _item.render!.el

    super!

module.exports = List
