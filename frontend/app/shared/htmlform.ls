/** @module app.shared.shortcuts */

FieldType = builtins.Types.Field


/**
 * Create field by field type.
 * @param {FieldOptions}
 */
fieldBy = ({_type=FieldType.kLineEdit, _name, _placeholder='', _options}) ->
  | _type is FieldType.kLineEdit => "
    <input type='text' class='#{gz.Css \form-control}' name='#_name'
        placeholder='#_placeholder'>
    "
  | _type is FieldType.kComboBox => "
    Not Implemented
    "
  | _type is FieldType.kTextEdit => "
    <textarea class='#{gz.Css \form-control}' name='#_name'
        placeholder='#_placeholder'>
    </textarea>
    "
  | _type is FieldType.kCheckBox => "
    <label class='#{gz.Css \checkbox}'>
      #_label
      &nbsp;
      <input type='checkbox' class='#{gz.Css \form-control}' name='#_name'
          placeholder='#_placeholder'>
    </label>
    "
  | otherwise => "Bad type"

/**
 * @typedef {{
 *   _type: FieldType,
 *   _name: string,
 *   _label: string,
 *   _placeholder: string
 *   _options: (Object|Array)
 * }}
 */
FieldOptions =
  _type        : null
  _name        : null
  _label       : null
  _placeholder : null
  _options     : null

/**
 * Create field.
 * @param {FieldOptions} _options
 */
_field = ({_label}: _options) ->
  (new Array
    .._push "<div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>"
    .._push (if _label? then "<label>#_label</label>" else '')
    .._push fieldBy _options
    .._push '</div>')._join ''

/** @export */
module.exports = _field: _field
