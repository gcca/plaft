Base = require './base'

FieldType         = App.builtins.Types.Field
$htmlControlGroup = App.shared.shortcuts.$html.controlGroup


module.exports = \

class Person extends Base

  render: ->
    for [field, fieldClass] in _.zip FIELDS, FIELDS_CLASS
      $controlGroup = $htmlControlGroup field
      $controlGroup.addClass fieldClass
      @$el._append $controlGroup

    @$el._find '[data-toggle=tooltip]' .tooltip!

    super!


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
    'Nombres y Apellidos'
    'Nombres y apellidos.'

  * 'document[type]'
    'b)'
    'Documento'
    'Tipo de documento de identidad.'
    FieldType.kComboBox
    * 'DNI'
      'Pasaporte'
      'Carné de extranjería'

  * 'document[number]'
    ''
    'Número'
    'Número del documento de identidad.'

  * 'business'
    'c)'
    'RUC <small>(de ser el caso)</small>'
    'Registro Único de Contribuyentes (RUC), de ser el caso.'

  * 'birthday'
    'd)'
    'Lugar y Fecha Nacimiento'
    'Lugar y fecha de nacimiento.'

  * 'nationality'
    'e)'
    'Nacionalidad'
    'Nacionalidad.'

  * 'address'
    'f)'
    'Domcilio declarado (lugar de residencia)'
    'Domicilio declarado (lugar de residencia).'

  * 'fiscal'
    'g)'
    'Domicilio fiscal <small>(de ser el caso)</small>'
    'Domicilio fiscal, de ser el caso.'

  * 'phone'
    'h)'
    'Teléfono fijo'
    'Número de teléfono fijo.'

  * 'mobile'
    ''
    'Celular'
    'Número de teléfono celular.'

  * 'email'
    'i)'
    'Correo electrónico'
    'Correo electrónico.'

  * 'activity'
    'j)'
    'Profesión u ocupación'
    'Profesión u ocupación.'

  * 'status'
    'k)'
    'Estado civil'
    'Estado civil.'

  * 'marital'
    '1)'
    'Nombre del cónyuge, de ser casado'
    'Nombre del cónyuge, de ser casado.'

  * null
    null
    null
    null

  * 'domestic'
    '2)'
    'Conviviente, consignar nombre'
    'Si declara ser conviviente, consignar nombre'

  * 'public'
    'l)'
    'Cargo o función pública en el Perú o extranjero - Nombre organismo'
    'Cargo o función pública que desempeña o que haya desempeñado en los
     \ últimos dos (2) años, en el Perú o en el extranjero, indicando el
     \ nombre del organismo público u organización internacional.'

  * 'source'
    'm)'
    'Origen de los fondos'
    'El origen de los fondos, bienes u otros activos involucrados en dicha
     \ transacción.'
    FieldType.kComboBox
    * 'Efectivo'
      'Cheque'
      'Giro'
      'Transferencia bancaria'
      'Deposito en cuenta'
      'Tarjeta de crédito'
      'Bien mueble'
      'Bien inmueble'
      'Otro'
      'No efectivo'

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

FIELDS_CLASS =
  gz.Css \col-md-6
  gz.Css \col-md-3
  gz.Css \col-md-3
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-3
  gz.Css \col-md-3
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
  gz.Css \col-md-6
