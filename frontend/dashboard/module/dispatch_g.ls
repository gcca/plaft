/**
 * @module dashboard.module
 */

model  = require '../../model'
widget = require '../../widget'

ModuleBaseView = require './base'

OperationView = require './dispatch/operation'
StakeholderView = require './dispatch/stakeholder'

/**
 * @private
 */
DispatchModel = model.Dispatch

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
      registration =
        \operation : @operationView.JSONFields!
        \sections  : [..JSONFields! for @sectionViewList]
      @dispatch.save \registration : registration, do
        \success : -> alert 'Guardado'
        \error : -> alert 'ERROR: Dispatch (6)'

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
        \error : ~>
          @$el.html ''
          (new widget.GAutoAlert (gz.Css \error),
                                 "<b>ERROR:</b> Despacho no encontrado:
                                 \ <em>#query</em>").elShow!
    else
      @$el.html ''
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
                     class='#{gz.Css \tabs-content}'
                     style='overflow:hidden;margin-top:0'>"
    content.append tabView.render!.el
    @$el.find "ul.#{gz.Css \tabs-nav}" .append tab
    @$el.find "div.#{gz.Css \ink-tabs}" .append content

  /**
   * Render dispatch form.
   * @private
   */
  renderInfo: ~>
    @$el.html @template
    @operationView = new OperationView kind: \operation
    @addTabView 'Operación', @operationView
    for caption in <[ Declarante Ordenante Destinario Tercero ]>
      new StakeholderView kind: caption
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
   * @return {string}
   * @private
   */
  template: -> "
    <button class='#{gz.Css \ink-button} #{gz.Css \green} #{gz.Css \push-right}'>
      Guardar
    </button>
    <div class='#{gz.Css \ink-tabs} #{gz.Css \top}'>
      <ul class='#{gz.Css \tabs-nav}'></ul>
    </div>"
