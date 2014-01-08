/** @module customer-form */

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
                              \ #{gz.Css \small-100}
                              \ #{gz.Css \parent-toggle}'>"

    controlGroup50 = "<div class='#{gz.Css \control-group}
                                \ #{gz.Css \large-50}
                                \ #{gz.Css \medium-50}
                                \ #{gz.Css \small-100}
                                \ #{gz.Css \parent-toggle}'>"

    controlGroup25 = "<div class='#{gz.Css \control-group}
                                \ #{gz.Css \large-25}
                                \ #{gz.Css \medium-25}
                                \ #{gz.Css \small-100}
                                \ #{gz.Css \parent-toggle}'>"

    label = "<label>"

    control = "<div class='#{gz.Css \control}'>"

    @$el.html "
      #controlGroup50
        #label
          <b>a)</b> Nombres y Apellidos
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Nombres y apellidos.'></i>
        </label>
        #control
          <input type='text' name='name'>
        </div>
      </div>

      #controlGroup25
        #label
          <b>b)</b> Documento
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Tipo de documento de identidad.'></i>
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
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Número del documento de identidad.'></i>
        </label>
        #control
          <input type='text' name='documentNumber'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>c)</b> RUC <small>(de ser el caso)</small>
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Registro Único de Contribuyentes (RUC),
                            \ de ser el caso.'></i>
        </label>
        #control
          <input type='text' name='businessNumber'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>d)</b> Lugar y Fecha Nacimiento
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Lugar y fecha de nacimiento.'></i>
        </label>
        #control
          <input type='text' name='birthday'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>e)</b> Nacionalidad
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Nacionalidad.'></i>
        </label>
        #control
          <input type='text' name='nationality'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>f)</b> Domcilio declarado (lugar de residencia)
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Domicilio declarado (lugar de residencia).'></i>
        </label>
        #control
          <input type='text' name='address'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>g)</b> Domcilio fiscal <small>(de ser el caso)</small>
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Domicilio fiscal, de ser el caso.'></i>
        </label>
        #control
          <input type='text' name='officialAddress'>
        </div>
      </div>

      #controlGroup25
        #label
          <b>h)</b> Teléfono fijo
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Número de teléfono fijo.'></i>
        </label>
        #control
          <input type='text' name='phone'>
        </div>
      </div>

      #controlGroup25
        #label
          <b>&nbsp;</b> Celular
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Número de teléfono celular.'></i>
        </label>
        #control
          <input type='text' name='mobile'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>i)</b> Correo electrónico
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Correo electrónico.'></i>
        </label>
        #control
          <input type='text' name='email'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>j)</b> Profesión u ocupación
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Profesión u ocupación.'></i>
        </label>
        #control
          <input type='text' name='activity'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>k)</b> Estado civil
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Estado civil.'></i>
        </label>
        #control
          <input type='text' name='civilStatus'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>1)</b> Nombre del cónyuge, de ser casado
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Nombre del cónyuge, de ser casado.'></i>
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
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Si declara ser conviviente, consignar nombre'></i>
        </label>
        #control
          <input type='text' name='domesticPartner'>
        </div>
      </div>

      #controlGroup50
        #label
          <b>j)</b> Cargo o función pública en el Perú o extranjero -
                  \ Nombre organismo
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Cargo o función pública que desempeña o que haya
                            \ desempeñado en los últimos dos (2) años,
                            \ en el Perú o en el extranjero, indicando
                            \ el nombre del organismo público u organización
                            \ internacional.'></i>
        </label>
        #control
          <input type='text' name='publicOffice'>
        </div>
      </div>

      <div class='#{gz.Css \control-group}
                \ #{gz.Css \large-50}
                \ #{gz.Css \medium-50}
                \ #{gz.Css \small-100}
                \ #{gz.Css \ink-clear-left}
                \ #{gz.Css \parent-toggle}'>
        #label
          <b>m)</b> Origen de los fondos
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='El origen de los fondos, bienes u otros
                            \ activos involucrados en dicha transacción.'></i>
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
          &nbsp;&nbsp;&nbsp;&nbsp;
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \toggle}'
              data-tip-text='¿Es sujeto obligado informar a la UIF-Perú?'></i>
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
          &nbsp;&nbsp;&nbsp;&nbsp;
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \toggle}'
              data-tip-text='En caso marcó SI, indique si designó a su
                            \ Oficial de Cumplimiento.'></i>
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
          <b>o)</b> Identificación Tercero
          <i class='#{gz.Css \icon-question}
                  \ #{gz.Css \push-right}
                  \ #{gz.Css \toggle}'
              data-tip-text='Identificación del tercero, sea persona natural
                            \ (nombres y apellidos) o persona jurídica
                            \ (razón o denominación social) por cuyo
                            \ intermedio se realiza la operación,
                            \ de ser el caso.'></i>
        </label>
        #control
          <input type='text' name='thirdName'>
        </div>
      </div>"
