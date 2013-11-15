/**
 * @module dashboard.module
 */

#form   = require../../form'
widget = require '../../widget'
ModuleBaseView = require './base'


## import infraestructure.utils as utils
## from domain.gz import Entity, PolyEntity, ReferenceProperty, StringProperty, \
##     EmailProperty, BooleanProperty, DateProperty, TextProperty, \
##     DocumentTypeProperty, JsonProperty, BadValueError


## class NaturalPerson(Entity):
##       """NaturalPerson

##       Persona Natural

##       Attributes:

##       documentTypeN          :Tipo de documento
##       documentNumberN        :Número de documento
##       CountryN               :Pais de emisión del documento
##       RUCN                   :RUC
##       firstSurnameN          :Apellido paterno
##       secondLastNameN        :Apellido materno
##       NameN                  :Nombres
##       OccupationN            :Ocupación
##       descriptionOccupationN :Descripción de ocupación
##       economicActivityN      :Actividad ecónomica
##       CodeCIIUN              :Código CIIU
##       chargeN                :Cargo
##       adressN                :Dirección
##       codeUbigeo             :Código ubigeo
##       phoneN                 :Teléfono
##       personN                :Persona """

##       documentTypeN          = DocumentTypeProperty ()
##       documentNumberN        = TextTypeProperty     ()
##       CountryN               = TextTypeProperty     ()
##       RUCN                   = TextTypeProperty     ()
##       firstSurnameN          = TextTypeProperty     ()
##       secondLastNameN        = TextTypeProperty     ()
##       NameN                  = TextTypeProperty     ()
##       OccupationN            = TextTypeProperty     ()
##       descriptionOccupationN = TextTypeProperty     ()
##       economicActivityN      = TextTypeProperty     ()
##       CodeCIIUN              = TextTypeProperty     ()
##       chargeN                = TextTypeProperty     ()
##       adressN                = TextTypeProperty     ()
##       codeUbigeoN            = TextTypeProperty     ()
##       phoneN                 = TextTypeProperty     ()
##       personN                = TextTypeProperty     ()


## class JuridicalPerson(Entity):
##       """ JuridicalPerson

##       Persona Juidico

##       Attributes:

##       RUCJ                 :RUC
##       businessNameJ        :Razón ocial
##       economicActivityJ    :Actividad ecónomica
##       codeCIIUJ            :Código CIIU
##       chargeJ              :Cargo
##       addressJ             :Dirección
##       codeUbigeoJ          :Código ubigeo
##       phoneJ               :Teléfono
##       personJ              :Persona (Importador, Destinatario, Proveedor del extranjero    o Exportador)
##       """

##       RUCJ                 = TextProperty       ()
##       businessNameJ        = TextProperty       ()
##       economicActivityJ    = TextProperty       ()
##       codeCIIUJ            = TextProperty       ()
##       chargeJ              = TextProperty       ()
##       addressJ             = TextProperty       ()
##       codeUbigeoJ          = TextProperty       ()
##       phoneJ               = TextProperty       ()
##       personJ              = TextProperty       ()


## class Operation(Entity):

##       """
##       codeSO                  :Codigo SO
##       codeOC                  :Codigo OC

##       numberRow               :Número de fila
##       numberRegisterOperation :Número de registro de Operación
##       numberRegistro          :Número de registro interno
##       modalityOperation       :Modalidad de operación
##       numberOperaciones       :Número de operaciones

##       operationType           :Tipo de operación
##       descrptionTypeOperation :Descripción de tipo de operacion (caso "otros")
##       descrptionMerchandise   :Descripción de mercancias
##       numberDAM               :Número de DAM
##       dateNumberDAM           :Fecha de numeración DAM
##       originFinance           :Origen de los fondos
##       currency                :moneda
##       descriptionTypeCurrency :Descripción tipo de moneda
##       exchangeRate            :Tipo de cambio
##       codeCountryOrigin       :Código país origen
##       codeCountryDestiny      :Código país destino
##       actorsOperation         :Actores de la operacion (declarantes,
##                               despachadores, mercaderes y terceros)
##       declarant               :declarantes
##       fastWorker              :despachadores
##       merchant                :mercaderes
##       third                   :terceros
##       typtPerson              :Tipo de persona (Persona natural o Persona
##                               juridica)
##       """


##       codeSO                  = TextTypeProperty ()
##       codeOC                  = TextTypeProperty ()

##       numberRow               = TextTypeProperty ()
##       numberRegisterOperation = TextTypeProperty ()
##       numberRegistro          = TextTypeProperty ()
##       modalityOperation       = TextTypeProperty ()
##       numberOperaciones       = TextTypeProperty ()

##       operationType           = TextTypeProperty ()
##       descrptionTypeOperation = TextTypeProperty ()
##       descriptionMerchandise  = TextTypeProperty ()
##       numberDAM               = TextTypeProperty ()
##       dateNumberDAM           = TextTypeProperty ()
##       originFinance           = TextTypeProperty ()
##       currency                = TextTypeProperty ()
##       descriptionTypeCurrency = TextTypeProperty ()
##       exchangeRate            = TextTypeProperty ()
##       codeCountryOrigin       = TextTypeProperty ()
##       codeCountryDestiny      = TextTypeProperty ()



/**
 * @class DispatchView
 */
module.exports = class DispatchView extends ModuleBaseView

  /**
   * On search from searchView event.
   * @param {!string} query Query text: orderNumber.
   * @private
   */
  onSearch: !(query) ~>
    if query.match /\d+-\d+/
      console.log query
    else
      (new widget.GAutoAlert (gz.Css \error),
                             "<b>ERROR:</b> Número de orden incorrecto:
                             \ <em>#query</em>").elShow!

  /**
   * Initialize view.
   * @private
   */
  initialize: !-> @render!

  /**
   * Render view.
   * @return {Object}
   */
  render: ->
    @desktop.uiSearch.showTooltip '<b>Buscar por <em>número de orden</em></b>'
    @desktop.uiSearch.elFocus!
    super!

  /** @private */ @menuCaption = 'Despacho'
  /** @private */ @menuIcon    = gz.Css \icon-file
  /** @private */ @menuTitle   = 'Despacho (Anexo 6)'

  /**
   * Template (Dispatch).
   * @param {!Object} dispatch
   * @return {string}
   * @private
   */
  template: (dispatch) -> "
    <div></div>"
