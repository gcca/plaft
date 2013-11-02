form   = require '../form'
model  = require '../model'
widget = require '../widget'

DeclarationModel = model.Declaration

/**
 * Create HTML form declaration-view
 * @class DeclarationFormView
 */
module.exports = class DeclarationFormView extends gz.GView
    /**
     * DOM element
     * @override
     */
    tagName: \form

    events :
        /**
         * Event for collapsible {@code div} of third.
         * @param {EventTarget} event
         */
        'change input[name=third]' : !(event) ->
            input   = event.currentTarget
            control = input.parentElement.parentElement
            control.classList.toggle gz.Css \declaration-third-hidden

    /**
     * Send declaration data.
     */
    commit : !(customer) ->
        # (-o-) get moneySource
        customer.createDeclaration @zJSON!, @commitOptions

    /**
     * Get JSON form.
     */
    zJSON: -> @$el.serializeJSON!

    /**
     * Initialize declaration form view.
     */
    initialize: !->
        /**
         * Used in commit method for create a declaration.
         * @private
         */
        @commitOptions =
            \success : gz.tie @, !(declaration) ->
                @trigger (gz.Css \event-created-declaration), declaration
            \error : ->
                alert 'ERROR declaration'
        @render!

    /**
     * Form style
     * @type {string}
     * @override
     */
    className : "#{gz.Css \ink-form}
               \ #{gz.Css \top-space}
               \ #{gz.Css \column-group}
               \ #{gz.Css \gutters}
               \ #{gz.Css \declaration-form}"

    /**
     * Render declaration view
     * @override
     */
    render : ->
        @$el.html @gtemplate!
        new widget.GTypeahead \el : (@$el.find '[name=references]' .get 0)
        super!

    /**
     * Form template
     */
    gtemplate : -> "
    #{form.block50}
      <fieldset>
        <legend>Origen de los fondos</legend>

        #{form.control-group}
          #{form.label}
            Origen
          </label>
          #{form.control}
            <select name='moneySource'>
              <option>Efectivo</option>
              <option>No Efectivo</option>
            </select>
          </div>
        </div>
      </fieldset>

      <fieldset>
        #{form.control-group}
          #{form.label100}
            Referencias
          </label>
          #{form.controlSym100}
            <span>
              <input type='text' name='references'
                  placeholder='Referencias del cliente'>
              <i class='#{gz.Css \icon-check-minus}'></i>
            </span>
          </div>
        </div>
      </fieldset>
    </div>

    #{form.block50}
      <fieldset>
        <div class='#{gz.Css \control-group}
                  \ #{gz.Css \column-group}
                  \ #{gz.Css \gutters}
                  \ #{gz.Css \declaration-third}
                  \ #{gz.Css \declaration-third-hidden}'>
          #{form.labelCheck}
            <h6>¿Existe un tercero?</h6>
          </label>
          #{form.controlCheck}
            <input type='checkbox' name='third'>
          </div>
        </div>

        #{form.control-group}
          #{form.label}
            Tipo
          </label>
          #{form.control}
            <select name='thirdType'>
              <option value='person'>Persona Natural</option>
              <option value='business'>Persona Jurídica</option>
            </select>
          </div>
        </div>

        #{form.control-group}
          #{form.label}
            Nombre
          </label>
          #{form.control}
            <input type='text' name='thirdName'
                placeholder='Nombres y Apellidos o Razón Social'>
          </div>
        </div>

        #{form.control-group}
          #{form.label}
            Tipo
          </label>
          #{form.control}
            <select name='thirdDocumentType'>
              <option value='DNI'>DNI</option>
              <option value='RUC'>RUC</option>
              <option value='CE'>Carné de extranjería</option>
              <option value='PA'>Pasaporte</option>
            </select>
          </div>
        </div>

        #{form.control-group}
          #{form.label}
            Número
          </label>
          #{form.control}
            <input type='text' name='thirdDocumentNumber'
                placeholder='Número de DNI o RUC'>
          </div>
        </div>
      </fieldset>
    </div>"
