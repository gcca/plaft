/**
 * @module dashboard.module
 */

form  = require '../../form'
model = require '../../model'
widget = require '../../widget'

ModuleBaseView = require './base'

/** @private */ DeclarationModel             = model.Declaration
/** @private */ CustomerLastDeclarationModel = model.CustomerLastDeclaration
/** @private */ DispatchModel                = model.Dispatch

/**
 * @class DeclarationView
 * @extends ModuleBaseView
 */
module.exports = class DeclarationView extends ModuleBaseView

  /**
   * View events.
   * @type {Object}
   * @private
   */
  events:
    /**
     * On click button for commit dispatch form.
     * @param {Object} evt Event object.
     * @private
     */
    'click button': !(evt) ->
      dispatchJSON = $ \form .serializeJSON!
      dispatchJSON[\declaration] = @declaration
      dispatch = new DispatchModel dispatchJSON
      dispatch.save new Object, do
        \success : -> alert 'OK'
        \error   : -> alert 'ERROR: new dispatch'

  /**
   * On search from searchView event.
   * @param {!string} query Query text: declaration trackingId or documentNumber.
   * @private
   */
  onSearch: !(query) ~>
    type = null
    if query.length is 8
      type = 'trackingId'
      Model = DeclarationModel
    else if query.length is 11
      type = 'documentNumber'
      Model = CustomerLastDeclarationModel
    else
      (new widget.GAutoAlert (gz.Css \error),
                            '<b>ERROR</b>: Debe ingresar un código
                            \ de declaración jurada o un número RUC.').show!
      return
    # (-o-) First find declaration
    @declaration = new Model "#type" : query
    # (-o-) First find customer
    @declaration.fetch do
      \success : (declaration) ~> @renderInfo declaration.attributes
      \error   : ~>
        console.log '500:'
        console.log arguments

  /**
   * Initialize view.
   * @private
   */
  initialize: !-> @render!

  /**
   * Render customer info form.
   * @param {!Object} declaration
   * @private
   */
  renderInfo: !(declaration) ->
    @$el.html @template declaration
    @$el.find "##{gz.Css \id-alert}" .on \change !(evt) ~>
      ta = @$el.find '[name=clerkAlert]'
      if evt.target.checked
        ta .css \minHeight '2.5em' .show! .animate \height : '10em', 700, \ease
      else
        ta .animate \height : '0', 300, \linear, -> ta .css \height '0' .hide!

  /**
   * Render view.
   * @return {Object}
   */
  render: ->
    @desktop.uiSearch.showTooltip '
      <b>Buscar por <em>razón social</em>, <em>RUC</em>
      \ o <em>código de declaración jurada</em>.</b>'
    @desktop.uiSearch.elFocus!
    super!

  /**
   * Template (Declaration).
   * @param {!Object} declaration
   * @return {string}
   * @private
   */
  template: (declaration) -> "
    <form id='dispatchForm' class='#{gz.Css \ink-form} #{gz.Css \ink-form-new}'>
      #{form.block50}
        <fieldset>
          <legend>Cliente</legend>

          #{form.control-group}
            #{form.label}Nombre</label>
            #{form.control}
              <input type='text'
                  value='#{declaration.'customer'.'name'}' disabled>
            </div>
          </div>

          #{form.control-group}
            #{form.label}Origen</label>
            #{form.control}
              <input type='text'
                  value='#{declaration.'source'}' disabled>
            </div>
          </div>

          #{form.control-group}
            #{form.label100}Referencias</label>
            #{form.control100}
              <input type='text' value='' disabled>
            </div>
          </div>
        </fieldset>
      </div>

      #{form.block50}
        <fieldset>
          <legend>Tercero</legend>

          #{form.control-group}
            #{form.label}Nombre</label>
            #{form.control}
              <input type='text'
                  value='#{declaration.'thirdName'}' disabled>
            </div>
          </div>

          <em><h6 class='#{gz.Css \note}'>Documento de identidad</h6><br></em>

          #{form.control-group}
            #{form.label}Tipo</label>
            #{form.control}
              <input type='text'
                  value='#{declaration.'thirdDocumentType'}' disabled>
            </div>
          </div>

          #{form.control-group}
            #{form.label}Número</label>
            #{form.control}
              <input type='text'
                  value='#{declaration[\thirdDocumentNumber]}' disabled>
            </div>
          </div>
        </fieldset>
      </div>

      #{form.block100}
        <fieldset>
          <legend>Alerta</legend>

          #{form.control-group}
            <div class='#{gz.Css \control}
                      \ #{gz.Css \large-100}
                      \ #{gz.Css \medium-100}
                      \ #{gz.Css \small-100}'>
              <label>
                <span>&nbsp;&nbsp;¿Hay alertas?</span>
                <input id='#{gz.Css \id-alert}' type='checkbox'>
              </label>
            </div>
          </div>

          #{form.control-group}
            #{form.control100}
              <textarea name='clerkAlert' style='display:none'
                  placeholder='Motivo de la alerta'>
              </textarea>
            </div>
            </div>
        </fieldset>
      </div>

      #{form.block50}

        <fieldset>
        <legend>Datos SO</legend>

        #{form.control-group}
          #{form.control}
            Cod. Agente Aduana
            <input name='customsBrokerCode' type='text' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control}
          Fecha Recepción <input name='dateReceived' type='text' value=''>
          </div>
        </div>


        #{form.control-group}
          #{form.control}
          Refer. Cliente <input name='customerReferences' type='text' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control}
          Reg. Aduanero <input name='customsRegime' type='text' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control}
          Cod. Aduana <input name='customsCode' type='text' value=''>
          </div>
        </div>

        </fieldset>

      </div>

      #{form.block50}
        <fieldset>
        <legend>Factura Comercial</legend>

        #{form.control-group}
          #{form.control}
          Num Factura <input name='invoiceNumber' type='text' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control}
          Razon Social <input name='businessName' type='text' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control}
          Direccion <input name='invoiceAddress' type='text' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control}
          Valor/Importe <input name='invoiceValue' type='text' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control}
          Moneda V/I <input name='invoiceCurrencyValue' type='text' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control}
          Ajuste Valor <input name='invoiceAdjustment' type='text' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control}
          Moneda AV <input name='invoiceCurrencyValue' type='text' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control}
            Orden Despacho <input name='orderNumber' type='text' value=''>
          </div>
        </div>

        </fieldset>

      </div>

      #{form.block100}
        #{form.control-group}
          #{form.control}
            <button type='button' class='#{gz.Css \ink-button}'>
              Generar Despacho
            </button>
          </div>
        </div>
      </div>
    </form>"

  /** @private */ @menuCaption = 'Declaración'
  /** @private */ @menuIcon    = gz.Css \icon-file-text
