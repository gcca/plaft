/** @module dashboard.modules.anex6 */

Module       = require '../module'
Stakeholders = require './shared/stakeholders'


/**
 * @class UiAnex6
 * @extends Module
 */
class Anex6 extends Module

  /**
   * (Event) On save anex 6.
   */
  onSave: ~>
    dto = new Object
    for xform in @xforms
      _._extend dto, ($ xform)._toJSON!

    dto\stakeholders = @stakeholders._toJSON!

    @dispatch.store \anex6 : dto, do
      _success: -> alert 'Guardado'
      _error: -> alert 'Error: 91b73520-b2ba-11e3-aff2-88252caeb7e8'

  /**
   * (Event) On search dispatch by order number.
   * @param {string} _query
   */
  onSearch: (_query) ~>
    @el.html ''

    @dispatch = new App.model.Dispatch \order : _query
    @dispatch.fetch do
      _success: (_, dispatch) ~>
        @showForm dispatch
      _error: ->
        alert 'Número de orden no hallado: ' + _query

  /**
   * Show anex 6 form.
   * @param {Object} dispatch
   */
  showForm: (dispatch) ->
    @el.html "
      #{@template-header!}

      <div class='#{gz.Css \col-md-12}'>
        <h4>Personas</h4>
      </div>

      #{@template-details!}

      <button class='#{gz.Css \btn}
                   \ #{gz.Css \btn-primary}
                   \ #{gz.Css \pull-right}'>
        Guardar
      </button>"

    @xforms = @$ \form

    ## for xform in @xforms
    ##   ($ xform)._fromJSON dispatch\anex6

    @stakeholders = new Stakeholders #dispatch.'anex6'.'stakeholders'
    @el._first._next._append @stakeholders.render!.el

    @$ 'label[title]' .tooltip!

    @el._last.onClick @onSave

  /** @override */
  render: ->
    @ui.desktop._search._focus!
    super!

  /** @private */ xforms       : null
  /** @private */ dispatch     : null
  /** @private */ stakeholders : null

  template-header: -> "
    <form class='#{gz.Css \row} #{gz.Css \col-md-12}'>

      <div class='#{gz.Css \col-md-12}'>

        <h4>Datos de identificación</h4>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label title='1. Código del sujeto obligado otorgado por la UIF.'>
            1. Código del sujeto obligado
          </label>
          <input type='text' name='f1' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label title='2. Código del oficial de cumplimiento otorgado
                        \ por la UIF.'>
            2. Código del oficial de cumplimiento
          </label>
          <input type='text' name='f2' class='#{gz.Css \form-control}'>
        </div>

      </div>

      <div class='#{gz.Css \col-md-12}'>

        <h4>Datos de identificación de la operación inusual</h4>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            3. Número de operación inusual
          </label>
          <input type='text' name='f3' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label title='4. Número de registro interno del sujeto obligado.'>
            4. Número de registro interno
          </label>
          <input type='text' name='f4' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            5. Fecha de la operación inusual
          </label>
          <input type='text' name='f5' class='#{gz.Css \form-control}'>
        </div>

      </div>

    </form>"

  template-details: -> "
    <form class='#{gz.Css \row} #{gz.Css \col-md-12}'>

      <div class='#{gz.Css \col-md-12}'>

        <h4>Datos relacionados a la descripción de la operación inusual</h4>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label title='29. Tipo de fondos con que se realizó la operación:
                        \ Consignar el código de acuerdo a la Tabla Nº 4.'>
            29. Tipo de fondos
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label title='30. Tipo de operación: Consignar el código de acuerdo
                        \ a la Tabla Nº 5: Tipos de Operación.'>
            30. Tipo de operación
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label title='31. Descripción del tipo de operación en caso según
                        \ la tabla de operaciones se haya consignado el código
                        \ de \"Otros\".'>
            31. Descripción del tipo de operación
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            32. Descripción de las mercancías involucradas en la operación
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            33. Origen de los fondos involucrados en la operación
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            34. Moneda en que se realizó la operación:
            \ S =Nuevos Soles; D= Dólares Americanos, E= Euros
            \ y O= Otra (Detallar en ítem siguiente)
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            35. Descripción del tipo de moneda en caso sea \"Otra\".
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            36. Monto de la operación: Consignar el valor de la mercancía
            \ correspondiente a la operación de comercio exterior que se haya
            \ realizado. Los montos deberán estar expresados en nuevos soles
            \ con céntimos. Para aquellas operaciones realizadas con alguna
            \ moneda extranjera diferente a la indicada, se deberán convertir
            \ a dólares, según el tipo de cambio que la entidad tenga vigente
            \ el día que se realizó la operación.
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            37. Tipo de cambio: Consignar el tipo de cambio respecto a la
            \ moneda nacional, en los casos en los que la operación haya sido
            \ registrada en moneda diferente a nuevos soles, dólares
            \ americanos o euros. El tipo de cambio a considerar será el tipo
            \ de cambio venta del día en qe se realizó la operación, publicado
            \ por la SBS.
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            38. Código de país de origen: Para las operaciones relacionadas
            \ con importación de bienes, para lo cual deben tomar la
            \ codificación publicada por la SBS.
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            39. Código de país destino: Para las operaciones relacionadas
            \ con exportación de bienes, para lo cual deben tomar la
            \ codificación publicada por la SBS.
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            40. Descripción de la operación (Señale los argumentos que lo
            \ llevaron a calificar como inusual la operación).
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            41. La operación ha sido calificada como sospechosa (1) Si, (2) No
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            42. En caso en el item 41 haya consignado la opción (1) indicar el
            \ número de ROS con el que se remitió a la UIF.
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-6}'>
          <label>
            43. En caso en el item 41 haya consignado la opción (2) describir
            \ los argumentos por los cuales esta operación no fue calificada
            \ como sospechosa.
          </label>
          <input type='text' class='#{gz.Css \form-control}'>
        </div>

      </div>

    </form>"

  @@_caption = 'Anexo 6'
  @@_icon    = gz.Css \glyphicon-file

module.exports = Anex6
