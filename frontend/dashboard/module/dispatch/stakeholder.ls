/**
 * @module dashboard.module.dispatch
 */

SectionBaseView = require './base'

/**
 * @class StakeholderView
 */
module.exports = class StakeholderView extends SectionBaseView

  /**
   * Render field.
   * @see render
   * @private
   */
  field: (name, label) -> "
    <div class='#{gz.Css \control-group}
              \ #{gz.Css \column-group}
              \ #{gz.Css \gutters}'>
      <label class='#{gz.Css \large-25}
                  \ #{gz.Css \medium-25}
                  \ #{gz.Css \small-40}
                  \ #{gz.Css \content-right}'>
        #label
      </label>
      <div class='#{gz.Css \control}
                \ #{gz.Css \large-75}
                \ #{gz.Css \medium-75}
                \ #{gz.Css \small-60}'>
        <input type='text' name='#name'>
      </div>
    </div>
  "

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
    @$el.html "
      <fieldset>
        <legend>Datos</legend>
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
