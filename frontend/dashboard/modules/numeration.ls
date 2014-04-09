/** @module dashboard.modules.numeration */

Module = require '../module'

new-field = ->

new-group = (_name, _label, _placeholder)->
  "
  <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
    <label>
      #_label
    </label>
    <input type='text' name='#_name' placeholder='#_placeholder'
        class='#{gz.Css \form-control}'>
  </div>
  "


/**
 * @class UiNumeration
 * @extends Module
 */
class Numeration extends Module

  /**
   * (Event) On save dispatch numeration data.
   * @param {Object} evt
   * @private
   */
  onSave: (evt) ~>
    evt.prevent!
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
    hstack = new Array

    for [_name, _label, _placeholder] in FIELDS-HEADER
      hstack._push new-group _name, _label, _placeholder

    hstack._push "
      <div class='#{gz.Css \col-md-12}'>
        <h3>Detalle</h3>
      </div>"

    for [_name, _label, _placeholder] in FIELDS-DETAILS
      hstack._push new-group _name, _label, _placeholder

    @el.html hstack._join ''

    ##     <div class='#{gz.Css \col-md-12}'>
    ##       <button class='#{gz.Css \btn}
    ##                    \ #{gz.Css \btn-primary}
    ##                    \ #{gz.Css \pull-right}'>
    ##         Guardar
    ##       </button>
    ##     </div>

    ##   </form>"
    ## @el._first
    ##   $ .. ._fromJSON dispatch\numeration
    ##   ..onSubmit @onSave

  /** @private */ dispatch: null

  /** @override */
  render: ->
    @ui.desktop._search._focus!
    super!

  @@_caption = 'Numeración'
  @@_icon    = gz.Css \glyphicon-book

module.exports = Numeration


FIELDS-HEADER =
  * 'number'
    'N&ordm; DAM'
    'A _ 2'
    'XXX-AAAA-RR-NNNNNN'

  * 'date'
    'Fecha numeración (dd-mm-aaaa)'
    'A _ 2'
    'dd/mm/aaaa'

  * 'type'
    'Tipo Aforo'
    'A _ 2'
    '1=verde, 2=naranja, 3=Rojo'

  * ''
    'Identificación Imp/Exp'
    'A _ 1.1'
    'Destinación=10, Operación=001\n
     Destinación=41, Operación=003'

  * ''
    'Dirección Imp/Exp'
    'A _ 1.3'
    'Destinación=10, Operación=001'

  ## * ''
  ##   'Moneda Transacción'
  ##   ''
  ##   'D=Dólar Automático'

  * 'amount'
    'Monto operación (FOB)'
    'A _ 6.1'
    'xx\'xxx,xxx.xxxx'

  * 'exchange'
    'Tipo cambio Venta'
    'Fecha numeración _ 2'
    'T/C publicado SBS xxx.xxxx'

  * ''
    'Total Series'
    'A _ 7.1'
    'Crea archivo detalle'

  * ''
    'Drawback Acogimiento'
    'A _ 7.28'
    'Código=13, Operación=003'

FIELDS-DETAILS =
  * ''
    'Subpartida Nacional (1)'
    'A _ 7.19'
    'xxxxxxxxxx'

  * ''
    'Subpartida Nacional (2)'
    'A1 _ 7.19'
    'xxxxxxxxxx'

  * ''
    'Subpartida Nacional (3)'
    'A1 _ 7.19'
    'xxxxxxxxxx'

  * ''
    'Subpartida Nacional (n)'
    'A1 _ 7.19'
    'xxxxxxxxxx'

  * ''
    'D. Leg. N&ordm; 1126'
    ''
    'Control Insumos Químicos y Productos Fiscalizados - CIQPF'

  * ''
    'D. Leg. N&ordm; 1103'
    ''
    'IQ Minería Ilegal'
