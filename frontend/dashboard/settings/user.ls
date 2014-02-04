Module = require '../module'

user = App._global.user


module.exports = \

class User extends Module

  onSaveUser: (evt) ~>
    evt.prevent!

    user._save @_form._toJSON!, do
      _success: ->
      _error: ->
        alert 'ERROR: 9aea3d26-8d22-11e3-858c-88252caeb7e8'

  render: ->
    @$el.html "
      <form class='#{gz.Css \row}'>

        <fieldset class='#{gz.Css \col-md-6}'>

          <legend>Usuario</legend>

          <div class='form-group'>
            <label>e-Mail</label>
            <input type='text' class='#{gz.Css \form-control}'
                name='email'>
          </div>

        </fieldset>


        <fieldset class='#{gz.Css \col-md-6}'>

          <legend>Oficial de cumplimiento</legend>

          <div class='form-group'>
            <label>Jurisdicción</label>
            <input type='text' class='#{gz.Css \form-control}'
                name='jurisdiction'>
          </div>

        </fieldset>


        <div class='form-group #{gz.Css \col-md-12}'>
          <button class='#{gz.Css \btn}
                       \ #{gz.Css \btn-primary}
                       \ #{gz.Css \pull-right}'>
            Guardar
          </button>
        </div>

      </form>"

    @_form = @$ \form

    App.shared._form.patch.saveButton (@_form._find \button .0)

    @_form.0.onSubmit @onSaveUser
    @_form._fromJSON user._attributes
    super!

  _form: null

  @@_caption = 'Agencia'
  @@_icon    = gz.Css \glyphicon-user
