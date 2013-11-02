/**
 * @module customer-form
 */

/**
 * Customer Base Form View
 *
 * ¡No instanciar directamente!
 * Esta clase solo es padre de PersonFormView y BusinessFormView
 *
 * @example
 * >>> declarationView = new DeclarationView
 * >>> baseView = new BaseFormView
 *             declarationView : declarationView
 */
module.exports = class BaseFormView extends gz.GView

    /**
     * DOM element.
     * @type {string}
     * @private
     */
    tagName : \form

    /**
     * Commit form
     * Send customer data.
     * @const
     */
    commit : !->
        # (-o-) critical zone
        dataJSON = @getDataJSON!
        dataCustomer = @customer.toJSON!
        dataJSON <<< \documentType : 'RUC'
        delete dataCustomer[\id]
        if _[\isEqual] dataCustomer, dataJSON
            @declarationView.commit @customer
        else
            @customer.save dataJSON, do
                \success : gz.tie @, !(customer) ->
                    @declarationView.commit customer
                \error : ->
                    alert 'ERROR customer'

    /**
     * Get JSON form.
     * @protected
     */
    getDataJSON : -> @$el.serializeJSON!

    /**
     * Initialize html form.
     * @protected
     */
    initForm : ->

    /**
     * @param {Object} declarationView GView.
     * @param {Object} customer GModel.
     * @constructor
     */
    !(@declarationView, @customer) -> super!

    /**
     * Initialize customer form view.
     * @private
     */
    initialize : !->
        @initForm!
        @el.id = \customer
        @el.onsubmit = (event) -> event.preventDefault!
        @el.className += " #{gz.Css \ink-form} #{gz.Css \top-space}
                         \ #{gz.Css \column-group} #{gz.Css \gutters}"
        @$el.populateJSON @customer.attributes
        ($ '[data-tip-text]' @el) .each (_, el) -> new gz.Ink.UI.Tooltip el

    /** @private */ declarationView : null
    /** @private */ customer        : null
