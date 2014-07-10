/** @module dashboard.modules.register */

Module = require '../module'

Anex5       = require './register/anex5'
Order       = require './register/order'
Stakeholder = require './register/stakeholder'


/** --------
 *  Register
 *  --------
 * Create and edit dispatch register. Further, is possible create a edit
 * declarations.
 * TODO(...): Currently create and update processes aren't integreated. This
 *   feature needs register module use the same attributes (customer, dispatch
 *   declaration) when search and save. Also the modules {@code UiAnex5} and
 *   {@code Order} will change. Remove {@code current-method} attribute and
 *   Enum {@code MethodType} for methods
 * @class UiRegister
 * @extends Module
 */
class Register extends Module

  /** @override */
  _id: gz.Css \id-accordion

  /** @override */
  _className: gz.Css \panel-group

  /** @override */
  free: ->
    @ui-declaration.free!
    @ui-dispatch.free!
    @ui-stakeholder.free!
    super!

  /**
   * (Event) On search by document number to create new dispatch or by order
   *   number to edit dispatch.
   * @param {string} _query
   * @protected
   */
  onSearch: (_query) ~>
    if /^\d+$/ is _query  # create
      if _query._length is 8 or _query._length is 11
        @customer = new App.model.Customer \document : \number : _query
        @customer.fetch do
          _success: (customer) ~>
            @current-method = @MethodType.kCreate
            @render-register customer
          _error: ~> @render-register @customer
      else
        alert '(Error) Número de identificación incorrecto: ' + _query

    else  # update
      @dispatch = new App.model.Dispatch \order : _query
      @dispatch.fetch do
        _success: (_, dto) ~>
          @current-method = @MethodType.kUpdate

          @declaration = new App.model.Declaration dto\declaration
          @customer    = new App.model.Customer dto'declaration'\customer

          @render-register @customer
          @render-query-pdf!
          @ui-declaration.ui-customer.$el._fromJSON dto\declaration
          @ui-dispatch.$el._fromJSON dto

        _error: ~> alert 'El despacho (' + _query + ') no existe'

  /**
   * Add button to show PDF declaration for current dispatch.
   * @private
   */
  render-query-pdf: ->
    $btn = $ "
      <button type='button'
          class='#{gz.Css \btn} #{gz.Css \btn-info} #{gz.Css \pull-right}'
          style='height:24px;margin:-4px 0;padding:2px 8px;font-size:12px'>
        PDF <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-bookmark}'></i>
      </button>"
    $btn.on \click ~> @ui-declaration.ui-customer.show-pdfmodal @declaration
    $ @el._first._first._first ._append $btn

  /**
   * (Event) On save data from declaration and dispatch views.
   * @param {Event} evt
   * @protected
   */
  onSave: (evt) ~>
    order-value = @ui-dispatch.el._elements'order'._value

    if order-value is ''
      alert 'Alerta: Número de orden incorrecto.'

    else
      [dtoCustomer, dtoDeclaration] = @ui-declaration.customer-declaration-dto!

      _s = ->
        alert 'Guardado.'

      _e = ->
        alert 'ERROR: No se pudo guardar el despacho.'

      dtoDispatch = @ui-dispatch.$el._toJSON!
      dtoDeclaration.\tracking = order-value
      dtoDeclaration.\customer = dtoCustomer

      dto =
        \declaration : dtoDeclaration
#        \customer    : dtoCustomer
        \dispatch    : dtoDispatch

      App.internals._post "/api/v1/dispatch/register", dto, _s

#      if @current-method is @MethodType.kCreate
#      then @onSaveTo = @onSaveToCreate
#      else if @current-method is @MethodType.kUpdate
#      then @onSaveTo = @onSaveToUpdate

#      if @onSaveTo?
#        @onSaveTo evt, order-value, dtoCustomer, dtoDeclaration
#      else
#        alert 'ERROR: a3bdc496-f7e3-11e3-9831-88252caeb7e8'

  /**
   * On save event to update declaration or dispatch.
   * @param {Event} evt
   * @param {string} order-value
   * @param {Object} dtoCustomer
   * @param {Object} dtoDeclaration
   * @private
   */
  onSaveToUpdate: (evt, order-value, dtoCustomer, dtoDeclaration) ->
    dtoDispatch = @ui-dispatch.$el._toJSON!

    dtoDeclaration <<<
      \customer : dtoCustomer
      \tracking : order-value

    @declaration.store dtoDeclaration, do
      _success: ~>
        @dispatch.store dtoDispatch, do
          _success: -> alert 'Guardado'
          _error: -> alert 'ERROR: b14db278-f7e9-11e3-bc7f-88252caeb7e8'
      _error: -> alert 'ERROR: b6877800-f7e9-11e3-bc7f-88252caeb7e8'

  /**
   * On save event to create new declaration and dispatch.
   * @param {Event} evt
   * @param {string} order-value
   * @param {Object} dtoCustomer
   * @param {Object} dtoDeclaration
   * @private
   */
  onSaveToCreate: (evt, order-value, dtoCustomer, dtoDeclaration) ->
    @customer._save dtoCustomer, do

      _success: (customer) ~>
        # Realtion data between {dispatch ~ declaration ~ customer}
        dtoDeclaration.tracking = order-value
        dtoDeclaration.owner    = customer._id

        # Create declaration
        @customer.newDeclaration dtoDeclaration, (declaration) ~>
          @ui-dispatch.on (gz.Css \on-stored), ~>
            @ui.desktop._search.query order-value
          @ui-dispatch.declarationId = declaration\id
          @ui-dispatch.onSave evt
          @ui-declaration.ui-customer.show-pdfmodal declaration

      _error: ->
        alert 'ERROR: ae1325f9-884c-11e3-96e1-88252caeb7e8'

  /**
   * Add new form panel.
   * @param {HTMLElement} _el Element to be added.
   * @param {string} _title
   * @param {string} _sid Name ID to identify panel-content.
   * @private
   * @see render-register
   */
  add-panel: (_el, _title, _sid) ->
    $panel = $ "
      <div class='#{gz.Css \panel} #{gz.Css \panel-default}'>
        <div class='#{gz.Css \panel-heading}'>
          <h4 class='#{gz.Css \panel-title}'>
            <a data-toggle='#{gz.Css \collapse}'
                data-parent='##{gz.Css \id-accordion}'
                href='##{gz.Css \id-collapse}-#_sid'>
              #_title
            </a>
          </h4>
        </div>
        <div id='#{gz.Css \id-collapse}-#_sid' class='#{gz.Css \panel-collapse}
                                                  \ #{gz.Css \collapse}
                                                  \ #{gz.Css \in}'>
          <div class='#{gz.Css \panel-body}'></div>
        </div>
      </div>"
    $panel.0
      .._last._first._append _el
      @el._append ..

  /**
   * (Event) On type operation change.
   * @param {Event} evt
   * @private
   * @see render-register
   */
  on-operation-change: (evt) ~>
    sharedLists = App.shared.lists
    i = sharedLists.OPERATION_DAM_TYPE._index evt._target._value
    io-class = sharedLists.OPERATION_MATCH_CLASS[i]
    @ui-stakeholder.render(@customer,
                           io-class,
                           @stakeholder-panel.customer-type._checked)

  /**
   */
  on-stakeholder-customer-type-change: ~>
    sharedLists = App.shared.lists
    regime-name = @el.query 'input[name=regime\\[name\\]]'
    i = sharedLists.OPERATION_DAM_TYPE._index regime-name._value
    io-class = sharedLists.OPERATION_MATCH_CLASS[i]
    @ui-stakeholder.render(@customer,
                           io-class,
                           @stakeholder-panel.customer-type._checked)

  /**
   * Render form view for declaration and dispatch.
   * @param {Customer} customer
   * @private
   */
  render-register: (customer) ->
    @clean!

    # Sub-views
    @ui-declaration = Anex5.New customer: customer
    @ui-dispatch    = Order.New!
    @ui-stakeholder = Stakeholder.New customer : customer

    @ui-dispatch.on (gz.Css \on-operation-change), @on-operation-change

    # Add panels
    @add-panel(@ui-declaration.render!.el,
               'Anexo 5: Declaración Jurada', gz.Css \one)
    @add-panel(@ui-dispatch.render!.el,
               'Datos de despacho', gz.Css \two)

    @stakeholder-panel = @add-panel(@ui-stakeholder.el,
                                   'Involucrados', gz.Css \three)
    _span = App.dom._new \span
      ..Class = gz.Css \pull-right
      ..html "
        <input type='checkbox'>
        &nbsp; ¿Persona jurídica?"
      ..onChange @on-stakeholder-customer-type-change
    @stakeholder-panel._first._first._append _span
    @stakeholder-panel.customer-type = _span._first

    # Save button
    @$el._append "
      <div class='#{gz.Css \col-md-12} #{gz.Css \form-group}'
          style='padding-right:0'>
        <button type='button'
            style='margin-top:2em'
            class='#{gz.Css \btn}
                 \ #{gz.Css \btn-primary}
                 \ #{gz.Css \pull-right}'>
          Guardar
        </button>
      </div>"

    @el._last._first.onClick @onSave

    @$ ".#{gz.Css \tt-input}"  # Hack to panel and typeahead
      ..on \focus (evt) ->
        $ evt._target .parents ".#{gz.Css \panel-default}"
          .css \overflow \visible
      ..on \blur (evt) ->
        $ evt._target .parents ".#{gz.Css \panel-default}"
          .css \overflow \hidden

  /** @protected */ @@_caption = 'Ingreso Operaciones - Anexo 5'
  /** @protected */ @@_icon    = gz.Css \glyphicon-file

  /** @private */ ui-declaration : App._void._View
  /** @private */ ui-dispatch    : App._void._View
  /** @private */ ui-stakeholder : App._void._View

  /** @private */ stakeholder-panel : null

  /** @private */ customer    : null
  /** @private */ dispatch    : null
  /** @private */ declaration : null

  /** @private */ current-method : null
  /** @private */ onSaveTo       : null

  /**
   * Method type to identify if user going to create or update a dispatch.
   * @type Enum
   * @private
   */
  MethodType: new App.builtins.Enum do
    kCreate : null
    kUpdate : null

  /** @override */
  render: ->
    @ui.desktop._search-focus!
    super!


/** @export */
module.exports = Register


# vim: ts=2 sw=2 sts=2 et:
