/**
 * @module dashboard.module
 */

/** @private */
form = require '../../form'
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
      alertModal = new AlertModal @dispatches.get btn.dataset[\id]
      AlertModal::_events.'dismiss'[0].\ctx = alertModal
      alertModal.buttonTarget = btn
      alertModal.show!

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
  toolbarCell: (dispatch) -> "
    <div class='#{gz.Css \button-toolbar} #{gz.Css \push-right}'>
      <div class='#{gz.Css \button-group}'>
      <button id='#{gz.Css \dispatch-alerts}'
        class='#{gz.Css \ink-button}'
        data-id='#{dispatch[\id]}'
        data-tip-text='Señales de alerta'
        data-tip-color='#{gz.Css \blue}'>
        <span class='#{gz.Css \icon-file-alt}'></span>
      </button>
      <button class='#{gz.Css \ink-button}'
        data-tip-text='Editar'
        data-tip-color='#{gz.Css \blue}'>
        <span class='#{gz.Css \icon-edit}'></span>
      </button>
      </div>

      <div class='#{gz.Css \button-group}'>
      <button class='#{gz.Css \ink-button}'
        data-tip-text='Normal'
        data-tip-color='#{gz.Css \green}'>
        <span class='#{gz.Css \icon-ok-sign}'></span>
      </button>
      <button class='#{gz.Css \ink-button}'
        data-tip-text='Inusual'
        data-tip-color='#{gz.Css \orange}'>
        <span class='#{gz.Css \icon-info-sign}'></span>
      </button>
      <button class='#{gz.Css \ink-button}'
        data-tip-text='Sospechosa'
        data-tip-color='#{gz.Css \red}'>
        <span class='#{gz.Css \icon-exclamation-sign}'></span>
      </button>
      </div>
    </div>"

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
    AlertModal::_events =
      \dismiss : [
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
    @el.innerHTML = '<h3>Lista de despachos</h3>'
    @createTable <[ Orden Cliente Alertas &nbsp; ]>
    @dispatches = new DispatchCollection
    @dispatches.fetch do
      \success : !(_, dispatches) ~>
        for dispatch in dispatches
          @addRow [
            "<b>#{dispatch[\orderNumber]}</b>"
            dispatch[\customer][\name]
            @countAlerts dispatch[\alerts]
            @toolbarCell dispatch
          ]
        @showTable!
        $ '[data-tip-text]' .each (_, el) -> new gz.Ink.UI.Tooltip el
    super!

  /** @private */ @menuCaption = 'Despachos'
  /** @private */ @menuIcon    = gz.Css \icon-paste
