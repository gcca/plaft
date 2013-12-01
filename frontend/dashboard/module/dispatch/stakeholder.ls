/**
 * @module dashboard.module.dispatch
 */

SectionBaseView = require './base'

/**
 * @class StakeholderView
 */
module.exports = class StakeholderView extends SectionBaseView

  /**
   * Initialize view.
   * @override
   * @private
   */
  initialize: !->
    super ...

  /**
   * Render view.
   * @override
   */
  render: ->
    @$el.html @template!
    super!

  /**
   * View template.
   * @return string
   * @private
   */
  template: -> gzc.Jade '''
    - var labelsLeft = [
    -   "Tipo de documento",
    -   "Número de documento",
    -   "País de emisión del documento",
    -   "Apellido paterno",
    -   "Apellido materno",
    -   "Nombres",
    -   "Nacionalidad"
    - ];

    - var labelsRight = [
    -   "Ocupación",
    -   "Descripción de ocupación",
    -   "Código CIIU",
    -   "Cargo",
    -   "Dirección",
    -   "Código ubigeo",
    -   "Teléfono"
    - ];

    .large-50.medium-50.small-100
      fieldset.block-left
        legend
        each label in labelsLeft
          .control-group.column-group
            label.large-100.medium-100.small-100= label
            .control.large-100.medium-100.small-100
              input(type="text", name=label)

    .large-50.medium-50.small-100
      fieldset.block-right
        legend
        each label in labelsRight
          .control-group.column-group
            label.large-100.medium-100.small-100= label
            .control.large-100.medium-100.small-100
              input(type="text", name=label)
  '''
