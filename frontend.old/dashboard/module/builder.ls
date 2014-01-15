/**
 * @module dashboard.module.builder
 */

ModuleBaseView = require './base'

/**
 * Builder table on desktop.
 * @class Builder Table
 * @extends ModuleBaseView
 */
class Table extends ModuleBaseView

  /**
   * Set table on div.
   * @return {Object}
   */
  showTable: !->
    @el.appendChild @table
    @el.appendChild @nav
    new gz.Ink.UI.Table @table

  /**
   * Add row list.
   * @param {Array.<Object>} Rows.
   */
  populateTable: !(rows) ->
    for row in rows
      @addRow row, table

  /**
   * Add a row.
   * @param {Array.<String|HTMLElement>} row Elements array for row table.
   */
  addRow: !(row) ->
    tr = gz.newel \tr
    for column in row
      column ||= ''
      td = gz.newel \td
      # (-o-) Only use DOM Elements
      if column.constructor is Object
        td.appendChild column
      else
        td.innerHTML = column
      tr.appendChild td
    td.className = gz.Css \content-right if @endright
    @tbody.appendChild tr

  /**
   * Create table base.
   * @param {Array.<string>} fields Headers table.
   */
  createTable: !(fields) ->
    table = gz.newel \table
    thead = gz.newel \thead
    tbody = gz.newel \tbody

    table.className = "#{gz.Css \ink-table} #{gz.Css \hover}
                     \ #{gz.Css \gz-options-toggleable}"
    table.dataset[\pageSize] = \6

    tr = gz.newel \tr
    for field in fields
      th = gz.newel \th
      th.innerHTML = field
      th.className = gz.Css \content-left
      #th.dataset[\sortable] = \true
      #th.width = '33%'
      tr.appendChild th
    @endright = true if field is '&nbsp;'
    thead.appendChild tr

    table.appendChild thead
    table.appendChild tbody

    nav = gz.newel \nav
    ul  = gz.newel \ul
    nav.className = gz.Css \ink-navigation
    ul.className = "#{gz.Css \pagination}
                  \ #{gz.Css \rounded}
                  \ #{gz.Css \shadowed}
                  \ #{gz.Css \blue}"

    nav.appendChild ul
    @tbody = tbody
    @nav   = nav
    @table = table

  /** @private */ tbody    : null
  /** @private */ nav      : null
  /** @private */ table    : null
  /** @private */ endright : null

/**
 * Public builders.
 * @type {Object}
 */
module.exports <<<
  Table: Table
