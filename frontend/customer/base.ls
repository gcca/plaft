module.exports = \

class Base extends App.View

  _tagName: \form

  _className: gz.Css \row

  _toJSON: -> @$el._toJSON!

  # Events
  onSubmit: (evt) !~>
    evt.prevent!

    # Save customer data
    dtoCustomer    = @_toJSON!
    dtoDeclaration =
      third  : delete dtoCustomer.\third
      source : delete dtoCustomer.\source

    @model._save dtoCustomer, do

      _success: ~>
        # Create declaration
        @model.newDeclaration dtoDeclaration, (declaration) ~>

          @$endSection.html "
            <div class='#{gz.Css \pull-right}'>

              <a class='#{gz.Css \btn} #{gz.Css \btn-default}'
                  href='/customer'>
                Nuevo
              </a>

              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

              <a class='#{gz.Css \btn} #{gz.Css \btn-info}'
                  target='_blank'
                  href='/declaration/#{declaration.\id}/pdf'>
                Ver Declaración Jurada
              </a>

            </div>"

      _error: ->
        alert 'ERROR: ae1323e8-884c-11e3-96e1-88252caeb7e8'

  # Attributes
  customer : null

  # View methods
  initialize: (options) !->
    @el.onsubmit = @onSubmit
    @el.html ''

  render: ->
    # Add button save section
    @$endSection = $ "
      <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
        <button class='#{gz.Css \btn}
                     \ #{gz.Css \btn-primary}
                     \ #{gz.Css \pull-right}'>
          Guardar
        </button>
      </div>"

    @$el._append @$endSection

    # Disable on click save
    @$endSection._find \button .0.onClick = -> @disabled = true

    # Populate form
    @$el._fromJSON @model._attributes

    super!
