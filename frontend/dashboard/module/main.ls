/**
 * @module dashboard.module
 */

/** @private */
ModuleBaseView = require './base'

for eso_ in <[ pol2 coffee ]>
  gz.newel \script
    ..src = "/static/#{eso_}.js"
    document.head.appendChild ..

/**
 * Dashboard: main page
 * @class MainView
 * @extends ModuleBaseView
 */
module.exports = class MainView extends ModuleBaseView

  /**
   * Html element.
   * @private
   */
  tagName: \div

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @$el.html "
    <div id='chart'></div>
    <div id='chartLine'></div>
    "
    @desktop.once (gz.Css \on-appended), @gen

  /** @private */ @menuCaption = 'Principal'
  /** @private */ @menuIcon    = gz.Css \icon-dashboard
  /** @private */ @menuTitle   = 'Inicio'

  gen: ->
    WIDTH = $ '#chart' .width! * 0.85
    HEIGHT = WIDTH * 0.24
    ## WIDTH = 666
    ## HEIGHT = 190

    data = polyjs['data'] do
      'data': [
        'artefacto': 'Nivel 1'
        'porcentaje': 10
        'cumplido': 'Sí'
      ,
        'artefacto': 'Nivel 1'
        'porcentaje': 90
        'cumplido': 'No'
      ,
        'artefacto': 'Nivel 2'
        'porcentaje': 40
        'cumplido': 'Sí'
      ,
        'artefacto': 'Nivel 2'
        'porcentaje': 60
        'cumplido': 'No'
      ,
        'artefacto': 'Nivel 3'
        'porcentaje': 70
        'cumplido': 'Sí'
      ,
        'artefacto': 'Nivel 3'
        'porcentaje': 30
        'cumplido': 'No'
      ,
        'artefacto': 'Nivel 4'
        'porcentaje': 90
        'cumplido': 'Sí'
      ,
        'artefacto': 'Nivel 4'
        'porcentaje': 10
        'cumplido': 'No'
      ]
      'meta':
        'artefacto':
          'type': 'cat'

        'porcentaje':
          'type': 'num'

        'cumplido':
          'type': 'cat'

    polyjs['chart'] do
      'title': 'Proporción de avance'
      'dom': 'chart'
      'width': WIDTH
      'height': HEIGHT
      'layer':
        'data': data
        'type': 'bar'
        'y': 'porcentaje'
        'color': 'cumplido'

      'guides':
        'x':
          'position': 'none'
          'padding': 0

        'y':
          'position': 'none'

        'color':
          scale: (value) ->
            (if value is 'Sí' then '#5eb95e' else '#e1efe1')

      'coord':
        'type': 'polar'

      'facet':
        'type': 'wrap'
        'var': 'artefacto'
        'cols': 4
        'formatter': (index) ->
          index['artefacto']



    # -----------

    index = 0
    # subset of djData
    addToSubset = (numToAdd) ->

      # function to add more values to the subset
      while numToAdd > 0 and index < dataSize - 1
        subset['Fecha']['push'] window['djData']['Date'][index]
        subset['Nivel']['push'] window['djData']['Open'][index]
        index := index + 1
        numToAdd = numToAdd - 1
      subset

    subset =
      'Fecha': []
      'Nivel': []

    dataSize = window['djData']['Date']['length']
    addToSubset 10
    polyjsdata = polyjs['data'](subset)
    # =============== CHARTSPEC ===============
    spec =
      'title': 'Evolución de los indicadores'
      'layers': [
        'data': polyjsdata
        'type': 'line'
        'x': 'Fecha'
        'y': 'Nivel'
        'size':
          'const': 3
      ,
        'data': polyjsdata
        'type': 'point'
        'x': 'Fecha'
        'y': 'Nivel'
        'size':
          'const': 3
      ]
      'guide':
        'x':
          'numticks': 10

      'dom': 'chartLine'
      'width': WIDTH
      'height': HEIGHT + 120

    c = polyjs['chart'](spec)

    # =============== ANIM ===============
    addNewPoint = ->
      polyjsdata['update'] addToSubset(1)
      c['make'] spec
      setTimeout addNewPoint, 1500

    setTimeout addNewPoint, 1500
