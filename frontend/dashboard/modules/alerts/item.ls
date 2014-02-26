  ## xContainer: null


    ## @xContainer = App.dom.newel \div

    ## xButton = App.dom.newel \button
    ##   ..Class = "#{gz.Css \btn} #{gz.Css \btn-default}"

    ##   ..html "Agregar
    ##    \ <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-plus}'></i>"

    ##   ..onClick @onClickButton

    ## @el._append @xContainer
    ## @el._append xButton

  ## onClickButton: ~>
  ##   @addItem!


  ## addItem: !-> @xContainer._append (new Item).render!.el

ITEMS = require './items'

selectAlerts = ->
  "<select class='#{gz.Css \form-control}'>
    #{["<option>#{..}</option>" for ITEMS].join ''}</select>"


class Item extends App.View

  /** @override */
  _tagName: \form

  /** @override */
  _className: gz.Css \row

  # Events
  onChangeSource: (evt) ~>
    xSelect = evt._target
    if xSelect._selected is (xSelect._length - 1)
      @$controlOther._show!
    else
      @$controlOther._hide!

  /** @override */
  render: ->
    @$el.html "
      <div class='#{gz.Css \form-group} #{gz.Css \col-md-10}'>
        <label>Alerta</label>
        #{selectAlerts!}
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-2}'>
        <label>Código</label>
        <input type='text' class='#{gz.Css \form-control}'>
      </div>"

    $controlSource = $ "
      <div class='#{gz.Css \form-group} #{gz.Css \col-md-4}'>
        <label>Fuente de la señal de alerta</label>
      </div>"

    $selectSource = $ "
      <select class='#{gz.Css \form-control}'>
        <option>(1) Sistema de Monitoreo</option>
        <option>(2) Area Comercial</option>
        <option>(3) Análisis del SO</option>
        <option>(4) Medio Periodístico</option>
        <option>(5) Otras fuentes</option>
      </select>"
    $controlSource._append $selectSource
    $selectSource.on \change @onChangeSource

    @$controlOther = $ "
      <div class='#{gz.Css \form-group} #{gz.Css \col-md-8}'>
        <label>En caso en el item 46 se haya consignado
               \ la opción 5 describir la fuente</label>
        <input type='text' class='#{gz.Css \form-control}'>
      </div>"
    @$controlOther.hide!

    @$el._append $controlSource
    @$el._append @$controlOther

    @$el._append "
      <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
        <hr style='margin: -5px 0 -10px;'>
      </div>"
    super!

  ## Attributes
  $controlOther: null
