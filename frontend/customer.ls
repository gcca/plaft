App = require './app'

Business = require './customer/business'
Person   = require './customer/person'


class Customer extends App.View

  el: $ \body

  ## Events
  onSubmitSearch: (evt) !~>
    evt.prevent!
    xForm = evt._target

    documentNumber = xForm._elements.0._value

    # Clean disclaimer
    @$disclaimer.html ''

    # Set main form
    @$body.html ''

    if @valid documentNumber
      # Load customer
      customer = new App.model.Customer \document : \number : documentNumber
      customer.fetch do
        _success : @showForm
        _error   : @showForm

    else
      alert 'Número de documento incorrecto: ' + documentNumber

  ## Methods
  valid: (documentNumber) ->
    documentNumber._length is 11 or documentNumber._length is 8

  showForm: (customer) !~>
    # Set "customerClass" by valid "documentNumber"
    customerClass = if customer.isBusiness then Business
                    else if customer.isPerson then Person
                    else null

    uiCustomer = new customerClass model: customer
    @$body._append uiCustomer.render!.el

  ## Attributes
  $body       : null
  $disclaimer : null

  ## View methods
  render: ->
    @$el.html @template!

    $formSearch = @$el._find \form
      ..on \submit @onSubmitSearch

    # Attributes
    @$disclaimer = @$el._find "##{gz.Css \id-disclaimer}"
    @$body       = @$el._find "##{gz.Css \id-body}"

    # Get focus
    $formSearch.0._elements.0._focus!

    super!

  template: gzc.Jade '''
    //- HEADER
    header.navbar.navbar-inverse.navbar-fixed-top.navbar-top-min(role="banner")
      .container
        .navbar-header
          button.navbar-toggle(type="button",
                               data-toggle="collapse",
                               data-target"{Css id-navbar-collapse}")
            span.sr-only Toggle navigation
            span.icon-bar
            span.icon-bar
            span.icon-bar
          a.navbar-brand(href="/") PLAFTsw
        nav.collapse.navbar-collapse#id-navbar-collapse(role="navigation")
          ul.nav.navbar-nav
           li
             a
          ul.nav.navbar-nav.navbar-right
           li
             a

    //- BODY
    .container.app-container
      .row
        .col-md-8#id-disclaimer
          small.pull-right
            | Ingresar RUC para Persona Jurídica o DNI para Persona Natural
        .col-md-4
          form.form-inline(role="form")
            .input-group
              input.form-control(type="text")
              span.input-group-btn
                button.btn.btn-default
                  i.glyphicon.glyphicon-search
                  | &nbsp;
        .col-md-12#id-body

    //- FOOTER
    - var aStyle = "padding-top:40px;";
    - aStyle += "padding-bottom:30px;";
    - aStyle += "margin-top:100px";
    footer(style=aStyle)
    '''

(new Customer).render!
$('input').\val '12345678989'
$('button').'click'!
