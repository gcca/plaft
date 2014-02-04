Module = require '../module'

customs = App._global.user.customs


module.exports = \

class Customs extends Module

  onSaveCustoms: (evt) ~>
    evt.prevent!

    customs._save @_form._toJSON!, do
      _success: ->
      _error: ->
        alert 'ERROR: 904a80b6-8d21-11e3-858c-88252caeb7e8'

  render: ->
    @$el.html "
      <form class='#{gz.Css \row}'>

        <fieldset class='#{gz.Css \col-md-6}'>

          <legend>Agencia de aduanas</legend>

          <div class='form-group'>
            <label>Razón social</label>
            <input type='text' class='#{gz.Css \form-control}'
                name='name'>
          </div>

          <div class='form-group'>
            <label>Código</label>
            <input type='text' class='#{gz.Css \form-control}'
                name='code'>
          </div>

        </fieldset>


        <fieldset class='#{gz.Css \col-md-6}'>

          <legend>Oficial de cumplimiento</legend>

          <div class='form-group'>
            <label>Nombre</label>
            <input type='text' class='#{gz.Css \form-control}'
                name='officer[name]'>
          </div>

          <div class='form-group'>
            <label>Código</label>
            <input type='text' class='#{gz.Css \form-control}'
                name='officer[code]'>
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

    @_form.0.onSubmit @onSaveCustoms
    @_form._fromJSON customs._attributes
    super!

  _form: null

  @@_caption = 'Agencia'
  @@_icon    = gz.Css \glyphicon-cog

## 711-4777   1019
## Adeudo cuenta de banco de crédito
