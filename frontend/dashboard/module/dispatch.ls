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
      register =
        \operation : @operationView.JSONFields!
        \sections  : [..JSONFields! for @sectionViewList]
      @dispatch.save \register : register, do
        \success : ->
          (new widget.GAutoAlert (gz.Css \success),
                                 "<b>DESPACHO:</b> Datos guardados.").elShow!
        \error : ->
          alert 'ERROR: Dispatch (6)'

  /**
   * On search from searchView event.
   * @param {!string} query Query text: orderNumber.
   * @private
   */
  onSearch: !(query) ~>
    if query.match /\d+-\d+/
      @dispatch = new DispatchModel \orderNumber : query
      @dispatch.fetch do
        \success : !(dispatch) ~>
          @renderInfo dispatch.get \register
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
                     style='overflow:hidden;margin-top:.8em'>"
    content.append tabView.render!.el
    @$el.find "ul.#{gz.Css \tabs-nav}" .append tab
    @$el.find "div.#{gz.Css \ink-tabs}" .append content

  /**
   * Render dispatch form.
   * @private
   */
  renderInfo : !(register) ~>
    # from template
    @$el.html @template
    # add operation view (anexo 2: operation register)
    @operationView = new OperationView kind: \operation
      @addTabView 'Operación', ..
      # set form data
      ..fieldsFromJSON register.\operation if register?
    # add section views (anexo 2: stakeholders)
    sections = register.\sections if register?
    sections ||= []
    capsSecs = _.\zip <[ Declarante Ordenante Destinario Tercero ]> sections
    for [caption, section]  in capsSecs
      new StakeholderView kind: caption
        @addTabView caption, ..
        @sectionViewList.push ..
        ..fieldsFromJSON section if register?
    # set ui-tabs manager
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
    super!

  /** @private */
  @menuCaption = 'Despacho'
  /** @private */
  @menuIcon    = gz.Css \icon-file
  /** @private */
  @menuTitle   = 'Despacho (Anexo 6)'
  /** @private */
  @menuHelp    = void

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
