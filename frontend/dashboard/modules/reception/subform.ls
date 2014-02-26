HAS_STATE =
  kNotFound       : 0
  kHasCustomer    : 1
  kHasDeclaration : 2


module.exports = \

class Subform extends App.View

  _tagName: \div

  _className: gz.Css \col-md-12

  processFields: (dto) ->
    if @hasState is HAS_STATE.kNotFound
      -1

    else if @hasState is HAS_STATE.kHasCustomer
      delete! dto.\declaration
      dto.\customer = @customer.\id

    else # HAS_STATE.kHasDeclaration
      dto.\declaration = @declaration.\id
      dto.\customer    = @declaration.'owner'.\id

  formWith: !->
    @el.html "
      <form class='#{gz.Css \row}'>
        <div class='#{gz.Css \col-md-6}'>
          <label>Código de declaración</label>
          <div class='#{gz.Css \input-group}'>
            <input type='text' class='#{gz.Css \form-control}'>
            <span class='#{gz.Css \input-group-btn}'>
              <button class='#{gz.Css \btn} #{gz.Css \btn-default}'>
                Buscar
              </button>
            </span>
          </div>
        </div>
      </form>
      <div></div>"

    @el._first.onSubmit (evt) !~>
      evt.prevent!
      tracking = evt._target._elements.0._value
      declaration = new App.model.Declaration \tracking : tracking
      declaration.fetch do
        _success: (_, @declaration) !~>
          @hasState = HAS_STATE.kHasDeclaration
          customer = declaration.\customer

          @xsave._disabled = off

          @el._last.html "
            <div class='#{gz.Css \row}'>

              <div class='#{gz.Css \col-md-6}'>
                <label class='#{gz.Css \col-md-3}'>
                  Cliente
                </label>
                <span class='#{gz.Css \col-md-9}'>
                  #{customer.\name}
                </span>
              </div>

              <div class='#{gz.Css \col-md-6}'>
                <label class='#{gz.Css \col-md-3}'>
                  RUC/DNI
                </label>
                <span class='#{gz.Css \col-md-9}'>
                  #{customer.'document'.\number}
                </span>
              </div>

              <div class='#{gz.Css \col-md-12}'>
                <label class='#{gz.Css \col-md-6}'>
                  ¿Es buen contribuyente o importador frecuente?
                </label>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <span class='#{gz.Css \col-md-3}'>
                  #{customer.\isgood}
                </span>
              </div>

            </div>"

        _error: !->
          alert 'No encontrado'


  formWithout: !->
    @el.html "
      <form class='#{gz.Css \row}'>
        <div class='#{gz.Css \col-md-6}'>
          <label>Buscar por RUC/DNI</label>
          <div class='#{gz.Css \input-group}'>
            <input type='text' class='#{gz.Css \form-control}'>
            <span class='#{gz.Css \input-group-btn}'>
              <button class='#{gz.Css \btn} #{gz.Css \btn-default}'>
                Buscar
              </button>
            </span>
          </div>
        </div>
      </form>
      <div></div>"

    @el._first.onSubmit (evt) !~>
      evt.prevent!
      documentNumber = evt._target._elements.0._value
      customer = new App.model.Customer \document : \number : documentNumber
      customer.fetch do
        _success: (_, @customer) !~>
          @hasState = HAS_STATE.kHasCustomer

          @xsave._disabled = off

          @el._last.html "
            <div class='#{gz.Css \row}'>

              <div class='#{gz.Css \col-md-6}'>
                <label class='#{gz.Css \col-md-3}'>
                  Cliente
                </label>
                <span class='#{gz.Css \col-md-9}'>
                  #{customer.\name}
                </span>
              </div>

              <div class='#{gz.Css \col-md-6}'>
                <label class='#{gz.Css \col-md-3}'>
                  RUC/DNI
                </label>
                <span class='#{gz.Css \col-md-9}'>
                  #{customer.'document'.\number}
                </span>
              </div>

              <div class='#{gz.Css \col-md-12}'>
                <label class='#{gz.Css \col-md-6}'>
                  ¿Es buen contribuyente o importador frecuente?
                </label>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <span class='#{gz.Css \col-md-3}'>
                  #{customer.\isgood}
                </span>
              </div>

            </div>"

        _error: !~>
          xgroup = @el._last
          xgroup.html "

            <h5>Cliente no encontrado</h5>

            <form class='#{gz.Css \row}'>

              <div class='#{gz.Css \form-group} #{gz.Css \col-md-5}'>
                <label>RUC/DNI</label>
                <input type='text' class='#{gz.Css \form-control}'
                    name='document[number]'>
              </div>

              <div class='#{gz.Css \form-group} #{gz.Css \col-md-7}'>
                <label>Nombre/Razón Social</label>
                <input type='text' class='#{gz.Css \form-control}'
                    name='name'>
              </div>

              <div class='#{gz.Css \form-group} #{gz.Css \col-md-5}'>
                <label>Tipo Empresa</label>
                <select class='#{gz.Css \form-control}'
                    name='document[type]'>
                  <option value='RUC'>Persona Jurídica</option>
                  <option value='DNI'>Persona Natural</option>
                </select>
              </div>

              <div class='#{gz.Css \form-group} #{gz.Css \col-md-7}'>
                <label>Tipo Contribuyente</label>
                <div>
                  ¿Es importador frecuente o buen contribuyente?
                  &nbsp;&nbsp;&nbsp;&nbsp;
                  <label class='#{gz.Css \radio-inline}'>
                    <input type='radio' name='isgood' value='Sí'> Sí
                  </label>
                  <label class='#{gz.Css \radio-inline}'>
                    <input type='radio' name='isgood' value='No'> No
                  </label>
                </div>
              </div>

              <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
                <button class='#{gz.Css \btn} #{gz.Css \btn-default}
                             \ #{gz.Css \pull-right}'>
                  Guardar Cliente
                </button>
              </div>

            </form>"

          xgroup._last.onSubmit (evt) !->
            evt.prevent!

            xform = evt._target
            dto   = $ xform ._toJSON!

            customer = new App.model.Customer
            customer._save dto, do
              _success: !->
                @hasState = HAS_STATE.kHasCustomer

                xform._last.html "
                  <button type='button'
                       class='#{gz.Css \btn} #{gz.Css \btn-info}
                            \ #{gz.Css \pull-right}'>
                    Guardado
                  </button>"

              _error: !->
                alert 'ERROR: e55c580a-936f-11e3-97d3-88252caeb7e8'

  initialize: (options) !->
    @hasState = HAS_STATE.kNotFound
    @xsave    = options.xsave

  render: ->
    @formWith!
    super!

  hasState    : HAS_STATE.kNotFound
  declaration : null
  customer    : null
  xsave       : null
