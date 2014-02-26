Module = require '../module'
Subform = require './reception/subform'

FieldType   = App.builtins.Types.Field
sharedLists = App.shared.lists

OPERATION_CODE     = sharedLists.OPERATION_CODE
OPERATION_TYPE     = sharedLists.OPERATION_TYPE
JURISDICTIONS_CODE = sharedLists.JURISDICTIONS_CODE
JURISDICTIONS      = sharedLists.JURISDICTIONS

isCtrlV = App.shared._event.isCtrlV

declaration       = App._global.settings.declaration
reValidSingle     = declaration.reValidSingle
reValidTracking   = declaration.reValidTracking
reInvalidTracking = declaration.reInvalidTracking

formHalf    = App.shared.shortcuts.xhtml._form.half
xLineEdit   = formHalf.lineEdit
xPairSelect = formHalf.pairSelect
xCheckBox   = formHalf.checkBox
xSave       = App.shared.shortcuts.xhtml._form.saveButton


module.exports = \

class Reception extends Module

  onSave: (evt) !~>
    evt.prevent!

    dto = $ @el._first ._toJSON!

    if (@vdeclaration.processFields dto) is -1
      alert 'No se ha buscado la Declaración o el Cliente'

    else
      dispatch = new App.model.Dispatch
      dispatch._save dto, do
        _success : !~>
          @xgroupSave.html "
            <button type='button'
                class='#{gz.Css \btn} #{gz.Css \btn-success}
                     \ #{gz.Css \pull-right}' disabled>
              Guardado
            </button>"

        _error   : !->
          alert 'ERROR: 92c0861a-934d-11e3-947e-88252caeb7e8'


  onChangeDeclaration: (evt) !~>
    evt.prevent!

    @xgroupSave._first._disabled = on

    if evt._target._checked
      then @showWithDeclaration! else @showWithoutDeclaration!

  showWithDeclaration: !-> @vdeclaration.formWith!

  showWithoutDeclaration: !-> @vdeclaration.formWithout!

  initiliaze: !->
    @vdeclaration = null
    @xgroupSave   = null

  render: ->
    xform = App.dom.newel \form
    xform.Class = gz.Css \row

    xLineEdit 'order' 'N&ordm; Orden de despacho' .appendTo xform

    # Set today
    today = new Date
    day   = today.getDate!
    day   = (if day < 10 then '0' else '') + day
    month = today.getMonth! + 1
    month = (if month < 10 then '0' else '') + month
    year  = today.getFullYear!

    xLineEdit 'date' 'Fecha'
      .._last._value = "#{day}-#{month}-#{year}"
      ..appendTo xform

    # Operation type
    xPairSelect('operation[code]',
                'operation[name]',
                OPERATION_CODE,
                OPERATION_TYPE,
                'Tipo de operación (SBS)')
      .appendTo xform

    # Regime
    xPairSelect('regime[code]',
                'regime[name]',
                OPERATION_CODE,
                OPERATION_TYPE,
                'Regimen Aduanero (DAM)')
      .appendTo xform

    # Jurisdiction
    xPairSelect('jurisdiction[code]',
                'jurisdiction[name]',
                JURISDICTIONS_CODE,
                JURISDICTIONS,
                'Aduana Despacho')
      .appendTo xform

    xLineEdit 'third' 'Identificación del Tercero' .appendTo xform

    xform.onSubmit ->
    @el._append xform

    # Declaration form
    xCheckBox '' '¿Hay Declaración Jurada?' .appendTo @el
      ..query 'input'
        .._checked = true
        ..onChange @onChangeDeclaration

    # Add button
    @xgroupSave = xSave!

    #   Init "with" declaration
    @vdeclaration = new Subform xsave: @xgroupSave._first
    @el._append @vdeclaration.render!.el

    #   button
    @xgroupSave._first
      .._disabled = yes
      ..onClick @onSave
    @el._append @xgroupSave

    super!

  @@_caption = 'Recepción'
  @@_icon    = gz.Css \glyphicon-inbox

  vdeclaration : null
  xgroupSave   : null