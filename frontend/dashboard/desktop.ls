module.exports = \

class Desktop extends App.View

  _tagName: \div

  _className: gz.Css \row

  changeModule: (module) !~>
    @$el._children!.last!.remove!
    @$el._append (@newCustom module).render!.el

  newCustom: (module) ->
    new module
      ..el.Class = gz.Css \col-md-12

  render: ->
    @$el.html "
      <ol class='#{gz.Css \breadcrumb} #{gz.Css \col-md-8}'>
        <li>
          <a href='#'>Despachos</a>
        </li>
        <li>
          <a href='#'>Edición</a>
        </li>
        <li class='active'>
          Alertas
        </li>
      </ol>

      <form class='#{gz.Css \form-inline} #{gz.Css \col-md-4}' role='form'>
        <div class='#{gz.Css \input-group}'>
          <input type='text' class='#{gz.Css \form-control}'>
          <span class='#{gz.Css \input-group-btn}'>
            <button class='#{gz.Css \btn}
                         \ #{gz.Css \btn-default}' type='button'>
              &nbsp;
              <i class='#{gz.Css \glyphicon}
                      \ #{gz.Css \glyphicon-search}'></i>
            </button>
          </span>
        </div>
      </form>

      <div class='#{gz.Css \hidden}'></div>"
    super!
