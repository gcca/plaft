/** @module dashboard.modules.dispatches */

Module = require '../module'

Customs = App.model.Customs


/**
 * @class UiDispatches
 * @extends Module
 */
class Dispatches extends Module

  /**
   * @return {string}
   */
  numeration: (dispatch) ->
    if dispatch\numeration
      "<span class='#{gz.Css \label} #{gz.Css \label}-
        #{if dispatch.'numeration'.'type' is \Verde
            gz.Css \success
          else if dispatch.'numeration'.'type' is \Naranja
            gz.Css \warning
          else if dispatch.'numeration'.'type' is \Rojo
            gz.Css \danger
         }'>
        #{dispatch.'numeration'.'type'}
      </span>"
    else
      "&\#8212;"

  isnumerated: (dispatch) ->
    if dispatch.'numeration'
      and dispatch.'numeration'.'number'
      and dispatch.'numeration'.'number' isnt ''
    then 'Sí'
    else 'No'

  /**
   * @return {string}
   */
  dropdown: ->
    "<button type='button' class='#{gz.Css \btn}
                               \ #{gz.Css \btn-default}
                               \ #{gz.Css \pull-right}'>
      <i class='#{gz.Css \glyphicon}
              \ #{gz.Css \glyphicon-circle-arrow-down}'></i>
    </button>"

  /**
   * @return {string}
   */
  verified: (dispatch) ->
    verifies = dispatch\verifies
    if verifies._length and _._all verifies then 'Sí' else 'No'

  /** @override */
  render: ->
    Customs.pending.dispatches (dispatches) !~>
      @el.html "
        <table class='#{gz.Css \table}
                    \ #{gz.Css \table-hover}
                    \ #{gz.Css \table-responsive}'>
          <thead>
            <tr>
              <th colspan='3' style='border-bottom:none'>&nbsp;</th>
              <th colspan='2' style='border-bottom:none'>Señales Alerta</th>
              <th colspan='2' style='border-bottom:none'>Numeración DAM</th>
            </tr>

            <tr style='border:none'>
              <th style='border-top:none'>\#Orden</th>
              <th style='border-top:none'>Cliente</th>
              <th style='border-top:none'>RUC/DNI</th>

              <th style='border-top:none'>Anexo 1</th>
              <th style='border-top:none'>Revisado</th>

              <th style='border-top:none'>Aforo</th>
              <th style='border-top:none'>¿Numerado?</th>
            </tr>
          </thead>
          <tbody>
          </tbody>
        </table>"

      xtbody = @el.query \tbody

      for dispatch in dispatches
        xtr = App.dom.newel \tr
          ..Class = gz.Css \parent-toggle
        xtr.html "
          <td>#{dispatch.'order'}</td>
          <td>#{dispatch.'customer'.'name'}</td>
          <td>#{dispatch.'customer'.'document'.'number'}</td>

          <td>#{[..\code for dispatch.'alerts'].join ', '}</td>
          <td>#{@verified dispatch}</td>

          <td>#{@numeration dispatch}</td>
          <td>#{@isnumerated dispatch}</td>

          <td class='#{gz.Css \toggle}'>#{@dropdown!}</td>"
        xtbody._append xtr
    super!

  @@_caption = 'Despachos'
  @@_icon    = gz.Css \glyphicon-list

module.exports = Dispatches
