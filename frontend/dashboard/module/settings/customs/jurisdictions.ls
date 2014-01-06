/** @module dashboard.module.settings.customs */

/**
 * Import {@code GTypeahead}.
 * @private
 */
widget = require '../../../../widget'
globalOptions = require '../../../../globalOptions'


class JurisdictionModel extends gz.GModel
  defaults:
    \name : ''
    \code : ''

class JurisdictionCollection extends gz.GCollection
  model: JurisdictionModel

/**
 * @class JurisdictionView
 * @private
 */
class JurisdictionView extends gz.GView

  tagName: \form

  className: "#{gz.Css \ink-form} #{gz.Css \column-group} #{gz.Css \gutters}
            \ #{gz.Css \parent-toggle}"

  # Events
  onClosed: (evt) ~>
    tInput = evt.currentTarget
    tControlGroup = @el.firstElementChild
    lIndex = globalOptions.JURISDICTIONS.indexOf tInput.value
    if lIndex >= 0
      tControlGroup.classList.remove gz.Css \warning
      codeSelected = globalOptions.JURISDICTIONS_CODE[lIndex]
      tInput.nextElementSibling.innerHTML = codeSelected
      @codeText                           = codeSelected
    else
      tControlGroup.classList.add gz.Css \warning
      tInput.nextElementSibling.innerHTML = ''
      @codeText                           = ''

  onRemove: ~>
    @trigger (gz.Css \remove), @
    @$el.remove!

  # Methods
  JSONFields: ->
    jsonFields = @$el.serializeJSON!
    jsonFields.\code = @codeText
    jsonFields

  initialize: !->
    @codeText = @model.get \code

  render: ->
    @$el.html "
      <div class='#{gz.Css \control-group}
                \ #{gz.Css \large-90}
                \ #{gz.Css \medium-90}
                \ #{gz.Css \small-90}
                \ #{gz.Css \validation}' style='margin-bottom:0'>
        <div class='#{gz.Css \control} #{gz.Css \append-symbol}'>
          <span>
            <input type='text' name='name' placeholder='Jurisdicción'
                value='#{@model.get \name}'>
            <i class='#{gz.Css \icon-gz}' style='color:\#888'>
              #{@model.get \code}
            </i>
          </span>
        </div>
      </div>
      <span class='#{gz.Css \large-10}
                 \ #{gz.Css \medium-10}
                 \ #{gz.Css \small-10}
                 \ #{gz.Css \toggle}'
          style='margin-bottom:0;
                 margin-top:.4em;
                 cursor:pointer;
                 padding-left:1em'>
        <i class='#{gz.Css \icon-remove}' style='font-size:1.2em'></i>
      </span>"

    # Typeahead <input>
    $tInput = @$el.find \input

    # GTypeahead object
    (new widget.GTypeahead do
      \el       : $tInput.get 0
      mLimit    : 13
      mData     : JURISDICTIONS
      mTemplate : (p) -> "
        <p style='float:right;font-style:italic;margin-left:1em'>#{p.tCode}</p>
        <p style='font-size:14px;text-align:justify'>#{p.tName}</p>")
      ..elWidth '100%'
      ..elCss \paddingRight '4em'

    # <input> events
    $tInput.on \typeahead:closed   @onClosed

    # On click to remove
    $ @el.lastElementChild .on \click @onRemove
    super!

  # Attributes
  codeText     : null


JURISDICTIONS = [{tName   : n, \
                  tCode   : c, \
                  \value  : n, \
                  \tokens : n.split(' ').concat(c)} \
                  for [n, c] in globalOptions.JURISDICTIONS_PAIR]


/**
 * @class JurisdictionsView
 * @private
 */
module.exports = class JurisdictionsView extends gz.GView

  tagName: \div

  events:
    'keyup input': (evt) ->
      @addJurisdiction! if evt.ctrlKey and evt.keyCode is 13

  JSONFields: -> [juris.JSONFields! for juris in @jurisdictionViews]

  onAddJurisdiction: !(evt) ~>
    evt.preventDefault!
    @addJurisdiction!

  addJurisdiction: !(vModel = new JurisdictionModel) ->
    jurisdictionView = new JurisdictionView model: vModel
    jurisdictionView.on (gz.Css \remove), @onRemoveJurisdiction
    @jurisdictionViews.push jurisdictionView
    @$el.append jurisdictionView.render!.el
    jurisdictionView.$el.find \input .focus!

  onRemoveJurisdiction: (jurisdictionView) ~>
    @jurisdictionViews
      ..splice (..indexOf jurisdictionView), 1

  initialize: !({@collection = new JurisdictionCollection}) ->
    # jurisdiction views
    @jurisdictionViews = new Array

  /** @private */ jurisdictionViews: null

  render: ->
    @$el.html "
      <button type='button' class='#{gz.Css \ink-button}'
          style='margin-bottom:1em'>
        Agregar <i class='#{gz.Css \icon-plus}'></i>
      </button>"
    @el.firstElementChild.onclick = @onAddJurisdiction
    for lModel in @collection.models then @addJurisdiction lModel
    super!
