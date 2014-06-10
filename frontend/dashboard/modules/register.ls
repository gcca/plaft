/** @module dashboard.modules.register */

Module = require '../module'

FieldType = App.builtins.Types.Field
sharedLists = App.shared.lists

# Local sharedlist
OPERATION_DAM_CODE   = sharedLists.OPERATION_DAM_CODE
OPERATION_MATCH_CODE = sharedLists.OPERATION_MATCH_CODE
OPERATION_MATCH_TYPE = sharedLists.OPERATION_MATCH_TYPE


/** -------------
 *  CodeNameField
 *  -------------
 * Widget field to manage relation between name and code text.
 * @class UiCodeNameField
 * @extends View
 */
class CodeNameField extends App.View

  /** @override */
  _tagName: \div

  /** @override */
  _className: "#{gz.Css \input-group} #{gz.Css \field-codename}"

  /**
   * (Event) On change input value.
   * @param {Object} evt
   * @private
   */
  changeCode: (evt) ~> @_span.html @_hidden._value

  /**
   * (Event) On change cursor for name.
   * @param {Event} _
   * @param {Object} _data Same data from collection.
   * @private
   */
  changeName: (_, _data) ~>
    @_span.html _data._code
    @_hidden._value = _data._code

  /**
   * (Event) On change value from number.
   * @private
   */
  changeValue: ~>
    _value = @_input._value
    if _value._match /\d+/
      i = @_code._index _value
      if i is -1
        @_input._value = 'Código inválido'
        @_span.html '000'
        @_hidden._value = '000'
      else
        @_input._value = @_name[i]
        @_span.html _value
        @_hidden._value = _value

  /**
   * @param {Object.<Array.<string>, Array.<string>, string>}
   * @override
   */
  initialize: ({@_code, @_name, @_field}) !->

  /** @private */ _field  : null
  /** @private */ _code   : null
  /** @private */ _name   : null
  /** @private */ _input  : null
  /** @private */ _span   : null
  /** @private */ _hdiden : null

  /** @override */
  render: ->
    @_input = App.dom._new \input
      .._type = \text
      .._name = "#{@_field}[name]"
      ..Class = gz.Css \form-control

    @_span = App.dom._new \span
      ..Class = gz.Css \input-group-addon
      ..html '000'

    @_hidden = App.dom._new \input
      .._type = \hidden
      .._name = "#{@_field}[code]"

    # Hack
    App.internals.defnps @_hidden, do
      _value:
        get: -> @value
        set: (a) ->  @value = a ; $ @ .trigger \change

    @el._append @_hidden
    @el._append @_input
    @el._append @_span

    (new App.widget.Typeahead do
      el          : @_input
      _source     :
        _display : App.widget.Typeahead.Source.kDisplay
        _tokens  : App.widget.Typeahead.Source.kTokens
      _limit      : 9
      _collection : [{
        _name    : n, \
        _code    : c, \
        _display : n, \
        _tokens  : n + ' ' + c } \
        for [n, c] in _.zip @_name, @_code]
      _template   : (p) -> "
        <p style='float:right;font-style:italic;margin-left:1em'>#{p._code}</p>
        <p style='font-size:14px;text-align:justify'>#{p._name}</p>")
      ..onCursorChanged @changeName
      ..onClosed @changeValue
      ..render!
    @_hidden.onChange @changeCode

    super!




class DModal extends App.widget.Modal

  /** @override */
  render: ->
    header-title = App.widget.Modal._title 'Declaración Jurada'

    ## button-left = App.dom._new \button
    ##   .._type = \button
    ##   ..Class = gz.Css \close
    ##   ..Class = "#{gz.Css \btn} #{gz.Css \btn-default} #{gz.Css \pull-left}"
    ##   ..html 'Nuevo'

    ## button-right = App.dom._new \a
    ##   ..Class   = "#{gz.Css \btn} #{gz.Css \btn-primary} #{gz.Css \pull-right}"
    ##   ..html 'x'

    _left = App.dom._new \div
      ..Class = gz.Css \col-md-3
      ..html "<button type='button'
                      class='close'
                      data-dismiss='modal'
                      style='font-size:33px;float:left'>&times;</button>"
      ## .._append button-left

    _center = App.dom._new \div
      ..Class = gz.Css \col-md-6
      .._append header-title

    _right = App.dom._new \div
      ..Class = gz.Css \col-md-3
      ## .._append button-right

    _row = App.dom._new \div
      ..Class = gz.Css \col-md-12
      .._append _left
      .._append _center
      .._append _right

    @m_header.Class._add gz.Css \row
    @m_header._append _row
    App.dom._write ~>
      _center.css
        .._text-align  = 'center'
        .._padding-top = '4px'

      _left.css._padding-left = '0'
      _right.css._padding-right = '0'

      _row.css
        .._padding-left  = '0'
        .._padding-right = '0'

      @m_header.css
        .._margin-left    = '0'
        .._margin-right   = '0'
        .._padding-bottom = '4px'
        .._padding-top    = '6px'

    App.dom._write ~> @m_body.css._padding = '0'
    @m_body.html "<iframe src='/customer'
                      style='border:none;width:100%;height:81%'></iframe>"

    @m_dialog.css._width = '96%'

    @_show!
    super!

  /** @override */
  initialize: !->
    super do
      _type  : App.widget.Modal.Type.kLarge
      _modal : \backdrop : \static




/** --------
 *  Register
 *  --------
 * Create and edit dispatch register. Further, is possible create a edit
 * declarations.
 * @class UiRegister
 * @extends Module
 */
class Register extends Module

  /** @override */
  _tagName: \form

  /** @override */
  _className : "#{Module::_className} #{gz.Css \row}"

  /** @override */
  free: ->
    ## @_fields.1._options.free!
    ## @_fields.2._options.free!
    super!

  /** @override */
  focus-first-field: -> @el.query \input ._focus!

  /**
   * (Event) On search by disptach order-number.
   * @param {string} _query
   * @private
   */
  onSearch: (_query) ~>
    @dispatch = new App.model.Dispatch \order : _query
    @dispatch.fetch do
      _success: (_, dispatch) ~>
        @render!
        @el._last
          .._first
            ..Class._remove gz.Css \hide
            .._next.Class._remove gz.Css \hide
        @$el._fromJSON dispatch
      _error: -> alert 'Número de orden no hallado: ' + _query

  /**
   * (Event) On save dispatch data.
   * @param {Object} evt
   * @private
   */
  onSave: (evt) ~>
    ## evt.prevent!

    dto = @$el._toJSON!
    i = OPERATION_DAM_CODE._index dto.'regime'.\code
    dto\type =
      \code : OPERATION_MATCH_CODE[i]
      \name : OPERATION_MATCH_TYPE[i]

    dto\declaration = @declarationId if @declarationId?
    dto\customer = @iwun if @iwun?

    @dispatch.store dto, do
      _success: -> alert 'Guardado'
      _error: -> alert 'ERROR: ea243004-d93f-11e3-8c62-88252caeb7e8'

  /** @override */
  initialize: ->
    /**
     * To create o edit dispatch.
     * @type {Model}
     * @private
     */
    @dispatch = new App.model.Dispatch
    @el.onSubmit App._void._submit

  /** @private */ dispatch       : null
  /** @private */ _fields        : null
  /** @private */ declarationId  : null

  /** @protected */ @@_caption = 'Ingreso de Operación'
  /** @protected */ @@_icon    = gz.Css \glyphicon-file

  /** @override */
  render: ->
    /**
     * Fields
     * @type {Array.<Options>}
     * @private
     */
    @_fields =
      * _name    : 'order'
        _label   : 'N&ordm; Orden de despacho'

      * _name    : 'regime'
        _label   : 'Tipo de operación'
        _type    : FieldType.kView
        _options : new CodeNameField do
                     _code  : App.shared.lists.OPERATION_DAM_CODE
                     _name  : App.shared.lists.OPERATION_DAM_TYPE
                     _field : 'regime'

      * _name    : 'jurisdiction'
        _label   : 'Aduana Despacho'
        _type    : FieldType.kView
        _options : new CodeNameField do
                     _code : App.shared.lists.JURISDICTIONS_CODE
                     _name : App.shared.lists.JURISDICTIONS
                     _field : 'jurisdiction'

      * _name    : 'third'
        _label   : 'Identificación del tercero'

    App.shared.shortcuts.xhtml._form.Builder.render-list.with-save @el,
                                                                   @_fields

    @el._last
      ..html "
        <button class='#{gz.Css \btn}
                     \ #{gz.Css \btn-primary}
                     \ #{gz.Css \pull-right}
                     \ #{gz.Css \hide}'
                style='margin-left:12px'>Guardar</button>
        <button class='#{gz.Css \btn}
                     \ #{gz.Css \btn-default}
                     \ #{gz.Css \pull-right}
                     \ #{gz.Css \hide}'
                style='margin-left:12px'>Nuevo</button>
        <button type='button'
                class='#{gz.Css \btn}
                     \ #{gz.Css \btn-default}
                     \ #{gz.Css \pull-right}'>Declaración Jurada</button>"
      .._first.onClick @onSave
      .._first._next.onClick ~> @ui.desktop._reload!
      .._last.onClick ~>

        @el._last
          .._first
            ..Class._remove gz.Css \hide
            .._next.Class._remove gz.Css \hide
          ## .._last.Class._add gz.Css \hide

        m = new DModal
        ## m.$el.on \hidden.bs.modal, (e) ->
        ##   console.log 'ehi-mdl'

        getBtnSave = ~>
          ifrm = m.el.query \iframe
          (setTimeout getBtnSave, 200; return) if not ifrm?
          (setTimeout getBtnSave, 200; return) if not ifrm.contentDocument?

          btn = ifrm.contentDocument.query "##{gz.Css \id-save}"
          setTimeout getBtnSave, 200 if not btn?

          btn.addEventListener \click ~>
            getHdr = ~>
              hdr = ifrm.contentDocument.query ".#{gz.Css \modal-header}"
              (setTimeout getHdr, 200; return) if not hdr?
              a = hdr.query "a.#{gz.Css \pull-left}"
              (setTimeout getHdr, 200; return) if not a?
              a\href = ''
              a.html 'Cerrar'
              a.onClick ~>
                m._hide!
                @declarationId = parseInt ((hdr._first._last._first.\href).slice 34, 50)
                @iwun = ifrm.contentWindow\kmll
            getHdr!

        m.render!
        m.el.query \iframe .\onload = getBtnSave
    super!


/** @export */
module.exports = Register
