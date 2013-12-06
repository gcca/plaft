/**
 * @module dashboard.module
 */

/** @const */
form  = require '../../form'
model = require '../../model'
widget = require '../../widget'

ModuleBaseView = require './base'

/** @private */ DeclarationModel             = model.Declaration
/** @private */ CustomerModel                = model.Customer
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
      dispatchJSON = @$el.find \form .serializeJSON!
      dispatchJSON.\declaration = @declaration
      dispatch = new DispatchModel dispatchJSON
      dispatch.save new Object, do
        \success : ~>
          @desktop.uiSearch.elClear!
          @remove!
          (new widget.GAutoAlert (gz.Css \success),
                                 '<b>DESPACHO</b>: Se ha creado el despacho
                                 \ de manera exitosa.').elShow!
        \error   : ->
          alert 'ERROR: new dispatch'

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
                             \ de declaración jurada o un número RUC.').elShow!
      return
    # (-o-) First find declaration
    @declaration = new Model "#type" : query
    # (-o-) First find customer
    @declaration.fetch do
      \success : (declaration) ~>
        if declaration.isNew!
          @onSearchInfoNoDeclaration
        else
          @renderInfo declaration.attributes
      \error : @onSearchInfoNoDeclaration

  /**
   * @see onSearch
   */
  onSearchInfoNoDeclaration: ->
    (new widget.GAutoAlert (gz.Css \info),
                           '<b>AVISO</b>: No existe una declaración
                             \ jurada.').elShow!

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
      <b>Buscar por <em>RUC</em>
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
    <form class='#{gz.Css \ink-form} #{gz.Css \ink-form-new}'
        style='margin-left:-2em'>
      #{form.block50}
        <fieldset>
          <legend>Cliente</legend>

          #{form.control-group}
            #{form.label}Nombre</label>
            #{form.control}
              <label><b>#{declaration.'customer'.'name'}</b></label>
            </div>
          </div>

          #{form.control-group}
            #{form.label}RUC</label>
            #{form.control}
              <label><b>#{declaration.'customer'.'documentNumber'}</b></label>
            </div>
          </div>
        </fieldset>
      </div>

      #{form.block50}
        <fieldset>
          <legend>Tercero</legend>

          #{
          if declaration.'thirdName' then "
            #{form.control-group}
              #{form.label}Nombre</label>
              #{form.control}
                <label><b>#{declaration.'thirdName'}</b></label>
              </div>
            </div>

            <h6 class='#{gz.Css \note}'><em>Documento de identidad</em></h6><br>

            #{form.control-group}
              #{form.label}Tipo</label>
              #{form.control}
                <label><b>#{declaration.'thirdDocumentType'}</b></label>
              </div>
            </div>

            #{form.control-group}
              #{form.label}Número</label>
              #{form.control}
                <label><b>#{declaration[\thirdDocumentNumber]}</b></label>
              </div>
            </div>"
          else
            "<h6 class='#{gz.Css \note}'>No figura un tercero.</h6>"
          }
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
          #{form.control100}
            <input name='customsBrokerCode' type='text'
                placeholder='Codigo de Agente de Aduana' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control100}
            <input name='dateReceived' type='text'
                placeholder='Fecha de recepción' value=''>
          </div>
        </div>


        #{form.control-group}
          #{form.control100}
            <input name='customerReferences' type='text'
                placeholder='Referencias' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control100}
            <input name='customsRegime' type='text'
                placeholder='Regimen aduanero'value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control100}
          <input name='customsCode' type='text'
              placeholder='Código de Aduana' value=''>
          </div>
        </div>

        </fieldset>

      </div>

      #{form.block50}
        <fieldset>
        <legend>Factura Comercial</legend>

        #{form.control-group}
          #{form.control100}
            <input name='invoiceNumber' type='text'
                placeholder='Número Factura' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control100}
            <input name='businessName' type='text'
                placeholder='Razón social' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control100}
            <input name='invoiceAddress' type='text'
                placeholder='Dirección' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control100}
            <input name='invoiceValue' type='text'
                placeholder='Valor / Importe' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control100}
            <input name='invoiceCurrencyValue' type='text'
                placeholder='Moneda V/I' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control100}
            <input name='invoiceAdjustment' type='text'
                placeholder='Ajuste Valor' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control100}
            <input name='invoiceCurrencyAdjustment' type='text'
                placeholder='Moneda AV' value=''>
          </div>
        </div>

        #{form.control-group}
          #{form.control100}
            <input name='orderNumber' type='text'
                placeholder='Orden de Despacho' value=''>
          </div>
        </div>

        </fieldset>

      </div>

      #{form.block100}
        #{form.control-group}
          #{form.control100}
            <button type='button' class='#{gz.Css \ink-button}'>
              Generar Despacho
            </button>
          </div>
        </div>
      </div>
    </form>"

  /** @private */ @menuCaption = 'Declaración'
  /** @private */ @menuIcon    = gz.Css \icon-file-text
  /** @private */ @menuTitle   = 'Declaración Jurada'
