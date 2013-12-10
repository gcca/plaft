/**
 * @module customer-form
 */

widget = require '../widget'

/**
 * Customer Base Form View
 * -----------------------
 * ¡No instanciar directamente!
 * Esta clase solo es padre de PersonFormView y BusinessFormView.
 * Es requerido sobre-escribir el método {@code initForm}.
 * El método {@code getDataJSON} es re-escrito en business-form.
 *
 * @example
 * >>> declarationView = new DeclarationView
 * >>> baseView = new BaseFormView do
 * ...   declarationView : declarationView
 */
module.exports = class BaseFormView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \form

  /**
   * Commit form
   * Send customer data.
   * @const
   */
  commit: !->
    # (-o-) critical zone
    dataJSON = @getDataJSON!
    dataCustomer = @customer.toJSON!
    dataJSON <<< \documentType : 'RUC'
    delete! dataCustomer.\id

    # valid data
    if not dataJSON.\documentNumber .match /^(\d{8}|\d{11})$/
      (new widget.GAutoAlert (gz.Css \error),
                             "DNI o RUC erróneo:
                              &nbsp;#{dataJSON.\documentNumber .replace ' ' '_'}"
                             ).elShow!
      @trigger (gz.Css \on-error-declaration)
      return

    # declaration data
    dataDeclaration =
      \source              : delete dataJSON.\source
      \thirdDocumentNumber : delete dataJSON.\thirdDocumentNumber
      \thirdName           : delete dataJSON.\thirdName

    optionsDeclaration =
      \success : !(declaration) ~>
        @trigger (gz.Css \event-created-declaration), declaration
      \error : ->
        alert 'ERROR declaration'

    if _.\isEqual dataCustomer, dataJSON
      @customer.createDeclaration dataDeclaration, optionsDeclaration
    else
      @customer.save dataJSON, do
        \success : !(customer) ~>
          customer.createDeclaration dataDeclaration, optionsDeclaration
        \error : !->
          alert 'ERROR declaration'

  /**
   * Get JSON form.
   * @see commit
   * @see customer-form.business-form.BusinessFormView
   * @protected
   */
  getDataJSON: -> @$el.serializeJSON!

  /**
   * Initialize html form.
   * @protected
   */
  initForm: ->

  /**
   * @param {Object} customer GModel.
   * @constructor
   */
  !(@customer) -> super!

  /**
   * Initialize customer form view.
   * @private
   */
  initialize: !->
    @initForm!
    @el.id = \customer
    @el.onsubmit = (evt) -> evt.preventDefault!
    @el.className += " #{gz.Css \ink-form} #{gz.Css \top-space}
                     \ #{gz.Css \column-group} #{gz.Css \gutters}"
    @$el.populateJSON @customer.attributes
    ($ '[data-tip-text]' @el) .each (_, el) -> new gz.Ink.UI.Tooltip el

  /** @private */ customer        : null
