/** @module dashboard.modules.numeration */


Module = require '../module'

Customs = App.model.Customs


/** ---------
 *  MainTable
 *  ---------
 * @class MainTable
 * @extends View
 */
class MainTable extends App.View

  /** @override */
  _tagName: \table

  /** @override */
  _className: "#{gz.Css \table}
             \ #{gz.Css \table-hover}
             \ #{gz.Css \table-responsive}"

  /**
   * Header.
   * @param {Array.<string>}
   * @protected
   */
  _header: -> ''

  /**
   * Add new row.
   * @public
   */
  addRow: (_cells) ->
    _tr = App.dom._new \tr
    for _cell in _cells
      _td = App.dom._new \td
        ..html ''
      _tr.append _td
    _tr

  onRowDoubleClicked: (evt) ~>
    @itemDoubleClicked evt._target._item

  itemDoubleClicked: ->

  /**
   * Customize row thead.
   * TODO(...): Currently only support for 2 rows.
   * @param {HTMLElement}
   * @private
   */
  customizeThead: (_thead) ->
    if _thead.childElementCount is 2
      _th = _thead._first._first
      while _th?
        _th.css.\borderBottom = 'none'
        _th.css.\textAlign = 'center' if _th.colSpan isnt 1
        _th = _th._next

      _th = _thead._last._first
      while _th?
        _th.css.\borderTop = 'none'
        _th = _th._next

  /** @override */
  initialize: (@options) -> super!

  /** @private */ options : null
  /** @private */ _tbody  : null

  /** @override */
  render: ->
    # tHead
    _thead = App.dom._new \thead
      ..html @_header!
    @customizeThead _thead
    @el._append _thead

    # tBody
    @_tbody = App.dom._new \tbody

    getRow = @options._getRow
    for _item in @options._collection
      _tr = App.dom._new \tr
      _tr._item = _item
      _cells = getRow _item
      for _text in _cells
        _td = App.dom._new \td
          ..html if _text? then _text else '&nbsp;'
        _tr._append _td
      _tr.onDblClick @onRowDoubleClicked
      @_tbody._append _tr

    @el._append @_tbody

    super!


NumerationEdit = require './numeration/numeration-edit'

class NumerationTable extends MainTable

  itemDoubleClicked: (dispatch) ->
    numeration = @options._numeration
    numeration.ui.desktop.push-sub NumerationEdit, dto : dispatch

  _header: -> "
    <tr>
      <th>N&ordm; Orden</th>
      <th>Reg</th>
      <th></th>
      <th></th>
      <th colspan='3'>Numeración</th>
      <th colspan='2'>DJ. Anexo 5</th>
    </tr>
    <tr>
      <th>Despacho</th>
      <th>Adu</th>
      <th>Aduana</th>
      <th>Nombre / Razón Social</th>
      <th>N&ordm;</th>
      <th>Fecha</th>
      <th>Aforo</th>
      <th>N&ordm;</th>
      <th>Firmado</th>
    </tr>"

/** ----------
 *  Numeration
 *  ----------
 * Show numeration list for non-officier. It can jump to numeration details.
 * @class UiNumeration
 * @extends Module
 */
class Numeration extends Module

  @@_caption = 'Lista de operaciones numeradas'
  @@_icon    = gz.Css \glyphicon-book

  /**
   * Dispatch type color cell.
   * @param {Dispatch} dispatch
   * @return {string}
   * @private
   */
  numeration-type: (dispatch) ->
    if dispatch\numeration
      "<span class='#{gz.Css \label} #{gz.Css \label}-
        #{if dispatch.'numeration'.'type' is \Verde
            gz.Css \success
          else if dispatch.'numeration'.'type' is \Naranja
            gz.Css \warning
          else if dispatch.'numeration'.'type' is \Rojo
            gz.Css \danger
         }'>
        #{dispatch.'numeration'.'type'}
      </span>"
    else
      "&\#8212;"

  /** @override */
  render: ->
    Customs.pending.dispatches (dispatches) ~>
      nt = new NumerationTable do
        _numeration : @
        _collection : dispatches
        _getRow     : (d) ~> [
          d\order
          d'regime'\code
          d'jurisdiction'\code
          d'customer'\name
          d'numeration'\number
          d'numeration'\date
          @numeration-type d
          if d'declaration'? then d'declaration'\tracking else '-'
          d'numeration'\signed]
      @el._append nt.render!.el
    super!


/** @export */
module.exports = Numeration
