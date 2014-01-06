/** @module dashboard.settings */

/**
 * Module list.
 * @private
 */
settingsModules = [
 CustomsView = require './module/settings/customs'
 UserView = require './module/settings/user'
]

/**
 * @class SettingsView
 */
module.exports = class SettingsView extends gz.GView

  tagName: \nav

  className: "#{gz.Css \ink-navigation}"

  /**
   * Configuartion module.
   * param {Object} evt Event object.
   * @private
   */
  createLi: (vModule) ->
    # <li>
    tLi   = gz.newel \li
    # <a>
    tA    = gz.newel \a
    tI    = gz.newel \i
    # <a>
    tI.className = vModule.menuIcon
    tA.appendChild tI
    new gz.Ink.UI.Tooltip tA, do
      \text  : vModule.menuCaption
      \where : gz.Css \down
      \color : gz.Css \blue
    tA.onclick = !(evt) ~>
      evt.preventDefault!
      @currentModule.classList.remove gz.Css \active if @currentModule?
      evt.currentTarget.parentElement
        ..classList.add gz.Css \active
        @currentModule = ..
      @trigger gz.Css \on-dashboard-settings-change-desktop
      @desktopView.changeDesktop vModule .render!
    # <li>
    tLi.appendChild tA
    # ret <li>
    tLi.style.width = '50%'
    tA.style
      ..width     = '100%'
      ..textAlign = 'center'
    tLi

  disableCurrent: ->
    @currentModule.classList.remove gz.Css \active if @currentModule?

  initialize: !(vOptions) ->
    @desktopView = vOptions.desktopView

  /**
   * @example
   * <ul class='#{gz.Css \menu}
   *          \ #{gz.Css \horizontal}
   *          \ #{gz.Css \white}
   *          \ #{gz.Css \rounded}
   *          \ #{gz.Css \shadowed}'>
   * </ul>"
   */
  render: ->
    tUl = gz.newel \ul
      ..className = "#{gz.Css \menu}
                   \ #{gz.Css \horizontal}
                   \ #{gz.Css \white}
                   \ #{gz.Css \rounded}
                   \ #{gz.Css \shadowed}"
    for vVals in settingsModules then tUl.appendChild @createLi vVals
    @$el.append tUl
    super!

  /** @private */ desktopView   : null
  /** @private */ currentModule : null
