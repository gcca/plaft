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
     * On
     * @private
     */
    "click ##{gz.Css \id-new-person}": ->
      @model.clear!
      @declaration = void
      @setCustomerView (new PersonView @model)

    "click ##{gz.Css \id-new-business}": ->
      @model.clear!
      @declaration = void
      @setCustomerView (new BusinessView @model)

    "click ##{gz.Css \id-edit}": ->
      documentNumber = @$el.find 'input[name=query]' .val!
      @editCustomer documentNumber

    "click ##{gz.Css \id-delete}": ->
      @model.clear!
      @declaration = void
      @customerView = null
      @$buttonSave.hide!
      @$bodyForm.html ''

    "click ##{gz.Css \id-print}": ->
      if @declaration?
        @showPdf "/declaration/#{@declaration.id}/pdf"
      else
        (new widget.GAutoAlert (gz.Css \info),
                       "Es necesario guardar la declaración.").elShow!


    "click ##{gz.Css \id-save}": ->
      @customerView.commit!
      @$buttonSave.html "Guardado &nbsp; <i class='#{gz.Css \icon-check}'></i>"

    "submit ##{gz.Css \id-form-search}": (evt) ->
      evt.preventDefault!
      documentNumber = evt.currentTarget.elements.'query'.value
      @editCustomer documentNumber

    "click a.#{gz.Css \link-pdf}": (evt) ->
      evt.preventDefault!
      a = evt.currentTarget
      @showPdf a.href

    "focus .#{gz.Css \input-query}": (evt) ->
      evt.currentTarget
        ..placeholder = '_'
        ..parentElement.nextElementSibling.lastElementChild
          ..style.display = 'inline'

    "blur .#{gz.Css \input-query}": (evt) ->
      setTimeout ->
        evt.currentTarget
          ..value = ''
          ..parentElement.nextElementSibling.lastElementChild
            ..style.display = 'none'
      , 500
      evt.currentTarget.placeholder = 'Buscar'

  /**
   * Edit customer.
   * @param {string} documentNumber
   * @private
   */
  editCustomer: (documentNumber) ->
    dnLength = documentNumber.length
    if dnLength is 8 or dnLength is 11
      @model.clear!
      @model.set \documentNumber : documentNumber
      @model.fetch do
        \success : (customer) ~>
          CustomerView = if customer.isBusiness!
                           then BusinessView else PersonView
          @setCustomerView (new CustomerView customer)
        \error : ~>
          @$bodyForm.html ''
          (new widget.GAutoAlert (gz.Css \error),
                                 "No existe el documento <em>
                                  &nbsp;#documentNumber</em>").elShow!

    else
      @$buttonSave.hide!
      @showDocumentError documentNumber

  /**
   * @see submit event
   * @private
   */
  showDocumentError: (documentNumber) ->
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
    @$buttonSave.html "Guardar &nbsp;
                       <i class='#{gz.Css \icon-check-empty}'></i>"
    @$buttonSave.show!

  /**
   * @private
   */
  onSavedDeclaration: !(@declaration) ~>
    @$tbodyEl.html ((@addRow @declaration.attributes,
                             "<span class='#{gz.Css \ink-badge}
                                         \ #{gz.Css \green}'
                                  style='margin-left:1.5em'>
                                <i class='#{gz.Css \icon-star}'></i>
                              </span>") + @$tbodyEl.html!)

  /**
   * @private
   */
  showPdf: !(urld) ->
    mHeader = 'Declaración Jurada'
    mBody = "<iframe src='#urld'
               style='border:0;width:100%;height:100%'></iframe>"
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
    (new widget.GModal mHeader, mBody, mFooter).elShow!

  /**
   * @private
   */
  addRow: (declaration, endCell = '') -> "
    <tr>
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
      <td>#{declaration.'customer'.\name}</td>
      <td>
        <a class='#{gz.Css \link-pdf}' href='/declaration/#{declaration.id}/pdf'>
          #{declaration.\trackingId}
        </a>
        #endCell
      </td>
    </tr>"

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
    $tbodyEl = $body.find \tbody
    @$tbodyEl = $tbodyEl
    apiUrl = gz.GAPI.path

    $.get (apiUrl + 'declarations/top'), (declarations, status) ~>
      if status is \success
        declarationsHtml = new Array
        for declaration in declarations
          declarationsHtml.push (@addRow declaration)
        $tbodyEl.append declarationsHtml.join ''
      else
        alert 'ERROR: Dispacthes (5c6sr)'

    # end
    #   set customer form base
    @$bodyForm = $body.find "##{gz.Css \body-form}"
    #   set body
    @$el.append $body
    $body.find 'input' .focus!
    #   set button save
    @$buttonSave = @$el.find "##{gz.Css \id-save}"
    @$buttonSave.hide!
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
            a Anexo 5: Declaración Jurada de Conocimiento del Cliente
          li.push-right
            button.ink-button.green#id-save
              | Guardar &nbsp;
              i.icon-check-empty
      .border
  '''

  templateBody: gzc.Jade '''
    .whatIs
      h1 &nbsp;
      p
    .column-group.gutters#id-toolbar
      .large-70.medium-75.small-100(style="margin-bottom:0")
        nav.ink-navigation
          ul.menu.horizontal.rounded.shadowed.white
            li.large-25.medium-25.small-100
              a(style="width:100%")
                i.icon-folder-open
                | &nbsp; Nuevo &nbsp;
                i.icon-caret-down
              ul.submenu(style="width:11em")
                li: a#id-new-person
                  i.icon-user
                  | &nbsp; Persona natural
                li: a#id-new-business
                  i.icon-sitemap
                  | &nbsp; Persona jurídica
            li.large-25.medium-25.small-100
              a(style="width:100%")#id-edit
                i.icon-edit
                | &nbsp; Modificar
            li.large-25.medium-25.small-100
              a(style="width:100%")#id-delete
                i.icon-eraser
                | &nbsp; Eliminar
            li.large-25.medium-25.small-100
              a(style="width:100%")#id-print
                i.icon-print
                | &nbsp; Imprimir
      .large-30.medium-25.small-100(style="margin-bottom:0")
        form.ink-form#id-form-search(style="margin-top:.3em")
          .control-group.content-right
            .column-group.horizontal-gutters
              .control.large-100.medium-100.small-100.append-button
                span
                  input.input-query(type="text", name="query",
                                    placeholder="Buscar")
                button.ink-button
                  i.icon-search
                  | &nbsp;
                  .hide-all(style="display:none") Buscar
      .large-100.medium-100.small-100#body-form
      .large-100.medium-100.small-100
        table.ink-table.alternating.hover
          thead
            tr
              th.content-left Documento
              th.content-left Cliente
              th.content-left Declaración Jurada
          tbody
  '''
## // button.ink-button#id-button-new(style="width:25%") Nuevo
## .ink-dropdown.black(style="width:22%;padding-right:.7em")
##   button.ink-button.toggle(data-target="\#{Css id-dropdown}",
##                            style="width:100%")
##     | Nuevo &nbsp;
##     span.icon-caret-down
##   ul.dropdown-menu#id-dropdown
##     li: a(href="#") Persona natural
##     li: a(href="#") Persona jurídica
## button.ink-button#id-button-edit(style="width:22%") Modificar
## button.ink-button#id-button-delete(style="width:22%") Eliminar
## button.ink-button#id-button-print(style="width:22%") Imprimir

(new CustomerView).render!
