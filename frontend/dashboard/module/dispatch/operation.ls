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
    -   "Codigo SO",
    -   "Codigo OC",
    -   "Número de fila"
    - ];

    - var labelsRight = [
    -   "Número de registro de Operación",
    -   "Número de registro interno",
    -   "Modalidad de operación",
    -   "Número de operaciones"
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
        legend Datos
        each label in labelsRight
          .control-group.column-group
            label.large-100.medium-100.small-100= label
            .control.large-100.medium-100.small-100
              input(type="text", name=label)
  '''
