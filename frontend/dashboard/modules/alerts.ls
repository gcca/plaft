Module = require '../module'

Picker = require './alerts/picker'


/** ------
 *  Alerts
 *  ------
 * @class UiAlerts
 * @extends Module
 */
class Alerts extends Module

  /**
   * (Event) Valid form data from declaration.
   * @param {Object} evt
   */
  onValidData: (evt) !~>
    evt.prevent!
    console.log \lalala

  /**
   * Show form from order number.
   * @param {number} order
   */
  fromOrder: (order) !->
    dispatch = new App.model.Dispatch \order : order
    dispatch.fetch do
      _success: !->
        @el.html "
          <form role='form'>
            <div class='#{gz.Css \form-group}'>
              <label>1. Número Uno</label>
              <input type='text' class='#{gz.Css \form-control}'>
            </div>
          </form>
        "
        console.log &

  /** @override */
  render: ->
    @el.html @templateHeader!
    @el.query \form .onSubmit @onValidData
    @el._append (new Picker).render!.el
    ## dispatch = new App.model.Dispatch \id : 5348024557502464
    ## dispatch.fetch do
    ##   _success: !->
    ##     console.log &

    super!

  @@_caption = 'Alertas'
  @@_icon    = gz.Css \glyphicon-check

  /**
   * Basic template for header anex 1.
   */
  templateHeader: -> "
    <div class='#{gz.Css \col-md-12}'>
      Verifcar:<br>
      <a>http://www.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias</a><br>
      <a>http://www.reniec.gob.pe/portal/intro.htm</a><br><br>
    </div>

    <form class='#{gz.Css \row}'>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>N&ordm; Orden Despacho</label>
        <input type='text' class='#{gz.Css \form-control}'>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Fecha</label>
        <input type='text' class='#{gz.Css \form-control}' name=''>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Tipo de Operación (SBS)</label>
        <input type='text' class='#{gz.Css \form-control}' name=''>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Aduana Despacho</label>
        <input type='text' class='#{gz.Css \form-control}' name=''>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Razón Social/Nombre</label>
        <input type='text' class='#{gz.Css \form-control}' name=''>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>RUC/DNI</label>
        <input type='text' class='#{gz.Css \form-control}' name=''>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Tipo Empresa</label>
        <input type='text' class='#{gz.Css \form-control}' name=''>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Tipo Contribuyente</label>
        <input type='text' class='#{gz.Css \form-control}' name=''>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Identificación del Tercero</label>
        <input type='text' class='#{gz.Css \form-control}' name=''>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Anexo 5</label>
        <input type='text' class='#{gz.Css \form-control}' name=''>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Doc. Despacho</label>
        <input type='text' class='#{gz.Css \form-control}' name=''>
      </div>

      <div class='#{gz.Css \col-md-12}'>
        <button class='#{gz.Css \btn}
                     \ #{gz.Css \btn-primary}
                     \ #{gz.Css \pull-right}'>
          Verificar
        </button>
      </div>

    </form>"

module.exports = Alerts
