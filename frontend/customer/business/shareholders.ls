class Shareholder extends App.View

  _tagName: \form

  _toJSON: -> @$el._toJSON!

  @@Pool!

  ## Events
  buttonOnRemove: !~>
    @Free!
    @_remove!

  ## View methods
  render: ->
    @$el.html @template!
    $buttonRemove = $ "
      <div class='#{gz.Css \form-group} #{gz.Css \col-md-1}'>
        <span class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-remove}'
            style='margin-top:8px;cursor:pointer;font-size:18px'></span>
      </div>"
    $buttonRemove.0.onClick @buttonOnRemove
    @$el._append $buttonRemove

    @$el._fromJSON @model
    super!

  template: ->
    shared = App.shared
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


module.exports = \

class Shareholders extends App.View

  _tagName: \div

  _toJSON: -> [.._toJSON! for @shareholders]

  ## Events
  buttonOnClick: ~> @addShareholder!

  ## Methods
  addShareholder: (model) !->
    shareholder = Shareholder.New model: model
    @shareholders._push shareholder
    @xContainer._append shareholder.render!.el

  ## View methods
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
