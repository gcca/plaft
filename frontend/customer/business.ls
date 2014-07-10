/** @module customer.business */

Base         = require './base'
Shareholders = require './business/shareholders'

FieldType         = App.builtins.Types.Field
$htmlControlGroup = App.shared.shortcuts.$html.controlGroup


/**
 * Business customer form.
 * @class UiBusiness
 * @extends UiBase
 */
class Business extends Base

  /** @override */
  _toJSON: ->
    super!
      ..\shareholders = @shareholders._toJSON!

  /** @override */
  render: ->
    for field in FIELDS
      if field.4 is FieldType.kView
        @shareholders = new Shareholders do
                          shareholders : @model.attributes\shareholders
        field.5 = @shareholders
        $controlGroup = $htmlControlGroup field
        $controlGroup.addClass gz.Css \col-md-12
      else
        $controlGroup = $htmlControlGroup field
        $controlGroup.addClass gz.Css \col-md-6
      @$el._append $controlGroup

    # Hidden fields
    @$el._append "<input type='hidden' name='document[type]' value='RUC'>"

    @$ '[data-toggle=tooltip]' .tooltip!

    super!


/** @export */
module.exports = Business

/**
 * [
 *   0 Input name
 *   1 Bulleted
 *   2 Description
 *   3 Tooltip
 *   4 TYPE
 * ]
 */
FIELDS =
  * 'name'
    'a)'
    'Denominación o Razón Social'
    'Denominación o razón social'

  * 'document[number]'
    'b)'
    'RUC'
    'Registro Único de Contribuyentes (RUC).'

  * 'social'
    'c)'
    'Objecto Social'
    'Objecto social'

  * 'activity'
    ''
    'Actividad económica principal'
    'Actividad económica principal (comercial, industrial, construcción,
     \ transporte, etc.).'

  * null
    'd)'
    'Identificación Accionistas'
    'Identificación de los accionistas, socios o asociados, que tengan un
     \ porcentaje igual o mayor al 5% de las acciones o participaciones
     \ de la persona jurídica.'
    FieldType.kView
    null

  * 'legal'
    'e)'
    'Identificación Representante Legal'
    'Identificación del representante legal o de quien comparece con facultades
     \ de representación y/o disposición de la persona jurídica.'

  * 'address'
    'f)'
    'Domicilio'
    'Domicilio'

  * 'fiscal'
    'g)'
    'Domicilio fiscal'
    'Domicilio fiscal'

  * null
    null
    null
    null

  * 'phone'
    'h)'
    'Teléfono oficina (incluir código ciudad)'
    'Teléfonos fijos de la oficina y/o de la persona de contacto incluyendo
     \ el código de la ciudad, sea que se trate del local principal, agencia,
     \ sucursal u otros locales donde desarrollan las actividades propias al
     \ giro de su negocio.'

  * 'contact'
    ''
    'Persona contacto'
    'Nombre de la persona de contacto.'

  * 'source'
    'i)'
    'Origen de los fondos'
    'El origen de los fondos, bienes u otros activos involucrados en dicha
     \ transacción.'
    FieldType.kComboBox
    App.shared.lists.SOURCE_TYPE

  * null
    null
    null
    null

  * 'isobliged'
    'j)'
    'Sujeto Obligado informar UIF-Perú'
    '¿Es sujeto obligado informar a la UIF-Perú?'
    FieldType.kRadioGroup
    * 'Sí'
      'No'

  * 'hasofficer'
    ''
    'Designó Oficial de Cumplimiento'
    'En caso marcó SI, indique si designó a su Oficial de Cumplimiento.'
    FieldType.kRadioGroup
    * 'Sí'
      'No'

  * 'third'
    'k)'
    'Identificación Tercero'
    'Identificación del tercero, sea persona natural (nombres y apellidos)
     \ o persona jurídica (razón o denominación social) por cuyo intermedio
     \ se realiza la operación, de ser el caso.'
