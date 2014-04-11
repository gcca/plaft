/** @module dashboard.modules.anex2 */

Module = require '../module'

FieldType = App.builtins.Types.Field


/**
 * Search, find or register new stakeholder.
 * Finding by slug attribute. Before store entity, {@code slug} is fixed.
 * TODO(...): Find stakeholder by multi-fields criteria.
 *
 * @class UiStakeholder
 * @extends View
 */
class Stakeholder extends App.View

  /** @override */
  _tagName: \form

  /** @override */
  _className: "#{gz.Css \parent-toggle} #{gz.Css \col-md-12}"

  /**
   * (Event) On remove stakeholder.
   * @private
   */
  onRemove: ~> @free!

  /**
   * (Event) On found stakeholder.
   * @param {Model} _model
   * @param {Object} _dto
   * @param {Object} _options
   * @private
   */
  onFindSuccess: (_model, _dto, _options) ~>
    @render-edit!
    @$el._fromJSON _dto

  /**
   * (Event) On not found stakeholder.
   * @param {Model} _model
   * @param {Object} _dto
   * @param {Object} _options
   * @private
   */
  onFindError: (_model, _dto, _options) ~>
    @render-edit!
    # TODO(...): Implement multi-fields
    @el.query "[name=#{@_slug.0}]" .value = _model._get @_slug.0

  /**
   * (Event) On find stakeholder.
   * @param {Object} evt
   * @private
   */
  findStakeholder: (evt) ~>
    evt.prevent!
    # TODO(...): Implement multi-fields
    _value = evt._target._elements.'q'._value
    stakeholder = new App.model.Stakeholder \slug : _value
    stakeholder.fetch do
      _success : @onFindSuccess
      _error   : @onFindError

  /**
   * Focus first form field.
   */
  focusField: !-> @el._last._first._focus!

  /**
   * Render find stakeholder form.
   * @private
   */
  render-find: ->
    @el.html @template-header! + "
      <div class='#{gz.Css \input-group} #{gz.Css \col-md-8}'>
        <input type='text' class='#{gz.Css \form-control}'
            name='q' placeholder='Buscar por RUC'>
        <span class='#{gz.Css \input-group-btn}'>
          <button class='#{gz.Css \btn} #{gz.Css \btn-default}'>
            &nbsp;
            <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-search}'></i>
          </button>
        </span>
      </div>"
    @el.onSubmit @findStakeholder

  /**
   * Render edit stakeholder form.
   * @private
   */
  render-edit: ->
    @el.html @template-header!

    @$ \button .0 .onClick @onRemove

    fbuilder = App.shared.shortcuts.xhtml._form.Builder.New @el
    for _field in @_fields then fbuilder.field _field
    fbuilder.render!
    fbuilder.free!

  /**
   * @param {!Array.<FieldOptions>} _fields
   * @param {!Array.<string>} _slug
   * @param {number} _counter
   * @override
   */
  initialize: (@_fields, @_slug, @_counter) !->

  /** @private */ _fields  : null
  /** @private */ _slug    : null
  /** @private */ _counter : null

  /** @override */
  render: ->
    @render-find!
    super!

  /**
   * Template header options: counter, line (separator), close button link.
   * @return {string}
   * @private
   */
  template-header: -> "
    <div class='#{gz.Css \col-md-11}'>
      <span style='position: absolute;
                   left:0;
                   top:6px;
                   font-size:20px;'>
        #{@_counter}
      </span>
      <hr>
    </div>
    <div class='#{gz.Css \col-md-1}'>
      <button type='button'
          style='font-size:16pt'
          class='#{gz.Css \btn}
               \ #{gz.Css \btn-link}
               \ #{gz.Css \pull-right}
               \ #{gz.Css \toggle}'>
        <i class='#{gz.Css \glyphicon}
                \ #{gz.Css \glyphicon-remove}'></i>
      </button>
    </div>"

/**
 * Class for stakeholder list, needs a {@code fields} constructor parameter
 * to send it to {@code UiStakeholder}.
 * You may want to change the title {@code label} using a header tag: h1..h6.
 *
 * @class UiStakeholders
 * @extends View
 */
class Stakeholders extends App.View

  /** @override */
  _tagName: \div

  /** @override */
  _className: gz.Css \col-md-12

  /** @override */
  _toJSON: -> [$ .. ._toJSON! for @$ \form]

  /**
   * Add new stakeholder.
   */
  addStakeholder: !~>
    stakeholder = Stakeholder.New @_fields, @_slug, ++@_counter
    @_container._append stakeholder.render!.el
    stakeholder.focusField!

  /**
   * @param {!Array.<FieldOptions>} _fields
   * @param {!(string|Array.<string>)} _slug To create slug to find stakeholder
   *   from name field(s).
   * @override
   */
  initialize: (@_fields, @_slug) !->
    /**
     * Container for stakeholder stacking.
     * @type {HTMLElement}
     * @private
     */
    @_container = null

    /**
     * Counter for stakeholder label.
     * @type {number}
     * @private
     */
    @_counter = 0

    /**
     * Slug to find stakeholder.
     * @type {Array.<string>}
     * @private
     */
    @_slug = [@_slug] if @_slug._constructor is String

  /** @private */ _fields    : null
  /** @private */ _slug      : null
  /** @private */ _container : null
  /** @private */ _counter   : null

  /** @override */
  render: ->
    @el.html "
      <div class='#{gz.Css \col-md-12}'></div>
      <button type='button' class='#{gz.Css \btn} #{gz.Css \btn-default}'>
        Agregar
      </button>"
    @_container = @el._first
    @el._last.onClick @addStakeholder
    super!


_Declarante =
  * _name    : 'f9'
    _label   : 'Representado'
    _tip     : 'La persona que solicita o físicamente realiza la operación
               \ actúa en representación del: (1) Ordenante
               \ o (2) Beneficiario.'
    _type    : FieldType.kComboBox
    _options :
      'Ordenante'
      'Beneficiario'

  * _name    : 'f10'
    _label   : 'Condición de residencia'
    _tip     : 'Condición de residencia de la persona que solicita o
               \ físicamente realiza la operación: (1) Residente
               \ o (2) No residente.'
    _type    : FieldType.kComboBox
    _options :
      'Residente'
      'No residente'

  * _name    : 'f11'
    _label   : 'Tipo de documento'
    _tip     : 'Tipo de documento la persona que solicita o físicamente
                \ realiza la operación (Consignar el código de acuerdo a
                \ la Tabla Nº 1)'
    _type    : FieldType.kComboBox
    _options : App.shared.lists.IDENTIFICATION

  * _name    : 'f12'
    _label   : 'Número de documento'
    _tip     : 'Número de documento de la persona que solicita o físicamente
               \ realiza la operación.'

  * _name    : 'f13'
    _label   : 'País de emisión'
    _tip     : 'País de emisión del documento de la persona que solicita o
               \ físicamente realiza la operación, en caso sea un documento
               \ emitido en el extranjero.'

  * _name    : 'f14'
    _label   : 'Apellido paterno'
    _tip     : 'Apellido paterno de la persona que solicita o físicamente
               \ realiza la operación.'

  * _name    : 'f15'
    _label   : 'Apellido materno'
    _tip     : 'Apellido materno de la persona que solicita o físicamente
               \ realiza la operación.'

  * _name    : 'f16'
    _label   : 'Nombres'
    _tip     : 'Nombres de la persona que solicita o físicamente realiza
               \ la operación.'

  * _name    : 'f17'
    _label   : 'Nacionalidad'
    _tip     : 'Nacionalidad de la persona que solicita o físicamente realiza
               \ la operación.'

  * _name    : 'f18'
    _label   : 'Ocupación, oficio o profesión'
    _tip     : 'Ocupación, oficio o profesión de la persona que solicita o
              \ físicamente realiza la operación: Consignar los códigos de
              \ acuerdo a la Tabla Nº 2'

  * _name    : 'f19'
    _label   : 'Descripción de la ocupación'
    _tip     : 'Descripción de la ocupación, oficio o profesión de la persona
               \ que solicita o físicamente realiza la operación en caso en
               \ el ítem anterior se haya consignado la opción otros.'

  * _name    : 'f20'
    _label   : 'Código CIIU'
    _tip     : 'Código CIIU de la ocupación de la persona que solicita o
               \ físicamente realiza la operación.'

  * _name    : 'f21'
    _label   : 'Cargo'
    _tip     : 'Cargo de la persona que solicita o físicamente realiza
               \ la operación (si aplica): Consignar los códigos de acuerdo
               \ a la Tabla Nº 3'

  * _name    : 'f22'
    _label   : 'Dirección'
    _tip     : 'Nombre y número de la vía de la dirección de la persona
               \ que solicita o físicamente realiza la operación.'

  * _name    : 'f23'
    _label   : 'UBIGEO'
    _tip     : 'Código UBIGEO del Departamento, provincia y distrito de la
               \ dirección de la persona que solicita o físicamente realiza
               \ la operación: de acuerdo a la codificación vigente y
               \ publicada por el INEI'

  * _name    : 'f24'
    _label   : 'Teléfono'
    _tip     : 'Teléfono de la persona que solicita o físicamente realiza
               \ la operación.'


_Ordenante =

  * _name    : 'f25'
    _label   : 'Ordenante'
    _tip     : 'La persona en cuyo nombre se realiza la operación es: (1)
               \ proveedor del extranjero (ingreso de mercancía),  (2)
               \ Exportador (salida de mercancía). Si es proveedor del
               \ extranjero sólo consignar nombres y apellidos completos
               \ (persona natural), razón social (personas jurídicas) y
               \ dirección. Si es el exportador, consignar todos los datos
               \ detallados en esta sección.'
    _type    : FieldType.kComboBox
    _options :
      'Proveedor del extranjero'
      'Exportador'

  * _name    : 'f26'
    _label   : 'Representador por'
    _tip     : 'La persona en cuyo nombre se realiza la operación ha sido
               \ representado por: (1) Representante legal  (2) Apoderado
               \ (3) Mandatario (4) Él mismo.'
    _type    : FieldType.kComboBox
    _options :
      'Representante legal'
      'Apoderado'
      'Mandatario'
      'Él mismo'

  * _name    : 'f27'
    _label   : 'Condición de residencia'
    _tip     : 'Condición de residencia de la persona en cuyo nombre se
               \ realiza la operación: (1) Residente, (2) No residente.'
    _type    : FieldType.kComboBox
    _options :
      'Residente'
      'No residente'

  * _name    : 'f28'
    _label   : ''
    _tip     : 'Tipo de persona en cuyo nombre se realiza la operación: (1)
               \ Persona Natural, (2) Persona Jurídica. Si consignó la
               \ opción (2) no llenar los items 29 al 31  ni los items 34
               \ al  38'
    _type    : FieldType.kComboBox
    _options :
      'Persona Natural'
      'Persona Jurídica'

  * _name    : 'f29'
    _label   : ''
    _tip     : 'Tipo de documento de la persona en cuyo nombre se realiza la
               \ operación. Consignar el código de acuerdo a la Tabla Nº 1.'
    _type    : FieldType.kComboBox
    _options : App.shared.lists.IDENTIFICATION

  * _name    : 'f30'
    _label   : 'Número de documento'
    _tip     : 'Número de documento de la persona en cuyo nombre se realiza
               \ la operación.'

  * _name    : 'f31'
    _label   : 'País de emisión del documento'
    _tip     : 'País de emisión del documento de la persona en cuyo nombre
               \ se realiza la operación, en caso sea un documento emitido
               \ en el extranjero.'

  * _name    : 'f32'
    _label   : 'RUC'
    _tip     : 'Número de RUC de la persona en cuyo nombre se realiza la
               \ operación.'

  * _name    : 'f33'
    _label   : 'Apellido paterno o razón social'
    _tip     : 'Apellido paterno o razón social (persona jurídica) de la
               \ persona en cuyo nombre se realiza la operación.'

  * _name    : 'f34'
    _label   : 'Apellido materno'
    _tip     : 'Apellido materno de la persona en cuyo nombre se realiza la
               \ operación.'

  * _name    : 'f35'
    _label   : 'Nombres'
    _tip     : 'Nombres de la persona en cuyo nombre se realiza la
               \ operación.'

  * _name    : 'f36'
    _label   : 'Nacionalidad'
    _tip     : 'Nacionalidad de la persona en cuyo nombre se realiza la
               \ operación.'

  * _name    : 'f37'
    _label   : 'Ocupación, oficio o profesión'
    _tip     : 'Ocupación, oficio o profesión de la persona en cuyo nombre se
               \ realiza la operación (persona natural): Consignar los
               \ códigos de acuerdo a la Tabla Nº 2.'
    _type    : FieldType.kComboBox
    _options : App.shared.lists.ACTIVITY

  * _name    : 'f38'
    _label   : 'Descripción de la ocupación'
    _tip     : 'Descripción de la ocupación, oficio o profesión de la persona
                \ en cuyo nombre se realiza la operación en caso en el ítem
                \ anterior se haya consignado la opción otros.'

  * _name    : 'f39'
    _label   : 'Actividad económica'
    _tip     : 'Actividad económica de la persona en cuyo nombre se realiza
               \ la operación (persona jurídica u otras formas de
               \ organización o asociación que la Ley establece): Consignar
               \ la actividad principal'

  * _name    : 'f40'
    _label   : 'Código CIIU'
    _tip     : 'Código CIIU de la ocupación de la persona en cuyo nombre se
               \ realiza la operación.'

  * _name    : 'f41'
    _label   : 'Cargo de la persona'
    _tip     : 'Cargo de la persona en cuyo nombre se realiza la operación
               \ (si aplica): consignar los códigos de acuerdo a la
               \ Tabla Nº 3.'
    _type    : FieldType.kComboBox
    _options : App.shared.lists.JOB_TITLE

  * _name    : 'f42'
    _label   : 'Dirección'
    _tip     : 'Nombre y número de la vía de la dirección de la persona en
               \ cuyo nombre se realiza la operación.'

  * _name    : 'f43'
    _label   : 'UBIGEO'
    _tip     : 'Código UBIGEO del Departamento, provincia y distrito de la
               \ dirección de la persona en cuyo nombre se realiza la
               \ operación: de acuerdo a la codificación vigente y publicada
               \ por el INEI.'

  * _name    : 'f44'
    _label   : 'Teléfono'
    _tip     : 'Teléfono de la persona en cuyo nombre se realiza la
               \ operación.'



_Destinatario =
  * _name    : 'f45'
    _label   : 'Destinatario'
    _tip     : 'La persona a favor de quien se realiza la operación es: (1)
               \ Importador (ingreso de mercancía) ó  (2) Destinatario del
               \ embarque (salida de mercancía). Si es el destinatario del
               \ embarque sólo consignar nombres y apellidos completos
               \ (persona natural), razón social (personas jurídicas) y
               \ dirección. Si es el importador, consignar todos los datos
               \ detallados en esta sección.'
    _type    : FieldType.kComboBox
    _options :
      'Importador'
      'Destinatario del embarque'

  * _name    : 'f46'
    _label   : 'Condición de residencia'
    _tip     : 'Condición de residencia de la persona a favor de quien se
               \ realiza la operación: (1) Residente ó (2) No residente.'
    _type    : FieldType.kComboBox
    _options :
      'Reisdente'
      'No residente'

  * _name    : 'f47'
    _label   : 'Tipo de persona'
    _tip     : 'Tipo de persona a favor de quien se realiza la operación:
               \ (1) Persona Natural ó (2) Persona Jurídica. Si consignó la
               \ opción (2) no llenar los items 48 al 50  ni los items 53 al
               \ 57.'
    _type    : FieldType.kComboBox
    _options :
      'Persona Natural'
      'Persona Jurídica'

  * _name    : 'f48'
    _label   : 'Tipo de documento'
    _tip     : 'Tipo de documento la persona a favor de quien se realiza la
               \ operación: Consignar el código de acuerdo a la Tabla Nº 1.'
    _type    : FieldType.kComboBox
    _options : App.shared.lists.IDENTIFICATION

  * _name    : 'f49'
    _label   : 'Número de documento'
    _tip     : 'Número de documento de la persona a favor de quien se realiza
               \ la operación.'

  * _name    : 'f50'
    _label   : 'País de emision del documento'
    _tip     : 'País de emisión del documento de la persona a favor de quien
               \ se realiza la operación, en caso sea un documento emitido
               \ en el extranjero.'

  * _name    : 'f51'
    _label   : 'RUC'
    _tip     : 'Número de RUC de la persona a favor de quien se realiza la
               \ operación.'

  * _name    : 'f52'
    _label   : 'Apellido paterno o razón social'
    _tip     : 'Apellido paterno o razón social (persona jurídica) de la
               \ persona a favor de quien se realiza la operación.'

  * _name    : 'f53'
    _label   : 'Apellido materno'
    _tip     : 'Apellido materno de la persona a favor de quien se realiza
               \ la operación.'

  * _name    : 'f54'
    _label   : 'Nombres'
    _tip     : 'Nombres de la persona a favor de quien se realiza la
               \ operación.'

  * _name    : 'f55'
    _label   : 'Nacionalidad'
    _tip     : 'Nacionalidad de la persona a favor de quien se realiza
               \ la operación.'

  * _name    : 'f56'
    _label   : 'Ocupación, oficio o profesión'
    _tip     : 'Ocupación, oficio o profesión de la persona a favor de quien
               \ se realiza la operación (persona natural): consignar los
               \ códigos de acuerdo a la Tabla Nº 2.'
    _type    : FieldType.kComboBox
    _options : App.shared.lists.ACTIVITY


  * _name    : 'f57'
    _label   : 'Descripción de la ocupación'
    _tip     : 'Descripción de la ocupación, oficio o profesión de la
               \ persona a favor de quien se realiza la operación en caso
               \ en el ítem anterior se haya consignado la opción otros.'

  * _name    : 'f58'
    _label   : 'Actividad económica'
    _tip     : 'Actividad económica de la persona a favor de quien se realiza
               \ la operación (persona jurídica u otras formas de organización
               \ o asociación que la Ley establece): Consignar la actividad
               \ principal'

  * _name    : 'f59'
    _label   : 'Código CIIU'
    _tip     : 'Código CIIU de la ocupación de la persona a favor de quien se
               \ realiza la operación'

  * _name    : 'f60'
    _label   : 'Cargo'
    _tip     : 'Cargo de la persona a favor de quien se realiza la operación
               \ (si aplica): consignar el código que corresponda de acuerdo
               \ a la Tabla Nº 3.'
    _type    : FieldType.kComboBox
    _options : App.shared.lists.JOB_TITLE

  * _name    : 'f61'
    _label   : 'Dirección'
    _tip     : 'Nombre y número de la vía de la dirección de la persona a
               \ favor de quien se realiza la operación.'

  * _name    : 'f62'
    _label   : 'UBIGEO'
    _tip     : 'Código UBIGEO del departamento, provincia y distrito de la
                \ dirección de la persona a favor de quien se realiza la
                \ operación: de acuerdo a la codificación vigente y publicada
                \ por el INEI.'

  * _name    : 'f63'
    _label   : 'Teléfono'
    _tip     : 'Teléfono de la persona a favor de quien se realiza la
               \ operación.'




_Tercero =
  * _name    : 'f64'
    _label   : 'Tipo de persona'
    _tip     : 'Tipo de persona en cuya cuenta se realiza la operación:
               \ (1) Persona Natural ó (2) Persona Jurídica. Si consignó
               \ la opción (2) no llenar los items 65 al 66  ni los items
               \ 68 al  69'
    _type    : FieldType.kComboBox
    _options :
      'Persona Natural'
      'Persona Jurídica'

  * _name    : 'f65'
    _label   : 'Tipo de documento'
    _tip     : 'Tipo de documento de la persona en cuya cuenta se realiza la
               \ operación: Consignar el código de acuerdo a la Tabla Nº 1.'
    _type    : FieldType.kComboBox
    _options : App.shared.lists.IDENTIFICATION

  * _name    : 'f66'
    _label   : 'Número de documento'
    _tip     : 'Número de documento de la persona en cuya cuenta se realiza
               \ la operación.'

  * _name    : 'f67'
    _label   : 'Apellido paterno o razón social'
    _tip     : 'Apellido paterno o razón social (persona jurídica) de la
               \ persona en cuya cuenta se realiza la operación.'

  * _name    : 'f68'
    _label   : 'Apellido materno'
    _tip     : 'Apellido materno de la persona en cuya cuenta se realiza
               \ la operación.'

  * _name    : 'f69'
    _label   : 'Nombres'
    _tip     : 'Nombres de la persona en cuya cuenta se realiza la operación.'

  * _name    : 'f70'
    _label   : 'Tercero'
    _tip     : 'La persona a favor de quien se realiza la operación es:
               \ (1) Importador (ingreso de mercancía); (2) Destinatario
               \ del embarque (salida de mercancía); (3) proveedor del
               \ extranjero (ingreso de mercancía); (4) Exportador (salida
               \ de mercancía).'
    _type    : FieldType.kComboBox
    _options :
      'Importador'
      'Destinatario'
      'Proveedor del extranjero'
      'Exportador'


/**
 * @class UiAnex2
 * @extends Module
 */
class Anex2 extends Module

  /** @override */
  _tagName: \form

  /**
   * (Event) On save Anex 2.
   * @param {Object} evt
   * @private
   */
  onSave: (evt) ~>
    evt.prevent!

    dto = @$el._toJSON!
    dto\stakeholders = [.._toJSON! for @stakeholders]

    @dispatch.store \anex6 : dto, do
      _success : -> alert 'Guardado'
      _error   : -> alert 'ERROR: 7d7aa7a8-c189-11e3-b894-88252caeb7e8'

  /**
   * (Event) On search by disptach order-number.
   * @param {string} _query
   * @protected
   */
  onSearch: (_query) ~>
    @el.html ''
    @dispatch = new App.model.Dispatch \order : _query
    @dispatch.fetch do
      _success: (_, dispatch) ~> @render-form!
      _error: -> alert 'Número de orden no hallado: ' + _query

  /** @override */
  render-form: ->
    fbuilder = App.shared.shortcuts.xhtml._form.Builder.New @el

    fbuilder.fieldset 'Datos de identificación del RO',
                      @fieldsRO
                      'Datos a ser consigados sólo en la parte inicial de RO,
                      \ no respecto de cada operación'

    @stakeholders =
      Stakeholders.New _Declarante  , 'f12'
      Stakeholders.New _Ordenante   , 'f12'
      Stakeholders.New _Destinatario, 'f12'
      Stakeholders.New _Tercero     , 'f12'

    _groups =
      * 'Declarantes'
        @stakeholders.0
        'DATOS DE IDENTIFICACIÓN DE LAS PERSONAS QUE SOLICITA O FISICAMENTE
        \ REALIZA LA OPERACIÓN EN REPRESENTACIÓN DEL CLIENTE DEL SUJETO
        \ OBLIGADO (DECLARANTE).'
      * 'Ordenantes'
        @stakeholders.1
        'DATOS DE IDENTIFICACIÓN DE LAS PERSONAS EN CUYOS NOMBRES SE REALIZA
        \ LA OPERACIÓN:   ORDENANTES/PROVEEDOR EXTRANJERO (INGRESO DE
        \ MERCANCÍA) / EXPORTADOR (SALIDA DE MERCANCÍA).'
      * 'Destinatario'
        @stakeholders.2
        'DATOS DE IDENTIFICACIÓN DE LAS PERSONAS A FAVOR DE QUIENES SE
        \ REALIZA LA OPERACIÓN IMPORTADOR (INGRESO DE MERCANCÍA) /
        \ DESTINATARIO DEL EMBARQUE (SALIDA DE MERCANCÍA).'
      * 'Terceros'
        @stakeholders.3
        'DATOS DE IDENTIFICACIÓN DEL TERCERO POR CUYO INTERMEDIO SE REALIZA
        \ LA OPERACIÓN, DE SER EL CASO.'

    fieldsStakeholders = [{
      _label   : ..0
      _type    : FieldType.kView
      _options : ..1
      _class   : gz.Css \col-md-12
      _tip     : ..2
      _head    : \h4
    } for _groups]

    fbuilder.fieldset 'Datos de identificación de los involucrados',
                      fieldsStakeholders

    fbuilder.fieldset 'Datos de identificación de la operación',
                      @fieldsOperation

    fbuilder.fieldset 'Datos relacionados a la descripción de la operación',
                      @fieldsDetails

    fbuilder._save!.onClick @onSave

    fbuilder.render!
    fbuilder.free!

    @$ '[title]' .tooltip!

#  /** @override */
#  initialize: ->
#    @stakeholders = null

  /** @private */ dispatch     : null
  /** @private */ stakeholders : null

  /** @protected */ @@_caption = 'Anexo 2'
  /** @protected */ @@_icon    = gz.Css \glyphicon-file

  /** @override */
  render: ->
    @ui.desktop._search._focus!
    super!

  /**
   * Fields for RO form.
   * @type {Array.<FieldOptions>}
   * @private
   */
  fieldsRO:
    * _name  : '1'
      _label : 'Código del sujeto obligado'
      _tip   : 'Código del sujeto obligado otorgado por la UIF.'

    * _name  : '2'
      _label : 'Código del oficial de cumplimiento'
      _tip   : 'Código del oficial de cumplimiento otorgado por la UIF.'

  /**
   * Fields for stakeholders form.
   * @type {Array.<FieldOptions>}
   * @private
   */
  fieldsStakeholders:
    * _label   : ''
      _options : ''

  /**
   * Fields for operation form.
   * @type {Array.<FieldOptions>}
   * @private
   */
  fieldsOperation:
    * _name  : '3'
      _label : 'Número de fila'
      _tip   : 'Número de fila: Consignar el número de secuencia
               \ correspondiente a las líneas contenidas en el RO debiendo
               \ empezar en el número uno (1). Si en la operación interviene
               \ más de una persona, se deberá crear una fila por cada una de
               \ ellas, consignando en cada fila el mismo número de registro
               \ de operación.'

    * _name  : '4'
      _label : 'Número de registro de operación'
      _tip   : 'Número de registro de operación: Consignar el número de
                \ secuencia correspondiente al registro de la operación en el
                \ RO debiendo empezar en el número uno (1), de acuerdo al
                \ formato siguiente: (año - número).'

    * _name  : '5'
      _label : 'Número de registro interno del sujeto obligado'
      _tip   : 'Número de registro interno del sujeto obligado para el
                \ registro de operación: Consignar el número de la
                \ Declaración Aduanera de Mercancías (DAM) correspondiente a
                \ la operación que se registra.'

    * _name  : '6'
      _label : 'Modalidad de operación'
      _tip   : 'Modalidad de operación: Consignar los siguientes valores:
               \ U para operaciones individuales y M para operaciones
               \ múltiples.'

    * _name  : '7'
      _label : 'Número de operaciones'
      _tip   : 'Número de operaciones que contiene la operación múltiple:
               \ En caso se trate de una operación múltiple consignar el
               \ número de operaciones que la conforman.'

    * _name  : '8'
      _label : 'Fecha de numeración'
      _tip   : 'Fecha de la operación: Consignar la fecha de numeración
               \ de la mercancía (dd/mm/aaaa)'

  /**
   * Fields for details form.
   * @type {Array.<FieldOptions>}
   * @private
   */
  fieldsDetails:
    * _name        : '71'
      _label       : 'Tipo de fondo'
      _tip         : 'Tipo de fondos con que se realizó la operación: consignar
                     \ el código de acuerdo a la Tabla Nº 5.'
      _type        : FieldType.kComboBox
      _options     : App.shared.lists.PAYMENT_TYPE

    * _name        : '72'
      _label       : 'Tipo de operación'
      _tip         : 'Tipo de operación: consignar el código de acuerdo a la
                     \ Tabla Nº 6: Tipos de Operación.'
      _type        : FieldType.kComboBox
      _options     : App.shared.lists.OPERATION_TYPE

    * _name        : '73'
      _label       : 'Descripción del tipo "Otros"'
      _tip         : 'Descripción del tipo de operación en caso según la tabla
                     \ de operaciones se haya consignado el código de "Otros"'

    * _name        : '74'
      _label       : 'Descripción de mercancías'
      _tip         : 'Descripción de las mercancías involucradas en
                     \ la operación.'

    * _name        : '75'
      _label       : 'Número de DAM.'

    * _name        : '76'
      _label       : 'Fecha de numeración de la DAM'

    * _name        : '77'
      _label       : 'Origen de los fondos involucrados en la operación'

    * _name        : '78'
      _label       : 'Moneda'
      _tip         : 'Moneda en que se realizó la operación (Según Codificación
                     \ ISO-4217).'

    * _name        : '79'
      _label       : 'Descripción del tipo de moneda en caso sea "Otra"'

    * _name        : '80'
      _label       : 'Monto de la operación'
      _tip         : 'Monto de la operación: Consignar el valor de la mercancía
                     \ correspondiente a la operación de comercio exterior
                     \ que se haya realizado. Los montos deberán estar
                     \ expresados en nuevos soles con céntimos. Para aquellas
                     \ operaciones realizadas con alguna moneda extranjera
                     \ diferente a la indicada, se deberán convertir a
                     \ dólares, según el tipo de cambio que la entidad tenga
                     \ vigente el día que se realizó la operación.'

    * _name        : '81'
      _label       : 'Tipo de cambio'
      _tip         : 'Tipo de cambio: consignar el tipo de cambio respecto a
                     \ la moneda nacional, en los casos en los que la
                     \ operación haya sido registrada en moneda diferente a
                     \ soles, dólares o euros. El tipo de cambio será el que
                     \ la entidad tenga vigente el día que se realizó la
                     \ operación.'

    * _name        : '82'
      _label       : 'Código del país de origen'
      _tip         : 'Código de país de origen: para las operaciones
                     \ relacionadas con importación de bienes, para lo cual
                     \ deben tomar la codificación publicada por la SBS.'

    * _name        : '83'
      _label       : 'Código del país de destino'
      _tip         : 'Código de país de destino: para las operaciones
                     \ relacionadas con exportación de bienes, para lo cual
                     \ deben tomar la codificación publicada por la SBS.'


/** @export */
module.exports = Anex2
