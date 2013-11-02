/**
 * @module dashboard
 */

/**
 * @private
 */
modules = [
    MainView        = require './module/main'
    DeclarationView = require './module/declaration'
    DispatchesView  = require './module/dispatches'
    # OperationsView   = require'./module/operations'
    # (-o-) To remove... NewOperation
    #NewOperationView = require'module/newoperation'
]

/**
 * @class MenuView
 */
module.exports = class MenuView extends gz.GView

    /**
     * DOM element.
     * @type {string}
     * @private
     */
    tagName : \nav

    /**
     * View events.
     * @private
     */
    events:
        /**
         * Click menu link.
         * @param {Object} evt Event object.
         * @private
         */
        'click a': !(evt) ->
            @trigger (gz.Css \change-desktop), evt.currentTarget.module
            el = evt.currentTarget.parentElement
            @prevEl.classList.remove gz.Css \active if @prevEl?
            @prevEl = el
            el.classList.add gz.Css \active

    /**
     * Initialize view.
     * @private
     */
    initialize : !->
        @el.className = gz.Css \ink-navigation

        @ul = gz.newel \ul
        @ul.className = "#{gz.Css \menu}
                      \ #{gz.Css \vertical}
                      \ #{gz.Css \white}
                      \ #{gz.Css \rounded}
                      \ #{gz.Css \shadowed}"
        for module in modules
            li = gz.newel \li
            a  = gz.newel \a

            a.href = 'javascript:void(0)'
            a.innerHTML = "<i class='#{module.menuIcon}'></i>&nbsp;&nbsp;
                           #{module.menuCaption}"
            a.module = module

            li.appendChild a
            @ul.appendChild li

        @el.appendChild @ul
