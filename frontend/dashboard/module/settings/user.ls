/** @module dashboard.module.settings.user */

/**
 * Import Module Base.
 * @private
 */
ModuleBaseView = require '../base'

widget = require '../../../widget'


/** ---------
 *  User View
 *  ---------
 * Settings for "customs broker user".
 * Options:
 *   e-Mail
 *   CustomsBroker Jurisdiction
 *
 * @class UserView
 */
module.exports = class UserView extends ModuleBaseView

  /**
   * Render view.
   * @return {Object}
   * @public
   */
  render: ->
    tControlGroup = "<div class='#{gz.Css \control-group}
                               \ #{gz.Css \large-50}
                               \ #{gz.Css \medium-50}
                               \ #{gz.Css \small-100}'>"

    tLabel = "<label class='#{gz.Css \large-100}
                          \ #{gz.Css \medium-100}
                          \ #{gz.Css \small-100}'>"

    tControl = "<div class='#{gz.Css \control}
                          \ #{gz.Css \large-100}
                          \ #{gz.Css \medium-100}
                          \ #{gz.Css \small-100}'>"

    user = gzApp.user
    uJurName = user.get \jurisdictionName
    uJurCode = user.get \jurisdictionCode

    # Jurisdiction 'name' and 'code' lists
    gzApp.shortcuts.ui.iHtml.jurisdictions.optionsSelected!
      optionsName = ..optionsName
      optionsCode = ..optionsCode

    @$el.html "
      <form class='#{gz.Css \ink-form}'>

        <fieldset class='#{gz.Css \column-group} #{gz.Css \gutters}'>

          #tControlGroup
            #tLabel
              Dirección de correo
            </label>
            #tControl
              <input type='text' name='email' value='#{user.get \email}'>
            </div>
          </div>

          <div class='#{gz.Css \control-group}
                    \ #{gz.Css \large-50}
                    \ #{gz.Css \medium-50}
                    \ #{gz.Css \small-100}'>
            #tLabel
              Jurisdicción
            </label>
            <div class='#{gz.Css \control}
                      \ #{gz.Css \large-75}
                      \ #{gz.Css \medium-75}
                      \ #{gz.Css \small-100}'>
              <select name='jurisdictionName'>
                #optionsName
              </select>
            </div>
            <span class='#{gz.Css \large-5}
                       \ #{gz.Css \medium-5}
                       \ #{gz.Css \small-100}'
                style='margin-top:0;margin-bottom:-1.5em'></span>
            <div class='#{gz.Css \control}
                      \ #{gz.Css \large-20}
                      \ #{gz.Css \medium-20}
                      \ #{gz.Css \small-100}'>
              <select name='jurisdictionCode'>
                #optionsCode
              </select>
            </div>
          </div>

        </fieldset>

        <button type='button'
            class='#{gz.Css \ink-button} #{gz.Css \green}
                 \ #{gz.Css \push-right}'>
          Guardar
        </button>

      </form>"

    # First use: No Juridisction in user
    if not uJurName or not uJurCode
      @$el.find \select .prop \selectedIndex -1

    # No auto-submit
    @el.firstElementChild.onsubmit = (evt) !-> evt.preventDefault!

    # Synchronize Name - Code
    selectName = @$el.find '[name=jurisdictionName]' .get 0
    selectCode = @$el.find '[name=jurisdictionCode]' .get 0
    gzApp.shortcuts.ui.jurisdictions.synchronizeSelects selectName, selectCode

    # Save event
    @el.lastElementChild.lastElementChild.onclick = ~>
      JSONFields = @$el.find \form .serializeJSON!

      user.save JSONFields, do
        \success : ->
          (new widget.GAutoAlert (gz.Css \success),
                                 "<b>USUARIO:</b> Datos guardados.").elShow!
        \error : -> alert 'ERROR: user (7f7sd89)'

    super!

  # Attributes
  /** @private */ @menuCaption = 'Usuario'
  /** @private */ @menuIcon    = gz.Css \icon-user
  /** @private */ @menuTitle   = 'Configuración de usuario'
