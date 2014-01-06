/** @module dashboard.module.settings.customs */

/**
 * Import {@code GAutoAlert}.
 * @private
 */
widget = require '../../../widget'

JurisdictionsView = require './customs/jurisdictions'

/**
 * Import Module Base.
 * @private
 */
ModuleBaseView = require '../base'


/**
 * @class CustomsView
 * @extends ModuleBaseView
 */
module.exports = class CustomsView extends ModuleBaseView

  /**
   * On click save form.
   * @param {Object} evt Event object.
   * @private
   */
  onClickSaveForm: !(evt) ~>
    dataJSON = @$el.find \form .serializeJSON!
    dataJSON.\jurisdictions = @jurisdictionsView.JSONFields!
    @model.save dataJSON, do
      \success : ->
        (new widget.GAutoAlert (gz.Css \success),
                               "<b>DESPACHO:</b> Datos guardados.").elShow!
      \error : ->
        alert 'ERROR: Config (a456)'

  /** @private */ @menuCaption = 'Agencia de aduanas'
  /** @private */ @menuIcon    = gz.Css \icon-cog
  /** @private */ @menuTitle   = 'Configuración de Agencia de Aduanas'

  /** @private */ jurisdictionsView: null

  /**
   * Render view.
   * @return {Object}
   * @private
   */
  render: ->
    @model = gzApp.customsBroker
    # Form
    @$el.html @templateMainForm!
    # Jurisdictions
    jurisdictionArray = gzApp.customsBroker.get \jurisdictions
    lCollection = new gz.GCollection jurisdictionArray
    @jurisdictionsView = new JurisdictionsView collection: lCollection
    @el.lastElementChild.lastElementChild \
      .appendChild @jurisdictionsView.render!.el
    # Button "Save"
    $tFieldset = $ "<fieldset class='#{gz.Css \large-50}
                                   \ #{gz.Css \medium-50}
                                   \ #{gz.Css \small-100}'>
                    </fieldset>"
    $tButton = $ "<button type='button'
                      class='#{gz.Css \ink-button}
                           \ #{gz.Css \green}
                           \ #{gz.Css \push-right}'>
                    Guardar
                  </button>"
      ..on \click @onClickSaveForm
    $tFieldset.append $tButton
    @$el.children!.last!.append $tFieldset
    super!

  /**
   * Template view.
   * @return {string}
   * @private
   */
  templateMainForm: ->
    divControlGroup = "<div class='#{gz.Css \control-group}'>"
    label = "<label class='#{gz.Css \large-25}
                         \ #{gz.Css \medium-30}
                         \ #{gz.Css \small-100}'>"
    divControl = "<div class='#{gz.Css \control}
                            \ #{gz.Css \large-75}
                            \ #{gz.Css \medium-70}
                            \ #{gz.Css \small-100}'>"
    "<form class='#{gz.Css \ink-form}
                \ #{gz.Css \column-group}
                \ #{gz.Css \gutters}' style='margin-top:0'>

      <fieldset class='#{gz.Css \large-50}
                     \ #{gz.Css \medium-100}
                     \ #{gz.Css \small-100}'>

        <legend>Agente de aduanas</legend>

        #divControlGroup
          #label
            Nombre
          </label>
          #divControl
            <input type='text' name='name'
                value='#{@model.get \name}'
                placeholder='Razón social'>
          </div>
        </div>

        #divControlGroup
          #label
            RUC
          </label>
          #divControl
            <input type='text' name='documentNumber'
                value='#{@model.get \documentNumber}'
                placeholder='RUC'>
          </div>
        </div>

        #divControlGroup
          #label
            Código
          </label>
          #divControl
            <input type='text' name='code'
                value='#{@model.get \code}'
                placeholder='Código de aduana'>
          </div>
        </div>


        <legend>Oficial de cumplimiento</legend>
        #divControlGroup
          #label
            Nombre
          </label>
          #divControl
            <input type='text' name='officierName'
                value='#{@model.get \officierName}'
                placeholder='Nombre'>
          </div>
        </div>

        #divControlGroup
          #label
            Código
          </label>
          #divControl
            <input type='text' name='officierCode'
                value='#{@model.get \officierCode}'
                placeholder='Código de oficial de cumplimiento'>
          </div>
        </div>

      </fieldset>

      <fieldset class='#{gz.Css \large-50}
                     \ #{gz.Css \medium-100}
                     \ #{gz.Css \small-100}'>
        <legend>Jurisdicciones</legend>
      </fieldset>

    </form>"
## <div class='#{gz.Css \control-group}'>
##   <label></label>
##   <div class='#{gz.Css \control}'>
##   </div>
## </div>
