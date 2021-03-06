/** @module dashboard.modules.alerts.picker */


/**
 * @class UiControl
 * @extends View
 */
class Control extends App.View

  /** @override */
  _tagName: \form

  /** @override */
  _className: gz.Css \row

  /**
   * (Event) Remove panel control.
   * @private
   */
  onRemove: ~>
    @_alert._showItem!
    @free!
    @_remove!

  /**
   * (Event) Show/Hide textarea for comment for correct alert.
   * @param {Object} evt
   * @private
   */
  onToggleCorrect: (evt) ~>
    _isChecked = evt._target._checked
    if _isChecked
      @xcorrect.Class._remove gz.Css \hidden
    else
      @xcorrect.Class._add gz.Css \hidden

  /** @override */
  initialize: (@_alert) !->

  /** @private */ xcorrect : null
  /** @private */ _alert   : null

  /** @override */
  render: ->
    @el.html "
      <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
        <div class='#{gz.Css \form-group} #{gz.Css \col-md-11}'
            style='text-align:justify'>
          <span class='#{gz.Css \pull-left}'
              style='font-size:24px;margin-right:.5em'>
            #{@_alert\code}
          </span>

          #{@_alert\text}
        </div>

        <div class='#{gz.Css \form-group} #{gz.Css \col-md-1}'
            style='padding:0'>
          <button type='button' class='#{gz.Css \close}'
              style='font-size:38px;
                     margin:-10px 0;'>
            &times;
          </button>
        </div>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
        <label>Comentario</label>
        <textarea class='#{gz.Css \form-control}' name='comment'></textarea>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-4}'>
        <label>Fuente de la señal de alerta</label>
        <select class='#{gz.Css \form-control}' name='source'>
          <option>(1) Sistema de Monitoreo</option>
          <option>(2) Area Comercial</option>
          <option>(3) Análisis del SO</option>
          <option>(4) Medio Periodístico</option>
          <option>(5) Otras fuentes</option>
        </select>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-8}'>
        <label>En caso en el item 46 se haya consignado
               \ la opción 5 describir la fuente</label>
        <input type='text' class='#{gz.Css \form-control}' name='other'>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
        <label class='#{gz.Css \checkbox}'>
          ¿Subsanado?
          &nbsp;
          <input id='#{gz.Css \id-1}' type='checkbox' name='iscorrect'>
        </label>

        <textarea id='#{gz.Css \id-2}'
            class='#{gz.Css \form-control} #{gz.Css \hidden}'
            name='correct'
            placeholder='Comentario'></textarea>
      </div>

      <div class='#{gz.Css \form-group} #{gz.Css \col-md-12}'>
        <hr style='margin:10px 0 -5px'>
      </div>

      <input type='hidden' name='code'>
      <input type='hidden' name='text'>"
    @xcorrect = @el.query "##{gz.Css \id-2}"
    @el.query "##{gz.Css \id-1}" .onChange @onToggleCorrect
    @el.query \button .onClick @onRemove
    @$el._fromJSON @_alert
    @xcorrect.Class._remove (gz.Css \hidden) if @_alert\iscorrect
    super!


/**
 * @class UiPanel
 * @extends View
 */
class Panel extends App.View

  /** @override */
  _tagName: \div

  /** @override */
  _className: gz.Css \col-md-12

  /** @override */
  _toJSON: -> [$ .. ._toJSON! for (@el.queryAll \form) || App._void._Array]

  /**
   * Add new control.
   * @param {Object} _alert {@code {_code, _text, _tip}}.
   */
  addControl: (_alert) ~> @el._append (Control.New _alert).render!.el

  /** @override */
  initialize: (@_alerts = App._void._Array) ->

  /** @private */ _alerts: null

  /** @override */
  render: ->
    for _alert in @_alerts then @addControl _alert
    super!

module.exports = Panel
