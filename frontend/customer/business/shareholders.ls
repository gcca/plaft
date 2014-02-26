/** @module customer.business.shareholders */


/**
 * Item for shareholder list.
 * @class UiShareholder
 * @extends View
 */
class Shareholder extends App.View

  /** @override */
  _tagName: \form

  /** @override */
  _className: gz.Css \parent-toggle

  /**
   * Form to JSON.
   * @return {Object}
   * @override
   */
  _toJSON: -> @$el._toJSON!

  /**
   * (Event) On remove shareholder from list.
   * @private
   */
  buttonOnRemove: !~> @free!

  /** @override */
  render: ->
    @$el.html @template!
    $buttonRemove = $ "
      <div class='#{gz.Css \form-group} #{gz.Css \col-md-1}'>
        <span class='#{gz.Css \glyphicon}
                   \ #{gz.Css \glyphicon-remove}
                   \ #{gz.Css \toggle}'
            style='margin-top:8px;cursor:pointer;font-size:18px'></span>
      </div>"
    $buttonRemove.0.onClick @buttonOnRemove
    @$el._append $buttonRemove

    @$el._fromJSON @model
    super!

  /**
   * Shareholder form.
   * @return {string}
   * @private
   */
  template: ->
    shared            = App.shared
    optionsFrom       = shared.shortcuts.html.optionsFrom
    documentTypeNames = shared.lists.documentTypes.names

    documentTypeOptions = optionsFrom documentTypeNames

    "
    <div class='#{gz.Css \form-group} #{gz.Css \col-md-3}'>
      <select class='#{gz.Css \form-control}' name='document[type]'>
        #documentTypeOptions
      </select>
    </div>

    <div class='#{gz.Css \form-group} #{gz.Css \col-md-3}'>
      <input type='text' class='#{gz.Css \form-control}'
          name='document[number]'>
    </div>

    <div class='#{gz.Css \form-group} #{gz.Css \col-md-5}'>
      <input type='text' class='#{gz.Css \form-control}'
          name='name'>
    </div>"


/**
 * Shareholder list.
 * @class UiShareholders
 * @extends View
 */
class Shareholders extends App.View

  /** @override */
  _tagName: \div

  /**
   * Shareholder list to JSON.
   * @return {Array.<Shareholder-JSON>}
   * @override
   */
  _toJSON: -> [.._toJSON! for @shareholders]

  /**
   * (Event) On add shareholder to list.
   * @private
   */
  buttonOnClick: ~> @addShareholder!

  /**
   * Add shareholder to list.
   * @param {Object} model Shareholder DTO.
   * @private
   */
  addShareholder: (model) !->
    shareholder = Shareholder.New model: model
    @shareholders._push shareholder
    @xContainer._append shareholder.render!.el

  /**
   * @param {Object} options {@code options.shareholders} collection.
   * @override
   */
  initialize: (options) !->
    /**
     * Shareholder views.
     * @type {Shareholder}
     * @private
     */
    @shareholders = new Array

    /**
     * Shareholder JSON list.
     * @type {Object}
     * @private
     */
    @collection = options.shareholders || new Array

    # Style
    App.dom._write ~> @el.css._marginBottom = '1em'

  /** @override */
  render: ->
    # Base form
    [@xContainer, xButton] = App.shared.shortcuts.xhtml.addToContainer!

    @el._append @xContainer
    @el._append xButton

    xButton.onClick @buttonOnClick

    @xContainer._append ($ "
      <form>
        <div class='#{gz.Css \form-group} #{gz.Css \col-md-3}'>
          <label>&nbsp;Documento</label>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-3}'>
          <label>&nbsp;Número</label>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-5}'>
          <label>&nbsp;Nombre</label>
        </div>
      </form>").0

    # Initial shareholders
    for model in @collection
      @addShareholder model

    super!

module.exports = Shareholders
