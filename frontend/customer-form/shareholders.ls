/**
 * @module customer-form.shareholder
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
 * @private
 */
class ShareholderView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \li

  /**
   * Initialize view.
   * @private
   */
  initialize: !(@options, @shareholder) ->
    a = gz.newel \a
    a.href = 'javascript:void(0)'

    cgroup = gz.newel \div
    cgroup.className = "#{gz.Css \column-group} #{gz.Css \gutters}"

    cname = gz.newel \div
    cname.className = "#{gz.Css \large-100}
                     \ #{gz.Css \medium-60}
                     \ #{gz.Css \small-70}"
    cname.style.margin = '0'

    cdocType = gz.newel \div
    cdocType.className = "#{gz.Css \large-50}
                        \ #{gz.Css \medium-20}
                        \ #{gz.Css \small-30}"
    cdocType.style.margin = '0'

    cdocNum = gz.newel \div
    cdocNum.className = "#{gz.Css \large-50}
                       \ #{gz.Css \medium-20}
                       \ #{gz.Css \small-100}"
    cdocNum.style.margin = '0'

    isNewMsg = @options.addIcon

    edName = new widget.EditableLabel do
      label : @shareholder.get \name
      icon  : isNewMsg
    cname.appendChild edName.el

    edDocNum = new widget.EditableLabel do
      label : @shareholder.get \documentNumber
      icon  : isNewMsg
    cdocNum.appendChild edDocNum.el

    edDocType = new widget.ComboBox do
      caption : 'Tipo de documento'
      choices :
        \DNI : 'Documento de Identidad Nacional'
        \PA  : 'Pasaporte'
        \CE  : 'Carné de Extranjería'
      choice : @shareholder.get \documentType
    cdocType.appendChild edDocType.el

    shareholder = @shareholder
    edName.bind \change, ->
      shareholder.set \name : @options.label

    edDocNum.bind \change, ->
      shareholder.set \documentNumber : @options.label

    edDocType.bind \change, ->
      shareholder.set \documentType : @choice!

    cgroup.appendChild cname
    cgroup.appendChild cdocType
    cgroup.appendChild cdocNum
    a.appendChild cgroup
    @el.appendChild a

/**
 * Shareholders view.
 * Manage shareholder list.
 * @public
 */
module.exports = class ShareholdersView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \nav

  /**
   * JSON shareholder list.
   * @return {Array.<!Object>}
   */
  zJSON: -> _.\map @shareholders.models, (.toJSON!)

  /**
   * Initialize view.
   * @param {?Object} options
   * @private
   */
  initialize: !(@options) ->
    div = gz.newel \div
    className = "#{gz.Css \large-100}
           \ #{gz.Css \medium-100}
           \ #{gz.Css \small-100}"
    div.innerHTML = "<button type='button'
               class='#{gz.Css \ink-button}
                  \ #{gz.Css \event-add-shareholder}'
               style='margin-bottom:0.7em'>
               Agregar <i class='#{gz.Css \icon-plus}'></i>
             </button>"
    @el.appendChild div

    ul = gz.newel \ul
    ul.className = "#{gz.Css \menu}
            \ #{gz.Css \vertical}
            \ #{gz.Css \rounded}
            \ #{gz.Css \shadowed}
            \ #{gz.Css \white}"

    @el.className = gz.Css \ink-navigation
    @el.appendChild ul
    @ul = ul

    shareholders = new ShareholderList
    shareholders.bind \add, !(shareholder, _, opts) ->
      shareholderView = new ShareholderView addIcon : opts.addIcon,
                          shareholder
      ul.appendChild shareholderView.el

    localShareholders = []
    localShareholders = @options.shareholders if @options.shareholders

    for shareholder in localShareholders
      shareholder = new ShareholderModel shareholder
      shareholders.add shareholder

    div.firstElementChild.onclick = !->
      shareholder = new ShareholderModel do
        \name           : 'Nombre'
        \documentType   : 'DNI'
        \documentNumber : 'Número'
      shareholders.add shareholder, addIcon : true

    @shareholders = shareholders

    @render!

  /**
   * Render view.
   * @return {Object}
   * @override
   */
  render: ->
    ## styleA1= @ul.firstElementChild.firstElementChild.style
    ## styleA1.borderTop = '1px solid rgba(0,0,0,0.08)'
    super!
