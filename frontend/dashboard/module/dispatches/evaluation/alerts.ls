/** @module dashboard.module.dispacthes.evaluation */


/**
 * Basic alert list.
 * @class AlertsView
 */
module.exports = class AlertsView extends gz.GView

  render: ->
    @$el.html "<h2>GCCA</h2>"
    super!
