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
    super!

  /**
   * Template.
   * @return {string}
   * @private
   */
  template: gzc.Jade '''
    - var labelsLeft = [
    -   "Código del Sujeto Obligado",
    -   "Código del Oficial de Cumplimiento",
    -   "Número de fila"
    - ];

    - var labelsRight = [
    -   "Número de operación",
    -   "Número de interno (DAM)",
    -   "Número de operaciones",
    -   "Fecha de operación"
    - ];

    .large-50.medium-50.small-100
      fieldset.block-left
        legend Registro
        each label in labelsLeft
          .control-group.column-group
            label.large-100.medium-100.small-100= label
            .control.large-100.medium-100.small-100
              input(type="text", name=label)

    .large-50.medium-50.small-100
      fieldset.block-right
        legend Operación
        each label in labelsRight
          .control-group.column-group
            label.large-100.medium-100.small-100= label
            .control.large-100.medium-100.small-100
              input(type="text", name=label)

        .control-group.column-group
          label.large-100.medium-100.small-100 Modalidad de operación
          .control.large-100.medium-100.small-100
            select(name="mode")
              option(value="U") Individual
              option(value="M") Múltiple
  '''
