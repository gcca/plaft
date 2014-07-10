/** @modules dashboard.modules.register */


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
 * TODO(...): Move to internal-module app widgets.
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


/** -----
 *  Order
 *  -----
 * View to manage dispatch initial data.
 * TODO(...): onSave deprecated.
 * @class UiOrder
 * @extends View
 */
class Order extends App.View implements App.builtins.Serializable

  /** @override */
  _tagName: \form

  /** @override */
  _className : "#{gz.Css \row}"

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
      _success: ~> @trigger gz.Css \on-stored
      _error: -> alert 'ERROR: ea243004-d93f-11e3-8c62-88252caeb7e8'

  /**
   * (Trigger) Operation change.
   * Raised when on blur event for input html element.
   * Send the {@code Event}.
   * @param {Event} evt
   * @private
   * @see @render
   */
  triggerOperationChange: (evt) ~>
    @trigger (gz.Css \on-operation-change), evt

  /** @override */
  initialize: ->
    /**
     * To create o edit dispatch.
     * @type {Model}
     * @private
     */
    @dispatch = new App.model.Dispatch
    @el.onSubmit App._void._submit
    super!

  /** @private */ dispatch       : null
  /** @private */ _fields        : null
  /** @private */ declarationId  : null

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

      * _name    : 'description'
        _label   : 'Descripción de mercancía'
        _type    : FieldType.kTextEdit

    App.shared.shortcuts.xhtml._form.Builder.render-list @el, @_fields

    @el._elements.'regime[name]'.onBlur @triggerOperationChange
    super!


/** @export */
module.exports = Order


# vim: ts=2 sw=2 sts=2 et:
