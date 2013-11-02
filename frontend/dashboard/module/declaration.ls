/**
 * @module dashboard.module
 */

form  = require '../../form'
model = require '../../model'

ModuleBaseView = require './base'

/** @private */ DeclarationModel             = model.Declaration
/** @private */ CustomerLastDeclarationModel = model.CustomerLastDeclaration
/** @private */ DispatchModel                = model.Dispatch

## class larationView extends gz.GView

##   @menuCaption = 'Declaración'
##   @menuIcon = gz.Css \icon-book

##   tagName: \div

##   events:
##     'submit form#search': (event) ->
##       f = event.currentTarget

##       query = f.elements[\query].value

##       type = null

##       if 8 == query.length
##         # Código de declaraión jurada
##         type = 'trackingId'
##         Model = DeclarationModel
##       else if 11 == query.length
##         # RUC
##         type = 'documentNumber'
##         Model = CustomerLastDeclarationModel
##       else if (query)
##         # Razón social
##         type = 'name'
##         Model = CustomerLastDeclarationModel
##       else
##         alert('Texto Invalido')
##         return

##       # (-o-) First find declaration
##       declaration = new Model "#{type}" : query

##       # (-o-) First find customer
##       self = @
##       declaration.fetch do
##         \success : (declaration) ->
##           self.showInfo declaration.attributes
##         \error   : ->
##           console.log 'ya fue'

##       @declaration = declaration

##       off

##     "click .#{gz.Css \event-submit-dispatch}" : ->

##       dispatchJSON = $('#dispatchForm').serializeJSON!
##       dispatchJSON[\declaration] = @declaration

##       dispatch = new Dispatch dispatchJSON

##       dispatch.save {}, do
##         \success : @newDeclarationView
##         \error   : @newDeclarationView

##   newDeclarationView: !(declaration) ->

##       if FormView?
##       # valid FormView
##         dispatchForm = @newDeclarationView!
##         formView = new FormView dispatchForm, declaration
##         @addDeclarationView formView, dispatchForm

##   addDeclarationView: !(@DeclarationView) ->
##     @frame-center
##       ..innerHTML = ''
##       ..appendChild dispatchForm.el
##       ..appendChild gz.newel \br
##       ..appendChild dispatchForm.el

##   initialize: !->
##     @formSearchHTML = "
##     #{form.block100}
##       <form id='search' class='#{gz.Css \ink-form}
##                  \ #{gz.Css \form-search}
##                  \ #{gz.Css \push-right}' style='width:40%'>
##       <div class='#{gz.Css \control-group}'>
##         <div class='#{gz.Css \column-group}'>
##         <div class='#{gz.Css \control}
##                \ #{gz.Css \append-button}'>
##           <span>
##           <input type='text' name='query'
##             placeholder='Código de declaración'>
##           </span>
##           <button class='#{gz.Css \ink-button}'>
##           &nbsp;
##           <i class='#{gz.Css \icon-search}'></i>
##           </button>
##         </div>
##         </div>
##       </div>
##       </form>
##     </div>"
##     @el.innerHTML = @formSearchHTML

##   showInfo: (declaration) ->
##     @el.innerHTML = "
##     #{@formSearchHTML}"


/**
 * @class DeclarationView
 * @extends ModuleBaseView
 */
module.exports = class DeclarationView extends ModuleBaseView

  ```` # CC

  /** @private */ @menuCaption = 'Declaración'
  /** @private */ @menuIcon    = gz.Css \icon-book

  /**
   * On search from searchView event.
   * @param {!string} value Query text.
   * @private
   */
  onSearch: !(value) ~> @renderInfo!

  /**
   * Initialize view.
   * @private
   */
  initialize: !-> @render!

  /**
   * Render customer info form.
   * @private
   */
  renderInfo: !->
    declaration =
      \references : null
      \trackingId : '2D9B2A7A'
      \source : null
      \customer :
        \contact : null
        \socialObject : null
        \legalDocumentType : 'DNI'
        \legalName : null
        \shareholders : []
        \name : 'cristHian Gz.'
        \documentNumber : '12345678989'
        \officePhone : null
        \addressCityCode : null
        \activity : null
        \legalDocumentNumber : null
        \documentType : 'RUC'
        \address : null
        \isObliged : false
        \contactPhone : null
        \hasOfficier : false
        \id : 5910974510923776
        \officialAddress : null
      \thirdDocumentType : 'DNI'
      \thirdDocumentNumber : null
      \thirdName : null
      \thirdType : 'person'
      \id : 5770237022568448
      \third : false
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
          #{form.label}Monto</label>
          #{form.control}
            <input type='text'
                value='#{declaration.'amount'}' disabled>
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
          #{form.label}Tipo</label>
          #{form.control}
            <input type='text'
                value='#{declaration.'thirdType'}' disabled>
          </div>
        </div>

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
        Cod. Agente Aduana <input name='customsBrokerCode' type='text' value=''>
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
