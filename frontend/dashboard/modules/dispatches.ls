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
              <th>\#Orden</th>
              <th>Cliente</th>
              <th>&nbsp;</th>
            </tr>
          </thead>
          <tbody>
          </tbody>
        </table>"

      xtbody = @el.query \tbody

      for dispatch in dispatches
        xtr = App.dom.newel \tr
        xtr.html "
          <tr>
            <td>#{dispatch.'order'}</td>
            <td>#{dispatch.'customer'.'name'}</td>
            <td>
              <button type='button' class='#{gz.Css \btn}
                                         \ #{gz.Css \btn-default}
                                         \ #{gz.Css \pull-right}'>
                Opciones
              </button>
            </td>
          </tr>"
        xtbody._append xtr

    super!

  @@_caption = 'Despachos'
  @@_icon    = gz.Css \glyphicon-list
