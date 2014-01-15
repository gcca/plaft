/** @module dashboard.module.dispacthes */

ModuleBaseView = require '../base'
AlertsView     = require './evaluation/alerts'



/**
 * Alerts and Anex 6.
 * @class EvaluationView
 */
module.exports = class EvaluationView extends ModuleBaseView

  /**
   * Initialize view.
   * @param {Object} opts Options.
   * @private
   */
  initialize: !(opts) ->
    @dispatch = opts.dispatch

  /**
   * Render view.
   * @return {Object}
   * @public
   */
  render: ->
    @$el.html @template!

    # Main form
    $form = @$el.find \form

    # Populate form
    $form.populateJSON @dispatch.get \evaluation

    # Button save
    @$el.find \button .on \click ~>
      JSONFields = \evaluation : $form.serializeJSON!
      @dispatch.save JSONFields, do
        \success : (dispatch) ->
          console.log dispatch
        \error   : ->
          alert 'ERROR: evaluation (aadd1c12-78b9-11e3-9aca-88252caeb7e8)'

    # Alerts view
    alertsView = new AlertsView
    @$el.find "##{gz.Css \id-tab-alerts}" .append alertsView.render!.el

    # Tabs
    new gz.Ink.UI.Tabs (@$el.find ".#{gz.Css \ink-tabs}" .get 0), do
      \preventUrlChange : on

    super!

  ## Attributes
  @menuCaption = 'Anexo 6'

  /**
   * View template.
   * @return {string}
   * @private
   */
  template: -> "
    <button class='#{gz.Css \ink-button}
                 \ #{gz.Css \green}
                 \ #{gz.Css \push-right}' type='button'>
      Guardar
    </button>

    <div class='#{gz.Css \ink-tabs} #{gz.Css \top}'>

      <ul class='#{gz.Css \tabs-nav}'>
        <li>
          <a href='\##{gz.Css \id-tab-alerts}'>
            Alertas
          </a>
        </li>
        <li>
          <a href='\##{gz.Css \id-tab-anex6}'>
            Anexo 6
          </a>
        </li>
      </ul>

      <div id='#{gz.Css \id-tab-alerts}' class='#{gz.Css \tabs-content}'>
      </div>

      <div id='#{gz.Css \id-tab-anex6}' class='#{gz.Css \tabs-content}'
          style='padding-left:.3em'>
        #templateAnex6
      </div>

    </div>"


## Template
tControlGroup = "<div class='#{gz.Css \control-group}
                           \ #{gz.Css \large-100}
                           \ #{gz.Css \medium-100}
                           \ #{gz.Css \small-100}'>"

tControlGroup50 = "<div class='#{gz.Css \control-group}
                             \ #{gz.Css \large-50}
                             \ #{gz.Css \medium-50}
                             \ #{gz.Css \small-100}'>"

tLabel = "<label>"

tControl = "<div class='#{gz.Css \control}'>"

tFieldset = "<fieldset class='#{gz.Css \large-100}
                            \ #{gz.Css \medium-100}
                            \ #{gz.Css \small-100}
                            \ #{gz.Css \column-group}
                            \ #{gz.Css \gutters}'>"

## tFieldset50 = "<fieldset class='#{gz.Css \large-50}
##                               \ #{gz.Css \medium-50}
##                               \ #{gz.Css \small-100}
##                               \ #{gz.Css \column-group}
##                               \ #{gz.Css \gutters}'>"

templateAnex6 = "
  <form class='#{gz.Css \ink-form}'>

    #tFieldset

      <legend>Datos de identificación</legend>

      <div class='#{gz.Css \control-group}
                \ #{gz.Css \large-50}
                \ #{gz.Css \medium-100}
                \ #{gz.Css \small-100}'>
        #tLabel
          <b>1</b> Código del sujeto obligado otorgado por la UIF.
        </label>
        #tControl
          <input type='text' name='c01'>
        </div>
      </div>

      <div class='#{gz.Css \control-group}
                \ #{gz.Css \large-50}
                \ #{gz.Css \medium-100}
                \ #{gz.Css \small-100}'>
        #tLabel
          <b>2</b> Código del oficial de cumplimiento otorgado por la UIF.
        </label>
        #tControl
          <input type='text' name='c02'>
        </div>
      </div>

    </fieldset>


    #tFieldset

      <legend>Datos de identificación de la operación inusual</legend>

      #tControlGroup
        #tLabel
          <b>3</b> Número de operación inusual: Consignar el número de
                   \ secuencia correspondiente al registro de la operación
                   \ inusual debiendo empezar en el número uno (1),
                   \ de acuerdo al formato siguiente: (año - número).
        </label>
        #tControl
          <input type='text' name='c03'>
        </div>
      </div>

      #tControlGroup
        #tLabel
          <b>4</b> Número de registro interno del sujeto obligado:
                   \ Consignar el número de la Declaración Aduanera
                   \ de Mercancías (DAM) correspondiente a la operación
                   \ inusual que se registra.
        </label>
        #tControl
          <input type='text' name='c04'>
        </div>
      </div>

      #tControlGroup
        #tLabel
          <b>5</b> Fecha de la operación inusual: Consignar la fecha
                   \ de numeración de la mercancía (dd/mm/aaaa).
        </label>
        #tControl
          <input type='text' name='c05'>
        </div>
      </div>

    </fieldset>


    #tFieldset

      <legend>Datos de identificación de las personas involucradas
              \ en las operaciones inusuales <small>
              \ (consignar los datos consignados en esta sección
              \ por cada persona involucrada
              \ en la operación inusual)</small></legend>

      #tControlGroup50
        #tLabel
          <b>6</b> La persona en cuyo nombre se realiza la operación es:
                   \ (1) proveedor del extranjero (ingreso de mercancía),
                   \ (2) Importador (ingreso de mercancía), ó
                   \ (3) Exportador (salida de mercancía) ó
                   \ Destinatario del embarque (salida de mercancía).
        </label>
        #tControl
          <input type='text' name='c06'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>7</b> Tipo de persona: (1) Persona Natural ó
                   \ (2) Persona Jurídica. Si consignó la opción
                   \ (2) no llenar los items 08 al 13 y del 15 al 22.
        </label>
        #tControl
          <input type='text' name='c07'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>8</b> Tipo de documento de identidad.
                   \ Consignar el código de acuerdo a la Tabla Nº 1.
        </label>
        #tControl
          <input type='text' name='c08'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>9</b> Número de documento de identidad.
        </label>
        #tControl
          <input type='text' name='c09'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>10</b> Condición de residencia : (1) Residente ó
                    \ (2) No Residente.
        </label>
        #tControl
          <input type='text' name='c10'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>11</b> País de emisión del documento (en caso corresponda).
        </label>
        #tControl
          <input type='text' name='c11'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>12</b> Persona es PEP: (1) Si ó (2) No.
        </label>
        #tControl
          <input type='text' name='c12'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>13</b> En caso en el item 12 haya consignado la opción (1),
                    \ indicar el cargo público que desempeña.
        </label>
        #tControl
          <input type='text' name='c13'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>14</b> Apellido paterno o razón social (persona jurídica).
        </label>
        #tControl
          <input type='text' name='c14'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>15</b> Apellido materno.
        </label>
        #tControl
          <input type='text' name='c15'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>16</b> Nombres.
        </label>
        #tControl
          <input type='text' name='c16'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>17</b> Nacionalidad.
        </label>
        #tControl
          <input type='text' name='c17'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>18</b> Fecha de nacimiento (dd/mm/aaaa).
        </label>
        #tControl
          <input type='text' name='c18'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>19</b> Ocupación, oficio o profesión (persona natural):
                    \ Consignar los códigos de acuerdo a la Tabla Nº 2.
        </label>
        #tControl
          <input type='text' name='c19'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>20</b> Descripción de la ocupación, oficio o profesión
                    \ la opción otros.
        </label>
        #tControl
          <input type='text' name='c20'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>21</b> Empleador (En caso de ser dependiente).
        </label>
        #tControl
          <input type='text' name='c21'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>22</b> Ingresos promedios mensuales aproximados
                    \ (En caso de ser dependiente).
        </label>
        #tControl
          <input type='text' name='c22'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>23</b> Objeto social de la persona jurídica
                    \ (Consignar la actividad principal).
        </label>
        #tControl
          <input type='text' name='c23'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>24</b> Cargo (si aplica): Consignar los códigos de acuerdo
                    \ a la Tabla Nº 3.
        </label>
        #tControl
          <input type='text' name='c24'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>25</b> Nombre y número de la vía de la dirección.
        </label>
        #tControl
          <input type='text' name='c25'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>26</b> Teléfono de la persona en cuyo nombre se realiza
                    \ la operación.
        </label>
        #tControl
          <input type='text' name='c26'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>27</b> Condición en la que interviene en la operación
                    \ inusual (1): Involucrado ó (2) Vinculado.
        </label>
        #tControl
          <input type='text' name='c27'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>28</b> Describir la condición en la que interviene
                    \ en la operación inusual.
        </label>
        #tControl
          <input type='text' name='c28'>
        </div>
      </div>

    </fieldset>


    #tFieldset

      <legend>Datos relacionados a la descripción
              \ de la operación inusual</legend>

      #tControlGroup50
        #tLabel
          <b>29</b> Tipo de fondos con que se realizó la operación:
                    \ Consignar el código de acuerdo a la Tabla Nº 4.
        </label>
        #tControl
          <input type='text' name='c29'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>30</b> Tipo de operación: Consignar el código de acuerdo
                    \ a la Tabla Nº 5: Tipos de Operación.
        </label>
        #tControl
          <input type='text' name='c30'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>31</b> Descripción del tipo de operación en caso según
                    \ la tabla de operaciones se haya consignado el código
                    \ de \"Otros\".
        </label>
        #tControl
          <input type='text' name='c31'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>32</b> Descripción de las mercancías involucradas
                    \ en la operación.
        </label>
        #tControl
          <input type='text' name='c32'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>33</b> Origen de los fondos involucrados en la operación.
        </label>
        #tControl
          <input type='text' name='c33'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>34</b> Moneda en que se realizó la operación:
                    \ S =Nuevos Soles; D= Dólares Americanos, E= Euros
                    \ y O= Otra (Detallar en ítem siguiente).
        </label>
        #tControl
          <input type='text' name='c34'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>35</b> Descripción del tipo de moneda en caso sea \"Otra\".
        </label>
        #tControl
          <input type='text' name='c35'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>36</b> Monto de la operación: Consignar el valor
                    \ de la mercancía correspondiente a la operación
                    \ de comercio exterior que se haya realizado.
                    \ Los montos deberán estar expresados en nuevos soles
                    \ con céntimos. Para aquellas operaciones realizadas
                    \ con alguna moneda extranjera diferente a la indicada,
                    \ se deberán convertir a dólares, según el tipo
                    \ de cambio que la entidad tenga vigente
                    \ el día que se realizó la operación.
        </label>
        #tControl
          <input type='text' name='c36'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>37</b> Tipo de cambio: Consignar el tipo de cambio respecto
                    \ a la moneda nacional, en los casos en los que
                    \ la operación haya sido registrada en moneda
                    \ diferente a nuevos soles, dólares americanos o euros.
                    \ El tipo de cambio a considerar será el tipo
                    \ de cambio venta del día en qe se realizó la operación
                    \, publicado por la SBS.
        </label>
        #tControl
          <input type='text' name='c37'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>38</b> Código de país de origen: Para las operaciones
                    \ relacionadas con importación de bienes, para lo cual
                    \ deben tomar la codificación publicada por la SBS.
        </label>
        #tControl
          <input type='text' name='c38'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>39</b> Código de país destino: Para las operaciones
                    \ relacionadas con exportación de bienes, para lo cual
                    \ deben tomar la codificación publicada por la SBS.
        </label>
        #tControl
          <input type='text' name='c39'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>40</b> Descripción de la operación (Señale los argumentos que
                    \ lo llevaron a calificar como inusual la operación).
        </label>
        #tControl
          <input type='text' name='c40'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>41</b> La operación ha sido calificada como sospechosa
                    \ (1) Si, (2) No.
        </label>
        #tControl
          <input type='text' name='c41'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>42</b> En caso en el item 41 haya consignado la opción
                    \ (1) indicar el número de ROS con el que se remitió
                    \ a la UIF.
        </label>
        #tControl
          <input type='text' name='c42'>
        </div>
      </div>

      #tControlGroup50
        #tLabel
          <b>43</b> En caso en el item 41 haya consignado la opción
                    \ (2) describir los argumentos por los cuales esta
                    \ operación no fue calificada como sospechosa.
        </label>
        #tControl
          <input type='text' name='c43'>
        </div>
      </div>

    </fieldset>

  </form>"
