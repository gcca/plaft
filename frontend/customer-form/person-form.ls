/**
 * @module customer-form
 */

BaseFormView = require './base-form'
form = require '../form'

/**
 * Person form view.
 * @public
 */
module.exports = class PersonFormView extends BaseFormView

  /**
   * Initialize person form.
   * @override
   */
  initForm : !->
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
    controlGroup25 = "<div class='#{gz.Css \control-group}
                                \ #{gz.Css \large-25}
                                \ #{gz.Css \medium-25}
                                \ #{gz.Css \small-100}'>"
    label = "<label>"
    control = "<div class='#{gz.Css \control}'>"
    @$el.html "
      #controlGroup50
        #label
          <b>a)</b> Nombres y Apellidos
        </label>
        #control
          <input type='text' name='name'>
        </div>
      </div>

      #controlGroup25
        #label
          <b>b)</b> Documento
        </label>
        #control
          <select name='documentType'>
            <option value='DNI'>DNI</option>
            <option value='PA'>Pasaporte</option>
            <option value='CE'>Carné de extranjería</option>
          </select>
        </div>
      </div>

      #controlGroup25
        #label
          <b>&nbsp;</b> Número
        </label>
        #control
          <input type='text' name='documentNumber'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>c)</b> RUC <small>(de ser el caso)</small>
        </label>
        #control
          <input type='text' name='businessNumber'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>d)</b> Lugar y Fecha Nacimiento
        </label>
        #control
          <input type='text' name='birthday'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>e)</b> Nacionalidad
        </label>
        #control
          <input type='text' name='nationality'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>f)</b> Domcilio declarado (lugar de residencia)
        </label>
        #control
          <input type='text' name='address'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>g)</b> Domcilio fiscal <small>(de ser el caso)</small>
        </label>
        #control
          <input type='text' name='officialAddress'>
        </div>
      </div>

      #controlGroup25
        #label
          <b>h)</b> Teléfono fijo
        </label>
        #control
          <input type='text' name='phone'>
        </div>
      </div>

      #controlGroup25
        #label
          <b>&nbsp;</b> Celular
        </label>
        #control
          <input type='text' name='mobile'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>i)</b> Correo electrónico
        </label>
        #control
          <input type='text' name='email'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>j)</b> Profesión u ocupación
        </label>
        #control
          <input type='text' name='activity'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>k)</b> Estado civil
        </label>
        #control
          <input type='text' name='civilStatus'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>1)</b> Nombre del cónyuge, de ser casado
        </label>
        #control
          <input type='text' name='maritalPartner'>
        </div>
      </div>

      <div class='#{gz.Css \control-group}
                \ #{gz.Css \large-50}
                \ #{gz.Css \medium-50}
                \ #{gz.Css \small-100}
                \ #{gz.Css \hide-small}'>
        #label
          <b>&nbsp;</b> &nbsp;
        </label>
        #control
          &nbsp;
        </div>
      </div>

      #controlGroup50
        #label
          <b>2)</b> Conviviente, consignar nombre
        </label>
        #control
          <input type='text' name='domesticPartner'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>j)</b> Cargo o función pública en el Perú o extranjero - Nombre organismo
        </label>
        #control
          <input type='text' name='publicOffice'>
        </div>
      </div>

      <div class='#{gz.Css \control-group}
                \ #{gz.Css \large-50}
                \ #{gz.Css \medium-50}
                \ #{gz.Css \small-100}
                \ #{gz.Css \ink-clear-left}'>
        #label
          <b>m)</b> Origen de los fondos
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

      #controlGroup
        <label class='#{gz.Css \large-50}
                    \ #{gz.Css \medium-50}
                    \ #{gz.Css \small-50}'>
          <b>n)</b> Sujeto Obligado informar UIF-Perú
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

      <br><br>"
