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
    control-group = "#{gz.Css \control-group}
                    .#{gz.Css \column-group}
                    .#{gz.Css \gutters}"

    label = "label.#{gz.Css \large-25}
                  .#{gz.Css \medium-25}
                  .#{gz.Css \small-40}
                  .#{gz.Css \content-right}"

    control = "#{gz.Css \control}
              .#{gz.Css \large-75}
              .#{gz.Css \medium-75}
              .#{gz.Css \small-60}"

    labels = "['Codigo SO',
               'Codigo OC',
               'Número de fila',
               'Número de registro de Operación',
               'Número de registro interno',
               'Modalidad de operación',
               'Número de operaciones']"

    gz.jParse """
    - var labels = #labels
    - each label in labels
      .#{control-group}
        #{label}= label
        .#{control}
          input(type='text', name=label)
    """)!
