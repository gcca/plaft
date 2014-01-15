/** @module dashboard.module */

form   = require '../../form'
model  = require '../../model'
widget = require '../../widget'

ModuleBaseView = require './base'
InvoicesView   = require './reception/invoices'

globalOptions = require '../../globalOptions'

/** @private */ DeclarationModel             = model.Declaration
/** @private */ CustomerModel                = model.Customer
/** @private */ CustomerLastDeclarationModel = model.CustomerLastDeclaration
/** @private */ DispatchModel                = model.Dispatch


/**
 * @class ReceptionView
 * @extends ModuleBaseView
 */
module.exports = class ReceptionView extends ModuleBaseView

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
          @desktop.uiSearch.elFocus!
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
    @$el.find '[name=orderNumber]' .focus!
    # Synchronize Name - Code
    selectName = @$el.find '[name=jurisdictionName]' .get 0
    selectCode = @$el.find '[name=jurisdictionCode]' .get 0
    gzApp.shortcuts.ui.jurisdictions.synchronizeSelects selectName, selectCode

  /**
   * Render view.
   * @return {Object}
   */
  render: ->
    @desktop.uiSearch.showTooltip '
      <b>Buscar por <em>RUC</em>
      \ o <em>código de declaración jurada</em>.</b>'
    # Init focus
    @desktop.uiSearch.elFocus!
    super!

  /**
   * Template (Declaration).
   * @param {!Object} declaration
   * @return {string}
   * @private
   */
  template: (declaration) ->
    # Constants for layout
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

    # html elements
    gzApp.shortcuts.ui.iHtml.jurisdictions.optionsSelected!
      optionsJurisdictionName = ..optionsName
      optionsJurisdictionCode = ..optionsCode

    optionsRegime = ["<option>#opType</option>" \
                     for opType in globalOptions.OPERATION_TYPE]

    # template
    "<form class='#{gz.Css \ink-form} #{gz.Css \ink-form-new}
                \ #{gz.Css \column-group} #{gz.Css \gutters}'
        style='margin-left:-2em;margin-bottom:0'>

      #tFieldset50
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

      #tFieldset50
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

      <fieldset class='#{gz.Css \large-100}
                     \ #{gz.Css \medium-100}
                     \ #{gz.Css \small-100}'>

        <div class='#{gz.Css \control-group}
                  \ #{gz.Css \large-50}
                  \ #{gz.Css \medium-50}
                  \ #{gz.Css \small-100}'>
          #tLabel
            Código de Agente de Aduana
          </label>
          #tControl
            <label><b>#{gzApp.customsBroker.get \code}</b></label>
            <input type='hidden' name='customsBrokerCode'
                value='#{gzApp.customsBroker.get \code}'>
          </div>
        </div>

        <div class='#{gz.Css \control-group}
                  \ #{gz.Css \large-50}
                  \ #{gz.Css \medium-50}
                  \ #{gz.Css \small-100}'>
          #tLabel
            Aduana Despacho
          </label>
          <div class='#{gz.Css \control}
                    \ #{gz.Css \large-75}
                    \ #{gz.Css \medium-75}
                    \ #{gz.Css \small-100}'>
            <select name='jurisdictionName'>
              #optionsJurisdictionName
            </select>
          </div>
          <span class='#{gz.Css \large-5}
                     \ #{gz.Css \medium-5}
                     \ #{gz.Css \small-100}'
              style='margin-top:0;margin-bottom:-1.5em'></span>
          <div class='#{gz.Css \control}
                    \ #{gz.Css \large-20}
                    \ #{gz.Css \medium-20}
                    \ #{gz.Css \small-100}'>
            <select name='jurisdictionCode'>
              #optionsJurisdictionCode
            </select>
          </div>
        </div>


      </fieldset>


      #tFieldset50

        #tControlGroup
          #tLabel
            N&ordm; Orden de despacho
          </label>
          #tControl
            <input type='text' name='orderNumber'>
          </div>
        </div>

      </fieldset>


      #tFieldset50

        #tControlGroup
          #tLabel
            Régimen aduanero
          </label>
          #tControl
            <select name='customsRegime'>
              #optionsRegime
            </select>
          </div>
        </div>

      </fieldset>

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

  /** @private */ @menuCaption = 'Recepción'
  /** @private */ @menuIcon    = gz.Css \icon-file-text
  /** @private */ @menuTitle   = 'Recepción'
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
