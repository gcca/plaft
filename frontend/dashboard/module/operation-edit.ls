form = require '../../form'

class OperationEditView extends gz.GView
    tagName: \div

    initialize: !->
        @el.innerHTML = "<h3>Señales de Alerta</h3>"

        alertArray = new Array
        for alert in alertSignals
            alertArray.push "
              #{form.control-group}
                <label class='#{gz.Css \large-85}
                            \ #{gz.Css \medium-85}
                            \ #{gz.Css \small-85}' style='margin-bottom:0'>
                  #alert
                </label>
                <div class='#{gz.Css \control}
                          \ #{gz.Css \large-15}
                          \ #{gz.Css \medium-15}
                          \ #{gz.Css \small-15}
                          \ #{gz.Css \content-right}'>
                  <input type='checkbox'>
                </div>
              </div>
              <hr>"

        # (-o-) Use id
        console.log @options.operationId

        @el.innerHTML += "
        <form class='#{gz.Css \ink-form}'>
          #{alertArray.join ''}
        </form>"

module.exports = OperationEditView

alertSignals = [
  '1. El cliente,para efectosde su identificación,presenta informacióninconsistenteo de dificilverificaciónpor parte del sujeto obligado.'
  '2. El clientedeclara o registra la mismadirección que la de otras personas con las que no tiene relación o vínculo aparente.'
  '3. Existencia de indicios de que el ordenante (propietario/titulardel bien o derecho) ó el beneficiario (adquirente o receptor del bien o derecho) no actúa por su cuenta y que intentaocultar la identidad del ordenante o beneficiarioreal.'
  '4. El cliente presenta una inusual despreocupación por los riesgos que asume o los importes involucrados en el despacho aduanero de mercanciaso los costosque implicala operación.'
  '5. El clienterealiza operaciones de forma sucesiva y/o reiterada.'
  '6. El clienterealiza constantementeoperaciones y de modo inusual usa o pretende utilizardinero en efectivocomo único medio de pago.'
  '7. El cliente se rehusa a llenar los formularios o proporcionar la informaciónrequerida por el sujeto obligado, o se niega a realizar la operación tan pronto se le solicita.'
  '8. Las operaciones realizadas por el clienteno corresponden a su actividad económica.'
  '9. El clienteestá siendo investigado o procesado por el delito de lavado de activos, delitosprecedentes, el delito de financiamientodel terrorismo y sus delitosconexos, y se toma conocimientode ello por los medios de difusiónpública u otros medios.'
  '10. Clientes entre los cuales no hay ninguna relación de parentesco, financiera o comercial, sean personas naturales o jurídicas, sin embargo son representados por una mismapersona. Se debe prestar especial atención cuando dichos clientes tengan fijado sus domiciliosen el extranjero o en paraísos fiscales.'
  '11. El clienterealiza frecuentementeoperaciones por sumas de dinero que no guardan relación con la ocupación que declara tener.'
  '12. Solicitud del cliente de realizar despachos aduaneros de mercancias en condiciones o valores que no guardan relación con las actividades del dueño o consignatario,o en las condicioneshabitualesdel mercado.'
  '13. Solicituddel clientede dividir los pagos por la prestación del servicio, generalmente,en efectivo.'
  '14. Personas naturales o jurídicas, incluyendo sus accionistas,socios, asociados, socios fundadores, gerentes y directores, que figuren en alguna listainternacionalde las Naciones Unidas, OFAC o similar.'
  '15. El cliente presenta una inusual despreocupación por la presentación o estado de su mercancía o carga y/o de las comisiones y costos que implicala operación.'
  '16. El clientesolicitaser excluido del registro de operaciones.'
  '17. El clienteasume el pago de comisiones,impuestosy cualquier otro costo o tributo generado no sólo por la realización de sus operaciones, sino la de terceros o a las de otras operaciones aparentementeno relacionadas.'
  '18. El clienterealiza frecuenteso significativasoperaciones y declara no realizar o no haber realizado actividad económicaalguna.'
]
