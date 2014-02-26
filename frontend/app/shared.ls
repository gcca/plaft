builtins = require './builtins'

FieldType = builtins.Types.Field


/**
 * Names.
 */
exports.lists = require './lists'
exports.lists <<<
  documentTypes:
    names:
      'DNI'
      'RUC'
      'Pasaporte'
      'Carné de Extranjería'
    codes:
      'DNI'
      'RUC'
      'PA'
      'CE'

/**
 * Shortcuts.
 */
exports.shortcuts =
  xhtml: require './shared/xhtml'

  html:
    optionsFrom: (names, values) ->
      if not values
        ["<option>#oName</option>" for oName in names]


  $html:
    controlGroup: ([fieldName,
                    fieldBullet, fieldLabel, fieldTip,
                    fieldType, ...fieldParams]) ->

      | not fieldLabel => $ "
        <div class='#{gz.Css \form-group}'>
          <label>
            <b>&nbsp;</b><span style='font-weight:normal'>&nbsp;</span>
          </label>
          <input type='text' class='#{gz.Css \form-control}'
              style='visibility:hidden'>
        </div>"

      | fieldType is FieldType.kLineEdit or not fieldType  => $ "
        <div class='#{gz.Css \form-group}'>
          <label data-toggle='tooltip' title='#fieldTip'>
            <b>#fieldBullet</b>
            &nbsp;
            <span style='font-weight:normal'>#fieldLabel</span>
          </label>
          <input type='text' class='#{gz.Css \form-control}' name='#fieldName'>
        </div>"

      | fieldType is FieldType.kComboBox =>
        html = new Array
        html._push "
          <div class='#{gz.Css \form-group}'>
            <label data-toggle='tooltip' title='#fieldTip'>
              <b>#fieldBullet</b>
              &nbsp;
              <span style='font-weight:normal'>#fieldLabel</span>
            </label>
            <select class='#{gz.Css \form-control}' name='#fieldName'>"
        for fieldOption in fieldParams.0
          html._push "<option>#fieldOption</option>"
        html._push '</select></div>'
        $ html._join ''

      | fieldType is FieldType.kRadioGroup =>
        html = new Array
        html._push "
          <div class='#{gz.Css \form-group}'>
            <label data-toggle='tooltip' title='#fieldTip'
                style='margin-right:4em;'>
              <b>#fieldBullet</b>
              &nbsp;
              <span style='font-weight:normal'>#fieldLabel</span>
            </label>
            <span class='#{gz.Css \pull-right}'>"
        for fieldOption in fieldParams.0
          html._push "
            <div class='#{gz.Css \radio-inline}'>
              <label style='font-weight:normal'>
                <input type='radio' name='#fieldName' value='#fieldOption'>
                #fieldOption
              </label>
            </div>"
        html._push '</span></div>'
        $ html._join ''

      | fieldType is FieldType.kView =>
        $control = $ "
          <div>
            <label data-toggle='tooltip' title='#fieldTip'>
              <b>#fieldBullet</b>
              &nbsp;
              <span style='font-weight:normal'>#fieldLabel</span>
            </label>
          </div>"
          .._append fieldParams.0.render!.el

/**
 * _form shared methods
 */
form_saveBack = (xbutton) !->
  xbutton.html 'Guardar'
  xbutton.Class._toggle gz.Css \btn-primary
  xbutton.Class._toggle gz.Css \btn-success

form_saveEvent = (evt) !->
  xbutton = evt._target
  xbutton.html 'Guardado'
  xbutton.Class._toggle gz.Css \btn-primary
  xbutton.Class._toggle gz.Css \btn-success
  setTimeout form_saveBack, 1500, xbutton


exports._form =
  patch:
    saveButton: (xbutton) !-> xbutton.addEvent \click form_saveEvent

exports._event =
  isCtrlV: (evt) -> evt._ctrlKey and evt._keyCode is 86
