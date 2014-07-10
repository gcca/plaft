/** @module dashboard.module */


/** -----
 *  Table
 *  -----
 * @class UiTable
 * @extends View
 */
class Table extends App.View

  /** @override */
  _tagName: \table

  /** @override */
  _className: "#{gz.Css \table}
             \ #{gz.Css \table-hover}
             \ #{gz.Css \table-responsive}"

  /**
   * Header.
   * @param {Array.<string>}
   * @protected
   */
  _header: -> ''

  /**
   * Add new row.
   * @public
   */
  addRow: (_cells) ->
    _tr = App.dom._new \tr
    for _cell in _cells
      _td = App.dom._new \td
        ..html ''
      _tr.append _td
    _tr

  /**
   * (Event) On row double click.
   * @param {Object} evt
   * @private
   */
  onRowDoubleClicked: (evt) ~> @itemDoubleClicked evt._target._item

  /**
   * Event on row double click. Use in derived classes.
   * @parma {Model} _item
   * @protected
   */
  itemDoubleClicked: (_item) ->

  /**
   * Fetch row callback for building table.
   * @param {Object} _item
   * @protected
   */
  fetch-row: (_item) ->

  /**
   * Customize row thead.
   * TODO(...): Currently only support for 2 rows.
   * @param {HTMLElement}
   * @private
   */
  customizeThead: (_thead) ->
    if _thead.childElementCount is 2
      _th = _thead._first._first
      while _th?
        _th.css.\borderBottom = 'none'
        ## _th.css.\textAlign = 'center' if _th.colSpan isnt 1
        _th = _th._next

      _th = _thead._last._first
      while _th?
        _th.css.\borderTop = 'none'
        _th = _th._next

  /** @override */
  initialize: (@options) -> super!

  /** @private */ options : null
  /** @private */ _tbody  : null

  /** @override */
  render: ->
    # tHead
    _thead = App.dom._new \thead
      ..html @_header!
    @customizeThead _thead
    @el._append _thead

    # tBody
    @_tbody = App.dom._new \tbody

    for _item in @options._collection
      _tr = App.dom._new \tr
      _tr._item = _item
      _cells = @fetch-row _item
      for _text in _cells
        _td = App.dom._new \td
          ..html if _text? then _text else '&nbsp;'
        _tr._append _td
      _tr.onDblClick @onRowDoubleClicked
      @_tbody._append _tr

    @el._append @_tbody

    super!


/** --------------
 *  TableSubmodule
 *  --------------
 * @class UiTableSubmodule
 * @extends UiTable
 */
class TableSubmodule extends Table

  /**
   * (Event) On double click on row to go a submodule.
   * @param {Object} _item Item DTO.
   * @override
   */
  itemDoubleClicked: (_item) ->
    _view = @options._view
    _view.ui.desktop.push-sub @View, dto : _item

  /** @protected */ View: null

/** @export */
exports <<<
  Table          : Table
  TableSubmodule : TableSubmodule


# vim: ts=2 sw=2 sts=2 et:
