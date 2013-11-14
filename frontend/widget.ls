/**
 * @module widget
 */

/**
 * Modal window
 * @class Modal
 *
 * @example
 * >>> modal = new Modal '<h3>Header</h3>', '<p>body</p>'
 * >>> modal.show!
 */
class Modal extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \div

  /**
   * Style.
   * @type {string}
   * @private
   */
  className: "#{gz.Css \ink-shade} #{gz.Css \fade}"

  /**
   * Show modal.
   * @protected
   */
  elShow: !->
    if not @uiModal?
      document.body.appendChild @el
      @uiModal = new gz.Ink.UI.Modal @modal, do
        \onDismiss : !~>
          @$el.remove!
          @trigger gz.Css \dismiss
      if @mBody.constructor is String
        @body.innerHTML = @mBody
      else
        @body.appendChild @mBody

  /**
   * Hide modal.
   * @protected
   */
  elHide: !->
    @uiModal.'dismiss'! if @uiModal?

  /**
   * @param {String} mHeader
   * @param {String|HTMLElement} mBody
   * @param {(String|HTMLElement)=} mFooter
   * @constructor
   */
  !(@mHeader, @mBody, @mFooter = @mFooterBase) -> super!

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    modal  = gz.newel \div
    header = gz.newel \div
    body   = gz.newel \div
    footer = gz.newel \div

    @el.style.zIndex = '10000'
    modal.className  = gz.Css \ink-modal
    header.className = gz.Css \modal-header
    body.className   = gz.Css \modal-body
    footer.className = gz.Css \modal-footer

    header.innerHTML = "
      <button class='#{gz.Css \modal-close} #{gz.Css \ink-dismiss}'></button>
      <h5>#{@mHeader}</h5>"

    if @mFooter.constructor is String
      footer.innerHTML = @mFooter
    else
      footer.appendChild @mFooter

    modal.appendChild header
    modal.appendChild body
    modal.appendChild footer
    @el.appendChild modal
    @modal = modal
    @body = body

  /** @private */ modal : null
  /** @private */ body  : null
  /** @private */ mBody : null
  /** @private */ mFooterBase : "
    <div class='#{gz.Css \push-right}'>
      <button class='#{gz.Css \ink-button} #{gz.Css \blue}'>Aceptar</button>
      <button class='#{gz.Css \ink-button}
                   \ #{gz.Css \red}
                   \ #{gz.Css \ink-dismiss}'>
        Cerrar
      </button>
    </div>"
  /** @private */ uiModal : null

/**
 * Create stacking alerts with position fixed.
 * @class AutoAlert
 *
 * @example
 * >>> // Choose style with (gz.Css <type>)
 * >>> // parameter {@code type} can be {@code ('error'|'success'|'info')}.
 * >>> autoAlert = new AutoAlert (gz.Css \error),
 * ...                           '<b>ERROR:</b> Esto es un error'
 * >>> autorAlert.show!
 */
class AutoAlert extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \div

  /**
   * Style.
   * @type {string}
   * @private
   */
  className: gz.Css \ink-alert

  /**
   * View events.
   * @type {Object}
   * @private
   */
  events:
    /**
     * On click close.
     * @private
     */
    'click button': -> @elHide!

  /**
   * @private
   */
  @acc = 0

  /**
   * @private
   */
  @bacc = 4

  /**
   * @private
   */
  @nacc = 0

  /**
   * @param {string} type One: {@code .error}, {@code .success}, {@code .info}.
   * @param {string} message Text
   * @param {string=} block HTML content
   * @constructor
   */
  !(@type, @message, @block = void) -> super!

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @$el.on \mouseover ~> @el.style.opacity = 'initial'
    @$el.on \mouseleave ~> @el.style.opacity = '0.69' # \(ツ)/
    @el.classList.add if @block? then gz.Css \block else gz.Css \basic
    @el.classList.add @type
    @el.style
      ..position   = 'fixed'
      ..width      = '96%'
      ..marginLeft = '2%'
    @render!

  /**
   * Render view.
   */
  render: ->
    @el.innerHTML = "
     <button class='#{gz.Css \ink-dismiss}'>&times;</button>
     <p>#{@message}</p>"
    super!

  /**
   * Show.
   * @param {boolean=} autohide
   */
  elShow: !(autohide = on) ->
    @el.style.bottom = "#{@@bacc * @@acc + 1.4}em"
    @@acc++
    @@nacc++
    ## @@bacc = 3.6
    @el.style.opacity = '0'
    @$el.appendTo document.body
    @$el.animate \opacity : 1, 400, \ease-in
    setTimeout @elHide, 6900 if autohide # \(ツ)/

  /**
   * Hide.
   */
  elHide: !~>
    @@nacc--
    if @@nacc < 1
      @@acc = 0
      ## @@bacc = 3
    @$el.off!
    @$el.animate \opacity : 0, 700, \ease-out, ~> @$el.remove!

## /**
##  * @class AlertManager
##  */
## class AlertManager extends gz.GView

/**
 * Typeahead input.
 * @class Typeahead
 *
 * @example
 * TODO(...)
 */
class Typeahead extends gz.GView

  /**
   * DOM element.
   * @type {string}
   * @private
   */
  tagName: \input

  /**
   * Initialize view.
   * @private
   */
  initialize: !-> @render!

  /**
   * Render view.
   * @return {Object}
   */
  render: ->
    next = @$el.next!
    isNext = next.get 0
    next.remove! if isNext
    @$el.\typeahead do
      \prefetch : '/static/pos.json'
      \template : '
        <p style="float:right;font-style:italic;"><%= language %></p>
        <p style="font-weight:bold;"><%= name %></p>
        <p style="font-size:14px;text-align:justify"><%= description %></p>'
      \engine   :
        \compile : (t) ->
          cc = _.\template t
          \render : (ctx) -> cc ctx
    @$el.after next if isNext
    super!

/**
 * Public widgets.
 * @type {Object}
 */
exports <<<
  GModal     : Modal
  GAutoAlert : AutoAlert
  GTypeahead : Typeahead
