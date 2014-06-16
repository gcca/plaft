class Anex5 extends App.View

  /**
   * (Event) Get focus to search. Use global search tool.
   * @private
   */
  search-focus: ~> @ui-search._focus!

  /**
   * Search customer by document number.
   * @param {string} _query
   * @public
   */
  _search: (_query) ->
    @customer = new App.model.Customer \document : \number : _query
    @customer.fetch do
      _success: (customer) ->

      _error: -> alert 'ERROR ... --'

  /**
   * Show customer form by type of customer: business or person.
   * @param {Customer} customer
   * @private
   */
  show-form: (@customer) ->
    formClass = if @customer.isBusiness?
                 th
    @customer

  /** @override */
  initialize: ({@ui-search}) !->
    /**
     * Current customer for dispatch.
     * @type {Model}
     * @private
     */
    @customer = null

  /** @private */ ui-search : null
  /** @private */ customer  : null

  /** @override */
  render: ->
    @el.html "
      <button type='button'
              class='#{gz.Css \btn}
                   \ #{gz.Css \btn-info}'>
        <span class='#{gz.Css \glyphicon}
                   \ #{gz.Css \glyphicon-search}'></span> Buscar
      </button>"
    @el._first.onClick @search-focus
    super!


/** @export */
module.exports = Anex5
