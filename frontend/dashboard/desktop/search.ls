/** @module dashboard.desktop */

/**
 * Void function.
 * @see UiSearch#internalOnSearch
 */
VOID-FN = ->


/**
 * Global search widget for current module on desktop.
 * Manage search events: find by query string and get focus.
 *
 * @class UiSearch
 * @extends View
 */
class Search extends App.View

  /** @override */
  _tagName: \form

  /** @override */
  _className: "#{gz.Css \form-inline} #{gz.Css \col-md-4}"

  /**
   * (Event) Call {@code #internalOnSearch}.
   * Send "query" to {@ #internalOnSearch}.
   * @param {Object} evt
   */
  onSearch: (evt) !~>
    evt.prevent!
    @internalOnSearch evt._target._elements.0._value

  /**
   * On search event from module.
   * @type {function(string)}
   */
  internalOnSearch: VOID-FN

  /**
   * Set {@code #internalOnSearch}.
   * @param {Function} callOnSearch
   */
  setOnSearch: (callOnSearch) !->
    @internalOnSearch = if callOnSearch? then callOnSearch else VOID-FN

  /**
   * Get focus for xinput search.
   */
  _focus: !-> @_xinput._focus!

  /** @override */
  initialize: !->
    @$el.attr 'role' 'form'
    @el.onSubmit @onSearch
    @internalOnSearch = VOID-FN

  /** @private */ _xinput: null

  /** @override */
  render: ->
    @el.html "
      <div class='#{gz.Css \input-group}'>
        <input type='text' class='#{gz.Css \form-control}'
            placeholder='Buscar'>
        <span class='#{gz.Css \input-group-btn}'>
          <button class='#{gz.Css \btn} #{gz.Css \btn-default}'>
            &nbsp;
            <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-search}'></i>
            &nbsp;
          </button>
          <button type='button'
              class='#{gz.Css \btn}
                   \ #{gz.Css \btn-default}
                   \ #{gz.Css \dropdown-toggle}'
              data-toggle='dropdown' tabindex='-1'>
            &nbsp;
            <span class='#{gz.Css \caret}'></span>
            <span class='#{gz.Css \sr-only}'>gz</span>
            &nbsp;
          </button>
          <ul class='#{gz.Css \dropdown-menu} #{gz.Css \pull-right}'
              role='menu'>
            <li><a href=''>Nuevo</a></li>
            <li><a href=''>Eliminar</a></li>
            <li><a href=''>Otras opcines</a></li>
            <li class='#{gz.Css \divider}'></li>
            <li><a href='/signout'>Salir</a></li>
          </ul>
        </span>
      </div>"
    @_xinput = @el.query \input
    super!


/** @export */
module.exports = Search
