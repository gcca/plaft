/** @module dashboard.module.dispatch */

SectionBaseView = require './base'
globalOptions = require '../../../globalOptions'
widget = require '../../../widget'


/**
 * @see ITYPES
 * @private
 */
FieldType =
  TEXT      : 1
  SELECT    : 2
  TEXTAREA  : 3
  TYPEAHEAD : 4

/**
 * Internal types
 * Lista de campos asociados al declarante, ordenante, destinatario, tercero.
 * [
 *   [
 *     'código del campo'  # input(name='$')
 *     'descripción'       # .control-group -> label
 *     'opciones'          # (opcional) Array de opciones (<select>)
 *     'tipo de opciones'  # (opcional) Tipo de input. (text, typeahead)
 *   ],
 *   [
 *     ...
 *   ],
 *   ...
 * ]
 * @private
 */
ITYPES =
  # DECLARANT ----------------------------------------------------------------
  * * '9'
      'La persona que solicita o físicamente realiza la operación actúa en representación del:'
      * '(1) Ordenante'
        '(2) Beneficiario'
    * '10'
      'Condición de residencia de la persona que solicita o físicamente realiza la operación:'
      * '(1) Residente'
        '(2) No residente'
    * '11'
      'Tipo de documento la persona que solicita o físicamente realiza la operación'
      globalOptions.IDENTIFICATION  # (Table Nº 1)
    * '12'
      'Número de documento de la persona que solicita o físicamente realiza la operación.'
      null
    * '13'
      'País de emisión del documento de la persona que solicita o físicamente realiza la operación, en caso sea un documento emitido en el extranjero.'
      null
    * '14'
      'Apellido paterno de la persona que solicita o físicamente realiza la operación.'
      null
    * '15'
      'Apellido materno de la persona que solicita o físicamente realiza la operación.'
      null
    * '16'
      'Nombres de la persona que solicita o físicamente realiza la operación.'
      null
    * '17'
      'Nacionalidad de la persona que solicita o físicamente realiza la operación.'
      null
    * '18'
      'Ocupación, oficio o profesión de la persona que solicita o físicamente realiza la operación:'
      globalOptions.ACTIVITY  # Tabla Nº 2
      FieldType.TYPEAHEAD
    * '19'
      'Descripción de la ocupación, oficio o profesión de la persona que solicita o físicamente realiza la operación en caso en el ítem anterior se haya consignado la opción otros.'
      null
    * '20'
      'Código CIIU de la ocupación de la persona que solicita o físicamente realiza la operación.'
      null
    * '21'
      'Cargo de la persona que solicita o físicamente realiza la operación (si aplica):'
      globalOptions.JOB_TITLE  # Tabla Nº 3
      FieldType.TYPEAHEAD
    * '22'
      'Nombre y número de la vía de la dirección de la persona que solicita o físicamente realiza la operación.'
      null
    * '23'
      'Código UBIGEO del Departamento, provincia y distrito de la dirección de la persona que solicita o físicamente realiza la operación: de acuerdo a la codificación vigente y publicada por el INEI'
      null
    * '24'
      'Teléfono de la persona que solicita o físicamente realiza la operación.'
      null
  # PAYER --------------------------------------------------------------------
  * * '25'
      'La persona en cuyo nombre se realiza la operación es: (1) proveedor del extranjero (ingreso de mercancía), (2) Exportador (salida de mercancía). Si es proveedor del extranjero sólo consignar nombres y apellidos completos (persona natural), razón social (personas jurídicas) y dirección. Si es el exportador, consignar todos los datos detallados en esta sección.'
      * 'Proveedor extanjero'
        'Exportador'

    * '26'
      'La persona en cuyo nombre se realiza la operación ha sido representado por: (1) Representante legal (2) Apoderado (3) Mandatario (4) Él mismo.'
      * 'Representante legal'
        'Apoderado'
        'Mandatario'
        'Él mismo'

    * '27'
      'Condición de residencia de la persona en cuyo nombre se realiza la operación: (1) Residente, (2) No residente.'
      * 'Residente'
        'No residente'

    * '28'
      'Tipo de persona en cuyo nombre se realiza la operación: (1) Persona Natural, (2) Persona Jurídica. Si consignó la opción (2) no llenar los items 29 al 31 ni los items 34 al 38'
      * 'Persona Natural'
        'Persona Jurídica'

    * '29'
      'Tipo de documento de la persona en cuyo nombre se realiza la operación.'
      globalOptions.IDENTIFICATION  # Tabla Nº 1

    * '30'
      'Número de documento de la persona en cuyo nombre se realiza la operación.'

    * '31'
      'País de emisión del documento de la persona en cuyo nombre se realiza la operación, en caso sea un documento emitido en el extranjero.'

    * '32'
      'Número de RUC de la persona en cuyo nombre se realiza la operación.'

    * '33'
      'Apellido paterno o razón social (persona jurídica) de la persona en cuyo nombre se realiza la operación.'

    * '34'
      'Apellido materno de la persona en cuyo nombre se realiza la operación.'

    * '35'
      'Nombres de la persona en cuyo nombre se realiza la operación.'

    * '36'
      'Nacionalidad de la persona en cuyo nombre se realiza la operación.'

    * '37'
      'Ocupación, oficio o profesión de la persona en cuyo nombre se realiza la operación (persona natural).'
      globalOptions.ACTIVITY  # Tabla Nº 2
      FieldType.TYPEAHEAD

    * '38'
      'Descripción de la ocupación, oficio o profesión de la persona en cuyo nombre se realiza la operación en caso en el ítem anterior se haya consignado la opción otros.'

    * '39'
      'Actividad económica de la persona en cuyo nombre se realiza la operación (persona jurídica u otras formas de organización o asociación que la Ley establece):Consignar la actividad principal'

    * '40'
      'Código CIIU de la ocupación de la persona en cuyo nombre se realiza la operación.'

    * '41'
      'Cargo de la persona en cuyo nombre se realiza la operación (si aplica).'
      globalOptions.JOB_TITLE  # Tabla Nº 3
      FieldType.TYPEAHEAD

    * '42'
      'Nombre y número de la vía de la dirección de la persona en cuyo nombre se realiza la operación.'

    * '43'
      'Código UBIGEO del Departamento, provincia y distrito de la dirección de la persona en cuyo nombre se realiza la operación: de acuerdo a la codificación vigente y publicada por el INEI.'

    * '44'
      'Teléfono de la persona en cuyo nombre se realiza la operación.'

  # RECEIVER -----------------------------------------------------------------
  * * '45'
      'La persona a favor de quien se realiza la operación es: (1) Importador (ingreso de mercancía) ó (2) Destinatario del embarque (salida de mercancía). Si es el destinatario del embarque sólo consignar nombres y apellidos completos (persona natural), razón social (personas jurídicas) y dirección. Si es el importador, consignar todos los datos detallados en esta sección.'
      * 'Importador'
        'Destinatario del embarque'

    * '46'
      'Condición de residencia de la persona a favor de quien se realiza la operación: (1) Residente ó (2) No residente.'
      * 'Residente'
        'No residente'

    * '47'
      'Tipo de persona a favor de quien se realiza la operación: (1) Persona Natural ó (2) Persona Jurídica. Si consignó la opción (2) no llenar los items 48 al 50 ni los items 53 al 57.'

    * '48'
      'Tipo de documento la persona a favor de quien se realiza la operación.'
      # Consignar el código de acuerdo a la Tabla Nº 1.'

    * '49'
      'Número de documento de la persona a favor de quien se realiza la operación.'

    * '50'
      'País de emisión del documento de la persona a favor de quien se realiza la operación, en caso sea un documento emitido en el extranjero.'

    * '51'
      'Número de RUC de la persona a favor de quien se realiza la operación.'

    * '52'
      'Apellido paterno o razón social (persona jurídica) de la persona a favor de quien se realiza la operación.'

    * '53'
      'Apellido materno de la persona a favor de quien se realiza la operación.'

    * '54'
      'Nombres de la persona a favor de quien se realiza la operación.'

    * '55'
      'Nacionalidad de la persona a favor de quien se realiza la operación.'

    * '56'
      'Ocupación, oficio o profesión de la persona a favor de quien se realiza la operación (persona natural): consignar los códigos de acuerdo a la Tabla Nº 2.'

    * '57'
      'Descripción de la ocupación, oficio o profesión de la persona a favor de quien se realiza la operación en caso en el ítem anterior se haya consignado la opción otros.'

    * '58'
      'Actividad económica de la persona a favor de quien se realiza la operación (persona jurídica u otras formas de organización o asociación que la Ley establece): Consignar la actividad principal'

    * '59'
      'Código CIIU de la ocupación de la persona a favor de quien se realiza la operación'

    * '60'
      'Cargo de la persona a favor de quien se realiza la operación (si aplica): consignar el código que corresponda de acuerdo a la Tabla Nº 3.'

    * '61'
      'Nombre y número de la vía de la dirección de la persona a favor de quien se realiza la operación.'

    * '62'
      'Código UBIGEO del departamento, provincia y distrito de la dirección de la persona a favor de quien se realiza la operación: de acuerdo a la codificación vigente y publicada por el INEI.'

    * '63'
      'Teléfono de la persona a favor de quien se realiza la operación.'

  # THIRD --------------------------------------------------------------------
  * * '9'
      'La persona que solicita o físicamente realiza la operación actúa en representación del:'
      * '(1) Ordenante'
        '(2) Beneficiario'
    * '10'
      'Condición de residencia de la persona que solicita o físicamente realiza la operación:'
      * '(1) Residente'
        '(2) No residente'
      null


/** ---------------
 *  StakeholderView
 *  ---------------
 * Terceros que participan en el despacho. Son identificados en el "Anexo 2".
 * Calsificados en
 *   Declarante   - Quien participa en la gestión de los documentos.
 *   Ordenante    - Quien solicita la gestión de los documentos.
 *   Destinatario - A quien se le entregal a mercancía.
 *   Tercero      - Beneficiario final de la mercancía.
 * @class StakeholderView
 */
module.exports = class StakeholderView extends SectionBaseView

  /**
   * Render view.
   * Choose fields by {@code kind} of stakeholder:
   *   declarant, payer, receiver, third.
   * @override
   */
  render: ->
    vFields = ITYPES[@@Kind[@kind]]
    vLength = vFields.length
    vSlice  = Math.floor (vLength / 2)
    @el.appendChild (@fieldsetTemplate (vFields.slice      0,  vSlice))
    @el.appendChild (@fieldsetTemplate (vFields.slice vSlice, vLength))
    @el.classList
      ..add gz.Css \column-group
      ..add gz.Css \gutters
    super!

  /**
   * Fieldset template.
   * Creates {@code <fieldset>} insert half elements from {@code vFields}.
   * @param {Array<Array<?string|Array<string>>>} vFields
   * @return {HTMLElement}
   * @see render
   * @private
   */
  fieldsetTemplate: (vFields) ->
    elFieldset = gz.newel \fieldset
      ..className = "#{gz.Css \large-50}
                   \ #{gz.Css \medium-100}
                   \ #{gz.Css \small-100}"
      @fieldTemplate vFields, ..

  /**
   * Field template.
   * Insert {@code .control-group} to {@code <fieldset>}.
   * @param {!Array<Array<?string|Array<string>>>} vFields
   * @param {!HTMLElement} elFieldset
   * @see fieldsetTemplate
   * @private
   */
  fieldTemplate: !(vFields, elFieldset) ->
    for [idNumber, description, optionValues, fieldType] in vFields
      elControlGroup = gz.newel \div
        ..className = "#{gz.Css \control-group}
                     \ #{gz.Css \large-100}
                     \ #{gz.Css \medium-100}
                     \ #{gz.Css \small-100}"

      elLabel = gz.newel \label
        ..className = "#{gz.Css \large-100}
                     \ #{gz.Css \medium-100}
                     \ #{gz.Css \small-100}"
        ..style.textAlign = 'justify'
        ..innerHTML = "<b>#idNumber)</b> #description"

      elControl = gz.newel \div
        ..className = "#{gz.Css \control}
                     \ #{gz.Css \large-100}
                     \ #{gz.Css \medium-100}
                     \ #{gz.Css \small-100}"

      if optionValues?
        if fieldType?
          elInput = gz.newel \input
            ..type = \text
            ..name = idNumber
          elControl.appendChild elInput
          (new widget.GTypeahead do
            \el       : elInput
            mData     : [{elCaption : optVal, \
                         \value    : optVal, \
                         \tokens   : optVal.split(' ')} \
                         for optVal in optionValues]
            mTemplate : (p) -> "
              <p style='font-size:14px;text-align:justify'>#{p.elCaption}</p>")
            ..elWidth '100%'
        else
          elControl.innerHTML = ["<select name='#idNumber'>"].concat(
            ["<option>#optionVal</option>" for optionVal in optionValues],
            ['</select>']).join('')
      else
        elControl.innerHTML = "<input type='text' name='#idNumber'>"

      elControlGroup
        ..appendChild elLabel
        ..appendChild elControl
      elFieldset.appendChild elControlGroup

  /**
   * View template.
   * @param {Array<Array<?string|Array<string>>>} vFields
   * @return {string}
   * @private
   */
  _template: (vFields) ->
    aHtml = ["<fieldset class='#{gz.Css \column-group} #{gz.Css \gutters}'>"]
    for [idNumber, description, optionValues] in vFields
      # .control-group
      aHtml.push "<div class='#{gz.Css \control-group}
                            \ #{gz.Css \large-50}
                            \ #{gz.Css \medium-100}
                            \ #{gz.Css \small-100}'>"
      # label
      aHtml.push "<label class='#{gz.Css \large-100}
                              \ #{gz.Css \medium-100}
                              \ #{gz.Css \small-100}'>"
      aHtml.push "<b>#idNumber</b> #description"
      aHtml.push '</label>'
      # .control
      aHtml.push "<div class='#{gz.Css \control}
                            \ #{gz.Css \large-100}
                            \ #{gz.Css \medium-100}
                            \ #{gz.Css \small-100}'>"
      if optionValues?
        aHtml.push "<select name='#idNumber'>"
        for optionVal in optionValues
          aHtml.push "<option>#optionVal</option>"
        aHtml.push '</select>'
      else
        aHtml.push "<input type='text' name='#idNumber'>"
      aHtml.push '</div>'
      aHtml.push '</div>'
    aHtml.push '</fieldset>'
    aHtml.join ''

  /**
   * @enum {number}
   * Internal types. (Unused)
   * @private
   */
  @Type =
    DECLARANT : 0  # Declarante
    PAYER     : 1  # Ordenante
    RECEIVER  : 2  # Destinatario
    THIRD     : 3  # Tercero (Beneficiario final)

  /**
   * @enum {number}
   * Use internal {@code kind} attribute to choose fields for stakeholder form.
   * @private
   */
  @Kind =
    \Declarante : 0  # Declarante
    \Ordenante  : 1  # Ordenante
    \Destinario : 2  # Destinatario
    \Tercero    : 3  # Tercero (Beneficiario final)
