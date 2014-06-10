/** @module app.shared.shortcuts */

FieldType    = builtins.Types.Field
FieldOptions = builtins.Types.Options


/**
 * Create field by field type.
 * @param {FieldOptions}
 * @return {string}
 * @private
 */
_fieldby = ({_type = FieldType.kLineEdit, _name, _placeholder = '', \
             _tip = '', _options}) ->
  | _type is FieldType.kLineEdit =>
    App.dom._new \input
      ..type         = 'text'
      ..Class        = gz.Css \form-control
      .._name        = _name
      .._placeholder = _placeholder
  | _type is FieldType.kComboBox =>
    _options = _fieldoptions _options
    App.dom._new \select
      ..Class = gz.Css \form-control
      .._name = _name
      ..html _options
  | _type is FieldType.kTextEdit =>
    App.dom._new \textarea
      ..Class        = gz.Css \form-control
      .._name        = _name
      .._placeholder = _placeholder
  | _type is FieldType.kCheckBox =>
    App.dom._new \label
      ..Class = gz.Css \checkbox
      ..html "<span title='#_tip'>#_label</span>
              &nbsp;
              <input type='checkbox' class='#{gz.Css \form-control}'
                  name='#_name' placeholder='#_placeholder'>"
  | _type is FieldType.kRadioGroup =>
    App.dom._new \div
      ..html "Not implemented"
  | _type is FieldType.kView =>
      _options.render!.el
  | otherwise => "Bad type"


/**
 * Create field.
 * @param {FieldOptions} _options
 */
_field = ({_label, _tip = '', _head = 'label', \
           _class = gz.Css \col-md-6}: _options) ->
  App.dom._new \div
    ..Class = "#{gz.Css \form-group} #_class"
    if _label?
      ..html "<#_head title='#_tip'>#_label</#_head>"
    .._append _fieldby _options


/**
 * Fieldset and legend from fields.
 * @param {string} _legend
 * @param {Array.<FieldOptions>} _fields
 * @param {?string} _tip
 */
_fieldset = (_legend, _fields, _tip) ->
  _tip = if _tip? then " title='#_tip'" else ''
  App.dom._new \fieldset
    ..html "<legend#_tip>#_legend</legend>"
    for _options in _fields
      .._append _field _options


/**
 * To build html string pushing {@code field}'s and {@code fieldset}'s.
 * @class Builder
 * @extends Array
 */
class Builder extends Array implements PoolMixIn

  /**
   * Push field string.
   * @param {FieldOptions} _options
   * @return {HTMLElement}
   */
  field: (_options) -> @_push _field _options

  /**
   * Push fieldset string.
   * @param {string} _legend
   * @param {Array.<FieldOptions>} _fields
   * @param {?string} _tip
   * @return {HTMLElement}
   */
  fieldset: (_legend, _fields, _tip) -> @_push _fieldset _legend, _fields, _tip

  /**
   * Add standard save button.
   * @return {HTMLElement}
   */
  _save: ->
    App.dom._new \div
      ..Class = gz.Css \col-md-12
      ..html "<button class='#{gz.Css \btn}
                           \ #{gz.Css \btn-primary}
                           \ #{gz.Css \pull-right}'>
                Guardar
              </button>"
      @_push ..

  /**
   * Enable tooltips.
   * @return {Array.<HTMLElement>}
   */
  tooltips: -> for xel in @ then $ xel .tooltip!

  /**
   * Render option field list for simple form.
   * @param {HTMLElement} el
   * @param {Array.<Options>} fields
   * @public
   */
  @@render-list = (el, fields) ->
    fbuilder = App.shared.shortcuts.xhtml._form.Builder.New el
    for _field in fields then fbuilder.field _field
    fbuilder.render!
    fbuilder.free!

  /**
   * Render option field list for simple form with button save.
   * @param {HTMLElement} el
   * @param {Array.<Options>} fields
   * @public
   */
  @@render-list.with-save = (el, fields) ->
    fbuilder = App.shared.shortcuts.xhtml._form.Builder.New el
    for _field in fields then fbuilder.field _field
    fbuilder._save!
    fbuilder.render!
    fbuilder.free!

  /** @override */
  render: ->
    @el.html null
    for x in @ then @el._append x
    @

  /** @override */
  initialize: (@el) !->
    @_length = 0

  /** @type {HTMLElement} */ el: null

  implementsPool @@


/** @export */
module.exports = Builder
