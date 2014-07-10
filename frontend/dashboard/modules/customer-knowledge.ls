/** @module dashboard.modules.customerknowledge */

Module = require '../module'

Customs = App.model.Customs

class DispatchEdit extends App.View

  render: ->
    super!


/** ---------------
 *  DispatchesTable
 *  ---------------
 * @class UiDispatchesTable
 * @extends UiTable
 */
class DispatchesTable extends Module.builder.TableSubmodule

  _header: -> "
    <tr>
      <th>N&ordm; Orden</th>
      <th>Reg</th>
      <th></th>
      <th></th>
      <th colspan='2'>Numeración</th>
      <th colspan='2'>DJ &minus; Anexo 5</th>
    </tr>
    <tr>
      <th>Despacho</th>
      <th>Adu</th>
      <th>Aduana</th>
      <th>Nombre/Razón Social</th>
      <th>N&ordm;</th>
      <th>Fecha</th>
      <th>N&ordm;</th>
      <th>Firmado</th>
    </tr>"

  fetch-row: (d) ->
    _numeration = d\numeration
    if _numeration?
      _number = _numeration\number
      _date   = _numeration\date
      _date   = '-' if not _date?
    else
      _number = '-'
      _date   = '-'

    _declaration = d\declaration
    if _num?
      _tracking = _declaration\tracking
      _signed   = _declaration\signed
    else
      _tracking = '-'
      _signed   = '-'

    [d\order
    if d'regime'? then d'regime'\code else '-'
    if d'jurisdiction'? then d'jurisdiction'\code else '-'
    d'customer'\name
    _number
    _date
    _tracking
    _signed]


/** -----------------
 *  CustomerKnowledge
 *  -----------------
 * @class UiCustomerKnowledge
 * @extends Module
 */
class CustomerKnowledge extends Module

  /** @override */
  free: ->
    @_table.free!
    super!

  /** @private */ _table: null

  /** @override */
  render: ->
    Customs.pending.dispatches (dispatches) ~>
      @_table = DispatchesTable.New do
        _collection: dispatches
      @inner @_table.render!.el
    super!

  /** @protected */ @@_caption = 'Alertas Conocimiento Cliente - Anexo 1'
  /** @protected */ @@_icon    = gz.Css \glyphicon-tags


/** @export */
module.exports = CustomerKnowledge


# vim: ts=2 sw=2 sts=2 et:
