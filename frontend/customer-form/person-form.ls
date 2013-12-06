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
    customer = @customer
    @el.innerHTML = "
    #{form.block50}
      <fieldset>
        <legend>Nombres y apellidos</legend>
        #{form.control-group}
          #{form.controlSym100}
            <span>
              <input type='text' name='name'
                  placeholder='Nombres y apellidos'>
              <i class='#{gz.Css \icon-user}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Nombres y apellidos'></i>
            </span>
          </div>
        </div>
      </fieldset>

      <fieldset>
        <legend>Documento de identidad</legend>
        #{form.control-group}
          #{form.controlSym100}
            <span>
              <select name='documentType'>
                <option value='DNI'>DNI</option>
                <option value='CE'>Carné de extranjería</option>
                <option value='PA'>Pasaporte</option>
                <option>Otro</option>
              </select>
              <i class='#{gz.Css \icon-credit-card}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Tipo de documento de identidad'></i>
            </span>
          </div>
        </div>

        #{form.control-group}
          #{form.controlSym100}
            <span>
              <input type='text' name='documentNumber' placeholder='Número de documento'>
              <i class='#{gz.Css \icon-credit-card}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Número del documento de identidad'></i>
            </span>
          </div>
        </div>
      </fieldset>

      <fieldset>
        <legend>Nacimiento</legend>
        #{form.control-group}
          #{form.controlSym100}
            <span>
              <input type='text' name='birthPlace' placeholder='Lugar de nacimiento'>
              <i class='#{gz.Css \icon-flag-checkered}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Lugar de nacimiento'></i>
            </span>
          </div>
        </div>

        #{form.control-group}
          #{form.controlSym100}
            <span>
              <input type='text' name='birthday' placeholder='Fecha de nacimiento'>
              <i class='#{gz.Css \icon-calendar}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Fecha de nacimiento'></i>
            </span>
          </div>
        </div>
      </fieldset>

      <fieldset>
        <legend>Información</legend>
        #{form.control-group}
          <label class='#{gz.Css \large-75}
                      \ #{gz.Css \medium-75}
                      \ #{gz.Css \small-75}'>
            ¿Es sujeto obligado informar a la UIF-Perú?
          </label>
          <div class='#{gz.Css \control}
                    \ #{gz.Css \large-25}
                    \ #{gz.Css \medium-25}
                    \ #{gz.Css \small-25}
                    \ #{gz.Css \append-symbol}'>
            <span>
              <input type='checkbox' name='isObliged'
                  class='#{gz.Css \check-yesno}'>
              <span></span>
              <i class='#{gz.Css \icon-legal}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='¿Es sujeto obligado informar a la UIF-Perú?'></i>
            </span>
          </div>
        </div>
        #{form.control-group}
          <label class='#{gz.Css \large-75}
                      \ #{gz.Css \medium-75}
                      \ #{gz.Css \small-75}'>
            ¿Designó a su Oficial de Cumplimiento?
          </label>
          <div class='#{gz.Css \control}
                    \ #{gz.Css \large-25}
                    \ #{gz.Css \medium-25}
                    \ #{gz.Css \small-25}
                    \ #{gz.Css \append-symbol}'>
            <span>
              <input type='checkbox' name='hasOfficier'
                  class='#{gz.Css \check-yesno}'>
              <span></span>
              <i class='#{gz.Css \icon-user}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='¿Designó a su Oficial de Cumplimiento?'></i>
            </span>
          </div>
        </div>

      </fieldset>
    </div>

    #{form.block50}
      <fieldset>
        <legend>Domicilio</legend>
        #{form.control-group}
          #{form.controlSym100}
            <span>
              <input type='text' name='addressLegal' placeholder='Domicilio declarado'>
              <i class='#{gz.Css \icon-home}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Domicilio declarado (Lugar de Residencia)'></i>
            </span>
          </div>
        </div>


        #{form.control-group}
          #{form.controlSym100}
            <span>
              <input type='text' name='addressFiscal' placeholder='Domicilio fiscal'>
              <i class='#{gz.Css \icon-home}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Domicilio Fiscal'></i>
            </span>
          </div>
        </div>

      </fieldset>



      <fieldset>

        <legend>Trabajo</legend>
        #{form.control-group}
          #{form.controlSym100}
            <span>
              <input type='text' name='activity' placeholder='Profesión'>
              <i class='#{gz.Css \icon-briefcase}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Profesión u Ocupación'></i>
            </span>
          </div>
        </div>

        #{form.control-group}
          #{form.controlSym100}
            <span>
              <input type='text' name='role' placeholder='Cargo o función publica'>
              <i class='#{gz.Css \icon-user}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Cargo o función pública que haya desempeñado en los últimos dos (2) años, en el Perú o en el extranjero.'></i>
            </span>
          </div>
        </div>

        #{form.control-group}
          #{form.controlSym100}
            <span>
              <input type='text' name='organization' placeholder='Organización'>
              <i class='#{gz.Css \icon-screenshot}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Nombre del oraganismo público u organización internacional en donde haya desempeñado el cargo o función publica'></i>
            </span>
          </div>
        </div>


        #{form.control-group}
          #{form.controlSym}
            <span>
              <input type='text' name='businessNumber' placeholder='RUC'>
              <i class='#{gz.Css \icon-credit-card}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='RUC del oraganismo público u organización internacional'></i>
            </span>
          </div>
        </div>

      </fieldset>


      <fieldset>
        <legend>Estado Civil</legend>
        #{form.control-group}
          #{form.controlSym100}
            <span>
              <input type='text' name='partner' placeholder='Nombre conyuge o conviviente'>
              <i class='#{gz.Css \icon-user}'
                  data-tip-color='#{gz.Css \blue}'
                  data-tip-text='Nombre de cónyuge, de ser casado. Si declara ser conviviente, consignar nombre'></i>
            </span>
          </div>
        </div>
      </fieldset>



    </div>"
    # Set {@code input} birthday as date picker.
    dp = new gz.Ink.UI.DatePicker @el.querySelector '[name=birthday]'
