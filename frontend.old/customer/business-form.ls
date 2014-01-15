/** @module customer-form */

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
                              \ #{gz.Css \small-100}
                              \ #{gz.Css \parent-toggle}'>"

    controlGroup50 = "<div class='#{gz.Css \control-group}
                                \ #{gz.Css \large-50}
                                \ #{gz.Css \medium-50}
                                \ #{gz.Css \small-100}
                                \ #{gz.Css \parent-toggle}'>"

    label = "<label>"

    control       = "<div class='#{gz.Css \control} #{gz.Css \append-symbol}'>"
    controlSingle = "<div class='#{gz.Css \control}'>"

    @$el.html "
      #controlGroup50
        #label
          <b>a)</b> Denominación o Razón Social
        </label>
        #control
          <span>
            <input type='text' name='name'>
            <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
                data-tip-text='Denominación o razón social.'></i>
          </span>
        </div>
      </div>

      #controlGroup50
        #label
          <b>b)</b> RUC
        </label>
        #control
          <span>
            <input type='text' name='documentNumber'>
            <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
                data-tip-text='Registro Único de Contribuyentes (RUC),
                              \ de ser el caso.'></i>
          </span>
        </div>
      </div>

      #controlGroup50
        #label
          <b>c)</b> Objecto Social
        </label>
        #control
          <span>
            <input type='text' name='socialObject'>
            <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
                data-tip-text='Objeto social'></i>
          </span>
        </div>
      </div>

      #controlGroup50
        #label
          Actividad económica principal
        </label>
        #control
          <span>
            <input type='text' name='activity'>
            <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
                data-tip-text='Actividad económica principal (comercial,
                              \ industrial, construcción, transporte,
                              \ etc.).'></i>
          </span>
        </div>
      </div>

      <div id='#{gz.Css \id-shareholders}'
          class='#{gz.Css \large-100}
               \ #{gz.Css \medium-100}
               \ #{gz.Css \small-100}
               \ #{gz.Css \parent-toggle}'>
        #label
          <b>d)</b> Identificación Accionistas
          &nbsp;&nbsp;&nbsp;&nbsp;
          <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
               data-tip-text='Identificación de los accionistas, socios
                             \ o asociados, que tengan un porcentaje igual
                             \ o mayor al 5% de las acciones
                             \ o participaciones de la persona jurídica.'></i>
        </label>
      </div>

      #controlGroup50
        #label
          <b>e)</b> Identificación Representante Legal
        </label>
        #control
          <span>
            <input type='text' name='legal'>
            <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
                data-tip-text='Identificación del representante legal
                              \ o de quien comparece con facultades
                              \ de representación y/o disposición
                              \ de la persona jurídica.'></i>
          </span>
        </div>
      </div>

      #controlGroup50
        #label
          <b>f)</b> Domicilio
        </label>
        #control
          <span>
            <input type='text' name='address'>
            <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
                data-tip-text='Domicilio.'></i>
          </span>
        </div>
      </div>

      #controlGroup50
        #label
          <b>g)</b> Domicilio fiscal
        </label>
        #control
          <span>
            <input type='text' name='officialAddress'>
            <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
                data-tip-text='Domicilio fiscal.'></i>
          </span>
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
          <span>
            <input type='text' name='' style='visibility:hidden'>
            <i class='#{gz.Css \icon}-'></i>
          </span>
        </div>
      </div>

      #controlGroup50
        #label
          <b>h)</b> Teléfono oficina (incluir código ciudad)
        </label>
        #control
          <span>
            <input type='text' name='phone'>
            <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
                data-tip-text='Teléfonos fijos de la oficina y/o de la persona
                              \ de contacto incluyendo el código de la ciudad,
                              \ sea que se trate del local principal, agencia,
                              \ sucursal u otros locales donde desarrollan
                              \ las actividades propias al giro
                              \ de su negocio.'></i>
          </span>
        </div>
      </div>

      #controlGroup50
        #label
          Persona contacto <b>&nbsp;</b>
        </label>
        #control
          <span>
            <input type='text' name='contact'>
            <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
                data-tip-text='Nombre de la persona de contacto.'></i>
          </span>
        </div>
      </div>

      #controlGroup50
        #label
          <b>i)</b> Origen de los fondos
          &nbsp;&nbsp;&nbsp;&nbsp;
          <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
              data-tip-text='El origen de los fondos, bienes u otros activos
                            \ involucrados en dicha transacción.'></i>
        </label>
        #controlSingle
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

      <div class='#{gz.Css \control-group}
                \ #{gz.Css \large-50}
                \ #{gz.Css \medium-50}
                \ #{gz.Css \small-100}
                \ #{gz.Css \hide-small}'>
        #label
          &nbsp;
        </label>
        #control
          <span>
            <input type='text' name='' style='visibility:hidden'>
            <i class='#{gz.Css \icon}-'></i>
          </span>
        </div>
      </div>

      #controlGroup
        <label class='#{gz.Css \large-50}
                    \ #{gz.Css \medium-50}
                    \ #{gz.Css \small-50}'>
          <b>j)</b> Sujeto Obligado informar UIF-Perú
          &nbsp;&nbsp;&nbsp;&nbsp;
          <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
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
          <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
              data-tip-text='En caso marcó SI, indique si designó
                            \ a su Oficial de Cumplimiento.'></i>
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
          <span>
            <input type='text' name='thirdName'>
            <i class='#{gz.Css \icon-question} #{gz.Css \toggle}'
                data-tip-text='Identificación del tercero, sea persona
                              \ natural (nombres y apellidos) o persona
                              \ jurídica (razón o denominación social)
                              \ por cuyo intermedio se realiza la operación,
                              \ de ser el caso.'></i>
          </span>
        </div>
      </div>"

    # Shareholders View
    @shareholdersView = new ShareholdersView
    $divShareholders = @$el.find "##{gz.Css \id-shareholders}"
    $divShareholders.append @shareholdersView.render!.el
    @shareholdersView.collection.set (@customer.get \shareholders)
