/** @module dashboard.modules.numeration */

Module = require '../../module'

FieldType = App.builtins.Types.Field


/**
 * Item for shareholder list.
 * @class UiProductItem
 * @extends View
 */
class ProductItem extends App.View

  /** @override */
  _tagName: \li

  /** @override */
  _className: gz.Css \parent-toggle

  /**
   * (Event) On key up. Add new {@code ProductItem} if key 'enter' up.
   * @private
   */
  onKeyUp: (evt) ~> @trigger gz.Css \on-key-enter if evt._keyCode is 13

  /**
   * (Event) Remove item.
   * @private
   */
  _destroy: !~> @free!

  /** @override */
  initialize: ({@_item = ''}) !->

  /** @private */ _item: null

  /** @override */
  render: ->
    @el.css._margin-bottom = '4px'
    @el.html "
      <input type='text' class='#{gz.Css \form-control} #{gz.Css \sibling}'
          name='items[]' value='#{@_item}'
          style='display:inline;
                 width:92%'>
      <span class='#{gz.Css \glyphicon}
                 \ #{gz.Css \glyphicon-remove}
                 \ #{gz.Css \toggle}'
          style='width:8%;
                 font-size:22px;
                 vertical-align:middle;
                 text-align:right;
                 cursor:default'></span>"
    @el._first.onKeyUp @onKeyUp
    @el._last.onClick @_destroy
    super!


/**
 * Shareholder list.
 * @class UiProductList
 * @extends View
 */
class ProductList extends App.View

  /** @override */
  _tagName: \ul

  /**
   * Add new item.
   * @param {string} _item
   * @return {UiProductItem}
   * @private
   */
  addOne: (_item) ->
    ProductItem.New _item: _item
      ..on (gz.Css \on-key-enter), @addOneWithFocus
      @el._append ..render!.el

  /**
   * Add new item and get focus.
   * @return {UiProductItem}
   * @private
   */
  addOneWithFocus: ~> @addOne!.el._first._focus!

  /** @override */
  initialize: ({@_collection}) !-> super!

  /** @private */ _collection: null

  /** @override */
  render: ->
    App.dom._write ~>
      @el.css._padding-left = '0'
      @el.css\listStyle     = 'none'

    if @_collection? and @_collection._length > 0
      for _item in @_collection
        @addOne _item
    else
      @addOne!

    super!


/** --------------
 *  NumerationEdit
 *  --------------
 * Numeration module for register DAM numeration and extra data.
 * TODO(...): This module should become a operator form for data analysis.
 * @class UiNumerationEdit
 * @extends Module
 */
class NumerationEdit extends Module

  ## /** @override */
  ## _tagName: \form

  /**
   * (Event) On save dispatch numeration data.
   * @param {Object} evt
   * @private
   */
  onSave: (evt) ~>
    dto = $ @main-form ._toJSON!
      ..\supplier = $ @supplier-form ._toJSON!
      ..\importer = $ @importer-form ._toJSON!

    @dispatch.store \numeration : dto, do
      _success: -> alert 'Guardado'
      _error: -> alert 'ERROR: 010dbe9c-a584-11e3-8bb0-88252caeb7e8'

  /**
   * Show form for dispatch numeration.
   * @param {Object} dispatch DTO disptach data.
   * @private
   */
  showForm: (dispatch) ->
    # Header form (info about dispatch)
    header_form =  App.dom._new \form
      ..Class = gz.Css \form-horizontal
      ..html "
        <fieldset disabled>
        <div class='#{gz.Css \form-group} #{gz.Css \col-md-7}'>
          <label class='#{gz.Css \col-md-5} #{gz.Css \control-label}'>
            N&ordm; Orden Despacho
          </label>
          <div class='#{gz.Css \col-md-7}'>
            <input type='text' class='#{gz.Css \form-control}'
                value='#{dispatch.\order}'>
          </div>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-5}'
             title='#{dispatch.'regime'.\name}'>
          <label class='#{gz.Css \col-md-8} #{gz.Css \control-label}'>
            Régimen Aduanero
          </label>
          <div class='#{gz.Css \col-md-4}'>
            <input type='text' class='#{gz.Css \form-control}'
                   value='#{dispatch.'regime'.\code}'
                   style='text-align:right'>
          </div>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-7}'>
          <input type='text' class='#{gz.Css \form-control}'
              style='visibility:hidden'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-5}'
             title='#{dispatch.'jurisdiction'.\name}'>
          <label class='#{gz.Css \col-md-8} #{gz.Css \control-label}'>
            Aduana Despacho
          </label>
          <div class='#{gz.Css \col-md-4}'>
            <input type='text' class='#{gz.Css \form-control}'
                   value='#{dispatch.'jurisdiction'.\code}'
                   style='text-align:right'>
          </div>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-7}'>
          <label class='#{gz.Css \col-md-5} #{gz.Css \control-label}'>
            DJ Anexo 5
          </label>
          <div class='#{gz.Css \col-md-7}'>
            <input type='text' class='#{gz.Css \form-control}'
                   value='#{if dispatch.'declaration'?
                            then dispatch.'declaration'.\tracking
                            else '-'}'>
          </div>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-5}'>
          <input type='text' class='#{gz.Css \form-control}'
              style='visibility:hidden'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-7}'>
          <label class='#{gz.Css \col-md-5} #{gz.Css \control-label}'>
            Nombre/Razón Social
          </label>
          <div class='#{gz.Css \col-md-7}'>
            <input type='text' class='#{gz.Css \form-control}'
                   value='#{dispatch'customer'\name}'>
          </div>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-5}'>
          <label class='#{gz.Css \col-md-8} #{gz.Css \control-label}'>
            PJ/PN
          </label>
          <div class='#{gz.Css \col-md-4}'>
            <input type='text' class='#{gz.Css \form-control}'
                   value='#{if dispatch'customer''document'\type is \RUC
                            then '1'
                            else '2'}'
                   style='text-align:right'>
          </div>
        </div><br></fieldset>"

    # Main form
    _form = App.dom._new \form
    fbuilder = App.shared.shortcuts.xhtml._form.Builder.New _form
    productList = ProductList.New _collection: dispatch'numeration'\items
    FIELDS-HEADER[FIELDS-HEADER._length - 1]._options = productList
    for _field in FIELDS-HEADER then fbuilder.field _field
    fbuilder.render!
    fbuilder.tooltips!
    fbuilder.free!
    @main-form = _form

    $ _form ._fromJSON dispatch\numeration
    _form.onSubmit App._void._submit  # @onSave

    @el._append header_form
    @el._append _form

    @addStakeholderForm dispatch

    @$ '[title]' .tooltip!

    # Add button save
    btngroup = $ "
      <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
        <button type='button' class='#{gz.Css \btn}
                                   \ #{gz.Css \btn-primary}
                                   \ #{gz.Css \pull-right}'>
          Guardar
        </button>
      </div>"
    btngroup.0._first.onClick @onSave
    @$el._append btngroup

  /**
   * Stakeholder form creation and appended to module.
   * TODO(...): Currently only manage 2 inner forms. Implement to manage
   *   'n' inner forms. (Hint: Two columns by 'n/2' rows.)
   * @param {Object} dispatch
   * @see @showForm
   * @private
   */
  addStakeholderForm: (dispatch) ->
    customer = new App.model.Customer @dispatch._get \customer

    if customer.isBusiness
      supplier-fields = @stakeholder-business-supplier-fields
      importer-fields = @stakeholder-business-importer-fields
    else
      supplier-fields = @stakeholder-person-supplier-importer-fields
      importer-fields = @stakeholder-person-supplier-importer-fields

    separation-section = App.dom._new \div
      ..Class = gz.Css \col-md-12
      ..html '<hr>'

    form-supplier = @get-stakeholder-form 'Datos proveedor'  supplier-fields
    form-importer = @get-stakeholder-form 'Datos importador' importer-fields
    @supplier-form = form-supplier
    @importer-form = form-importer

    $ form-supplier ._fromJSON dispatch'numeration'\supplier
    $ form-importer ._fromJSON dispatch\customer

    if customer.isPerson  # Extra procedure for splitted person name
      _names = dispatch'customer''name'.split ' '
      if _names._length > 2
        [..._names, _father, _mother] = _names
      else if _names._length is 2
        [_names, _father] = _names
      else
        _names = []
        _father = _mother = ''
      form-importer._elements'surname_father'._value = _father
      form-importer._elements'surname_mother'._value = _mother
      form-importer._elements'names'._value          = _names._join ' '

    @el._append separation-section
    @el._append form-supplier
    @el._append form-importer

  /**
   * Create supplier-importer busines-person stakeholder form.
   * @param {string} _legend
   * @param Array.<Options> stakeholder-fields
   * @see @addStakeholderForm
   */
  get-stakeholder-form: (_legend, stakeholder-fields) ->
    _form = App.dom._new \form
      ..Class = gz.Css \col-md-6

    fbuilder = App.shared.shortcuts.xhtml._form.Builder.New _form
    fbuilder.fieldset _legend, stakeholder-fields
    fbuilder.render!
    fbuilder.free!

    _form

  /** @override */
  initialize: ({dto}) ->
    @dispatch = new App.model.Dispatch dto
    super!

  /** @private */ dispatch      : null
  /** @private */ main-form     : null
  /** @private */ supplier-form : null
  /** @private */ importer-form : null

  /** @override */
  render: ->
    @showForm @dispatch\attributes
    super!

  /** @protected */ @@_caption = 'Numeración'
  /** @protected */ @@_icon    = gz.Css \glyphicon-book

  /**
   * Fields for business supplier stakeholder.
   * @type Array.<Options>
   * @see @addStakeholderForm
   * @private
   */
  stakeholder-business-supplier-fields:
    * _name  : 'name'
      _label : 'Razón social'
      _class : gz.Css \col-md-12

    * _name  : 'object'
      _label : 'Objeto social'
      _class : gz.Css \col-md-12

    * _name  : 'address'
      _label : 'Nombre y N&ordm; via dirección'
      _class : gz.Css \col-md-12

    * _name  : 'phone'
      _label : 'Teléfono de la persona'
      _class : gz.Css \col-md-12

  /**
   * Fields for business importer stakeholder.
   * @type Array.<Options>
   * @see @addStakeholderForm
   * @private
   */
  stakeholder-business-importer-fields:
    * _name  : 'name'
      _label : 'Razón social'
      _class : gz.Css \col-md-12

    * _name  : 'object'
      _label : 'Objeto social'
      _class : gz.Css \col-md-12

    * _name  : 'address'
      _label : 'Nombre y N&ordm; via dirección'
      _class : gz.Css \col-md-12

    * _name  : 'phone'
      _label : 'Teléfono de la persona'
      _class : gz.Css \col-md-12

    * _name  : 'document[number]'
      _label : 'RUC'
      _class : gz.Css \col-md-12

    * _name  : 'activity'
      _label : 'Actividad económica principal'
      _class : gz.Css \col-md-12

    * _name  : 'country'
      _label : 'Código país origen'
      _class : gz.Css \col-md-12
      _type  : FieldType.kComboBox
      _options : ['PE']

  /**
   * Fields for person supplier-importer stakeholder.
   * @type Array.<Options>
   * @see @addStakeholderForm
   * @private
   */
  stakeholder-person-supplier-importer-fields:
    * _name  : 'document[type]'
      _label : 'Tipo documento'
      _class : gz.Css \col-md-12
      _type  : FieldType.kComboBox
      _options : App.shared.lists.IDENTIFICATION

    * _name  : 'document[number]'
      _label : 'N&ordm; Documento identidad'
      _class : gz.Css \col-md-12

    * _name  : 'residence'
      _label : 'Condición residencia'
      _class : gz.Css \col-md-12

    * _name  : 'issuance'
      _label : 'País emisión documento'
      _class : gz.Css \col-md-12

    * _name  : 'pep'
      _label : 'Persona PEP'
      _class : gz.Css \col-md-12

    * _name  : 'pep_office'
      _label : 'PEP Cargo público'
      _class : gz.Css \col-md-12

    * _name  : 'surname_father'
      _label : 'Apellido paterno'
      _class : gz.Css \col-md-12

    * _name  : 'surname_mother'
      _label : 'Apellido materno'
      _class : gz.Css \col-md-12

    * _name  : 'names'
      _label : 'Nombres'
      _class : gz.Css \col-md-12

    * _name  : 'nationality'
      _label : 'Nacionalidad'
      _class : gz.Css \col-md-12

    * _name  : 'birthday'
      _label : 'Fecha nacimiento'
      _class : gz.Css \col-md-12

    * _name  : 'activity'
      _label : 'Ocupación, oficio'
      _class : gz.Css \col-md-12

    * _name  : 'employer'
      _label : 'Empleador/Dependiente'
      _class : gz.Css \col-md-12

    * _name  : 'mean-income'
      _label : 'Ingreso promedio/Dependiente'
      _class : gz.Css \col-md-12


/** @export */
module.exports = NumerationEdit


# Fields
FIELDS-HEADER =
  * _name        : 'number'
    _label       : 'N&ordm; Declaración'
    _tip         : 'A Casillero 2'
#    'XXX-AAAA-RR-NNNNNN'

  * _name        : 'date'
    _label       : 'Fecha Numeración'
    _tip         : 'A Casillero 2'
    _placeholder : 'dd/mm/aaaa'

  * _name        : 'type'
    _label       : 'T. Aforo'
    _tip         : 'A Casillero 2'
    _type        : FieldType.kComboBox
    _options     :
      'Verde'
      'Naranja'
      'Rojo'

  * _name        : 'amount'
    _label       : 'Valor Mercancía-FOB $'
    _tip         : 'A Casillero 6.1'
#    'xx\'xxx,xxx.xxxx'

  * _name        :'currency'
    _label       :'Moneda $'
    _tip         : 'D=Dólar Automático'
    _type        : FieldType.kComboBox
    _options     : ['USD']

  * _name        : 'series'
    _label       : 'Total Series'

  * _name        : 'exchange'
    _label       : 'Tipo Cambio'
    _tip         : 'Fecha numeración _ 2'
#    'T/C publicado SBS xxx.xxxx'

  * _name        : 'soles'
    _label       : 'N. Soles S/.'
