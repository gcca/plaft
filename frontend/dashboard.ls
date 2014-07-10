/**
 * @module dashboard
 * Main view for user dashboard.
 */


App = require './app'

# Set global (user and customs data)
App._global.user = new App.model.User App.win.'plaft'.'a1'
App._global.user.customs = \
  new App.model.Customs App._global.user._attributes.\customs

Menu    = require './dashboard/menu'
Desktop = require './dashboard/desktop'


/** ---------
 *  Dashboard
 *  ---------
 * User dashboard view.
 * @class UiDashboard
 * @extends View
 */
class Dashboard extends App.View

  /** @override */
  el: $ \body

  /** @override */
  render: ->
    @$el.html @template!
    App._history._replaceState '' '' '/dashboard'

    menu    = new Menu
    desktop = new Desktop

    @$ "##{gz.Css \id-dashboard-menu}"
      .._append menu.render!.el

    @$ "##{gz.Css \id-dashboard-desktop}"
      .._append desktop.render!.el

    menu.on (gz.Css \select), desktop.changeModule

    super!

  /**
   * Base dashboard template.
   * @return {string}
   */
  template: ->
    # HEADER
    tHeader = "
      <header class='#{gz.Css \navbar}
                   \ #{gz.Css \navbar-inverse}
                   \ #{gz.Css \navbar-fixed-top}
                   \ #{gz.Css \navbar-top-min}'
            role='banner'>
        <div class='#{gz.Css \container}'>
          <div class='#{gz.Css \navbar-header}'>
            <button class='#{gz.Css \navbar-toggle}' type='button'
                data-toggle='collapse'
                data-target='##{gz.Css \id-navbar-collapse}'>
              <span class='#{gz.Css \sr-only}'>Toggle navigation</span>
              <span class='#{gz.Css \icon-bar}'></span>
              <span class='#{gz.Css \icon-bar}'></span>
              <span class='#{gz.Css \icon-bar}'></span>
            </button>

            <a href='/' class='#{gz.Css \navbar-brand}'>PLAFTsw</a>
          </div>
          <nav class='#{gz.Css \collapse}
                    \ #{gz.Css \navbar-collapse}'
              id='#{gz.Css \id-navbar-collapse}'
              role='navigation'>
            <ul class='#{gz.Css \nav} #{gz.Css \navbar-nav}'>
              <li>
                <a></a>
              </li>
            </ul>
            <ul class='#{gz.Css \nav}
                     \ #{gz.Css \navbar-nav}
                     \ #{gz.Css \navbar-right}'>
              <li>
                <a></a>
              </li>
            </ul>
          </nav>
        </div>
      </header>"

    # BODY
    tBody = "
      <div class='#{gz.Css \container} #{gz.Css \app-container}'>
        <div class='#{gz.Css \row}'>

          <div id='#{gz.Css \id-dashboard-menu}'
              class='#{gz.Css \col-md-2}'>
          </div>

          <div id='#{gz.Css \id-dashboard-desktop}'
              class='#{gz.Css \col-md-10}'>
          </div>

        </div>
      </div>"

    # FOOTER
    tFooter = "
      <footer style='padding-top:40px;
                     padding-bottom:30px;
                     margin-top:100px'></footer>"

    tHeader + tBody + tFooter

(new Dashboard).render!

# !!! Temporal to list complete module names.
$ "ul.#{gz.Css \nav-stacked}"
  ..append "
    <li>
      <a>
        <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-compressed}'></i>
        &nbsp; Identificación Operaciones sospechosas - Anexo 6
      </a>
    </li>"
  ..append "
    <li>
      <a>
        <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-plane}'></i>
        &nbsp; Registro de Operaciones - Anexo 2
      </a>
    </li>"
  ..append "
    <li>
      <a>
        <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-qrcode}'></i>
        &nbsp; Estadística Anual
      </a>
    </li>"

$ ('.' + gz.Css \glyphicon-file) ._parent! .click!
$ 'input[placeholder=Buscar]' .val '12345678989'
$ ".#{gz.Css \glyphicon-search}" ._parent! .click!

# vim: ts=2 sw=2 sts=2 et:
