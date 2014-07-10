/** @module dashboard.modules.numeration */


Module = require '../module'
NumerationEdit = require './numeration/numeration-edit'

Customs = App.model.Customs


/**
 * Table for numeration module dispatch list.
 * @class UiNumerationTable
 * @extends MainTable
 */
class NumerationTable extends Module.builder.Table

  /** @override */
  itemDoubleClicked: (dispatch) ->
    numeration = @options._numeration
    numeration.ui.desktop.push-sub NumerationEdit, dto : dispatch

  # TODO(...): Brutal Coding. Needs Refactor.
  /** @override */
  fetch-row: (d) ~> [
    d\order
    if d'regime'? then d'regime'\code else '-'
    if d'jurisdiction'? then d'jurisdiction'\code else '-'
    if d'customer'? then d'customer'\name else '-'
    if d'numeration'? then d'numeration'\number else '-'
    if d'numeration'? then d'numeration'\date else '-'
    @numeration-type d
    if d'declaration'? then d'declaration'\tracking else '-'
    if d'numeration'? then d'numeration'\signed else '-']

  /**
   * Dispatch type color cell.
   * @param {Dispatch} dispatch
   * @return {string}
   * @private
   */
  numeration-type: (dispatch) ->
    if dispatch'numeration'?
      "<div class='#{gz.Css \label} #{gz.Css \label}-
        #{if dispatch.'numeration'.'type' is \Verde
            gz.Css \success
          else if dispatch.'numeration'.'type' is \Naranja
            gz.Css \warning
          else if dispatch.'numeration'.'type' is \Rojo
            gz.Css \danger
         }' style='display:block'>
        #{dispatch.'numeration'.'type'}
      </div>"
    else
      "&\#8212;"

  /** @override */
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

  /** @private */ @@_caption = 'Numeración de Operaciones'
  /** @private */ @@_icon    = gz.Css \glyphicon-book

  /** @override */
  render: ->
    Customs.pending.dispatches (dispatches) ~>
      nt = new NumerationTable do
        _numeration : @
        _collection : dispatches
      @el._append nt.render!.el
    super!


/** @export */
module.exports = Numeration


# vim: ts=2 sw=2 sts=2 et:
