/**
 * @module customer-form
 */

BaseFormView = require './base-form'
ShareholdersView = require './shareholders'
form = require '../form'

/**
 * Business form view.
 * @public
 */
module.exports = class BusinessFormView extends BaseFormView

    /**
     * Get JSON business form.
     * @override
     */
    getDataJSON : ->
        dataJSON = super!
        dataJSON <<< \shareholders : @shareholdersView.zJSON!

    /**
     * Initialize business form.
     * @override
     */
    initForm : !->
        customer = @customer
        @el.innerHTML = "
        #{form.block50}

          <fieldset>
            <legend>Razón Social</legend>
            #{form.control-group}
              #{form.controlSym100}
                <span>
                  <input type='text' name='name' placeholder='Razón social'>
                  <i class='#{gz.Css \icon-group}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Demoninación o razón social'></i>
                </span>
              </div>
            </div>
          </fieldset>


          <fieldset>
            <legend>RUC</legend>
            #{form.control-group}
              #{form.controlSym}
                <span>
                  <input type='text' name='documentNumber' placeholder='RUC'>
                  <i class='#{gz.Css \icon-barcode}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Registro Unico de Contribuyentes (RUC)'></i>
                </span>
              </div>
            </div>
          </fieldset>


          <fieldset>
            <legend>Objeto Social y Actividad Economica</legend>
            #{form.control-group}
              #{form.controlSym100}
                <span>
                  <input type='text' name='socialObject' placeholder='Objeto social'>
                  <i class='#{gz.Css \icon-sign-blank}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Objeto social'></i>
                </span>
              </div>
            </div>

            #{form.control-group}
              #{form.controlSym100}
                <span>
                  <input type='text' name='activityEconomic' placeholder='Actividad economica principal'>
                  <i class='#{gz.Css \icon-tasks}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Actividad económica principal (comercial, industrial, construcción, transporte, etc.)'></i>
                </span>
              </div>
            </div>

          </fieldset>



          <fieldset>
            <legend>Accionistas</legend>
            #{form.control-group}
              #{form.controlSym100}
                <span>
                <div class='#{gz.Css \gz-customsbroker-sel-shareholders}'></div>
                <i class='#{gz.Css \icon-group}'
                   data-tip-color='#{gz.Css \blue}'
                   data-tip-text='Identificación de los accionistas, socios o asociados que tengan un porcentaje igual o mayor al 5% de las acciones o participaciones de la persona jurídica'></i>
                </span>
              </div>

            </div>

          </fieldset>





          <fieldset>
            <legend>Identificación de Representante Legal</legend>

            #{form.control-group}
              #{form.controlSym100}
                <span>
                  <input type='text' name='legalName' placeholder='Nombre representante legal'>
                  <i class='#{gz.Css \icon-user}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Identificación del representante legal o de quien comparece con facultades de representación y/o disposición de la persona jurídica.'></i>
                </span>
              </div>
            </div>

            #{form.control-group}
              #{form.controlSym100}
                <span>
                  <select name='legalDocumentType'>
                    <option value='DNI'>DNI</option>
                    <option value='CE'>Carné de extranjería</option>
                    <option value='PA'>Pasaporte</option>
                    <option>Otro</option>
                  </select>
                  <i class='#{gz.Css \icon-credit-card}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Tipo de documento de identidad del Representante Legal'></i>
                </span>
              </div>
            </div>

            #{form.control-group}
              #{form.controlSym100}
                <span>
                  <input type='text' name='legalDocumentNumber' placeholder='Número de identificación'>
                  <i class='#{gz.Css \icon-credit-card}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Número de identificación a persona jurídica.'></i>
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
                  <input type='text' name='address' placeholder='Domicilio declarado'>
                  <i class='#{gz.Css \icon-home}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Domicilio principal de la persona jurídica'></i>
                </span>
              </div>
            </div>
          </fieldset>


          <fieldset>
            <legend>Domicilio Fiscal</legend>
            #{form.control-group}
              #{form.controlSym100}
                <span>
                  <input type='text' name='officialAddress' placeholder='Domicilio fiscal'>
                  <i class='#{gz.Css \icon-home}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Domicilio fiscal de la persona jurídica'></i>
                </span>
              </div>
            </div>
          </fieldset>
        </div>



        #{form.block50}
          <fieldset>

            <legend>Datos Persona Contacto</legend>
            #{form.control-group}
              #{form.controlSym100}
                <span>
                <input type='text' name='contactPhone' placeholder='Teléfono contacto'>
                <i class='#{gz.Css \icon-phone}'
                    data-tip-color='#{gz.Css \blue}'
                    data-tip-text='Teléfono fijo de la persona de contacto'></i>
                </span>
              </div>
            </div>

            #{form.control-group}
              #{form.controlSym100}
                <span>
                  <input type='text' name='officePhone' placeholder='Teléfono oficina'>
                  <i class='#{gz.Css \icon-phone}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Teléfono fijo de la oficina de la persona de contacto'></i>
                </span>
              </div>
            </div>



            #{form.control-group}
              #{form.controlSym100}
                <span>
                <input type='text' name='addressCityCode'
                    placeholder='Código Postal'>
                <i class='#{gz.Css \icon-envelope}'
                    data-tip-color='#{gz.Css \blue}'
                    data-tip-text='Código postal de la persona contacto'></i>
                </span>
              </div>
            </div>


            #{form.control-group}
              #{form.controlSym100}
                <span>
                  <input type='text' name='contact' placeholder='Nombre de Persona de Contacto'>
                  <i class='#{gz.Css \icon-user}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='Persona a contactar'></i>
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
                  <input type='checkbox' name='isObliged'>
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
                ¿Designó a su oficial de Cumplimiento?
              </label>
              <div class='#{gz.Css \control}
                        \ #{gz.Css \large-25}
                        \ #{gz.Css \medium-25}
                        \ #{gz.Css \small-25}
                        \ #{gz.Css \append-symbol}'>
                <span>
                  <input type='checkbox' name='hasOfficier'>
                  <i class='#{gz.Css \icon-user}'
                      data-tip-color='#{gz.Css \blue}'
                      data-tip-text='¿Designó a su oficial de Cumplimiento?'></i>
                </span>
              </div>
            </div>

          </fieldset>

        </div>

        </div>"
        # Append shareholder view.
        div = @el.querySelector ".#{gz.Css \gz-customsbroker-sel-shareholders}"
        shareholdersView = \
             new ShareholdersView do
                 shareholders : @customer.get \shareholders
        div.appendChild shareholdersView.el
        @shareholdersView = shareholdersView
        ## #{form.control-group}
        ##   #{form.label100}
        ##     Origen de Fondos
        ##   </label>
        ##   #{form.control100}
        ##     <textarea name='moneySource' placeholder='Especifique el origen de los fondos, bienes u otros activos involucrados en la transacción.'></textarea>
        ##   </div>
        ## </div>
