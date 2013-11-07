/**
 * @class
 */
module.exports = class AlertModal extends widget.GModal

    /**
     * @type {string}
     * @private
     */
    amHeader: "Señales de alerta"

    /**
     * amBody method
     * Form for listing alerts with checkbox and textarea for comments.
     * @return {HTMLFormElement}
     * @private
     */
    amBody: ~>
        count = 0
        form = $ "<form class='#{gz.Css \ink-form}'>"
        for alert in @alertSignals
            control-group = $ "
                <div class='#{gz.Css \control-group} #{gz.Css \column-group}'>"

            control-group.append "
                <label class='#{gz.Css \large-90}
                            \ #{gz.Css \medium-90}
                            \ #{gz.Css \small-90}'
                    style='margin-bottom:0;text-align:justify'>
                  #alert
                </label>"

            control = $ "
                <div class='#{gz.Css \control}
                          \ #{gz.Css \large-10}
                          \ #{gz.Css \medium-10}
                          \ #{gz.Css \small-10}
                          \ #{gz.Css \content-center}'>"
            input = $ \<input>
                ..attr \type, \checkbox
                ..css do
                  \float : 'initial'
                  \transform : 'scale(1.5)'
                  \-moz-transform : 'scale(1.5)'
                  \-webkit-transform : 'scale(1.5)'
            control.append input
            control-group.append control

            control-textarea = $ "
                <div class='#{gz.Css \control}
                          \ #{gz.Css \large-100}
                          \ #{gz.Css \medium-100}
                          \ #{gz.Css \small-100}'
                    style='padding-right:7em;padding-left:2em'>
                </div>"
            textarea = $ "<textarea name='#{++count}'
                          placeholder='Comentarios acerca de la alerta #count'>"
                ..css do
                    \minHeight : '9em'
                    \marginTop : '1em'
            if (@dispatch.get \alerts)? and (@dispatch.get \alerts)[count]?
                input.attr \checked true
                textarea.val (@dispatch.get \alerts)[count]
            else
                textarea.hide!
            input.on \click ((textarea) -> (event) ->
                input = event.currentTarget
                if input.checked
                    textarea.show!
                else
                    ## textarea.val ''
                    textarea.hide!) textarea
            control-textarea.append textarea
            control-group.append control-textarea

            form.append control-group
            form.append '<hr>'
        @form = form
        form.get 0

    /**
     * amFooter method
     * @return {HTMLDivElement} Buttons
     * @private
     */
    amFooter: ~>
        footer = $ "<div class='#{gz.Css \push-right}'>"
        btnOk = $ "<button class='#{gz.Css \ink-button} #{gz.Css \blue}'>
                     Guardar
                   </button>"
        btnClose = $ "<button class='#{gz.Css \ink-button}
                                   \ #{gz.Css \red}
                                   \ #{gz.Css \ink-dismiss}'>
                        Cerrar
                      </button>"
        btnOk.on \click, @onClickOk
        footer.append btnOk
        footer.append btnClose
        footer.get 0

    # ------
    # Events
    # ------
    /**
     * onClickOk event method
     * @private
     */
    onClickOk: !~>
        @dispatch.save (\alerts : @form.serializeJSON!), do
            \success : ~> @hide!
            \error : ~> alert 'ERROR: alerts'
    # -- end Events --

    /**
     * Constructor set {@code mHead} and {@code mBody} to show alert list.
     * @param {!Object} dispatch Dispatch model.
     * @constructor
     * @override
     */
    !(@dispatch) ->
        super @amHeader, @amBody!, @amFooter!

    /**
     * Alert caption list.
     * @type {Array.<string>}
     * @private
     */
    alertSignals : [
        '1. El cliente, para efectos de su identificación, presenta información inconsistenteo de dificilverificaciónpor parte del sujeto obligado.'
        '2. El cliente declara o registra la misma dirección que la de otras personas con las que no tiene relación o vínculo aparente.'
        '3. Existencia de indicios de que el ordenante (propietario/titulardel bien o derecho) ó el beneficiario (adquirente o receptor del bien o derecho) no actúa por su cuenta y que intentaocultar la identidad del ordenante o beneficiarioreal.'
        '4. El cliente presenta una inusual despreocupación por los riesgos que asume o los importes involucrados en el despacho aduanero de mercanciaso los costosque implicala operación.'
        '5. El cliente realiza operaciones de forma sucesiva y/o reiterada.'
        '6. El cliente realiza constantementeoperaciones y de modo inusual usa o pretende utilizardinero en efectivocomo único medio de pago.'
        '7. El cliente se rehusa a llenar los formularios o proporcionar la informaciónrequerida por el sujeto obligado, o se niega a realizar la operación tan pronto se le solicita.'
        '8. Las operaciones realizadas por el clienteno corresponden a su actividad económica.'
        '9. El cliente está siendo investigado o procesado por el delito de lavado de activos, delitosprecedentes, el delito de financiamientodel terrorismo y sus delitosconexos, y se toma conocimientode ello por los medios de difusiónpública u otros medios.'
        '10. Clientes entre los cuales no hay ninguna relación de parentesco, financiera o comercial, sean personas naturales o jurídicas, sin embargo son representados por una mismapersona. Se debe prestar especial atención cuando dichos clientes tengan fijado sus domiciliosen el extranjero o en paraísos fiscales.'
        '11. El cliente realiza frecuentementeoperaciones por sumas de dinero que no guardan relación con la ocupación que declara tener.'
        '12. Solicitud del cliente de realizar despachos aduaneros de mercancias en condiciones o valores que no guardan relación con las actividades del dueño o consignatario,o en las condicioneshabitualesdel mercado.'
        '13. Solicitud del clientede dividir los pagos por la prestación del servicio, generalmente,en efectivo.'
        '14. Personas naturales o jurídicas, incluyendo sus accionistas,socios, asociados, socios fundadores, gerentes y directores, que figuren en alguna listainternacionalde las Naciones Unidas, OFAC o similar.'
        '15. El cliente presenta una inusual despreocupación por la presentación o estado de su mercancía o carga y/o de las comisiones y costos que implicala operación.'
        '16. El cliente solicita ser excluido del registro de operaciones.'
        '17. El cliente asume el pago de comisiones, impuestos y cualquier otro costo o tributo generado no sólo por la realización de sus operaciones, sino la de terceros o a las de otras operaciones aparentemente no relacionadas.'
        '18. El cliente realiza frecuentes o significativas operaciones y declara no realizar o no haber realizado actividad económicaalguna.']
