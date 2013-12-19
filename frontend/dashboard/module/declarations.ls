/**
 * @module dashboard.module
 */

/**
 * @private
 */
model = require '../../model'

/**
 * @private
 */
builder = require './builder'

/**
 * @private
 */
DeclarationCollection = model.Declarations

/**
 * @class DeclarationsView
 * @extends builder.Table
 */
module.exports = class DeclarationsView extends builder.Table

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \div

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @el.style.paddingTop = '0.6em'
    @createTable <[ ID Cliente Documento ]>

    declarations = new DeclarationCollection
    declarations.fetch do
      \success : !(_, declarations) ~>
        for declaration in declarations
          @addRow [
            "<b>#{declaration.\trackingId}</b>"
            declaration .\customer .\name
            declaration .\customer .\documentNumber
          ]
        @showTable!
        @$el.find \b .css do
          \user-select         : \text
          \-moz-user-select    : \text
          \-webkit-user-select : \text

  /** @private */ @menuCaption = '<div style="font-size:0.7em;display:inline">Declaraciones</div>'
  /** @private */ @menuIcon = gz.Css \icon-ambulance
  /** @private */ @menuTitle = 'Lista de declaraciones juradas <em>(DBZ)</em>'
