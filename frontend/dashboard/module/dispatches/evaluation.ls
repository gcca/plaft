/** @module dashboard.module.dispacthes */

ModuleBaseView = require '../base'


module.exports = class EvaluationView extends ModuleBaseView

  render: ->
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

    @$el.html "
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
              <input type='text' name='01'>
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
              <input type='text' name='02'>
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
              <input type='text' name='03'>
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
              <input type='text' name='04'>
            </div>
          </div>

          #tControlGroup
            #tLabel
              <b>5</b> Fecha de la operación inusual: Consignar la fecha
                       \ de numeración de la mercancía (dd/mm/aaaa).
            </label>
            #tControl
              <input type='text' name='05'>
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
              <input type='text' name='06'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>7</b> Tipo de persona: (1) Persona Natural ó
                       \ (2) Persona Jurídica. Si consignó la opción
                       \ (2) no llenar los items 08 al 13 y del 15 al 22.
            </label>
            #tControl
              <input type='text' name='07'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>8</b> Tipo de documento de identidad.
                       \ Consignar el código de acuerdo a la Tabla Nº 1.
            </label>
            #tControl
              <input type='text' name='08'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>9</b> Número de documento de identidad.
            </label>
            #tControl
              <input type='text' name='09'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>10</b> Condición de residencia : (1) Residente ó
                        \ (2) No Residente.
            </label>
            #tControl
              <input type='text' name='10'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>11</b> País de emisión del documento (en caso corresponda).
            </label>
            #tControl
              <input type='text' name='11'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>12</b> Persona es PEP: (1) Si ó (2) No.
            </label>
            #tControl
              <input type='text' name='12'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>13</b> En caso en el item 12 haya consignado la opción (1),
                        \ indicar el cargo público que desempeña.
            </label>
            #tControl
              <input type='text' name='13'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>14</b> Apellido paterno o razón social (persona jurídica).
            </label>
            #tControl
              <input type='text' name='14'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>15</b> Apellido materno.
            </label>
            #tControl
              <input type='text' name='15'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>16</b> Nombres.
            </label>
            #tControl
              <input type='text' name='16'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>17</b> Nacionalidad.
            </label>
            #tControl
              <input type='text' name='17'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>18</b> Fecha de nacimiento (dd/mm/aaaa).
            </label>
            #tControl
              <input type='text' name='18'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>19</b> Ocupación, oficio o profesión (persona natural):
                        \ Consignar los códigos de acuerdo a la Tabla Nº 2.
            </label>
            #tControl
              <input type='text' name='19'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>20</b> Descripción de la ocupación, oficio o profesión
                        \ la opción otros.
            </label>
            #tControl
              <input type='text' name='20'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>21</b> Empleador (En caso de ser dependiente).
            </label>
            #tControl
              <input type='text' name='21'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>22</b> Ingresos promedios mensuales aproximados
                        \ (En caso de ser dependiente).
            </label>
            #tControl
              <input type='text' name='22'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>23</b> Objeto social de la persona jurídica
                        \ (Consignar la actividad principal).
            </label>
            #tControl
              <input type='text' name='23'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>24</b> Cargo (si aplica): Consignar los códigos de acuerdo
                        \ a la Tabla Nº 3.
            </label>
            #tControl
              <input type='text' name='24'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>25</b> Nombre y número de la vía de la dirección.
            </label>
            #tControl
              <input type='text' name='25'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>26</b> Teléfono de la persona en cuyo nombre se realiza
                        \ la operación.
            </label>
            #tControl
              <input type='text' name='26'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>27</b> Condición en la que interviene en la operación
                        \ inusual (1): Involucrado ó (2) Vinculado.
            </label>
            #tControl
              <input type='text' name='27'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>28</b> Describir la condición en la que interviene
                        \ en la operación inusual.
            </label>
            #tControl
              <input type='text' name='28'>
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
              <input type='text' name='29'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>30</b> Tipo de operación: Consignar el código de acuerdo
                        \ a la Tabla Nº 5: Tipos de Operación.
            </label>
            #tControl
              <input type='text' name='30'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>31</b> Descripción del tipo de operación en caso según
                        \ la tabla de operaciones se haya consignado el código
                        \ de \"Otros\".
            </label>
            #tControl
              <input type='text' name='31'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>32</b> Descripción de las mercancías involucradas
                        \ en la operación.
            </label>
            #tControl
              <input type='text' name='32'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>33</b> Origen de los fondos involucrados en la operación.
            </label>
            #tControl
              <input type='text' name='33'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>34</b> Moneda en que se realizó la operación:
                        \ S =Nuevos Soles; D= Dólares Americanos, E= Euros
                        \ y O= Otra (Detallar en ítem siguiente).
            </label>
            #tControl
              <input type='text' name='34'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>35</b> Descripción del tipo de moneda en caso sea \"Otra\".
            </label>
            #tControl
              <input type='text' name='35'>
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
              <input type='text' name='36'>
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
              <input type='text' name='37'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>38</b> Código de país de origen: Para las operaciones
                        \ relacionadas con importación de bienes, para lo cual
                        \ deben tomar la codificación publicada por la SBS.
            </label>
            #tControl
              <input type='text' name='38'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>39</b> Código de país destino: Para las operaciones
                        \ relacionadas con exportación de bienes, para lo cual
                        \ deben tomar la codificación publicada por la SBS.
            </label>
            #tControl
              <input type='text' name='39'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>40</b> Descripción de la operación (Señale los argumentos que
                        \ lo llevaron a calificar como inusual la operación).
            </label>
            #tControl
              <input type='text' name='40'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>41</b> La operación ha sido calificada como sospechosa
                        \ (1) Si, (2) No.
            </label>
            #tControl
              <input type='text' name='41'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>42</b> En caso en el item 41 haya consignado la opción
                        \ (1) indicar el número de ROS con el que se remitió
                        \ a la UIF.
            </label>
            #tControl
              <input type='text' name='42'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>43</b> En caso en el item 41 haya consignado la opción
                        \ (2) describir los argumentos por los cuales esta
                        \ operación no fue calificada como sospechosa.
            </label>
            #tControl
              <input type='text' name='43'>
            </div>
          </div>

        </fieldset>


        #tFieldset

          <legend>SEÑALES DE ALERTA IDENTIFICADAS
                  \ <small>(Se debe consignar estos datos por cada señal
                  \ de alerta)</small></legend>

          #tControlGroup50
            #tLabel
              <b>44</b> Código de la señal de alerta.
            </label>
            #tControl
              <input type='text' name='44'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>45</b> Descripción de la señal de alerta.
            </label>
            #tControl
              <input type='text' name='45'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>46</b> Fuente de la señal de alerta: Sistema de Monitoreo
                        \ (1), Area Comercial (2), Análisis del SO (3),
                        \ Medio Periodístico (4) y Otras fuentes (5).
            </label>
            #tControl
              <input type='text' name='46'>
            </div>
          </div>

          #tControlGroup50
            #tLabel
              <b>47</b> En caso en el item 46 se haya consignado la opción 5
                        \ describir la fuente.
            </label>
            #tControl
              <input type='text' name='47'>
            </div>
          </div>

        </fieldset>

      </form>"
    super!

  @menuCaption = 'Anexo 6'
