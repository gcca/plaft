/**
 * @module dashboard.module
 */

/** @private */
model = require '../../model'
/** @private */
widget = require '../../widget'
/** @private */
builder = require './builder'

/**
 * Alert signals modal.
 * @private
 */
AlertModal = require './dispatches/alertmodal'

/**
 * Dispatches (Disaptch collection).
 * @private
 */
DispatchCollection = model.Dispatches

/**
 * @class DispatchesView
 * @extends builder.Table
 */
module.exports = class DispatchesView extends builder.Table

  /**
   * View events.
   * @type {Object}
   * @private
   */
  events:
    /**
     * Show alert signals modal.
     * @param {Object} evt Event object
     * @private
     */
    "click ##{gz.Css \dispatch-alerts}": !(evt) ->
      btn = evt.currentTarget
      alertModal = new AlertModal @dispatches.get btn.dataset.\id
      AlertModal::'_events'."#{gz.Css \dismiss}"[0].\ctx = alertModal
      alertModal.buttonTarget = btn
      alertModal.elShow!

    "click ##{gz.Css \dispatch-save}": !(evt) ->
      btn = evt.currentTarget
      dispatch = @dispatches.get btn.dataset.\id
      dispatch.fix!

  /**
   * Generate toolbar for cell
   * Options:
   *   - alerts, edit dispatch
   *   - unusual, suspicious
   * Used by {@code render}.
   * @param {!Object} dispatch
   * @return {string}
   * @private
   */
  toolbarCell: gzc.Jade '''
    .button-toolbar.push-right
      .button-group
        button.ink-button#dispatch-alerts(
            data-id=id,
            data-tip-text="Señales de alerta",
            data-tip-color="{Css blue}")
          span.icon-file-alt
        button.ink-button(
            data-tip-text="Editar",
            data-tip-color="{Css blue}")
          span.icon-edit
        button.ink-button#dispatch-save(
            data-id=id,
            data-tip-text="Guardar",
            data-tip-color="{Css blue}")
          span.icon-save
      .button-group
        button.ink-button(
            data-tip-text="Normal",
            data-tip-color="{Css green}")
          span.icon-ok-sign
        button.ink-button(
            data-tip-text="Inusual",
            data-tip-color="{Css orange}")
          span.icon-info-sign
        button.ink-button(
            data-tip-text="Sospechosa",
            data-tip-color="{Css red}")
          span.icon-exclamation-sign
  '''

  /**
   * Counting alerts for dispatch.
   * Used by {@code render}.
   * @private
   */
  countAlerts: (alerts) ->
    (alerts |> _.\map _, (?) |> _.\reduce _, (+), 0).toString!

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    # (-o-) Remove. Improve Dispatch Model, Alert Modal View.
    # Builder particular alert modal
    AlertModal::countAlerts = @countAlerts
    AlertModal::\_events =
      "#{gz.Css \dismiss}": [
        \callback : ->
          $ @buttonTarget .parents \tr .children ':nth-child(3)' .html \
            (@countAlerts @dispatch.get \alerts)
        \context : void
        \ctx : void
      ]
    # ----
    @render!

  /**
   * Render view.
   * @requires countAlerts
   * @requires toolbarCell
   * @return {Object}
   */
  render: ->
    @createTable <[ Orden Cliente Alertas &nbsp; ]>
    @dispatches = new DispatchCollection
    @dispatches.fetch do
      \success : !(_, dispatches) ~>
        for dispatch in dispatches
          @addRow [
            "<b>#{dispatch[\orderNumber]}</b>"
            dispatch .\declaration .\customer .\name
            @countAlerts dispatch.\alerts
            @toolbarCell dispatch
          ]
        @showTable!
        $ '[data-tip-text]' .each (_, el) -> new gz.Ink.UI.Tooltip el
    super!

  /** @private */ @menuCaption = 'Despachos'
  /** @private */ @menuIcon    = gz.Css \icon-paste
  /** @private */ @menuTitle   = 'Lista de despachos'
