/** @module dashboard.modules.anex2 */

Module = require '../module'


class Anex2 extends Module

  render: ->

    @$el.html @template-details!
    super!

  template-details: ->
    _html = new Array
    for [_name, _label] in @fieldsDetails
      _html._push App.shared.shortcuts.html._form._field do
        _name  : _name
        _label : _label
    _html._join ''

  @@_caption = 'Anexo 2'
  @@_icon    = gz.Css \glyphicon-file

  fieldsDetails:
    * '71'
      'Tipo de fondos con que se realizó la operación: consignar el código de
      \ acuerdo a la Tabla Nº 5.'

    * '72'
      'Tipo de operación: consignar el código de acuerdo a la Tabla Nº 6:
      \ Tipos de Operación.'

    * '73'
      'Descripción del tipo de operación en caso según la tabla de operaciones
      \ se haya consignado el código de "Otros"'

    * '74'
      'Descripción de las mercancías involucradas en la operación.'

    * '75'
      'Número de DAM.'

    * '76'
      'Fecha de numeración de la DAM.'

    * '77'
      'Origen de los fondos involucrados en la operación.'

    * '78'
      'Moneda en que se realizó la operación (Según Codificación ISO-4217).'

    * '79'
      'Descripción del tipo de moneda en caso sea "otra".'

    * '80'
      'Monto de la operación: Consignar el valor de la mercancía
       \ correspondiente a la operación de comercio exterior que se haya
       \ realizado. Los montos deberán estar expresados en nuevos soles
       \ con céntimos. Para aquellas operaciones realizadas con alguna moneda
       \ extranjera diferente a la indicada, se deberán convertir a dólares,
       \ según el tipo de cambio que la entidad tenga vigente el día que
       \ se realizó la operación.'

    * '81'
      'Tipo de cambio: consignar el tipo de cambio respecto a la moneda
      \ nacional, en los casos en los que la operación haya sido registrada
      \ en moneda diferente a soles, dólares o euros. El tipo de cambio será
      \ el que la entidad tenga vigente el día que se realizó la operación.'

    * '82'
      'Código de país de origen: para las operaciones relacionadas con
      \ importación de bienes, para lo cual deben tomar la codificación
      \ publicada por la SBS.'

    * '83'
      'Código de país de destino: para las operaciones relacionadas con
      \ exportación de bienes, para lo cual deben tomar la codificación
      \ publicada por la SBS.'


/** @export */
module.exports = Anex2
