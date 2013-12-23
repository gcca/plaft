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
  * * '9'
      'La persona que solicita o físicamente realiza la operación actúa en representación del:'
      * '(1) Ordenante'
        '(2) Beneficiario'
    * '10'
      'Condición de residencia de la persona que solicita o físicamente realiza la operación:'
      * '(1) Residente'
        '(2) No residente'
      null
  # RECEIVER -----------------------------------------------------------------
  * * '9'
      'La persona que solicita o físicamente realiza la operación actúa en representación del:'
      * '(1) Ordenante'
        '(2) Beneficiario'
    * '10'
      'Condición de residencia de la persona que solicita o físicamente realiza la operación:'
      * '(1) Residente'
        '(2) No residente'
      null
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
   * @override
   */
  render: ->
    # @$el.html (@stakeholderTemplate ITYPES[@@Kind[@kind]])
    @el.appendChild (@domView ITYPES[@@Kind[@kind]])
    super!

  /**
   */
  domView: (vFields) ->
    elFieldset = gz.newel \fieldset
      ..className = "#{gz.Css \column-group} #{gz.Css \gutters}"
    for [idNumber, description, optionValues, fieldType] in vFields
      elControlGroup = gz.newel \div
        ..className = "#{gz.Css \control-group}
                     \ #{gz.Css \large-50}
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
    elFieldset

  /**
   * stakeholderTemplate
   * @return {string}
   * @private
   */
  stakeholderTemplate: (vFields) ->
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

  @Type =
    DECLARANT : 0  # Declarante
    PAYER     : 1  # Ordenante
    RECEIVER  : 2  # Destinatario
    THIRD     : 3  # Tercero (Beneficiario final)

  @Kind =
    \Declarante : 0  # Declarante
    \Ordenante  : 1  # Ordenante
    \Destinario : 2  # Destinatario
    \Tercero    : 3  # Tercero (Beneficiario final)
