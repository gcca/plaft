/** @module customer.base */


/**
 * @class UiPDFMOdal
 * @extends Modal
 */
class PDFModal extends App.widget.Modal

  /** @override */
  render: ->
    header-title = App.widget.Modal._title 'Declaración Jurada'

    button-left = App.dom._new \a
      ..Class = "#{gz.Css \btn} #{gz.Css \btn-default} #{gz.Css \pull-left}"
      ..'dataset'\dismiss = 'modal'
      ..html "<button type='button' class='#{gz.Css \close}'>
                &times;
              </button>"

    button-right = App.dom._new \a
      ..Class   = "#{gz.Css \btn} #{gz.Css \btn-primary} #{gz.Css \pull-right}"
      ..href    = "/declaration/#{@declarationId}/pdf"
      .._target = '_blank'
      ..html 'Imprimir'

    _left = App.dom._new \div
      ..Class = gz.Css \col-md-3
      .._append button-left

    _center = App.dom._new \div
      ..Class = gz.Css \col-md-6
      .._append header-title

    _right = App.dom._new \div
      ..Class = gz.Css \col-md-3
      .._append button-right

    _row = App.dom._new \div
      ..Class = gz.Css \col-md-12
      .._append _left
      .._append _center
      .._append _right

    @m_header.Class._add gz.Css \row
    @m_header._append _row
    App.dom._write ~>
      _center.css
        .._text-align  = 'center'
        .._padding-top = '4px'

      _left.css._padding-left = '0'
      _right.css._padding-right = '0'

      _row.css
        .._padding-left  = '0'
        .._padding-right = '0'

      @m_header.css
        .._margin-left    = '0'
        .._margin-right   = '0'
        .._padding-bottom = '4px'
        .._padding-top    = '6px'

    App.dom._write ~> @m_body.css._padding = '0'

    isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0
    isFirefox = typeof InstallTrigger isnt \undefined
    isChrome = !!window.chrome && !isOpera;

    declarationUrl = "/declaration/#{@declarationId}/pdf"
    if not (isFirefox or isChrome)
      declarationUrl = "/static/pdfjs/web/viewer.html?file=#declarationUrl"
    @m_body.html "<iframe src='#declarationUrl'
                          style='border:none;width:100%;height:80%'></iframe>"

    @_show!
    super!

  /** @override */
  initialize: ({@declarationId = 'No existe'}) ->
    super do
      _type  : App.widget.Modal.Type.kLarge
      _modal : \backdrop : \static

  /** @private */ declarationId: null


/** @export */
module.exports = PDFModal


# vim: ts=2 sw=2 sts=2 et:
