/** @module dashboard */

gz     = require './helpers'
model  = require './model'
widget = require './dashboard/widget'

MenuView    = require './dashboard/menu'
DesktopView = require './dashboard/desktop'

ConfigView = require './dashboard/module/config'

# ----------
# Global App
# ----------
gzApp = new Object

customsBroker = new model.CustomsBroker
customsBroker.fetch do
  \success : !(customsBroker) ->
    gzApp.customsBroker = customsBroker


/**
 * Main view.
 * @class DashboardView
 */
class DashboardView extends gz.GView

  /**
   * DOM element.
   * @type {!Object}
   * @private
   */
  el: $ \body

  /**
   * View events.
   * @type {Object}
   * @private
   */
  events:
    /**
     * Configuartion module.
     * @param {Object} evt Event object.
     * @private
     */
    "click ##{gz.Css \id-cog}": !(evt) ->
      @desktopView.changeDesktop ConfigView .render!

    /**
     * On click help-me button.
     * @param {Object} evt Event object.
     * @private
     */
    "click ##{gz.Css \id-helpme}": !(evt) ->
      @el.classList.toggle (gz.Css \helpme-dashboard)
      evt.currentTarget
        ..firstElementChild
          ..classList.toggle (gz.Css \icon-question)
          ..classList.toggle (gz.Css \icon-question-sign)
        ..disabled = not ..disabled
      new gz.Ink.UI.Tabs ".#{gz.Css \helpme-tabs}", do
        \preventUrlChange : on

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @el.className = gz.Css \gz-dashboard
    @el.innerHTML = DashboardView_template

    body = @el.lastElementChild.firstElementChild
    body.innerHTML = ''

    # Left side
    left = gz.newel \div
    left.className = "#{gz.Css \large-15}
                    \ #{gz.Css \medium-100}
                    \ #{gz.Css \small-100}"

    tools = gz.newel \div
    tools.style.marginBottom = '1em'
    tools.className = "#{gz.Css \large-100}
                     \ #{gz.Css \medium-100}
                     \ #{gz.Css \small-100}"
    tools.innerHTML = "
      <nav class='#{gz.Css \ink-navigation}'>
        <ul class='#{gz.Css \menu}
                 \ #{gz.Css \horizontal}
                 \ #{gz.Css \white}
                 \ #{gz.Css \rounded}
                 \ #{gz.Css \shadowed}'>
          <li style='width:100%'>
            <a id='#{gz.Css \id-cog}' href='javascript:void(0);'
                style='width:100%'>
              <i class='#{gz.Css \icon-cog}'></i>
              &nbsp;&nbsp;
              <span>Agencia</span>
            </a>
          </li>
        </ul>
      </nav>"
    left.appendChild tools

    menu = gz.newel \div
    menu.className = "#{gz.Css \large-100}
                    \ #{gz.Css \medium-100}
                    \ #{gz.Css \small-100}"
    menuView = new MenuView
    menu.appendChild menuView.el
    left.appendChild menu

    body.appendChild left

    # Right side
    right = gz.newel \div
    right.style.verticalAlign = 'middle'
    right.className = "#{gz.Css \large-85}
                     \ #{gz.Css \medium-100}
                     \ #{gz.Css \small-100}"
    right.innerHTML = right_vTemplate
    searchView = new widget.GSearchView el: ($ right .find 'input' .get 0)
    desktopView = new DesktopView menuView, searchView
    right.appendChild desktopView.el

    body.appendChild right

    # attributes
    /** @private */ @menuView = menuView
    /** @private */ @desktopView = desktopView

# ---------
# Templates
# ---------
/** @private */ right_vTemplate =  "
<div class='#{gz.Css \large-100} #{gz.Css \medium-100} #{gz.Css \small-100}'>
  <div class='#{gz.Css \large-75} #{gz.Css \medium-75} #{gz.Css \small-100}'>
    <nav class='#{gz.Css \ink-navigation}'>
      <ul class='#{gz.Css \breadcrumbs}
               \ #{gz.Css \flat}
               \ #{gz.Css \orange}
               \ #{gz.Css \rounded}
               \ #{gz.Css \shadowed}'>
        <li>
          <a href='#'>
          <i class='#{gz.Css \icon-home}'></i>
          &nbsp;
          &nbsp;
          Inicio
          </a>
        </li>
        <li class='#{gz.Css \active}'>
          <a href='javascript:void(0)'>
            Despacho
          </a>
        </li>
      </ul>
    </nav>
  </div>
  <div class='#{gz.Css \large-25} #{gz.Css \medium-25} #{gz.Css \small-100}'>
    <form style='margin: 0.29em 0.4em 0;'
        class='#{gz.Css \ink-form} #{gz.Css \top-space}'
        onsubmit='return false'>
      <div class='#{gz.Css \control-group}' style='margin-bottom:0'>
        <div class='#{gz.Css \control} #{gz.Css \append-symbol}'>
          <span>
            <input type='text' placeholder='Buscar...' style='font-size:16px'>
            <i class='#{gz.Css \icon-search}'></i>
          </span>
        </div>
      </div>
    </form>
  </div>
</div>"

/** @private */ DashboardView_template = "
<div class='#{gz.Css \topbar}'>
  <nav class='#{gz.Css \ink-navigation}'>
    <ul class='#{gz.Css \menu} #{gz.Css \horizontal}
             \ #{gz.Css \shadowed} #{gz.Css \black}'>
      <li class='#{gz.Css \active}'>
        <a href='javascript:void(0);'>
          <i class='#{gz.Css \icon-home}'></i>
        </a>
      </li>
      <li>
        <a id='#{gz.Css \topbar-title}' href='javascript:void(0);'>
          PLAFT-sw
        </a>
      </li>
      <li class='#{gz.Css \push-right}'>
        <a href='javascript:void(0);'>
          <button id='#{gz.Css \id-helpme}'
              class='#{gz.Css \ink-button} #{gz.Css \blue}'
              style='padding:.1em .4em;margin:0'>
            <i class='#{gz.Css \icon-question}'></i>
          </button>
        </a>
      </li>
    </ul>
  </nav>
  <div class='#{gz.Css \border}'></div>
</div>

<div class='#{gz.Css \whatIs}'>
  <h1>&nbsp;</h1>
  <p></p>
</div>

<div class='#{gz.Css \ink-grid}'>
  <div class='#{gz.Css \column-group} #{gz.Css \half-gutters}'></div>
</div>"

# ---------
# Body Init
# ---------
(new DashboardView).render!
## ($ "ul.#{gz.Css \grey}").children!.next!.children!.first!.click!
## evt = $.Event \keyup
##   ..keyCode = 13
## ## $ 'input' .val 'GGGGG666' .trigger evt
## $ 'input' .val '12345678989' .trigger evt
## $ "ul.#{gz.Css \grey}" .children! .last! .children! .first! .click!
