/** @module dashboard.modules.numeration */

Module = require '../module'


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
    @el.html "
      <form>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>Número DAM</label>
          <input type='text' class='#{gz.Css \form-control}' name='number'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>Fecha de Numeración</label>
          <input type='text' class='#{gz.Css \form-control}' name='date'
              placeholder='dd-mm-aaaa'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>Tipo Aforo</label>
          <select class='#{gz.Css \form-control}' name='type'>
            <option>Verde</option>
            <option>Naranja</option>
            <option>Rojo</option>
          </select>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>Valor Mercancía (FOB $)</label>
          <input type='text' class='#{gz.Css \form-control}' name='amount'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>Tipo cambio</label>
          <input type='text' class='#{gz.Css \form-control}' name='exchange'>
        </div>

        <div class='#{gz.Css \col-md-12}'>
          <button class='#{gz.Css \btn}
                       \ #{gz.Css \btn-primary}
                       \ #{gz.Css \pull-right}'>
            Guardar
          </button>
        </div>

      </form>"
    @el._first
      $ .. ._fromJSON dispatch\numeration
      ..onSubmit @onSave

  /** @private */ dispatch: null

  /** @override */
  render: ->
    @ui.desktop._search._focus!
    super!

  @@_caption = 'Numeración'
  @@_icon    = gz.Css \glyphicon-book

module.exports = Numeration
