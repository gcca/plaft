/** @module dashboard.module */

form  = require '../../form'
model = require '../../model'
widget = require '../../widget'

ModuleBaseView = require './base'
InvoicesView = require './declaration/invoices'


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
    "click button##{gz.Css \id-submit-declaration}": !(evt) ->
      dispatchJSON = @$el.find \form .serializeJSON!
      dispatchJSON.\declaration = @declaration
      dispatchJSON.\invoices = @invoicesView.JSONFields!
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
   * @param {!string} query Query text: declaration trackingId
   *   or documentNumber.
   * @param {function(string)} searchState Set color decorator
   *   to {@code searchView}.
   * @private
   */
  onSearch: !(query, searchState) ~>
    type = null
    if query.length is 8
      type = 'trackingId'
      Model = DeclarationModel
    else if query.length is 11
      type = 'documentNumber'
      Model = CustomerLastDeclarationModel
    else
      searchState gz.Css \error
      @$el.html ''
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
          @onSearchInfoNoDeclaration!
        else
          @renderInfo declaration.attributes
        searchState gz.Css \success
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

  /** @private */ invoicesView: null

  /**
   * Render customer info form.
   * @param {!Object} declaration
   * @private
   */
  renderInfo: !(declaration) ->
    @$el.html @template declaration
    @invoicesView = new InvoicesView
    @$el.find "##{gz.Css \id-invoices}" .append @invoicesView.render!.el

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
  template: (declaration) ->
    tBlock100 = "<div class='#{gz.Css \large-100}
                           \ #{gz.Css \medium-100}
                           \ #{gz.Css \small-100}'>"

    tFieldset50 = "<fieldset class='#{gz.Css \large-50}
                                  \ #{gz.Css \medium-50}
                                  \ #{gz.Css \small-100}'>"

    tControlGroup = "<div class='#{gz.Css \control-group}
                               \ #{gz.Css \large-100}
                               \ #{gz.Css \medium-100}
                               \ #{gz.Css \small-100}'>"

    tLabel = "<label class='#{gz.Css \large-100}
                          \ #{gz.Css \medium-100}
                          \ #{gz.Css \small-100}'>"

    tControl = "<div class='#{gz.Css \control}
                          \ #{gz.Css \large-100}
                          \ #{gz.Css \medium-100}
                          \ #{gz.Css \small-100}'>"

    "<form class='#{gz.Css \ink-form} #{gz.Css \ink-form-new}
                \ #{gz.Css \column-group} #{gz.Css \gutters}'
        style='margin-left:-2em;margin-bottom:0'>
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
            </div>"
          else
            "<h6 class='#{gz.Css \note}'>No figura un tercero.</h6>"
          }
        </fieldset>
      </div>


      <div class='#{gz.Css \large-100}
                \ #{gz.Css \medium-100}
                \ #{gz.Css \small-100}'
          style='margin-bottom:0;margin-top:-2em'>
        &nbsp;
      </div>


      #tFieldset50

        #tControlGroup
          #tLabel
            N&ordm; Orden de despacho
          </label>
          #tControl
            <input type='text' name='orderNumber'>
          </div>
        </div>

        #tControlGroup
          #tLabel
            Código de Agente de Aduana
          </label>
          #tControl
            <input type='text' name='customsBrokerCode'>
          </div>
        </div>

      </fieldset>


      #tFieldset50

        #tControlGroup
          #tLabel
            Régimen aduanero
          </label>
          #tControl
            <input type='text' name='customsRegime'>
          </div>
        </div>

        #tControlGroup
          #tLabel
            Despacho de Aduana
          </label>
          #tControl
            <input type='text' name='customsCode'>
          </div>
        </div>

      </fieldset>



      <!--
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
            <button id='#{gz.Css \id-submit-declaration}'
                type='button' class='#{gz.Css \ink-button}'>
              Generar Despacho
            </button>
          </div>
        </div>
      </div> -->
    </form>
    <div id='#{gz.Css \id-invoices}' class='#{gz.Css \large-100}
                                          \ #{gz.Css \medium-100}
                                          \ #{gz.Css \small-100}'>
      <h4 style='margin-bottom:1em'>
        Facturas Comerciales
      </h4>
    </div>

    <button type='button' id='#{gz.Css \id-submit-declaration}'
        class='#{gz.Css \ink-button} #{gz.Css \green} #{gz.Css \push-right}'>
      Generar Despacho
    </button>"

  /** @private */ @menuCaption = 'Declaración'
  /** @private */ @menuIcon    = gz.Css \icon-file-text
  /** @private */ @menuTitle   = 'Declaración Jurada'
  /** @private */ @menuHelp    = "
    <b></b>

    <h5>Registrar despacho</h5>

    <ol>
      <li>Buscar por código de declaración o RUC.
        <small>&nbsp;(<em>RUC</em> si es importador frecuente,
        &nbsp;<em>código</em> en caso contrario.)</small>
      </li>
      <li>Verificar datos del cliente.</li>
      <li>Ingresar datos del sujeto obligado y de la factura comercial.</li>
      <li>Ingresar <b>Número de Orden</b>.</li>
      <li>Generar despacho (movimiento).</li>
    </ol>

    <img src='/static/help/declaration.png'>"
