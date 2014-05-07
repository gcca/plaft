/** @module dashboard.modules.register */

Module = require '../module'

FieldType = App.builtins.Types.Field


class CodeNameField extends App.View

  _tagName: \div

  _className: "#{gz.Css \input-group} #{gz.Css \field-codename}"

  changeName: (_, _data) ~>
    @_span.html _data._code
    @_hidden._value = _data._code

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

  initialize: ({@_code, @_name, @_field}) !->

  _field  : null
  _code   : null
  _name   : null
  _input  : null
  _span   : null
  _hdiden : null

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
      .._enable!

    super!


/** --------
 *  Register
 *  --------
 * @class UiRegister
 * @extends Module
 */
class Register extends Module

  _tagName: \form

  /** @protected */ @@_caption = 'Ingreso de Operación'
  /** @protected */ @@_icon    = gz.Css \glyphicon-file

  /** @override */
  render: ->
    _FIELDS =
      * _name  : 'order'
        _label : 'N&ordm; Orden de despacho'

      * _name  : 'type'
        _label : 'Tipo de operación'
        _type  : FieldType.kView
        _options : new CodeNameField do
                     _code  : App.shared.lists.OPERATION_DAM_CODE
                     _name  : App.shared.lists.OPERATION_DAM_TYPE
                     _field : 'type'

      * _name  : 'jurisdiction'
        _label : 'Aduana Despacho'
        _type  : FieldType.kView
        _options : new CodeNameField do
                     _code : App.shared.lists.JURISDICTIONS_CODE
                     _name : App.shared.lists.JURISDICTIONS
                     _field : 'regime'

      * _name  : 'third'
        _label : 'Identificación del tercero'


    fbuilder = App.shared.shortcuts.xhtml._form.Builder.New @el
    for _field in _FIELDS then fbuilder.field _field
    fbuilder.render!
    fbuilder.free!

    ## @ui.desktop._search._focus!
    super!


/** @export */
module.exports = Register
