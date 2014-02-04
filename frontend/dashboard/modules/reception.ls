Module = require '../module'


module.exports = \

class Reception extends Module

  render: ->
    @$el.html "
      <form class='#{gz.Css \row}'>
        <div class='#{gz.Css \form-group}
                  \ #{gz.Css \col-lg-6}
                  \ #{gz.Css \col-md-6}'>
          <label>Número de orden</label>
          <input class='#{gz.Css \form-control}' name='trackingId'>
        </div>

        <div class='#{gz.Css \form-group}
                  \ #{gz.Css \col-lg-6}
                  \ #{gz.Css \col-md-6}'>
          <label>Tipo de operación</label>
          <select class='#{gz.Css \form-control}' name='operationType'>
            <option>Importación</option>
            <option>Exportación</option>
          </select>
        </div>

        <div class='#{gz.Css \form-group}
                  \ #{gz.Css \col-lg-6}
                  \ #{gz.Css \col-md-6}'>
          <label>Régimen aduanero</label>
          <input class='#{gz.Css \form-control}' name='regime'>
        </div>

        <div class='#{gz.Css \form-group}
                  \ #{gz.Css \col-lg-6}
                  \ #{gz.Css \col-md-6}'>
          <label>Código de declaración</label>
          <input class='#{gz.Css \form-control}' name='declarationTrackingId'>
        </div>

        <div class='#{gz.Css \form-group}
                  \ #{gz.Css \col-md-12}'>
          <button type='button'
              class='#{gz.Css \btn}
                   \ #{gz.Css \btn-primary}
                   \ #{gz.Css \pull-right}'>
            Guardar
          </button>
        </div>
      </form>"
    super!

  @@_caption = 'Recepción'
  @@_icon    = gz.Css \glyphicon-inbox
