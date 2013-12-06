/** @module dashboard.module */

widget = require '../../widget'
ModuleBaseView = require './base'

/**
 * @class ConfigView
 * @extends ModuleBaseView
 */
module.exports = class ConfigView extends ModuleBaseView

  /**
   * View events.
   * @type {Object}
   * @private
   */
  events:
    /**
     * On click save form.
     * @param {Object} evt Event object.
     * @private
     */
    'click button': !(evt) ->
      dataJSON = @$el.find \form .serializeJSON!
      @model.save dataJSON, do
        \success : ->
          (new widget.GAutoAlert (gz.Css \success),
                                 "<b>DESPACHO:</b> Datos guardados.").elShow!
        \error : ->
          alert 'ERROR: Config (a456)'

  /**
   * Render view.
   * @return {Object}
   * @private
   */
  render: ->
    @model = gzApp.customsBroker
    @$el.html @template!

  /** @private */ @menuTitle = 'Panel de configuración'

  /**
   * Template view.
   * @return {string}
   * @private
   */
  template: ->
    divControlGroup = "<div class='#{gz.Css \control-group}'>"
    label = "<label class='#{gz.Css \large-25}
                         \ #{gz.Css \medium-30}
                         \ #{gz.Css \small-100}'>"
    divControl = "<div class='#{gz.Css \control}
                            \ #{gz.Css \large-75}
                            \ #{gz.Css \medium-70}
                            \ #{gz.Css \small-100}'>"
    "<form class='#{gz.Css \ink-form}' style='margin-top:0'>
      <div class='#{gz.Css \large-50}
                \ #{gz.Css \medium-100}
                \ #{gz.Css \small-100}
                \ #{gz.Css \block-left}'>
        <fieldset>
          <legend>Agente de aduanas</legend>
          #divControlGroup
            #label
              Nombre
            </label>
            #divControl
              <input type='text' name='name'
                  value='#{@model.get \name}'>
            </div>
          </div>

          #divControlGroup
            #label
              RUC
            </label>
            #divControl
              <input type='text' name='documentNumber'
                  value='#{@model.get \documentNumber}'>
            </div>
          </div>

          #divControlGroup
            #label
              Código
            </label>
            #divControl
              <input type='text' name='code'
                  value='#{@model.get \code}'>
            </div>
          </div>
        </fieldset>
      </div>

      <div class='#{gz.Css \large-50}
                \ #{gz.Css \medium-100}
                \ #{gz.Css \small-100}
                \ #{gz.Css \block-right}'>
        <fieldset>
          <legend>Oficial de cumplimiento</legend>
          #divControlGroup
            #label
              Nombre
            </label>
            #divControl
              <input type='text' name='officierName'
                  value='#{@model.get \officierName}'>
            </div>
          </div>

          #divControlGroup
            #label
              Código
            </label>
            #divControl
              <input type='text' name='officierCode'
                  value='#{@model.get \officierCode}'>
            </div>
          </div>
        </fieldset>
      </div>
    </form>
    <button type='button'
        class='#{gz.Css \ink-button}
             \ #{gz.Css \green}
             \ #{gz.Css \push-right}'>
      Guardar
    </button>"
## <div class='#{gz.Css \control-group}'>
##   <label></label>
##   <div class='#{gz.Css \control}'>
##   </div>
## </div>
