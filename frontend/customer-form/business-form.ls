/**
 * @module customer-form
 */

BaseFormView = require './base-form'
ShareholdersView = require './shareholders'
model = require '../model'

/**
 * Business form view.
 * @public
 */
module.exports = class BusinessFormView extends BaseFormView

  /**
   * Get JSON business form.
   * @see customer-form.base-form.BaseFormView.commit
   * @override
   */
  getDataJSON: ->
    dataJSON = super!
    dataJSON <<< \shareholders : @shareholdersView.JSONFields!

  /**
   * Initialize business form.
   * @see BaseFormView
   * @override
   */
  initForm: !->
    block = "<div class='#{gz.Css \large-100}
                       \ #{gz.Css \medium-100}
                       \ #{gz.Css \small-100}'>"
    block50 = "<div class='#{gz.Css \large-50}
                         \ #{gz.Css \medium-100}
                         \ #{gz.Css \small-100}'>"
    controlGroup = "<div class='#{gz.Css \control-group}
                              \ #{gz.Css \large-100}
                              \ #{gz.Css \medium-100}
                              \ #{gz.Css \small-100}'>"
    controlGroup50 = "<div class='#{gz.Css \control-group}
                                \ #{gz.Css \large-50}
                                \ #{gz.Css \medium-50}
                                \ #{gz.Css \small-100}'>"
    label = "<label>"
    control = "<div class='#{gz.Css \control}'>"
    @$el.html "
      #controlGroup50
        #label
          <b>a)</b> Denominación o Razón Social
        </label>
        #control
          <input type='text' name='name'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>b)</b> RUC
        </label>
        #control
          <input type='text' name='documentNumber'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>c)</b> Objecto Social
        </label>
        #control
          <input type='text' name='socialObject'>
        </div>
      </div>

      #controlGroup50
        #label
          Actividad económica principal
        </label>
        #control
          <input type='text' name='activity'>
        </div>
      </div>

      <div id='#{gz.Css \id-shareholders}' class='#{gz.Css \large-100}
                \ #{gz.Css \medium-100}
                \ #{gz.Css \small-100}'>
        #label
          <b>d)</b> Identificación Accionistas
        </label>
      </div>

      #controlGroup50
        #label
          <b>e)</b> Identificación Representante Legal
        </label>
        #control
          <input type='text' name='legal'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>f)</b> Domicilio
        </label>
        #control
          <input type='text' name='address'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>g)</b> Domicilio fiscal
        </label>
        #control
          <input type='text' name='officialAddress'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>&nbsp;</b> &nbsp;
        </label>
        #control
          <input type='text' name='' style='visibility:hidden'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>h)</b> Teléfono oficina (incluir código ciudad)
        </label>
        #control
          <input type='text' name='phone'>
        </div>
      </div>

      #controlGroup50
        #label
          Persona contacto <b>&nbsp;</b>
        </label>
        #control
          <input type='text' name='contact'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>i)</b> Origen de los fondos
        </label>
        #control
          <select name='source'>
            <option>Efectivo</option>
            <option>Cheque</option>
            <option>Giro</option>
            <option>Transferencia bancaria</option>
            <option>Deposito en cuenta</option>
            <option>Tarjeta de crédito</option>
            <option>Bien mueble</option>
            <option>Bien inmueble</option>
            <option>Otro</option>
            <option>No efectivo</option>
          </select>
        </div>
      </div>

      #controlGroup50
        #label
          &nbsp;
        </label>
        #control
          <input type='text' name='' style='visibility:hidden'>
        </div>
      </div>

      #controlGroup
        <label class='#{gz.Css \large-50}
                    \ #{gz.Css \medium-50}
                    \ #{gz.Css \small-50}'>
          <b>j)</b> Sujeto Obligado informar UIF-Perú
        </label>
        <ul class='#{gz.Css \control}
                 \ #{gz.Css \unstyled}
                 \ #{gz.Css \inline}
                 \ #{gz.Css \large-50}
                  \ #{gz.Css \medium-50}
                  \ #{gz.Css \small-50}'>
          <li>
            <input type='radio' name='isObliged' value='Sí'>
            <label>Sí</label>
          </li>
          <li>
            <input type='radio' name='isObliged' value='No'>
            <label>No</label>
          </li>
        </ul>
      </div>

      #controlGroup
        <label class='#{gz.Css \large-50}
                    \ #{gz.Css \medium-50}
                    \ #{gz.Css \small-50}'>
          <b>&nbsp;&nbsp;</b> Designó Oficial de Cumplimiento
        </label>
        <ul class='#{gz.Css \control}
                 \ #{gz.Css \unstyled}
                 \ #{gz.Css \inline}
                 \ #{gz.Css \large-50}
                  \ #{gz.Css \medium-50}
                  \ #{gz.Css \small-50}'>
          <li>
            <input type='radio' name='hasOfficier' value='Sí'>
            <label>Sí</label>
          </li>
          <li>
            <input type='radio' name='hasOfficier' value='No'>
            <label>No</label>
          </li>
        </ul>
      </div>

      #controlGroup50
        #label
          <b>k)</b> Identificación Tercero
        </label>
        #control
          <input type='text' name='thirdName'>
        </div>
      </div>"
    @shareholdersView = new ShareholdersView
    $divShareholders = @$el.find "##{gz.Css \id-shareholders}"
    $divShareholders.append @shareholdersView.render!.el
    @shareholdersView.collection.set (@customer.get \shareholders)
