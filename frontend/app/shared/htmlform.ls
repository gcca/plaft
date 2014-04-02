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
  | _type is FieldType.kLineEdit => "
    <input type='text' class='#{gz.Css \form-control}' name='#_name'
        placeholder='#_placeholder'>
    "
  | _type is FieldType.kComboBox =>
    _options = _fieldoptions _options
    "
    <select class='#{gz.Css \form-control}' name='#_name'>
      #_options
    </select>
    "
  | _type is FieldType.kTextEdit => "
    <textarea class='#{gz.Css \form-control}' name='#_name'
        placeholder='#_placeholder'>
    </textarea>
    "
  | _type is FieldType.kCheckBox => "
    <label class='#{gz.Css \checkbox}'>
      <span title='#_tip'>#_label</span>
      &nbsp;
      <input type='checkbox' class='#{gz.Css \form-control}' name='#_name'
          placeholder='#_placeholder'>
    </label>
    "
  | _type is FieldType.kRadioGroup => "
    Not implemented
    "
  | _type is FieldType.kView => "
    Not implemented
    "
  | otherwise => "Bad type"


/**
 * Create field.
 * @param {Array.<string>} _html
 * @param {FieldOptions} _options
 */
_field = (_html, {_label, _tip = '', _head = 'label', \
          _class = gz.Css \col-md-6}: _options) !->
  _html._push "<div class='#{gz.Css \form-group} #_class'>"
  _html._push (if _label?
               then "<#_head title='#_tip'>#_label</#_head>"
               else '')
  _html._push _fieldby _options
  _html._push '</div>'


/**
 * Fieldset and legend html from fields.
 * @param {Array.<string>} _html
 * @param {string} _legend
 * @param {Array.<FieldOptions>} _fields
 * @param {?string} _tip
 */
_fieldset = (_html, _legend, _fields, _tip) !->
  _tip = if _tip? then " title='#_tip'" else ''
  _html._push "<fieldset><legend#_tip>#_legend</legend>"
  for _options in _fields
    _field _html, _options
  _html._push '</fieldset>'


/**
 * To build html string pushing {@code field}'s and {@code fieldset}'s.
 * @class Builder
 * @extends Array
 */
class Builder extends Array implements PoolMixIn

  /**
   * Push field string.
   * @param {FieldOptions} _options
   * @return {string}
   */
  field: (_options) -> _field @, _options

  /**
   * Push fieldset string.
   * @param {string} _legend
   * @param {Array.<FieldOptions>} _fields
   * @param {?string} _tip
   * @return {string}
   */
  fieldset: (_legend, _fields, _tip) -> _fieldset @, _legend, _fields, _tip

  /**
   * Html string.
   * @return {string}
   */
  html: -> @_join ''

  /** @override */
  initialize: !-> @_length = 0

  implementsPool @@


/** @export */
exports.Builder = Builder
