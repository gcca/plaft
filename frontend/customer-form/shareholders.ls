/**
 * @module customer-form.shareholder
 * Use by BusinessFormView, to manage shareholder list.
 * @see customer-form.business-form.BusinessFormView
 */

/**
 * Ui Widgets (Customer).
 * @private
 */
widget = require './widget'

/**
 * Domain models.
 * @private
 */
model  = require '../model'

/** @private */ ShareholderModel = model.Shareholder
/** @private */ ShareholderList  = model.Shareholders

/**
 * Shareholder view.
 * Manage shareholder item in list.
 * @class
 * @private
 */
class ShareholderView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \div

  /**
   * Style.
   * @type {string}
   * @private
   */
  className: "#{gz.Css \large-100} #{gz.Css \medium-100} #{gz.Css \small-100}'>"

  /**
   * View events.
   * @type {Object}
   * @private
   */
  events:
    /**
     * On click remove DOM element.
     * @private
     */
    "click ##{gz.Css \id-icon-remove}": !-> @model.destroy!
    /**
     * On key press enter.
     * @param {Object} evt
     * @private
     */
    "keypress input": !(evt) ->
      @model.collection.push new ShareholderModel if 13 == evt.keyCode

  /**
   * JSON shareholder model.
   * @return {!Object}
   */
  JSONFields: ->
    \documentType   : @$el.find "##{gz.Css \id-documentType}"   .val!
    \documentNumber : @$el.find "##{gz.Css \id-documentNumber}" .val!
    \name           : @$el.find "##{gz.Css \id-name}"           .val!

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    # model
    @model.bind \destroy @unrender
    # Style
    @$el.css \margin '.3em 0'

  /**
   * Render view.
   * @return {Object}
   * @override
   */
  render: ->
    aHtml = new Array

    aHtml.push "<div class='#{gz.Css \large-20}
                          \ #{gz.Css \medium-20}
                          \ #{gz.Css \small-100}'>"
    doct = @model.get \documentType
    aHtml.push "<select id='#{gz.Css \id-documentType}'
                    class='#{gz.Css \large-95}
                         \ #{gz.Css \medium-95}
                         \ #{gz.Css \small-95}'>
                  <option value='DNI' #{if doct is \DNI then \selected else ''}>
                    DNI
                  </option>
                  <option value='PA' #{if doct is \PA then \selected else ''}>
                    Pasaporte
                  </option>
                  <option value='CE' #{if doct is \CE then \selected else ''}>
                    Carné de extranjería
                  </option>
                </select>"
    aHtml.push '</div>'

    aHtml.push "<div class='#{gz.Css \large-20}
                          \ #{gz.Css \medium-20}
                          \ #{gz.Css \small-100}'>"
    aHtml.push "<input id='#{gz.Css \id-documentNumber}' type='text'
                    class='#{gz.Css \large-95}
                         \ #{gz.Css \medium-95}
                         \ #{gz.Css \small-95}'
                    value='#{@model.get \documentNumber}'>"
    aHtml.push '</div>'

    aHtml.push "<div class='#{gz.Css \large-50}
                          \ #{gz.Css \medium-50}
                          \ #{gz.Css \small-100}'>"
    aHtml.push "<input id='#{gz.Css \id-name}' type='text'
                    class='#{gz.Css \large-95}
                         \ #{gz.Css \medium-95}
                         \ #{gz.Css \small-95}'
                     value='#{@model.get \name}'>"
    aHtml.push '</div>'

    aHtml.push "<div class='#{gz.Css \large-10}
                          \ #{gz.Css \medium-10}
                          \ #{gz.Css \small-100}'>"
    aHtml.push "<span id='#{gz.Css \id-icon-remove}'
                    class='#{gz.Css \icon-remove}
                         \ #{gz.Css \icon-large}' style='cursor:pointer'>
                </span>"
    aHtml.push '</div>'

    @$el.html (aHtml.join '')
    super!

  /**
   * Unrender view.
   * @override
   */
  unrender: !~> @remove!

/**
 * Shareholders view.
 * Manage shareholder list.
 * @class ShareholdersView
 * @public
 */
module.exports = class ShareholdersView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \div

  /**
   * Style.
   * @type {string}
   * @private
   */
  className: "#{gz.Css \large-100} #{gz.Css \medium-100} #{gz.Css \small-100}'>"

  /**
   * View events.
   * @type {Object}
   * @private
   */
  events:
    /**
     * On click add shareholder.
     * @private
     */
    "click ##{gz.Css \id-icon-plus}": !-> @collection.push new ShareholderModel

  /**
   * JSON shareholder collection.
   * @return {Array.<!Object>}
   */
  JSONFields: -> _.\map @collection.models, (.view.JSONFields!)

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    /**
     * Shareholder collection.
     * @type {Array.<Object>}
     * @private
     */
    @collection ||= new ShareholderList
    # collection
    @collection.bind \add @appendShareholder
    # Style
    @$el.css do
      \marginTop  : '.8em'
      \marginLeft : '1em'

  /**
   * Render view.
   * @return {Object} DOM object.
   * @override
   */
  render: ->
    ## styleA1= @ul.firstElementChild.firstElementChild.style
    ## styleA1.borderTop = '1px solid rgba(0,0,0,0.08)'
    aHtml = new Array

    aHtml.push "<div class='#{gz.Css \large-100}
                          \ #{gz.Css \medium-100}
                          \ #{gz.Css \small-100}' style='margin-bottom:.5em'>"

    aHtml.push "<div class='#{gz.Css \large-10}
                          \ #{gz.Css \medium-10}
                          \ #{gz.Css \small-100}
                          \ #{gz.Css \content-left}'>"
    aHtml.push "<button id='#{gz.Css \id-icon-plus}' type='button'
                    class='#{gz.Css \ink-button}'>
                  Agregar
                  &nbsp;
                  <i class='#{gz.Css \icon-plus}'></i>
                </button>"
    aHtml.push '</div>'
    aHtml.push '</div>'

    aHtml.push "<div class='#{gz.Css \large-100}
                          \ #{gz.Css \medium-100}
                          \ #{gz.Css \small-100}'>"

    aHtml.push "<div class='#{gz.Css \large-20}
                          \ #{gz.Css \medium-20}
                          \ #{gz.Css \small-100}'>"
    aHtml.push '<b>Documento</b>'
    aHtml.push '</div>'

    aHtml.push "<div class='#{gz.Css \large-20}
                          \ #{gz.Css \medium-20}
                          \ #{gz.Css \small-100}'>"
    aHtml.push '<b>Número</b>'
    aHtml.push '</div>'

    aHtml.push "<div class='#{gz.Css \large-50}
                          \ #{gz.Css \medium-50}
                          \ #{gz.Css \small-100}'>"
    aHtml.push '<b>Nombres</b>'
    aHtml.push '</div>'

    aHtml.push '</div>'

    @$el.html (aHtml.join '')
    super!

  /**
   * @param {Object} shareholder
   * @public
   */
  appendShareholder: !(shareholder) ~>
    shareholder.collection = @collection
    shareholderView = new ShareholderView model: shareholder
    shareholder.view = shareholderView
    @$el.append shareholderView.render!.el
    shareholderView.el.firstElementChild.firstElementChild.focus!
