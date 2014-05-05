/**
 * @class UiModal
 * @extends View
 */
class Modal extends App.View

  /** @override */
  _tagName: \div

  /** @override */
  _className: "#{gz.Css \modal} #{gz.Css \fade}"

  /**
   * Show modal. Use after assemble the modal.
   * @public
   */
  _show: !-> @$el.modal @_options._modal

  /**
   * Set basic header with title and close button.
   * @protected
   */
  basicHeader: !->
    @m_header._append @@_title @m_title
    $ @m_header ._append "<button type='button'
                                  class='close'
                                  data-dismiss='modal'>
                            &times;
                          </button>"

  /**
   * @param {Object} _options {_type, _modal}
   * @override
   */
  initialize: (@_options = App._void._Object) !->
    @m_dialog = App.dom._new \div
      ..Class = gz.Css \modal-dialog
    @m_dialog.Class._add @_options._type if @_options._type?

    @m_content = App.dom._new \div
      ..Class = gz.Css \modal-content

    @m_header = App.dom._new \div
      ..Class = gz.Css \modal-header

    @m_body = App.dom._new \div
      ..Class = gz.Css \modal-body

    @m_content
      .._append @m_header
      .._append @m_body
    @m_dialog._append @m_content
    @inner @m_dialog

  /** @protected */ m_header : null
  /** @protected */ m_body   : null
  /** @protected */ m_footer : null

  /** @private */ m_dialog  : null
  /** @private */ m_content : null
  /** @private */ _options  : null

  /**
   * Create header title.
   * @param {string} _title
   * @return {HTMLElement}
   * @public
   */
  @@_title = (_title) ->
    App.dom._new \h4
      ..Class = gz.Css \modal-title
      ..css._display = \inline
      ..html _title

  /**
   * Modal type.
   * @type {Enum}
   * @public
   */
  @@Type =
    kLarge : gz.Css \modal-lg
    kSmall : gz.Css \modal-sm


/** @export */
exports <<<
  Modal : Modal
