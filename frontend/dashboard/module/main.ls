/**
 * @module dashboard.module
 */

/** @private */
ModuleBaseView = require './base'


/**
 * Dashboard: main page
 * @class MainView
 * @extends ModuleBaseView
 */
module.exports = class MainView extends ModuleBaseView

    /**
     * Html element.
     * @private
     */
    tagName: \div

    /**
     * Initialize view.
     * @private
     */
    initialize: !->
        @$el.html "
        <h3>Principal</h3>
        "

    /** @private  */ @menuCaption = 'Principal'
    /** @private  */ @menuIcon    = gz.Css \icon-dashboard
