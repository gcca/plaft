/** @modules dashboard.modules.reception */

Module  = require '../module'
Subform = require './reception/subform'


# App local
FieldType   = App.builtins.Types.Field
sharedLists = App.shared.lists

# Local sharedlist
OPERATION_CODE     = sharedLists.OPERATION_CODE
OPERATION_TYPE     = sharedLists.OPERATION_TYPE
OPERATION_DAM_CODE = sharedLists.OPERATION_DAM_CODE
OPERATION_DAM_TYPE = sharedLists.OPERATION_DAM_TYPE
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


/** ---------
 *  Reception
 *  ---------
 * Module reception for dispatch documents.
 * @class UiReception
 * @extends Module
 */
class Reception extends Module

  /**
   * (Event) On save new dispatch.
   * @param {Object} evt
   * @private
   */
  onSave: (evt) !~>
    evt.prevent!

    xbutton = @xgroupSave._first
    xbutton._disabled = true

    dto = $ @el._first ._toJSON!

    if (@vdeclaration.processFields dto) is -1
      alert 'No se ha buscado la Declaración o el Cliente'

    else
      dispatch = new App.model.Dispatch
      dispatch._save dto, do
        _success : ~>
          @xgroupSave.html "
            <button type='button'
                class='#{gz.Css \btn} #{gz.Css \btn-success}
                     \ #{gz.Css \pull-right}' disabled>
              Guardado
            </button>"
          alert 'Guardado'
          @clean!
          @render!

        _error   : ->
          xbutton._disabled = false
          _error = App._global._error._get ...
          if _error._code isnt 500
            alert _error._json\e
          else
            alert 'ERROR: 92c0861a-934d-11e3-947e-88252caeb7e8'

  /**
   * (Event) On change form for declaration - customer.
   * @param {Object} evt
   * @see #showWithDeclaration
   * @see #showWithoutDeclaration
   * @private
   */
  onChangeDeclaration: (evt) !~>
    evt.prevent!

    @xgroupSave._first._disabled = on

    if evt._target._checked
      then @showWithDeclaration! else @showWithoutDeclaration!

  /**
   * Show declaration form.
   * @see #onChangeDeclaration
   * @private
   */
  showWithDeclaration: !-> @vdeclaration.formWith!

  /**
   * Show customer form.
   * @see #onChangeDeclaration
   * @private
   */
  showWithoutDeclaration: !-> @vdeclaration.formWithout!

  /** @override */
  initiliaze: !->
    /**
     * Declaration - customer form.
     * @type {Subform}
     * @private
     */
    @vdeclaration = null

    /**
     * DOM group div for save button.
     * @type {View}
     * @private
     */
    @xgroupSave   = null

  /** @private */ vdeclaration : null
  /** @private */ xgroupSave   : null

  /** @override */
  render: ->
    xform = App.dom.newel \form
    xform.Class = gz.Css \row

    xLineEdit 'order' 'N&ordm; Orden de despacho' .appendTo xform

    # Set today
#    today = new Date
#    day   = today.getDate!
#    day   = (if day < 10 then '0' else '') + day
#    month = today.getMonth! + 1
#    month = (if month < 10 then '0' else '') + month
#    year  = today.getFullYear!

#    xLineEdit 'date' 'Fecha'
#      .._last._value = "#{day}-#{month}-#{year}"
#      ..appendTo xform

    # Operation type
    xPairSelect('type[code]',
                'type[name]',
                OPERATION_CODE,
                OPERATION_TYPE,
                'Tipo de operación (SBS)')
      .appendTo xform

#    # Regime
#    xPairSelect('regime[code]',
#                'regime[name]',
#                OPERATION_DAM_CODE,
#                OPERATION_DAM_TYPE,
#                'Regimen Aduanero (DAM)')
#      .appendTo xform

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

  /** @protected */ @@_caption = 'Recepción'
  /** @protected */ @@_icon    = gz.Css \glyphicon-inbox


/** @export */
module.exports = Reception
