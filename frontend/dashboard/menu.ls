/** @module dashboard.menu */


MODULES =
  Reception  = require './modules/reception'
  Dispatches = require './modules/dispatches'
  Alerts     = require './modules/alerts'
  Anex2      = require './modules/anex2'
  Anex6      = require './modules/anex6'


SETTINGS =
  Customs = require './settings/customs'
  User    = require './settings/user'


class Settings extends App.View

  _tagName: \ul

  _className: "#{gz.Css \nav} #{gz.Css \nav-pills}"

  addItem: (module, elWidth) ->
    a = App.dom.newel \a
      ..module = module
      ..css._width = '100%'
      ..html "<span class='#{gz.Css \glyphicon} #{module._icon}'></span>"

    li = App.dom.newel \li
      .._append a
      ..Class = gz.Css \text-center
      ..css._width = elWidth

  render: ->
    elWidth = "#{98 / SETTINGS.length}%"
    for module in SETTINGS
      @$el._append @addItem module, elWidth
    super!


class Modules extends App.View

  _tagName: \ul

  _className: "#{gz.Css \nav} #{gz.Css \nav-pills} #{gz.Css \nav-stacked}"

  addItem: (module) ->
    a = App.dom.newel \a
      ..module = module
      ..html "<i class='#{gz.Css \glyphicon}
                      \ #{module._icon}'></i>
              \&nbsp; #{module._caption}"

    li = App.dom.newel \li
      .._append a

  render: ->
    for module in MODULES
      @$el._append @addItem module
    super!


class Menu extends App.View

  _tagName: \div

  _className: "#{gz.Css \hidden-print} #{gz.Css \affix-top}"

  events:
    "click a": (evt) ->
      elm = evt.currentTarget
      @$prevItem._parent!.removeClass (gz.Css \active)
      @$prevItem = $ elm
      @$prevItem._parent!.addClass (gz.Css \active)
      @trigger (gz.Css \select), elm.module

  initialize: !->
    @$el.attr 'role' 'complementary'
    @$prevItem = _parent: -> removeClass: !->

  $prevItem: null

  render: ->
    settings = new Settings
    modules  = new Modules

    @$el._append settings.render!.el
    @$el._append "<hr style='margin-bottom:8px;
                             margin-top:8px;'>"
    @$el._append modules.render!.el

    super!


module.exports = Menu
