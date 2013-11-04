gz     = require './helpers'
model  = require './model'
widget = require './dashboard/widget'

MenuView    = require './dashboard/menu'
DesktopView = require './dashboard/desktop'

/**
 * Main view.
 * @class
 */
class DashboardView extends gz.GView

  /**
   * DOM element.
   * @type {!Object}
   * @private
   */
  el: $ \body

  /**
   * Initialize view.
   * @private
   */
  initialize: !->
    @el.innerHTML = DashboardView_template

    body = @el.lastElementChild.firstElementChild
    body.innerHTML = ''

    # Left side
    left = gz.newel \div
    left.className = "#{gz.Css \large-15}
                    \ #{gz.Css \medium-100}
                    \ #{gz.Css \small-100}"

    ## tools = gz.newel \div
    ## tools.style.marginBottom = '1em'
    ## tools.className = "#{gz.Css \large-100}
    ##                  \ #{gz.Css \medium-100}
    ##                  \ #{gz.Css \small-100}"
    ## tools.innerHTML = "
    ##     <nav class='#{gz.Css \ink-navigation}'>
    ##       <ul style='visibility:hidden' class='#{gz.Css \breadcrumbs}
    ##                                          \ #{gz.Css \flat}
    ##                                          \ #{gz.Css \black}
    ##                                          \ #{gz.Css \rounded}
    ##                                          \ #{gz.Css \shadowed}'>
    ##         <li>
    ##           <a href='javascript:void(0);'>
    ##             &nbsp;
    ##           </a>
    ##         </li>
    ##       </ul>
    ##     </nav>"
    ## left.appendChild tools

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
      Start
      </a>
    </li>
    <li><a href='#'>Level 1</a></li>
    <li><a href='#'>Level 2</a></li>
    <li class='#{gz.Css \active}'>
      <a href='javascript:void(0)'>
      Current item
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
new DashboardView

($ (($ "ul.#{gz.Css \white}") .children! .next! .get 0)).children! .first! .click!
evt = $.Event \keyup
  ..keyCode = 13
$ 'input' .val '123' .trigger evt
