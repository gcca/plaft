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
  template: (->
    block = "#{gz.Css \large-50}
            .#{gz.Css \medium-50}
            .#{gz.Css \small-100}
            .#{gz.Css \gz-block}"

    control-group = "#{gz.Css \control-group}
                    .#{gz.Css \column-group}"

    labelL = "label.#{gz.Css \large-25}
                   .#{gz.Css \medium-25}
                   .#{gz.Css \small-100}"

    controlL = "#{gz.Css \control}
               .#{gz.Css \large-75}
               .#{gz.Css \medium-75}
               .#{gz.Css \small-100}"


    labelR = "label.#{gz.Css \large-100}
                   .#{gz.Css \medium-100}
                   .#{gz.Css \small-100}"

    controlR = "#{gz.Css \control}
               .#{gz.Css \large-100}
               .#{gz.Css \medium-100}
               .#{gz.Css \small-100}"

    labelsLeft = "['Codigo SO',
                   'Codigo OC',
                   'Número de fila']"

    labelsRight = "['Número de registro de Operación',
                    'Número de registro interno',
                    'Modalidad de operación',
                    'Número de operaciones']"

    gz.jParse """
      .#block
        fieldset
          legend Registro
          - each label in #labelsLeft
            .#control-group
              #labelL= label
              .#controlL
                input(type='text', name=label)
      .#block
        fieldset
          legend Datos
          - each label in #labelsRight
            .#control-group
              #labelR= label
              .#controlR
                input(type='text', name=label)
    """)!
