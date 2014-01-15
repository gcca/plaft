/** @module dashboard.module.dispacthes.evaluation */


/**
 * Manage group fields for alert report.
 * @class AlertView
 * @private
 */
class AlertView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \form

  /**
   * Style.
   * @type {string}
   * @private
   */
  className: "#{gz.Css \ink-form} #{gz.Css \parent-toggle}"

  /**
   * Form to JSON.
   * @return {Object}
   * @public
   */
  JSONFields: -> @$el.serializeJSON!

  /**
   * Render view.
   * @return {Object}
   * @override
   * @public
   */
  render: ->
    tFieldset = "<fieldset class='#{gz.Css \column-group}
                                \ #{gz.Css \gutters}'>"

    tLabel = "<label>"

    tControl = "<div class='#{gz.Css \control}'>"

    @$el.html "
      <hr class='#{gz.Css \large-95}
               \ #{gz.Css \medium-95}
               \ #{gz.Css \small-90}
               \ #{gz.Css \push-left}'
          style='margin:1em 0'>

      <span class='#{gz.Css \icon-remove}
                 \ #{gz.Css \icon-2x}
                 \ #{gz.Css \push-right}
                 \ #{gz.Css \toggle}'></span>


      <div class='#{gz.Css \large-100}
                \ #{gz.Css \medium-100}
                \ #{gz.Css \small-100}'

          style='margin-top:-1em;
                 margin-bottom:-1.5em'>

        #tFieldset

          <div class='#{gz.Css \control-group}
                    \ #{gz.Css \large-30}
                    \ #{gz.Css \medium-30}
                    \ #{gz.Css \small-100}'>
            #tLabel
              <b>44</b> Código de la señal de alerta
            </label>
            #tControl
              <input type='text' name='c44'>
            </div>
          </div>

          <div class='#{gz.Css \control-group}
                    \ #{gz.Css \large-70}
                    \ #{gz.Css \medium-70}
                    \ #{gz.Css \small-100}'>
            #tLabel
              <b>45</b> Descripción de la señal de alerta
            </label>
            #tControl
              <input type='text' name='c45'>
            </div>
          </div>

        </fieldset>


        #tFieldset

          <div class='#{gz.Css \control-group}
                    \ #{gz.Css \large-30}
                    \ #{gz.Css \medium-30}
                    \ #{gz.Css \small-100}'>
            #tLabel
              <b>46</b> Fuente de la señal de alerta
            </label>
            #tControl
              <select name='c46'>
                <option>(1) Sistema de Monitoreo</option>
                <option>(2) Area Comercial</option>
                <option>(3) Análisis del SO</option>
                <option>(4) Medio Periodístico</option>
                <option>(5) Otras fuentes</option>
              </select>
            </div>
          </div>

          <div class='#{gz.Css \control-group}
                    \ #{gz.Css \large-70}
                    \ #{gz.Css \medium-70}
                    \ #{gz.Css \small-100}'>
            #tLabel
              <b>47</b> Describir la fuente de señal alerta
            </label>
            #tControl
              <input type='text' name='c47'>
            </div>
          </div>

        </fieldset>

      </div>"

    # Field 47: Other alert signal source.
    $field47 = @$el.find '[name=c47]' .parents ".#{gz.Css \control-group}"
    $field47.hide!

    # Event: On other alert signal
    @$el.find '[name=c46]' .on \change !->
      if @value is '(5) Otras fuentes'
        $field47.show!
      else
        $field47.hide!

    super!


/**
 * Manage alert list.
 * @class AlertsView
 */
module.exports = class AlertsView extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \div

  events:
    'keyup input': (evt) -> @addAlertView! if evt.ctrlKey and evt.keyCode is 13

  /**
   * Form to JSON.
   * @return {Object}
   * @public
   */
  JSONFields: -> [..JSONFields! for @alertViews]

  /**
   * Create and append new alert view.
   * @private
   */
  addAlertView: !->
    alertView = new AlertView
    @$container.append alertView.render!.el
    alertView.$el.find \input .get 0 .focus!

  # Events
  onAddButtonClick: !~>
    @addAlertView!

  # View methods
  initialize: !->
    @alertViews = new Array

  render: ->
    @$el.html "
      <h4>SEÑALES DE ALERTA IDENTIFICADAS
          \ <small>(Se debe consignar estos datos por cada señal
          \ de alerta)</small></h4>

      <div></div>"

    # Add button
    $button = $ "<button type='button' class='#{gz.Css \ink-button}'>
                   Agregar <i class='#{gz.Css \icon}'></i>
                 </button>"
    $button.on \click @onAddButtonClick
    @$el.append $button

    # Alert view container
    @$container = @$el.find \div

    super!
