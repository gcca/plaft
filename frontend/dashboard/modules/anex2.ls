/** @module dashboard.modules.anex2 */

Module = require '../module'

FieldType = App.builtins.Types.Field


class Stakeholder extends App.View

  _tagName: \form


class Stakeholders extends App.View

  _tagName: \div

  _className: gz.Css \col-md-12

  addStakeholder: ~> (Stakeholder.New @_fields).render!.el

  initialize: (@_fields) ->

  _fields: null

  render: ->
    @el.html "
      <button type='button' class='#{gz.Css \btn} #{gz.Css \btn-default}'>
        Agregar
      </button>"
    @el._first.onClick = @addStakeholder
    super!


/**
 * @class UiAnex2
 * @extends Module
 */
class Anex2 extends Module

  /** @override */
  render: ->
    fbuilder = App.shared.shortcuts.xhtml._form.Builder.New @el

    fbuilder.fieldset 'Datos de identificación del RO',
                      @fieldsRO
                      'Datos a ser consigados sólo en la parte inicial de RO,
                      \ no respecto de cada operación'

    _groups =
      * 'Uno'
        Stakeholders.New!
      * 'Dos'
        Stakeholders.New!
      * 'Tres'
        Stakeholders.New!
      * 'Cuatro'
        Stakeholders.New!

    fieldsStakeholders = [{
      _label   : ..0
      _type    : FieldType.kView
      _options : ..1
      _class   : gz.Css \col-md-12
      _head    : 'h4'
    } for _groups]

    fbuilder.fieldset 'Datos de identificación de los involucrados',
                      fieldsStakeholders

    fbuilder.fieldset 'Datos de identificación de la operación',
                      @fieldsOperation

    fbuilder.fieldset 'Datos relacionados a la descripción de la operación',
                      @fieldsDetails

    fbuilder.render!
    fbuilder.free!

    $group = @$ "##{gz.Css \id-stakeholders-group}"
    $group._append "<h4>Declarantes</h4>"
    $group._append Stakeholders.New!.render!.el

    @$ '[title]' .tooltip!
    super!

  /** @public */ @@_caption = 'Anexo 2'
  /** @public */ @@_icon    = gz.Css \glyphicon-file

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
