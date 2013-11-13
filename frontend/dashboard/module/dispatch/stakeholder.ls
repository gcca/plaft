/**
 * @module dashboard.module.dispatch
 */

SectionBaseView = require './base'

/**
 * @class StakeholderView
 */
module.exports = class StakeholderView extends SectionBaseView

  /**
   * @see render
   * @private
   */
  field: (name, label) -> @@_field \$A : name, \$B : label

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @@_field ||= (->
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
      gz.jParse  """
        .#{control-group}
          #{label}= $B
          .#{control}
            input(type='text', name=$A)
      """)!

  /**
   * Render view.
   * @override
   */
  render: ->
    @$el.html "
      <fieldset>
        #{@field '' 'Tipo de documento'}
        #{@field '' 'Número de documento'}
        #{@field '' 'País de emisión del documento'}
        #{@field '' 'Apellido paterno'}
        #{@field '' 'Apellido materno'}
        #{@field '' 'Nombres'}
        #{@field '' 'Nacionalidad'}
        #{@field '' 'Ocupación'}
        #{@field '' 'Descripción de ocupación'}
        #{@field '' 'Código CIIU'}
        #{@field '' 'Cargo'}
        #{@field '' 'Dirección'}
        #{@field '' 'Código ubigeo'}
        #{@field '' 'Teléfono'}
      </fieldset>"
    super!
