/**
 * @module dashboard.module.dispatch
 */

SectionBaseView = require './base'

/**
 * @class OperationView
 */
module.exports = class OperationView extends SectionBaseView

  /**
   * Render view.
   * @return {Object}
   * @override
   */
  render: ->
    @$el.html @template!
    ## @$el.find 'input[name=Código del Sujeto Obligado]' .val(
    ##   gzApp.customsBroker.get \code)
    super!

  /**
   * Template.
   * @return {string}
   * @private
   */
  template: ->
    leftNames = [
      'obligedCode'
      'officierCode'
      'rowCode'
    ]
    leftLabels = [
      "Código del Sujeto Obligado"
      "Código del Oficial de Cumplimiento"
      "Número de fila"
    ]
    leftDefaults = [
      gzApp.customsBroker.get \code
      gzApp.customsBroker.get \officierCode
      ''
    ]

    rightNames = [
      'operationCode'
      'internalCode'
      'operationsNumber'
      'operationDate'
    ]
    rightLabels = [
      "Número de operación"
      "Número de interno (DAM)"
      "Número de operaciones"
      "Fecha de operación"
    ]
    rightDefaults = [
      ''
      ''
      ''
      ''
    ]

    block = "<div class='#{gz.Css \large-50}
                       \ #{gz.Css \medium-50}
                       \ #{gz.Css \small-100}'>"
    divControlGroup = "<div class='#{gz.Css \control-group}'>"
    label = '<label>'
    divControl = "<div class='#{gz.Css \control}'>"

    text = new Array

    text
      ..push block
      ..push "<fieldset class='#{gz.Css \block-left}'>"
      ..push '<legend>Registro</legend>'
    for [fname, flabel, fvalue] in (_.\zip leftNames, leftLabels, leftDefaults)
      text
        ..push divControlGroup
        ..push label
        ..push flabel
        ..push '</label>'
        ..push divControl
        ..push "<input type='text' name='#{fname}' value='#{fvalue}'>"
        ..push '</div>'
        ..push '</div>'
    text
      ..push '</fieldset>'
      ..push '</div>'

    text
      ..push block
      ..push "<fieldset class='#{gz.Css \block-right}'>"
      ..push '<legend>Operación</legend>'
    for [fname, flabel, fvalue] in (_.\zip rightNames, rightLabels, rightDefaults)
      text
        ..push divControlGroup
        ..push label
        ..push flabel
        ..push '</label>'
        ..push divControl
        ..push "<input type='text' name='#{fname}' value='#{fvalue}'>"
        ..push '</div>'
        ..push '</div>'

    text
      ..push divControlGroup
      ..push label
      ..push 'Modalidad de operación'
      ..push '</label>'
      ..push divControl
      ..push "<select name='operationMode'>
                <option value='U'>Individual</option>
                <option value='M'>Múltiple</option>
              </select>"
      ..push '</div>'
      ..push '</div>'

    text
      ..push '</fieldset>'
      ..push '</div>'

    text.join ''
