gz      = require './helpers'
model   = require './model'
widget  = require './widget'

DeclarationModel   = model.Declaration
CustomerModel      = model.Customer

# -------------------------
# Business/Person Form View
# -------------------------
BusinessFormView = require './customer-form/business-form'
PersonFormView   = require './customer-form/person-form'

# ---------------------
# Declaration Form View
# ---------------------
DeclarationFormView = require './customer-form/declaration-form'

/** ------------------
 *  Customer Form View
 *  ------------------
 * Vista que controla el cuerpo del documento HTML (document.body),
 * los fomularios de cliente (persona o negocio), el formulario
 * de movimiento y la generación de la declaración jurada en
 * formato pdf.
 * @class
 */
class CustomerFormView extends gz.GView

  /**
   * DOM element.
   * @type {Object}
   * @private
   */
  el: $ \body

  /**
   * View events.
   * @type {Object}
   * @private
   */
  events:
    /**
     * On click to create customer model.
     * @param {!Object} evt Event object.
     * @private
     */
    "click .#{gz.Css \event-submit-customer}" : !(evt) ->
      evt.currentTarget
        ..innerHTML = "Guardado <i class='#{gz.Css \icon-check}'></i>"
        ..disabled = true
      @customerView.commit!

    /**
     * On keyup for input[name=name]. Show customer name on topbar.
     * @param {!Object} evt Event object.
     * @private
     */
    'keyup input[name=name]': !(evt) ->
      input = evt.currentTarget
      @logo.innerHTML = input.value

  /**
   * Initialize private events.
   * @private
   */
  initEvents : !->
    formSearch = @el.querySelector 'form#search'
    formSearch.onsubmit = (evt) ~>
      evt.preventDefault!
      f = evt.currentTarget
      documentNumber = f.elements[\query].value
      localStorage.setItem \query documentNumber
      # (-o-) First find customer
      @customer = new CustomerModel do
        \documentNumber : documentNumber
      @customer.fetch do
        \success : @newCustomerView
        \error   : @newCustomerView
      off

  /**
   * Valida si el número de documento es de una persona.
   * @param {!string} idn Número de documento.
   * @return {boolean}
   * @private
   *
   * @example
   * >>> isPerson '12345678'
   * true
   * >>> isPerson '123456789'
   * false
   * >>> isPerson '1234567'
   * false
   */
  isPerson   : (idn) ->  8 == idn.length

  /**
   * Valida si el número de documento es de un negocio.
   * @param {!string} idn Número de documento.
   * @return {boolean}
   * @private
   *
   * @example
   * >>> isBusiness '12345678901'
   * true
   * >>> isBusiness '123456789012'
   * false
   * >>> isBusiness '1234567890'
   * false
   */
  isBusiness : (idn) -> 11 == idn.length

  /**
   * Evento que se lanza al crear un movimiento.
   * @param {!Object} declaration
   * @private
   */
  createdDeclaration: !(@declaration) ->
    (new widget.GAutoAlert (gz.Css \success),
                           '''<b>Datos guardados
                           \ satisfactoriamente</b>''').show off
    @showModalPdf!

  /**
   * Muestra la ventana modal de las declaraciones juradas
   * a ser descargadas.
   * (-o-) Debería contemplar la aceptación de la generación
   * del movimiento.
   * @private
   *
   * @example
   * >>> showModalPdf()
   */
  showModalPdf: !->
    mHeader = 'Declaración Jurada&nbsp;<small><em>pdf</em></small>'
    mBody   = "
      <h4>Lista</h4>
      <p>
        Clic en los enlaces para ver la declaración jurada
      </p>
      <ul>
        <li>
          <a href='/declaration/#{@declaration.get \id}/pdf' target='_blank'>
            Declaración jurada
          </a>
        </li>
      </ul>"

    modal = new widget.GModal mHeader, mBody
    modal.show!

  /**
   * Limpia solo la zona de alertas para mostrar la alerta.
   * @param {!string} classType Css classname of alertType.
   * @param {!string} messageHTML Alert message (HTML format).
   * @private
   *
   * @example
   * >>> showAlert (gz.Css \success), 'Envío satisfactorio'
   * >>> showAlert (gz.Css \error), 'Envío satisfactorio'
   */
  showAlert: !(classType, messageHTML) ->
    div = gz.newel \div
    p   = gz.newel \p

    div.className = "#{gz.Css \ink-alert}
                   \ #{gz.Css \basic}
                   \ #classType"
    div.style.margin = \0
    div.style.marginBottom = \2.2em

    p.innerHTML = messageHTML

    div.appendChild p

    frame-alerts = @frame-alerts
    frame-alerts.innerHTML = ''
    frame-alerts.appendChild div

  /**
   * Limpia la zona de alertas y formulario para mostrar
   * la alerta. Nivel de `error` implica ocultar el `form`.
   * @param {!string} classType Css classname of alertType.
   * @param {!string} messageHTML Alert message (HTML format).
   * @private
   *
   * @example
   * >>> showError (gz.Css \error), 'Sin datos en el form'
   */
  showError: !(classType, messageHTML) ->
    @frame-center.innerHTML = ''
    @showAlert ...

  /**
   * Limpia la zona de alertas.
   * @private
   */
  cleanAlerts: !->
    @frame-alerts.innerHTML = ''

  /**
   * Método interno de newCustomerView. Agrega el `form`
   * al elemento del DOM.
   * @see newCustomerView
   * @param {!Object} customerView
   * @param {!Object} declarationView
   * @private
   */
  addCustomerView: !(@customerView, @declarationView) ->
    @frame-center
      ..innerHTML = ''
      ..appendChild declarationView.el
      ..appendChild gz.newel \br
      ..appendChild customerView.el

  /**
   * Método interno de newCustomerView. Crea el formulario
   * de movimiento y lo guarda en el contexto del MainView
   * @see newCustomerView
   * @private
   */
  newDeclarationView: ->
    # Always add declaration info
    declarationView = new DeclarationFormView
    declarationView.bind (gz.Css \event-created-declaration), @createdDeclaration, @
    @declarationView = declarationView

  /**
   * Genera el formulario de cliente, después de
   * identificar el tipo de cliente (persona, negocio).
   * @param {!Object} customer CustomerModel.
   * @private
   *
   * @example
   * >>> customer = new PersonFormView (or BusinessFormView)
   * >>> customer.set do
   *       \name           : 'cristHian Gz. (gcca)'
   *       \documentNumber : '666'
   *       ...
   * >>> [..]newCustomerView customer
   */
  newCustomerView: !(customer) ~>
    @cleanAlerts!

    @logo = document.querySelector ".#{gz.Css \logoPlaceholder}"

    documentNumber = customer.get \documentNumber

    # either Business or Person or Any else?
    if @isBusiness documentNumber
      FormView = BusinessFormView
    else if @isPerson documentNumber
      FormView = PersonFormView
    else
      FormView = null

    if FormView?
    # valid FormView
      declarationView = @newDeclarationView!
      formView = new FormView declarationView, customer
      @addCustomerView formView, declarationView

      if customer.id
      # exists Identification Number
        (new widget.GAutoAlert (gz.Css \info),
                               '''<b>Usuario registrado</b>: Actualice
                                sus datos de ser necesario.''').show!
        @logo.innerHTML = customer.get \name
      else
      # No existe y se crea nuevo cliente
        (new widget.GAutoAlert (gz.Css \info),
                               '''<b>Usuario no registrado</b>: Llene
                                los campos correspondientes
                                para su registro.''').show!
        @logo.innerHTML = customer.get \documentNumber
        #{alerta}

      @buttonSave.style.display = 'inline'

    else
    # show message invalid Identification Number
      @showError (gz.Css \error),
                 """El número de identificación no es válido
                 <em> &nbsp; #documentNumber</em>"""

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @el.innerHTML = CustomerFormView_template

    # body (grid)
    grid = gz.newel \div
    grid.className = gz.Css \ink-grid

    # body frame
    frame = gz.newel \div
    frame.className = "#{gz.Css \column-group} #{gz.Css \gutters}"

    # Alerts
    frame-alerts = gz.newel \div
    frame-alerts.className = "#{gz.Css \large-100}
                            \ #{gz.Css \medium-100}
                            \ #{gz.Css \small-100}"
    frame-alerts.style.margin = \0
    frame.appendChild frame-alerts
    @frame-alerts = frame-alerts

    # Sub Frame
    frame-center = gz.newel \div
    frame-center.className = "#{gz.Css \large-100}
                            \ #{gz.Css \medium-100}
                            \ #{gz.Css \small-100}"

    @showAlert (gz.Css \info), '''
      Ingrese el número del documento de identidad
      <em>(RUC o DNI)</em>'''

    frame.appendChild frame-center
    @frame-center = frame-center

    grid.appendChild frame

    @el.appendChild grid

    @buttonSave = @el.querySelector ".#{gz.Css \event-submit-customer}"

    @initEvents!
    inputQuery = @el.querySelector 'input[name=query]'
    query = localStorage.getItem \query
    if query?
      inputQuery.value = query
      @el.querySelector ".#{gz.Css \query-button}" .click!
    inputQuery.focus()

/**
 * Template. Menu on topbar.
 * @see CustomerFormView_template
 * @private
 */
CustomerForm-MenuLI= "
<li>
  <a class='#{gz.Css \logoPlaceholder}' href='javascript:void(0)'>
    Anexo 5: Declaración Jurada
  </a>
</li>

<li class='#{gz.Css \push-right}'>
  <a href='javascript:void(0);' style='margin:0;padding:6px 1em'>
    <button class='#{gz.Css \ink-button}
                 \ #{gz.Css \green}
                 \ #{gz.Css \event-submit-customer}'
        style='display:none;margin:0'>
      Guardar <i class='#{gz.Css \icon-check-empty}'></i>
    </button>
  </a>
</li>

<li class='#{gz.Css \push-right}'>
  <form id='search' class='#{gz.Css \ink-form} #{gz.Css \form-search}'>
    <fieldset class='#{gz.Css \column-group} #{gz.Css \gutters}'>
      <div class='#{gz.Css \control-group}'>
        <div class='#{gz.Css \column-group}'>
          <div class='#{gz.Css \control} #{gz.Css \append-button}'>
            <span>
              <input type='text' name='query' placeholder='RUC o DNI'>
            </span>
            <button class='#{gz.Css \ink-button} #{gz.Css \query-button}'>
              Buscar&nbsp;&nbsp;<i class='#{gz.Css \icon-search}'></i>
            </button>
          </div>
        </div>
      </div>
    </fieldset>
  </form>
</li>"

/**
 * Template (main).
 * @private
 */
CustomerFormView_template = "
<div class='#{gz.Css \topbar}'>
  <nav class='#{gz.Css \ink-navigation} #{gz.Css \ink-grid}'>
    <ul class='#{gz.Css \menu}
             \ #{gz.Css \horizontal}
             \ #{gz.Css \shadowed}
             \ #{gz.Css \black}'>
      #{CustomerForm-MenuLI}
    </ul>
  </nav>

  <nav class='#{gz.Css \ink-navigation} #{gz.Css \ink-grid} #{gz.Css \hide-all}'>
    <ul class='#{gz.Css \menu}
             \ #{gz.Css \vertical}
             \ #{gz.Css \flat}
             \ #{gz.Css \black}'>
      <li class='#{gz.Css \title}'>
        <a class='#{gz.Css \logoPlaceholder} #{gz.Css \push-left}'
          href='#' title='gcca'>
          LAc
        </a>

        <button data-target='\#topbar_menu'>
          <span class='#{gz.Css \icon-reorder}'></span>
        </button>
      </li>
    </ul>

    <ul id='topbar_menu' class='#{gz.Css \menu}
                              \ #{gz.Css \vertical}
                              \ #{gz.Css \flat}
                              \ #{gz.Css \black}
                              \ #{gz.Css \hide-all}'>
      #{CustomerForm-MenuLI}
    </ul>
  </nav>
  <div class='#{gz.Css \border}'></div>
</div>

<div class='#{gz.Css \whatIs}'>
  <h1>&nbsp;</h1>
  <p></p>
</div>"

# ---------
# Body init
# ---------
new CustomerFormView
