/**
 * @module dashboard.module
 */

form   = require '../../form'
model  = require '../../model'
widget = require '../../widget'
ModuleBaseView = require './base'

/** @private */ DispatchModel = model.Dispatch

/**
 * @class DispatchView
 */
module.exports = class DispatchView extends ModuleBaseView

  /**
   * On search from searchView event.
   * @param {!string} query Query text: orderNumber.
   * @private
   */
  onSearch: !(query) ~>
    if query.match /\d+-\d+/
      @dispatch = new DispatchModel \orderNumber : query
      window.yYy = @dispatch
      @dispatch.fetch do
        \success : @renderInfo
        \error : ->
          alert 'ERROR: Load disptach'
    else
      (new widget.GAutoAlert (gz.Css \error),
                             "<b>ERROR:</b> Número de orden incorrecto:
                             \ <em>#query</em>").show!

  /**
   * @private
   */
  renderInfo: ~>
    @$el.html @template
    tabs = @$el.find ".#{gz.Css \ink-tabs}" .get 0
    new gz.Ink.UI.Tabs tabs, do
      \preventUrlChange : on

  /**
   * Initialize view.
   * @private
   */
  initialize: !-> @render!

  /**
   * Render view.
   * @return {Object}
   */
  render: ->
    @desktop.uiSearch.showTooltip '<b>Buscar por <em>número de orden</em></b>'
    @desktop.uiSearch.elFocus!
    @renderInfo!
    super!

  /** @private */ @menuCaption = '<span style="font-size:0.7em">Despacho (tmp)</span>'
  /** @private */ @menuIcon    = gz.Css \icon-ambulance
  /** @private */ @menuTitle   = 'Despacho (Anexo 6) <em>(DBZ)</em>'

  /**
   * Template (Dispatch).
   * @param {!Object} dispatch
   * @return {string}
   * @private
   */
  template: (dispatch) -> "
    <div class='#{gz.Css \ink-tabs} #{gz.Css \top}'>
      <ul class='#{gz.Css \tabs-nav}'>
        <li><a href='\##{gz.Css \tabs}1'>Operación</a></li>
        <li><a href='\##{gz.Css \tabs}2'>Declarante</a></li>
        <li><a href='\##{gz.Css \tabs}3'>Ordenante</a></li>
        <li><a href='\##{gz.Css \tabs}4'>Destinatario</a></li>
        <li><a href='\##{gz.Css \tabs}5'>Tercero</a></li>
      </ul>

      <div id='#{gz.Css \tabs}1' class='tabs-content' style='height:100%'>
        <form action='' class='ink-form'>
          <fieldset>
              <div class='control-group column-group gutters'>
                  <label for='phone' class='large-15 medium-20 small-30 content-right'>Phone</label>
                  <div class='control large-85 medium-80 small-70'>
                      <input type='text' id='phone'>
                      <p class='tip'>You can add help text to fields</p>
                  </div>
              </div>

              <div class='control-group column-group gutters'>
                  <label for='email' class='large-15 medium-20 small-30 content-right'>Email</label>
                  <div class='control large-85 medium-80 small-70'>
                      <input type='text' id='email'>
                  </div>
              </div>

              <div class='control-group column-group gutters'>
                  <label for='area' class='large-15 medium-20 small-30 content-right'>Description</label>
                  <div class='control large-85 medium-80 small-70'>
                      <textarea id='area'></textarea>
                  </div>
              </div>

              <div class='control-group column-group horizontal-gutters'>
                  <label for='file-input' class='large-15 medium-20 small-30 content-right'>File input</label>
                  <div class='control large-85 medium-80 small-70'>
                      <div class='input-file'>
                          <input type='file' name='' id='file-input'>
                      </div>
                  </div>
              </div>
          </fieldset>
        </form>
      </div>

      <div id='#{gz.Css \tabs}2' class='tabs-content'>
        <form action='#' class='ink-form'>
          <fieldset class='column-group horizontal-gutters'>
              <div class='control-group required validation warning large-50 medium-100 small-100'>
                  <label for='text-input'>Text input</label>
                  <div class='control'>
                      <input id='text-input' type='text' placeholder='Please input some text'>
                  </div>
                  <p class='tip'>Warn about something</p>
              </div>
              <div class='control-group required validation error large-50 medium-100 small-100'>
                  <label for='text-input'>Text input</label>
                  <div class='control'>
                      <input id='text-input' type='text' placeholder='Please input some text'>
                  </div>
                  <p class='tip'>This field is required</p>
              </div>
          </fieldset>
        </form>
      </div>

      <div id='#{gz.Css \tabs}3' class='tabs-content'>
        <form action='#' class='ink-form'>
          <fieldset class='column-group horizontal-gutters'>
              <div class='control-group required validation warning large-50 medium-100 small-100'>
                  <label for='text-input'>Text input</label>
                  <div class='control'>
                      <input id='text-input' type='text' placeholder='Please input some text'>
                  </div>
                  <p class='tip'>Warn about something</p>
              </div>
              <div class='control-group required validation error large-50 medium-100 small-100'>
                  <label for='text-input'>Text input</label>
                  <div class='control'>
                      <input id='text-input' type='text' placeholder='Please input some text'>
                  </div>
                  <p class='tip'>This field is required</p>
              </div>
          </fieldset>
        </form>
      </div>

      <div id='#{gz.Css \tabs}4' class='tabs-content'>
        <form action='#' class='ink-form'>
          <fieldset class='column-group horizontal-gutters'>
              <div class='control-group required validation warning large-50 medium-100 small-100'>
                  <label for='text-input'>Text input</label>
                  <div class='control'>
                      <input id='text-input' type='text' placeholder='Please input some text'>
                  </div>
                  <p class='tip'>Warn about something</p>
              </div>
              <div class='control-group required validation error large-50 medium-100 small-100'>
                  <label for='text-input'>Text input</label>
                  <div class='control'>
                      <input id='text-input' type='text' placeholder='Please input some text'>
                  </div>
                  <p class='tip'>This field is required</p>
              </div>
          </fieldset>
        </form>
      </div>

      <div id='#{gz.Css \tabs}5' class='tabs-content'>
        <form action='#' class='ink-form'>
          <fieldset class='column-group horizontal-gutters'>
              <div class='control-group required validation warning large-50 medium-100 small-100'>
                  <label for='text-input'>Text input</label>
                  <div class='control'>
                      <input id='text-input' type='text' placeholder='Please input some text'>
                  </div>
                  <p class='tip'>Warn about something</p>
              </div>
              <div class='control-group required validation error large-50 medium-100 small-100'>
                  <label for='text-input'>Text input</label>
                  <div class='control'>
                      <input id='text-input' type='text' placeholder='Please input some text'>
                  </div>
                  <p class='tip'>This field is required</p>
              </div>
          </fieldset>
        </form>
      </div>

    </div>"
