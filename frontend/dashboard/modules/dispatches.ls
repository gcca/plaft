Module = require '../module'

Customs = App.model.Customs


module.exports = \

class Dispatches extends Module

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
            </tr>

            <tr style='border:none'>
              <th style='border-top:none'>\#Orden Despacho</th>
              <th style='border-top:none'>Nombre/Razón Social</th>
              <th style='border-top:none'>RUC/DNI</th>
              <th style='border-top:none'>Anexo 1</th>
              <th style='border-top:none'>Revisado</th>
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
          <td>#{if _._all dispatch.'verifies' then 'Sí' else 'No'}</td>
          <td class='#{gz.Css \toggle}'>
            <button type='button' class='#{gz.Css \btn}
                                       \ #{gz.Css \btn-default}
                                       \ #{gz.Css \pull-right}'>
              <i class='#{gz.Css \glyphicon}
                      \ #{gz.Css \glyphicon-circle-arrow-down}'></i>
            </button>
          </td>"
        xtbody._append xtr

    super!

  @@_caption = 'Despachos'
  @@_icon    = gz.Css \glyphicon-list
