/** @module customer */

App = require './app'

Business = require './customer/business'
Person   = require './customer/person'


/**
 * Customer main view.
 * @class UiCustomer
 * @extends View
 */
class Customer extends App.View

  /** @override */
  el: $ \body

  /**
   * (Event) On search by document number.
   * @param {Object} evt
   */
  onSubmitSearch: (evt) !~>
    evt.prevent!
    xForm = evt._target

    documentNumber = xForm._elements.0._value

    # Set main form
    @$body.html ''

    if @_valid documentNumber
      App.storage.local.\q = documentNumber

      # Load customer
      customer = new App.model.Customer \document : \number : documentNumber
      customer.fetch do
        _success : @showForm
        _error   : @showForm

    else
      alert 'Número de documento incorrecto: ' + documentNumber

  /**
   * Valid customer type (business or person) by document number.
   * @param {string} documentNumber
   * @return {boolean}
   */
  _valid: (documentNumber) ->
    documentNumber._length is 11 or documentNumber._length is 8

  /**
   * Show form by customer type (business or person).
   * @param {App.model.Customer} customer
   */
  showForm: (customer) !~>
    # Set "customerClass" by valid "documentNumber"
    customerClass = if customer.isBusiness then Business
                    else if customer.isPerson then Person
                    else null

    uiCustomer = new customerClass model: customer
    @$body._append uiCustomer.render!.el

  /** @private */ $body       : null

  /** @override */
  render: ->
    @$el.html @template!

    $formSearch = @$ "##{gz.Css \id-search}"
      ..on \submit @onSubmitSearch

    # Attributes
    @$body       = @$el._find "##{gz.Css \id-body}"

    # Get focus
    $formSearch.0._elements.0._focus!
    $ ($formSearch._find \input) .tooltip!

    query = App.storage.local.\q
    if query?
      $formSearch.0._elements.0._value = query
      $formSearch._find \button ._click!

    super!

  /**
   * Base template: header and search form.
   * @return {string}
   */
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
        .col-md-8
        .col-md-4
          form.form-inline(role="form")#id-search
            .input-group
              input.form-control(type="text", placeholder="RUC o DNI",
                                 title="Para buscar Personas Jurídicas, ingresar RUC. Para Personas Naturales, el DNI.")
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
## $('input').\val '12345678989'
## $('button').'click'!
