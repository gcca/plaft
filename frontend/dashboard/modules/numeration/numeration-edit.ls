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
    console.log \guardado
    ## @dispatch.store \numeration : @$el._toJSON!, do
    ##   _success: -> alert 'Guardado'
    ##   _error: -> alert 'ERROR: 010dbe9c-a584-11e3-8bb0-88252caeb7e8'

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

    $ _form ._fromJSON dispatch\numeration
    _form.onSubmit App._void._submit  # @onSave

    @el._append header_form
    @el._append _form

    @addStakeholderForm!

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
   * @private
   */
  addStakeholderForm: ->
    customer = new App.model.Customer @dispatch._get \customer
    innerforms = if customer.isBusiness
                 then @templates-business!
                 else @templates-person!

    stakeholdersHtml = "
      <div class='#{gz.Css \col-md-12}'><hr></div>
      <div class='#{gz.Css \col-md-6}'>
        #{innerforms.0}
      </div>"

    if innerforms._length is 2
      stakeholdersHtml += "
        <div class='#{gz.Css \col-md-6}'>
          #{innerforms.1}
        </div>"

    @$el._append stakeholdersHtml

  /** @override */
  initialize: ({dto}) ->
    @dispatch = new App.model.Dispatch dto
    super!

  /** @private */ dispatch: null

  /** @override */
  render: ->
    @showForm @dispatch\attributes
    super!

  /** @protected */ @@_caption = 'Numeración'
  /** @protected */ @@_icon    = gz.Css \glyphicon-book

  /**
   * Templates for business stakeholders.
   * @return Array.<string>
   * @see @addStakeholderForm
   * @private
   */
  templates-business: ->
    form-supplier = App.dom._new \form
    fbuilder = App.shared.shortcuts.xhtml._form.Builder.New form-supplier
    fbuilder._fieldset
    fbuilder.render!
    fbuilder.tooltips!
    fbuilder.free!

    _supplier = "
      <form>
        <fieldset>
          <legend>Datos proveedor</legend>

          <div class='#{gz.Css \form-group}'>
            <label>
              Razón social
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='name'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Objeto social
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='object'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Nombre y N&ordm; via dirección
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='address'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Teléfono de la persona
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='phone'>
          </div>
        </fieldset>
      </form>"

    _importer = "
      <form>
        <fieldset>
          <legend>Datos de importador</legend>

          <div class='#{gz.Css \form-group}'>
            <label>
              Razón social
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='name'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Objeto social
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='object'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Nombre y N&ordm; via dirección
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='address'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Teléfono de la persona
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='phone'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              RUC
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='number'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Actividad económica principal
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='activity'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Código país origen
            </label>
            <select class='#{gz.Css \form-control}' name='country'>
              <option>PE</option>
            </select>
          </div>
        </fieldset>
      </form>"

    [_supplier, _importer]

  /**
   * Templates for person stakeholders.
   * @return Array.<string>
   * @see @addStakeholderForm
   * @private
   */
  templates-person: ->
    _supplier = "
      <form>
        <fieldset>
          <legend>Datos proveedor</legend>

          <div class='#{gz.Css \form-group}'>
            <label>
              Tipo documento
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='document[type]'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              N&ordm; Documento identidad
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='document[number]'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Condición residencia
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='residence'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              País emisión documento
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='issuance'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Persona PEP
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='pep'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              PEP Cargo público
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='pep_office'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Apellido paterno
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='surname_father'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Apellido materno
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='surname_mother'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Nombres
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='name'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Nacionalidad
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='nationality'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Fecha nacimiento
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='birthday'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Ocupación, oficio
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='activity'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Empleador/Dependiente
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='employer'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Ingreso promedio/Dependendiente
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='mean_income'>
          </div>
        </fieldset>
      </form>"

    _importer = "
      <form>
        <fieldset>
          <legend>Datos importador</legend>

          <div class='#{gz.Css \form-group}'>
            <label>
              Tipo documento
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='document[type]'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              N&ordm; Documento identidad
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='document[number]'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Condición residencia
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='residence'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              País emisión documento
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='issuance'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Persona PEP
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='pep'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              PEP Cargo público
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='pep_office'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Apellido paterno
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='surname_father'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Apellido materno
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='surname_mother'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Nombres
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='name'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Nacionalidad
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='nationality'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Fecha nacimiento
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='birthday'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Ocupación, oficio
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='activity'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Empleador/Dependiente
            </label>
            <input type='text' class='#{gz.Css \form-control}' name='employer'>
          </div>

          <div class='#{gz.Css \form-group}'>
            <label>
              Ingreso promedio/Dependendiente
            </label>
            <input type='text' class='#{gz.Css \form-control}'
                name='mean_income'>
          </div>
        </fieldset>
      </form>"

    [_supplier, _importer]

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
