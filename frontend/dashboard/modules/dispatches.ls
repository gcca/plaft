/** @module dashboard.modules.dispatches */

Module = require '../module'

# App model local
Customs = App.model.Customs


/** ----------
 *  Dispatches
 *  ----------
 * Dispatch list to show status resume.
 * TODO(...): Base class to create tables. Tables: dynamic ordering by column.
 * @class UiDispatches
 * @extends Module
 */
class Dispatches extends Module

  /**
   * Dispatch type color cell.
   * @param {Dispatch} dispatch
   * @return {string}
   * @private
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

  /**
   * Is "numerated" dispatch?.
   * @param {Dispatch} dispatch
   * @return {string}
   * @private
   */
  isnumerated: (dispatch) ->
    if dispatch.'numeration'
      and dispatch.'numeration'.'number'
      and dispatch.'numeration'.'number' isnt ''
    then 'Sí'
    else 'No'

  /**
   * Options per dispatch.
   * TODO(...): Close dispatch. Get CalcPage unusual and register.
   * @param {Object} dispatch
   * @return {string}
   * @private
   */
  dropdown: (dispatch) -> "
    <div class='#{gz.Css \dropdown} #{gz.Css \pull-right}'>
      <a role='button' data-toggle='dropdown'>
        <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-bookmark}'></i>
        <span class='#{gz.Css \caret}'></span>
      </a>
      <ul class='#{gz.Css \dropdown-menu}' role='menu'>
        <li>
          <a>Reporte RO</a>
        </li>
        <li>
          <a>Reporte Inusual</a>
        </li>
        <li>
          <a>Concluir</a>
        </li>
      </ul>
    </div>"

  /**
   * (Event) On click to report operation register.
   * @param {Object} dispatch DTO.
   * @param {Object} evt
   * @private
   */
  options-report-register: (dispatch, evt) ~~>
    console.log 'Not-Implemented'

  /**
   * Is verified dispatch? Based on {@code alert.verifies} attribute.
   * @param {Dispatch} dispatch
   * @return {string}
   * @private
   */
  verified: (dispatch) ->
    verifies = dispatch\verifies
    if verifies._length and _._all verifies then 'Sí' else 'No'

  /**
   * Ensure dispatch data consistence.
   * @param {Dispatch} dispatch
   * @private
   */
  ensure: (dispatch) ->
    if not dispatch.'customer'?
      dispatch.'customer' =
        \name     : 'ERROR'
        \document :
          \number : 'ERROR'

  /** @override */
  render: ->
    Customs.pending.dispatches (dispatches) !~>
      @el.html "
        <table class='#{gz.Css \table}
                    \ #{gz.Css \table-hover}
                    \ #{gz.Css \table-responsive}'>
          <thead>
            <tr>
              <th colspan='4' style='border-bottom:none'>&nbsp;</th>
              <th colspan='2' style='border-bottom:none'>Señales Alerta</th>
              <th colspan='2' style='border-bottom:none'>Numeración DAM</th>
            </tr>

            <tr style='border:none'>
              <th style='border-top:none'>\#Orden</th>
              <th style='border-top:none'>Cliente</th>
              <th style='border-top:none'>RUC/DNI</th>
              <th style='border-top:none'>Fecha</th>

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
        @ensure dispatch

        xtr = App.dom.newel \tr
          ..Class = gz.Css \parent-toggle
        xtr.html "
          <td>#{dispatch.'order'}</td>
          <td>#{dispatch.'customer'.'name'}</td>
          <td>#{dispatch.'customer'.'document'.'number'}</td>
          <td>#{dispatch.'created'}</td>

          <td>#{[..\code for dispatch.'alerts'].join ', '}</td>
          <td>#{@verified dispatch}</td>

          <td>#{@numeration dispatch}</td>
          <td>#{@isnumerated dispatch}</td>

          <td class='#{gz.Css \toggle}'>#{@dropdown dispatch}</td>"

        # Options events
        ## op = xtr._last._first._last._first
        ## op.onClick @options-report-register dispatch

        $ xtr._last._first._first .dropdown!

        xtbody._append xtr


      # Options for operation register
      # ------------------------------
      # TODO(...): Create widget bar or something similar for option views.

      # * Operation Register options
      # TODO(...): Create widget for separated button and combobox
      #   for filters by year-month.
      xOpciones = App.dom._new \div
        ..Class = gz.Css \col-md-12
        ..css._padding-left = '0'
        ..html "<button class='#{gz.Css \btn} #{gz.Css \btn-default}'>
                  Exportar RO
                </button>"

      xOpciones._first.onClick ->
        document.location = "#{App.Model.API}dispatch/report/register"

      @el._append xOpciones

    super!

  /** @protected */ @@_caption = 'Despachos'
  /** @protected */ @@_icon    = gz.Css \glyphicon-list


/** @export */
module.exports = Dispatches
