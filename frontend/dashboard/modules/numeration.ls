/** @module dashboard.modules.numeration */

Module = require '../module'

FieldType = App.builtins.Types.Field


/** ----------
 *  Numeration
 *  ----------
 * Numeration module for register DAM numeration and extra data.
 * TODO(...): This module should become a operator form for data analysis.
 * @class UiNumeration
 * @extends Module
 */
class Numeration extends Module

  /** @override */
  _tagName: \form

  /**
   * (Event) On save dispatch numeration data.
   * @param {Object} evt
   * @private
   */
  onSave: (evt) ~>
    evt.prevent!
    console.log \dfdmfmk
    return
    $form = $ evt._target
    @dispatch.store \numeration : $form._toJSON!, do
      _success: -> alert 'Guardado'
      _error: -> alert 'ERROR: 010dbe9c-a584-11e3-8bb0-88252caeb7e8'

  /**
   * (Event) On search by disptach order-number.
   * @param {string} _query
   * @private
   */
  onSearch: (_query) ~>
    @el.html ''
    @dispatch = new App.model.Dispatch \order : _query
    @dispatch.fetch do
      _success: (_, dispatch) ~>
        @showForm dispatch
      _error: -> alert 'Número de orden no hallado: ' + _query

  /**
   * Show form for dispatch numeration.
   * @param {Object} dispatch DTO disptach data.
   * @private
   */
  showForm: (dispatch) ->
    fbuilder = App.shared.shortcuts.html._form.Builder.New @el
    fbuilder._push "
      <div class='#{gz.Css \col-md-12}'>
        <div class='#{gz.Css \col-md-2}'>
          <label>Cliente:</label>
        </div>
        <div class='#{gz.Css \col-md-10}'>
          <span>#{dispatch.'customer'.\name}</span>
        </div>
      </div>
      <div class='#{gz.Css \col-md-12}'>
        <div class='#{gz.Css \col-md-2}'>
          <label>Persona:</label>
        </div>
        <div class='#{gz.Css \col-md-10}'>
          <span>#{if dispatch.'customer'.'document'.\type is \RUC
                  then 'Jurídica' else 'Natural'}</span>
        </div>
      </div>
      <div class='#{gz.Css \col-md-12}'>
        &nbsp;
      </div>"
    for _field in FIELDS-HEADER then fbuilder.field _field
    fbuilder._save!
    fbuilder.render!
    fbuilder.tooltips!
    fbuilder.free!

    @$el._fromJSON dispatch\numeration
    @el.onSubmit @onSave

  /** @private */ dispatch: null

  /** @override */
  render: ->
    @ui.desktop._search._focus!
    super!

  @@_caption = 'Numeración'
  @@_icon    = gz.Css \glyphicon-book


/** @export */
module.exports = Numeration


# Fields
FIELDS-HEADER =
  * _name  : 'number'
    _label : 'N&ordm; DAM'
    _tip   : 'A Casillero 2'
#    'XXX-AAAA-RR-NNNNNN'

  * _name  : 'date'
    _label : 'Fecha numeración (dd-mm-aaaa)'
    _tip   : 'A Casillero 2'
#    'dd/mm/aaaa'

  * _name    : 'type'
    _label   : 'Tipo Aforo'
    _tip     : 'A Casillero 2'
    _type    : FieldType.kComboBox
    _options :
      'Verde'
      'Naranja'
      'Rojo'

#  * ''
#    'Identificación Imp/Exp'
#    'A Casillero 1.1'
#    'Destinación=10, Operación=001\n
#     Destinación=41, Operación=003'

#  * ''
#    'Dirección Imp/Exp'
#    'A Casillero 1.3'
#    'Destinación=10, Operación=001'

  ## * ''
  ##   'Moneda Transacción'
  ##   ''
  ##   'D=Dólar Automático'

  * _name  : 'amount'
    _label : 'Monto operación (FOB)'
    _tip   : 'A Casillero 6.1'
#    'xx\'xxx,xxx.xxxx'

  * _name  : 'exchange'
    _label : 'Tipo cambio Venta'
    _tip   : 'Fecha numeración _ 2'
#    'T/C publicado SBS xxx.xxxx'

#  * ''
#    'Total Series'
#    'A Casillero 7.1'
#    'Crea archivo detalle'

  * _name  : 'drawback'
    _label : 'Drawback Acogimiento'
    _tip   : 'A Casillero 7.28'
#    'Código=13, Operación=003'

FIELDS-DETAILS =
  * ''
    'Subpartida Nacional (1)'
    'A Casillero 7.19'
    'xxxxxxxxxx'

  * ''
    'Subpartida Nacional (2)'
    'A1 Casillero 7.19'
    'xxxxxxxxxx'

  * ''
    'Subpartida Nacional (3)'
    'A1 Casillero 7.19'
    'xxxxxxxxxx'

  * ''
    'Subpartida Nacional (n)'
    'A1 Casillero 7.19'
    'xxxxxxxxxx'

  * ''
    'D. Leg. N&ordm; 1126'
    ''
    'Control Insumos Químicos y Productos Fiscalizados - CIQPF'

  * ''
    'D. Leg. N&ordm; 1103'
    ''
    'IQ Minería Ilegal'
