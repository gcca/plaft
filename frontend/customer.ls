/** @module customer */

gz = require './helpers'
model = require './model'
widget = require './widget'

PersonView   = require './customer-form/person-form'
BusinessView = require './customer-form/business-form'


/** -------------
 *  Customer View
 *  -------------
 * Index page.
 * Workflow: Find a customer (business or person), create/update info, save
 * read pdf declaration.
 *
 * @class CustomerView
 */
class CustomerView extends gz.GView

  /**
   * DOM element.
   * @private
   */
  el: \body

  /**
   * View events.
   * @type {Object}
   * @private
   */
  events:
    /**
     * On search a customer.
     * @param {Object} evt
     * @private
     */
    "submit ##{gz.Css \id-form-search}": !(evt) ->
      evt.preventDefault!
      documentNumber = evt.currentTarget.elements.'query'.value
      localStorage.setItem (gz.Css \query), documentNumber
      @editCustomer documentNumber
      setTimeout (~> @$el.find 'input[name=name]' .focus!), 300

    /**
     * On save (generate) a declaration.
     * @private
     */
    "click ##{gz.Css \id-save}": !->
      @$el.find "##{gz.Css \id-declaration-list}" .show!
      @customerView.commit!
      @$buttonSave.prop \disabled true
      @$buttonSave.html "Guardado &nbsp;<i class='#{gz.Css \icon-check}'></i>"

    /**
     * On click to show pdf from list (table).
     * @param {Object} evt
     * @private
     */
    "click a.#{gz.Css \link-pdf}": !(evt) ->
      evt.preventDefault!
      a = evt.currentTarget
      @showPdf a.href

    /**
     * On keyup for input[name=name]. Show customer name on topbar.
     * @param {!Object} evt Event object.
     * @private
     */
    'keyup input[name=name]': !(evt) -> @$logo.html evt.currentTarget.value

    /**
     * On focus input for search customer.
     * @param {Object} evt
     * @private
     */
    "focus .#{gz.Css \input-query}": !(evt) ->
      evt.currentTarget
        ..placeholder = 'Buscar'
        ..parentElement.nextElementSibling.lastElementChild \
          .style.display = 'none'

    /**
     * On blur input for search customer.
     * @param {Object} evt
     * @private
     */
    "blur .#{gz.Css \input-query}": (evt) ->
      evt.currentTarget
        ..placeholder = '_'
        ..parentElement.nextElementSibling.lastElementChild \
          .style.display = 'inline'

    /**
     * On declaration list click.
     * @private
     */
    "click ##{gz.Css \id-declaration-list}": -> @$bodyForm.html ''

  /**
   * Edit customer.
   * @param {string} documentNumber
   * @see event {@code 'submit #id-form-search'}
   * @private
   */
  editCustomer: (documentNumber) ->
    dnLength = documentNumber.length
    if dnLength is 8 or dnLength is 11
      @model.clear!
      @model.set \documentNumber : documentNumber
      CustomerView = if dnLength is 11 then BusinessView else PersonView
      @model.fetch do
        \success : (customer) ~>
          @$logo.html customer.get \name
          @setCustomerView (new CustomerView customer)
        \error : ~>
          @$logo.html documentNumber
          @setCustomerView (new CustomerView @model)
          (new widget.GAutoAlert (gz.Css \info),
                                 "Registro de nuevo cliente:<em>
                                  &nbsp;#documentNumber</em>").elShow!
    else
      @$buttonSave.hide!
      @$bodyForm.html ''
      (new widget.GAutoAlert (gz.Css \error),
                             "Número de DNI o RUC incrorecto:<em>
                              &nbsp;#documentNumber</em>").elShow!

  /**
   * Add customer view. Declaration form.
   * @private
   */
  setCustomerView: !(@customerView) ->
    @customerView.on (gz.Css \event-created-declaration), @onSavedDeclaration
    @$bodyForm.html ''
    @$bodyForm.append @customerView.render!.el
    @$buttonSave.prop \disabled false
    @$buttonSave.html "Guardar &nbsp;
                       <i class='#{gz.Css \icon-check-empty}'></i>"
    @$buttonSave.show!

  /**
   * On saved declaration adds row to table.
   * @see setCustomerView
   * @private
   */
  onSavedDeclaration: !(@declaration) ~>
    @showPdf "/declaration/#{@declaration.id}/pdf"
    @$tbodyEl.html ((@addRowWithLink @declaration.attributes) \
                    + @$tbodyEl.html!)

  /**
   * Show modal PDF.
   * @param urld {string} Url to pdf.
   * @private
   */
  showPdf: !(urld) ->
    ## isSafari = Object::toString.call(window.HTMLElement) \
    ##              .indexOf(\Constructor) > 0
    ## isIE = ``/*@cc_on!@*/false`` || !!document.documentMode;
    isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0
    isFirefox = typeof InstallTrigger isnt \undefined
    isChrome = !!window.chrome && !isOpera;
    if not (isFirefox or isChrome)
      urld = "/static/pdfjs/web/viewer.html?file=#urld"
    mHeader = 'Declaración Jurada'
    mBody = "<iframe src='#urld'
                 style='border:0;width:100%;height:100%'></iframe>
             <!-- <div style='position:absolute;top:0;z-index:-1;padding:2em'>
               <p>Su navegador no cuenta con un visor de pdf.</p>
               <p>Clic en el botón
                 <button class='#{gz.Css \ink-button} #{gz.Css \blue}'>
                   Abrir</button> de la barra inferior.</p>
             </div> -->"
    mFooter = "<div class='#{gz.Css \push-right}'>
                 <a href='#urld' class='#{gz.Css \ink-button} #{gz.Css \blue}'
                     target='_blank'>
                   Abrir
                 </a>
                 <button class='#{gz.Css \ink-button}
                              \ #{gz.Css \red}
                              \ #{gz.Css \ink-dismiss}'>
                   Cerrar
                 </button>
               </div>"
    (new widget.GModal mHeader, mBody, mFooter)
      ..body.style
        ..padding = '0'
        ..position = 'relative'
        ..zIndex = '1'
      ..elShow!

  /**
   * Add row with link.
   * @param {Object} declaration
   * @param {string=} endCell Optional cell visual decoration.
   * @return {string}
   * @private
   */
  addRowWithLink: (declaration) -> "
    <tr>
      #{@addRowBase declaration}
      <td>
        <a class='#{gz.Css \link-pdf}'
            href='/declaration/#{declaration.id}/pdf'>
          #{declaration.\trackingId}
        </a>
        <span class='#{gz.Css \ink-badge} #{gz.Css \green}'
            style='margin-left:1.5em'>
          <i class='#{gz.Css \icon-star}'></i>
        </span>
      </td>
    </tr>"

  /**
   * Add single row.
   * @param {Object} declaration
   * @return {string}
   * @private
   */
  addRow: (declaration) -> "
    <tr>
      #{@addRowBase declaration}
      <td>&nbsp;</td>
    </tr>"

  /**
   * Add base row.
   * @param {Object} declaration
   * @return {string}
   * @private
   */
  addRowBase: (declaration) -> "
    <td>
      #{declaration.'customer'.\documentNumber} &nbsp;
      <small>
        #{
          if declaration.'customer'.'documentNumber'.length is 11
            then 'RUC'
            else 'DNI'
         }
      </small>
    </td>
    <td>#{declaration.'customer'.\name}</td>"

  /**
   * Initialize view.
   * @private
   */
  initialize: -> @model = new model.Customer

  # Attributes
  /**
   * @type {Object}
   * @private
   */
  customerView: null
  /**
   * @type {Object}
   * @private
   */
  $buttonSave: null

  /**
   * Render view.
   * @return {Object} el.
   * @public
   */
  render: ->
    # start
    @$el.html @template!
    $body = $ "<div class='#{gz.Css \ink-grid}'>"
    $body.html @templateBody!

    # body.table
    @$tbodyEl = $body.find \tbody
    apiUrl = gz.GAPI.path

    $.get (apiUrl + 'declarations/top'), (declarations, status) ~>
      if status is \success
        declarationsHtml = new Array
        for declaration in declarations
          declarationsHtml.push (@addRow declaration)
        @$tbodyEl.append declarationsHtml.join ''
      else
        alert 'ERROR: Dispacthes (5c6sr)'

    # end
    #   set customer form base
    @$bodyForm = $body.find "##{gz.Css \body-form}"
    #   set body
    @$el.append $body
    @$el.append "<div class='#{gz.Css \large-100}
                           \ #{gz.Css \medium-100}
                           \ #{gz.Css \small-100}' style='margin-bottom:6em'>
                   &nbsp;
                 </div>"
    #   set button save
    @$buttonSave = @$el.find "##{gz.Css \id-save}"
    @$buttonSave.hide!
    #   set logo
    @$logo = @$el.find "##{gz.Css \id-logo}"
    #   set search
    $input = $body.find 'input'
    query = localStorage.getItem (gz.Css \query)
    if query?
      $input.val query
      $body.find "##{gz.Css \id-form-search}" .submit!
    $input.focus
    super!

  /**
   * View template.
   * @return {string} Html.
   * @private
   */
  template: gzc.Jade '''
    .topbar
      nav.ink-navigation.ink-grid
        ul.menu.horizontal.shadowed.black
          li.hide-small
            a#id-logo Anexo 5: Declaración Jurada de Conocimiento del Cliente
          li.push-right
            button.ink-button.green#id-save(style="margin:1px 0 0")
              | Guardar &nbsp;
              i.icon-check-empty
      .border
  '''

  /**
   * Body template. Toolbar, declaration table list and customer form.
   * @return {string}
   * @private
   */
  templateBody: gzc.Jade '''
    .whatIs
      h1 &nbsp;
      p
    .column-group.gutters
      .large-70.medium-75.hide-small(style="margin-bottom:0") &nbsp;
        button.ink-button#id-declaration-list(style="display:none")
          | Ver lista
      .large-30.medium-25.small-100(style="margin-bottom:0")
        form.ink-form#id-form-search(style="margin-top:.3em")
          .control-group.content-right
            .column-group.horizontal-gutters
              .control.large-100.medium-100.small-100.append-button
                span
                  input.input-query(type="text", name="query",
                                    placeholder="_")
                button.ink-button
                  i.icon-search
                  | &nbsp;
                  .show-all(style="display:inline") Buscar
      .large-100.medium-100.small-100#body-form(style="margin-bottom:1em")
      .large-100.medium-100.small-100
        table.ink-table.alternating.hover
          thead
            tr
              th.content-left Documento
              th.content-left Cliente
              th.content-left &nbsp;
          tbody
  '''

(new CustomerView).render!
## $ \input .val \12345678989
## $ \button .click!
