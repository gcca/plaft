/**
 * @module dashboard.module
 */

form   = require '../../form'
model  = require '../../model'
widget = require '../../widget'

ModuleBaseView = require './base'

OperationView = require './dispatch/operation'
StakeholderView = require './dispatch/stakeholder'

/**
 * @class DispatchView
 */
module.exports = class DispatchView extends ModuleBaseView

  /**
   * View events.
   * @private
   */
  events:
    /**
     * On button save clic.
     * @param {!Object} evt
     * @private
     */
    "click button.#{gz.Css \green}": !(evt) ->
      operationRecord =
        \operation : @operationView.JSONControls!
        \sections : [section.JSONControls! for section in @sectionViewList]
      console.log operationRecord


  /**
   * On search from searchView event.
   * @param {!string} query Query text: orderNumber.
   * @private
   */
  onSearch: !(query) ~>
    if query.match /\d+-\d+/
      @dispatch = new DispatchModel \orderNumber : query
      @dispatch.fetch do
        \success : @renderInfo
        \error : ->
          alert 'ERROR: Load disptach'
    else
      (new widget.GAutoAlert (gz.Css \error),
                             "<b>ERROR:</b> Número de orden incorrecto:
                             \ <em>#query</em>").elShow!

  /**
   * Add new stakeholder tab.
   * @param {!string} caption
   * @param {!Object} tabView
   * @see renderInfo
   * @private
   */
  addTabView: !(caption, tabView) ->
    tId = (new Date).getTime!
    tab = $ "<li><a href='\##{gz.Css \tabs}#tId'>#caption</a></li>"
    content = $ "<div id='#{gz.Css \tabs}#tId'
                     class='#{gz.Css \tabs-content}' style='overflow:hidden'>"
    content.append tabView.render!.el
    @$el.find "ul.#{gz.Css \tabs-nav}" .append tab
    @$el.find "div.#{gz.Css \ink-tabs}" .append content

  /**
   * Render dispatch form.
   * @private
   */
  renderInfo: ~>
    @$el.html @template
    @operationView = new OperationView
    @addTabView 'Operación', @operationView
    for caption in <[ Declarante Ordenante Destinario Tercero ]>
      new StakeholderView caption: caption
        @addTabView caption, ..
        @sectionViewList.push ..
    new gz.Ink.UI.Tabs (@$el.find ".#{gz.Css \ink-tabs}" .get 0), do
      \preventUrlChange : on

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    /**
     * Operation and stakeholders sections.
     * @type {Array.<Object>}
     * @private
     */
    @sectionViewList = new Array
    @render!

  /**
   * Render view.
   * @return {Object}
   */
  render: ->
    @desktop.uiSearch.showTooltip '<b>Buscar por <em>número de orden</em></b>'
    @desktop.uiSearch.elFocus!
    @renderInfo!
    super!

  /** @private */
  @menuCaption = '<span style="font-size:0.7em">Despacho (tmp)</span>'
  /** @private */
  @menuIcon    = gz.Css \icon-ambulance
  /** @private */
  @menuTitle   = 'Despacho (Anexo 6) <em>(DBZ)</em>'

  /** @private */ operationView: null

  /**
   * Template (Dispatch).
   * @param {!Object} dispatch
   * @return {string}
   * @private
   */
  template: (->
    tabs = "#{gz.Css \ink-tabs}.#{gz.Css \top}"
    tabs-nav = gz.Css \tabs-nav
    btn = "#{gz.Css \ink-button}.#{gz.Css \green}.#{gz.Css \push-right}"
    gz.jParse """
    button.#btn Guardar
    .#tabs
      ul.#tabs-nav
    """)!
