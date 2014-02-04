Module = require '../module'


module.exports = \

class Dispatches extends Module

  render: ->
    @$el.html "
      <table class='#{gz.Css \table}
                  \ #{gz.Css \table-striped}
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
          <tr>
            <td>2014-1256</td>
            <td>Scharff</td>
            <td>
              <button type='button' class='#{gz.Css \btn}
                                         \ #{gz.Css \btn-default}
                                         \ #{gz.Css \pull-right}'>
                Opciones
              </button>
            </td>
          </tr>
          <tr>
            <td>2013-456</td>
            <td>Loro Inc.</td>
            <td>
              <button type='button' class='#{gz.Css \btn}
                                         \ #{gz.Css \btn-default}
                                         \ #{gz.Css \pull-right}'>
                Opciones
              </button>
            </td>
          </tr>
          <tr>
            <td>2014-566</td>
            <td>La Mar</td>
            <td>
              <button type='button' class='#{gz.Css \btn}
                                         \ #{gz.Css \btn-default}
                                         \ #{gz.Css \pull-right}'>
                Opciones
              </button>
            </td>
          </tr>
        </tbody>
      </table>"
    super!

  @@_caption = 'Despachos'
  @@_icon    = gz.Css \glyphicon-list
