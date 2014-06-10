/** @module customer.base */

PDFModal = require './pdfmodal'


/**
 * Base for Busines and Person customer form.
 * @class UiBase
 * @extends View
 */
class Base extends App.View

  /** @override */
  _tagName: \form

  /** @override */
  _className: gz.Css \row

  /**
   * Form to JSON.
   * @return {Object}
   * @override
   */
  _toJSON: -> @$el._toJSON!

  /**
   * (Event) On save customer data.
   * @param {Object} evt
   */
  onSave: (evt) !~>
    evt.prevent!

    # Disable button save
    evt._target._elements."#{gz.Css \id-save}"
      .._disabled = on
      ..html "Guardado"
      ..Class = "#{gz.Css \btn} #{gz.Css \btn-success}"

    # Save customer data
    dtoCustomer    = @_toJSON!
    dtoDeclaration =
      third  : delete dtoCustomer.\third
      source : delete dtoCustomer.\source

    @model._save dtoCustomer, do

      _success: ~>
        # Create declaration
        @model.newDeclaration dtoDeclaration, (declaration) ~>
          window.\kmll = @model.\id
          a = new PDFModal declarationId: declaration.\id
          a.render!

      _error: ->
        alert 'ERROR: ae1323e8-884c-11e3-96e1-88252caeb7e8'

  /** @override */
  initialize: !->
    @el._id = gz.Css \id-form-declaration
    @el.onsubmit = @onSave
    @el.html "
      <div class='#{gz.Css \col-md-12}'>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-4}'>
          <label class='#{gz.Css \radio-inline}'>
            <input type='radio' name='category' value='Importador frecuente'>
            \ Importador Frecuente
          </label>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-4}'>
          <label class='#{gz.Css \radio-inline}'>
            <input type='radio' name='category' value='Buen contribuyente'>
            \ Buen Contribuyente
          </label>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-4}'>
          <label class='#{gz.Css \radio-inline}'>
            <input type='radio' name='category' value='Otros'> Otros
          </label>
        </div>

      </div>"

  /** @private */
  customer : null

  /** @override */
  render: ->
    # Populate form
    @$el._fromJSON @model._attributes

    # Sync isobliged and hasofficer
    $isobliged  = @$ '[name=isobliged]'
    $hasofficer = @$ '[name=hasofficer]' .parents "div.#{gz.Css \form-group}"

    xisobliged = @el._elements\isobliged
    $hasofficer._hide! if xisobliged._value isnt \Sí
    $isobliged .on \change ->
      if xisobliged._value is \Sí
        $hasofficer._show!
      else
        $hasofficer._hide!

    # Customize sensitive fields
    @$ '[name=source]' ._parent!
      ..addClass gz.Css \has-warning
      ..addClass gz.Css \has-feedback
      .._append "<span class='#{gz.Css \glyphicon}
                            \ #{gz.Css \glyphicon-warning-sign}
                            \ #{gz.Css \form-control-feedback}'></span>"

    @$ '[name=third]' ._parent!
      ..addClass gz.Css \has-warning
      ..addClass gz.Css \has-feedback
      .._append "<span class='#{gz.Css \glyphicon}
                            \ #{gz.Css \glyphicon-warning-sign}
                            \ #{gz.Css \form-control-feedback}'></span>"

    @$ '[name=isobliged]' .parents "div.#{gz.Css \form-group}"
      ..addClass gz.Css \has-warning
      ..addClass gz.Css \has-feedback

    @$ '[name=hasofficer]' .parents "div.#{gz.Css \form-group}"
      ..addClass gz.Css \has-warning
      ..addClass gz.Css \has-feedback

    super!


/** @export */
module.exports = Base
