Module = require '../module'

Picker = require './alerts/picker'


/** ------
 *  Alerts
 *  ------
 * Warning: Be careful for global alert list for UiPanel and UiList.
 * @class UiAlerts
 * @extends Module
 */
class Alerts extends Module

  /**
   * (Event) On save dispatch alert signals.
   * @private
   */
  onSave: ~>
    @dispatch._save \alerts : @picker._toJSON!, do
      _success: -> alert 'Guardado'
      _error: -> alert 'Error: ddf09c04-a3f8-11e3-9499-88252caeb7e8'

  /**
   * (Event) On search by disptach order-number.
   * @param {string} _query
   * @private
   */
  onSearch: (_query) ~>
    @dispatch = new App.model.Dispatch \order : _query
    @dispatch.fetch do
      _success: (_, dispatch) ~>
        @showForm dispatch
      _error: ->
        alert 'Número de orden no hallado: ' + _query

  /**
   * Show form with disptach data (declartion, customer and dispatch)
   * and alert picker.
   * @param {Object} dispatch DTO disptach data.
   * @private
   */
  showForm: (dispatch) ->
    @el.html @templateDispatch dispatch

    @picker = new Picker dispatch\alerts
    @el._append @picker.render!.el

    $div = $ "<div class='#{gz.Css \col-md-12}'></div>"

    $check = $ "<label class='#{gz.Css \checkboox}'>
                  ¿Verificado?
                  &nbsp;&nbsp;
                  <input type='checkbox'>
                </label>"

    $button = $ "<button class='#{gz.Css \btn}
                              \ #{gz.Css \btn-default}
                              \ #{gz.Css \pull-right}'
                     style='margin-top:1em'>
                   Guardar
                 </button>"

    $button.0.onClick @onSave

    $div._append $check
    $div._append $button
    @$el._append $div

  /** @private */ picker   : null
  /** @private */ dispatch : null

  /** @override */
  render: ->
    @ui.desktop._search._focus!
    super!

  @@_caption = 'Alertas'
  @@_icon    = gz.Css \glyphicon-check

  /**
   * Template for dispatch data.
   * @param {Object} dispatch DTO dispatch data.
   * @return {string}
   * @private
   */
  templateDispatch: (dispatch) -> "
    <div class='#{gz.Css \col-md-12}'>
      Verifcar:<br>
      <a href='http://www.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias'
          target='_blank'>
        http://www.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias
      </a><br>
      <a href='http://www.reniec.gob.pe/portal/intro.htm'
          target='_blank'>
        http://www.reniec.gob.pe/portal/intro.htm
      </a><br><br>
    </div>

    <form class='#{gz.Css \row}'>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>N&ordm; Orden Despacho</label>
        <div>#{dispatch\order}</div>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Fecha</label>
        <div>#{dispatch\date}</div>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Tipo de Operación (SBS)</label>
        <div>
          #{dispatch.'type'.'name'}
          &nbsp;
          (#{dispatch.'type'.'code'})
        </div>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Aduana Despacho</label>
        <div>
          #{dispatch.'jurisdiction'.'name'}
          &nbsp;
          (#{dispatch.'jurisdiction'.'code'})
        </div>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Razón Social/Nombre</label>
        <div>#{dispatch.'customer'.\name}</div>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>RUC/DNI</label>
        <div>#{dispatch.'customer'.'document'.\number}</div>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Tipo Empresa</label>
        <div>#{dispatch.'customer'.'document'.\type}</div>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Tipo Contribuyente</label>
        <div>#{dispatch.'customer'.\category}</div>
      </div>

      <div class='#{gz.Css \col-md-12}'>
        <label>Identificación del Tercero</label>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Anexo 5</label>
        <div>
          #{if dispatch.'declaration'
            then dispatch.'declaration'.'third'
            else 'No existe declaración jurada'}
        </div>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Doc. Despacho</label>
        <div>#{dispatch.'third'}</div>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
        <label class='#{gz.Css \checkbox}'>
          ¿Verificado?
          <input type='checkbox'>
        </label>
      </div>

    </form>"

module.exports = Alerts
