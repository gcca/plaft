/** @module dashboard.module.declaration */

/**
 * @class InvoiceView
 * @private
 */
class InvoiceView extends gz.GView

  tagName: \form

  className: "#{gz.Css \ink-form} #{gz.Css \ink-form-new}
            \ #{gz.Css \column-group} #{gz.Css \gutters}"

  onClickRemove: !~>
    @invoiceViews.splice (@invoiceViews.indexOf @), 1
    @$el.remove!

  JSONFields: -> @$el.serializeJSON!

  initialize: !(vOptions) ->
    @invoiceViews = vOptions.invoiceViews

  /** @private */ invoicesView: null

  render: ->
    tControlGroup = "<div class='#{gz.Css \control-group}
                               \ #{gz.Css \large-100}
                               \ #{gz.Css \medium-100}
                               \ #{gz.Css \small-100}'>"

    tLabel = "<label class='#{gz.Css \large-45}
                          \ #{gz.Css \medium-100}
                          \ #{gz.Css \small-100}'>"

    tControl = "<div class='#{gz.Css \control}
                          \ #{gz.Css \large-55}
                          \ #{gz.Css \medium-100}
                          \ #{gz.Css \small-100}'>"

    tLabelRight = "<label class='#{gz.Css \large-40}
                               \ #{gz.Css \medium-100}
                               \ #{gz.Css \small-100}'>"

    tControlRight = "<div class='#{gz.Css \control}
                               \ #{gz.Css \large-60}
                               \ #{gz.Css \medium-100}
                               \ #{gz.Css \small-100}'>"

    @$el.html "
      <hr>
      <fieldset class='#{gz.Css \large-50}
                     \ #{gz.Css \medium-50}
                     \ #{gz.Css \small-100}' style='margin-bottom:0'>

        #tControlGroup
          #tLabel
            Factura N&ordm;
          </label>
          #tControl
            <input type='text' name='code'>
          </div>
        </div>

        #tControlGroup
          #tLabel
            Fecha de Factura
          </label>
          #tControl
            <input type='text' name='date'>
          </div>
        </div>

        #tControlGroup
          #tLabel
            Razón Social / Nombre
          </label>
          #tControl
            <input type='text' name='name'>
          </div>
        </div>

        #tControlGroup
          #tLabel
            Dirección
          </label>
          #tControl
            <input type='text' name='address'>
          </div>
        </div>

      </fieldset>


      <fieldset class='#{gz.Css \large-45}
                     \ #{gz.Css \medium-45}
                     \ #{gz.Css \small-100}' style='margin-bottom:0'>

        #tControlGroup
          #tLabelRight
            Ciudad
          </label>
          #tControlRight
            <input type='text' name='city'>
          </div>
        </div>

        #tControlGroup
          #tLabelRight
            País
          </label>
          #tControlRight
            <input type='text' name='country'>
          </div>
        </div>

        #tControlGroup
          #tLabelRight
            Importe
          </label>
          #tControlRight
            <input type='text' name='amount'>
          </div>
        </div>

        #tControlGroup
          #tLabelRight
            Moneda
          </label>
          #tControlRight
            <input type='text' name='currency'>
          </div>
        </div>

      </fieldset>"
    tSpan = gz.newel \span
      ..className = "#{gz.Css \icon-remove}
                   \ #{gz.Css \icon-2x}
                   \ #{gz.Css \push-right}"
      ..onclick = @onClickRemove
      ..style.cursor = 'pointer'
    @$el.append tSpan
    super!


/**
 */
module.exports = class InvoicesView extends gz.GView

  tagName: \div

  className: "#{gz.Css \large-100}
            \ #{gz.Css \medium-100}
            \ #{gz.Css \small-100}"

  events:
    "click button##{gz.Css \id-add-invoice}": ->
      @addInvoice!

    "keyup input": (evt) !->
      evt.preventDefault!
      lKeyCode = evt.keyCode
      if lKeyCode is 13
        invoiceView = @addInvoice!
        invoiceView.$el.find \input .first! .focus!
      ## else if lKeyCode is 46
      ##   $tInput = $ evt.currentTarget
      ##   $tInput.parents \form .find \span .click!

  addInvoice: ->
    invoiceView = new InvoiceView invoiceViews: @invoiceViews
    @invoiceViews.push invoiceView
    @domInvoices.appendChild invoiceView.render!.el
    invoiceView

  JSONFields: -> [invoiceView.JSONFields! for invoiceView in @invoiceViews]

  initialize: ->
    @invoiceViews = new Array

  /** @private */ invoiceViews: null

  render: ->
    @$el.html "
      <div class='#{gz.Css \large-100}
                \ #{gz.Css \medium-100}
                \ #{gz.Css \small-100}'></div>

      <button id='#{gz.Css \id-add-invoice}'
          type='button' class='#{gz.Css \ink-button}'>
        Agregar <i class='#{gz.Css \icon-plus}'></i>
      </button>"
    @domInvoices = @el.firstElementChild
    super!
