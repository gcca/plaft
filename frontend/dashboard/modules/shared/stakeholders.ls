/** @module dashboard.modules.shared */

/** @enum {number} */
StakeholderType =
  kBusiness : 1
  kPerson   : 2


/**
 * @class UiStakeholder
 * @extends View
 */
class Stakeholder extends App.View

  /** @override */
  _tagName: \form

  /** @override */
  _className: "#{gz.Css \row} #{gz.Css \parent-toggle}"

  /**
   * (Event) On search stakeholder by {@code name}.
   * @param {Object} evt
   * @private
   */
  onSearch: (evt) ~>
    evt.prevent!
    _query = evt._target._elements.0._value
    ## new App.model.Stakeholder
    @newStakeholder!

  /**
   * (Event) On remove stakeholder view.
   */
  onRemove: ~>
    ## @free!
    @_remove!

  /**
   * Set stakeholder form by type.
   * @param {StakeholderType} _type
   * @private
   */
  newStakeholder: (_type = StakeholderType.kBusiness) ->
    if _type is StakeholderType.kBusiness
      _oBusiness = 'selected'
      _oPerson   = ''
    else if _type is StakeholderType.kPerson
      _oBusiness = ''
      _oPerson   = 'selected'
    else
      alert 'ERROR: 24284e16-adf8-11e3-bfb5-88252caeb7e8'

    @el.html "
      <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
        <span class='#{gz.Css \glyphicon}
                   \ #{gz.Css \glyphicon-remove}
                   \ #{gz.Css \toggle}'
            style='margin-top:8px;cursor:pointer;font-size:18px'></span>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
        <label>Tipo</label>
        <select class='#{gz.Css \form-control}'>
          <option value='b' #_oBusiness>Persona Jurídica</option>
          <option value='p' #_oPerson>Persona Natural</option>
        </select>
      </div>
      <div></div>"
    @el._first._first.onClick @onRemove
    @el._first._next._last.onChange @onChooseStakeholderType
    @el._last.html @template-by _type
    @$el._append "<div class='#{gz.Css \col-md-12}'><hr></div>"

  /**
   * (Event) Choose business or person stakeholder form.
   * @param {Object} evt
   * @private
   */
  onChooseStakeholderType: (evt) ~>
    _type = evt._target._value

    if _type is \b  # business
      @newStakeholder StakeholderType.kBusiness
    else if _type is \p  # person
      @newStakeholder StakeholderType.kPerson

  /** @override */
  initialize: (@dto = null) !->

  /** @override */
  render: ->
    ## @el.html "
    ##   <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
    ##     <div class='#{gz.Css \input-group}'>
    ##       <input type='text' class='#{gz.Css \form-control}'>
    ##       <span class='#{gz.Css \input-group-btn}'>
    ##         <button class='#{gz.Css \btn} #{gz.Css \btn-default}'>
    ##           &nbsp;
    ##           <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-search}'>
    ##           </i>
    ##         </button>
    ##       </span>
    ##     </div>
    ##   </div>"
    ## @el.onSubmit @onSearch
    @newStakeholder!

    @$el._fromJSON @dto

    super!

  /**
   * Get template form by stakeholder type.
   * @param {StakeholderType} _type
   * @return {string}
   * @private
   */
  template-by: (_type) ->
    | _type is StakeholderType.kBusiness => @template-business!
    | _type is StakeholderType.kPerson   => @template-person!
    | otherwise => alert 'ERROR: dab54794-adf6-11e3-bfb5-88252caeb7e8'

  /**
   * Template for business form.
   * @return {string}
   * @private
   */
  template-business: ->
    vHtml = new Array

    for [_name, _label, _placeholder] in @kBusinessFields
      vHtml.push "
        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>#_label</label>
          <input type='text' class='#{gz.Css \form-control}'
              name='#_name' placeholder='#_placeholder'>
        </div>"

    vHtml.join ''


  kBusinessFields:
    * '6'
      'Proveedor extranjero'
      'Automático'

    * '14'
      'Razón social'
      'A 1.1'

    ## * 'f25'
    ##   'Dirección fiscal'
    ##   'A 1.3'

    * '23'
      'Objeto social'
      ''

    * '24'
      'Cargo'
      ''

    * '25'
      'Nombre y número dirección'
      ''

    * '26'
      'Teléfono de la persona operac'
      ''

    * '27'
      'Condición operación inusual'
      ''

    * '28'
      'Describir la condición interiviene'
      ''

  /**
   * Template for person form.
   * @return {string}
   * @private
   */
  template-person: -> "
    <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
      <label>Apellido paterno</label>
      <input type='text' class='#{gz.Css \form-control}'
          name='surname1'>
    </div>

    <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
      <label>Apellido materno</label>
      <input type='text' class='#{gz.Css \form-control}'
          name='surname2'>
    </div>

    <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
      <label>Nombres</label>
      <input type='text' class='#{gz.Css \form-control}'
          name='name'>
    </div>

    <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
      <label>Nacionalidad</label>
      <input type='text' class='#{gz.Css \form-control}'
          name='nationality'>
    </div>"

  kPersonFields:
    * '8'
      'Tipo documento'
      ''

    * '9'
      'Número de documento'
      ''

    * '10'
      'Condición de residencia'
      ''

    * '11'
      'País emisión documento'
      ''

    * '12'
      '¿Persona es PEP?'
      ''

    * '13'
      'Si es PEP, indicar cargo público'
      ''

    * '17'
      'Nacionalidad'
      ''

    * '18'
      'Fecha nacimiento'
      ''

    * '19'
      'Ocupación, oficio o profesión'
      ''

    * '20'
      'Ocupación, opción Otros'
      ''

    * '21'
      'Empleador'
      ''

    * '22'
      'Ingresos promedios mensual'
      ''


/**
 * @class UiStakeholders
 * @extends View
 */
class Stakeholders extends App.View

  /** @override */
  _tagName: \div

  /** @override */
  _toJSON: -> [$ .. ._toJSON! for @$ \form]

  /**
   * Add new stakeholder.
   * @param {Object} dto Stakeholder DTO.
   */
  addStakeholder: (dto = null) !~>
    @xcontainer._append (Stakeholder.New dto).render!.el

  /** @override */
  initialize: (@collection = App._void._Array) !->
    @xcontainer = null

  /** @private */ xcontainer: null

  /** @override */
  render: ->
    @el.html "
      <div></div>
      <button type='button' class='#{gz.Css \btn} #{gz.Css \btn-default}'>
        Agregar
        &nbsp;
        <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-plus}'></i>
      </button>"
    @xcontainer = @el._first
    @el._last.onClick @addStakeholder

    for dto in @collection
      @addStakeholder dto

    for x to 3
      @addStakeholder!

    super!

module.exports = Stakeholders
