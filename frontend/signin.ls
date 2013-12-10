#                    __
#               _--'"  "`--_
#        /( _--'_.        =":-_
#       | \___/{          '>_ ".
#       |-"  ' /\            :  \:
#      /       { `-_*         \  |
#     '/        -:='           |  \:
#     {   '  -___\            |/   |
#    |   :   / (.             |     /
#    `.   .  | | \_-'-.     )\|    '
#     |    :  ` \ __-'-    /      |
#      \    ".   "'--__-''"       /
#       \     "--"''   ,.'":     /
#        `-_        ''" .."   _-'
#           "'--__      __--'"    cristHian Gz. (gcca)
#                 ""--""
document.body.innerHTML = "
<div class='#{gz.Css \topbar}' style='margin-bottom:1em;'>

  <nav class='#{gz.Css \ink-navigation} #{gz.Css \hide-small}'>

    <ul class='#{gz.Css \menu}
             \ #{gz.Css \horizontal}
             \ #{gz.Css \shadowed}
             \ #{gz.Css \black}'>

      <li class='#{gz.Css \active}'>
        <a href='javascript:void(0);'>
          <i class='#{gz.Css \icon-home}'></i>
        </a>
        <button class='#{gz.Css \ink-for-s}
                     \ #{gz.Css \ink-for-m}
                     \ #{gz.Css \ink-button}' style='display: none;'>
          <i class='#{gz.Css \icon-reorder}' style='height:auto'></i>
        </button>
      </li>
      <li>
        <a href='javascript:void(0);'>
          Prevención del Lavado de Activos y Financiamiento del Terrorismo
        </a>
      </li>
      <li><a href='#'>CavaSoft</a></li>
    </ul>

  </nav>

  <div class='#{gz.Css \border}'></div>
</div>

<div class='#{gz.Css \whatIs}'>
    <h1>&nbsp;</h1>
</div>

<div class='#{gz.Css \ink-grid}'>

  <div class='#{gz.Css \column-group} #{gz.Css \half-gutters}'>
    <div class='#{gz.Css \large-100}
              \ #{gz.Css \medium-100}
              \ #{gz.Css \small-100}'>
    <h5><!-- cristHian Gz. (gcca) . http://gcca.tk -->&nbsp;</h5>
  </div>

  <div class='#{gz.Css \large-50}
            \ #{gz.Css \medium-50}
            \ #{gz.Css \small-100}'>

    <a href='http://www.mozilla.org/es-ES/firefox/new' target='_blank' title='Firefox'>
      <img src='/static/firefox.png' alt='Firefox'
        class='#{gz.Css \large-100}
             \ #{gz.Css \medium-100}
             \ #{gz.Css \small-100}'>
    </a>

  </div>

    <div class='#{gz.Css \ink-navigation}
              \ #{gz.Css \large-50}
              \ #{gz.Css \medium-50}
              \ #{gz.Css \small-100}'>
      <ul class='#{gz.Css \menu}
               \ #{gz.Css \vertical}
               \ #{gz.Css \orange}
               \ #{gz.Css \rounded}
               \ #{gz.Css \shadowed}'>
        <li>
          <a href='/static/show/index.html'>
            Presentación del software
          </a>
        </li>
        <li>
          <a href='/customer-form'>
            Anexo 5: Declaración Jurada de Conocimiento del Cliente
            <i class='#{gz.Css \icon-pencil} #{gz.Css \push-right}'></i>
          </a>
        </li>
      </ul>

      <br><br>

      <form class='#{gz.Css \ink-form}'>
        <fieldset>
          <div class='#{gz.Css \control-group}'>
            <div class='#{gz.Css \control} #{gz.Css \append-symbol}'>
              <span>
                <input type='text' name='username' placeholder='Usuario' value='gcca@meil.io'>
                <i class='#{gz.Css \icon-envelope-alt}'></i>
              </span>
            </div>
          </div>

          <div class='#{gz.Css \control-group}'>
            <div class='#{gz.Css \control} #{gz.Css \append-symbol}'>
              <span>
                <input type='password' name='password' placeholder='Clave' value='123'>
                <i class='#{gz.Css \icon-asterisk}'></i>
              </span>
            </div>
          </div>

          <div class='#{gz.Css \control-group}'>
            <div class='#{gz.Css \control}'>
              <img id='signin-img'
                  style='float:left;
                         margin-left:4px;
                         margin-right:5px;
                         margin-top:6px;
                         visibility:hidden'>
              #{
                if (document.cookie.match /ud=(.*\|.*\|.*)/) then
                  "<button class='#{gz.Css \ink-button}
                               \ #{gz.Css \blue}
                               \ #{gz.Css \push-right}' type='button'
                      onclick='location.href = \"/dashboard\"'>
                    Dashboard
                  </button>"
                else
                  ""
              }
              <button class='#{gz.Css \ink-button}
                           \ #{gz.Css \green}
                           \ #{gz.Css \push-right}' type='button'>
                Ingresar
              </button>
            </div>
          </div>
        </fieldset>
      </form>
    </div>
</div>

<div class='#{gz.Css \column-group} #{gz.Css \half-gutters}'>
    <div class='#{gz.Css \large-20}
              \ #{gz.Css \medium-20}
              \ #{gz.Css \small-100}'>
      <h6>
        <i class='#{gz.Css \icon-star} #{gz.Css \icon-large}'></i>
        &nbsp;Directo
      </h6>
      <p>Este servicio abarca los requisitos e indicadores necesarios.</p>
    </div>

    <div class='#{gz.Css \large-20}
              \ #{gz.Css \medium-20}
              \ #{gz.Css \small-100}'>
      <h6>
        <i class='#{gz.Css \icon-dashboard} #{gz.Css \icon-large}'>
        </i>&nbsp; Rápido
      </h6>
      <p>Nuestro servicio permite identificar unidades de trabajo.</p>
    </div>

    <div class='#{gz.Css \large-20}
              \ #{gz.Css \medium-20}
              \ #{gz.Css \small-100}'>
      <h6>
        <i class='#{gz.Css \icon-truck} #{gz.Css \icon-large}'></i>
        &nbsp; Completo
      </h6>
      <p>Dispón del servicio en todos los dispositivos tablets, smartphones, notebooks.</p>
    </div>

    <div class='#{gz.Css \large-20}
              \ #{gz.Css \medium-20}
              \ #{gz.Css \small-100}'>
      <h6>
        <i class='#{gz.Css \icon-key} #{gz.Css \icon-large}'>
        </i>&nbsp; Seguro
      </h6>
      <p>Los datos de los usuarios son confidenciales y viajan cifrados en nuestro sistema.</p>
    </div>

    <div class='#{gz.Css \large-20}
              \ #{gz.Css \medium-20}
              \ #{gz.Css \small-100}'>
      <h6>
        <i class='#{gz.Css \icon-gift} #{gz.Css \icon-large}'></i>
        &nbsp; Actualizado
      </h6>
      <p>Mantenemos nuestro sofwtare con los útlimos avances tecnológicos.</p>
    </div>
  </div>
</div>

<footer style='padding: 0 1em 0 1em;font-size:0.8em;margin-top:5em'>
  <nav class='#{gz.Css \ink-navigation}'>
    <ul class='#{gz.Css \menu} #{gz.Css \horizontal}'>
      <li>
        © Copyright 2013, CavaSoft SAC. <a href='#'>&nbsp;</a>
      </li>
      <li class='#{gz.Css \push-right}' style='font-size:.88em;padding-top:.25em'>
        Created by &nbsp;
        <a href='http://gcca.alwaysdata.net'>cristHian Gz. (gcca)</a>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <a href='/static/doc/index.html'>Doc</a>
      </li>
    </ul>
  </nav>
</footer>"
document.querySelector "button.#{gz.Css \green}" .onclick = ->
  document.querySelector \#signin-img
    ..src = '/static/img/ss.gif'
    ..style.visibility = \visible
  form = document.querySelector \form .elements
  new XMLHttpRequest
    ..open \post '/api/v1/signin'
    ..setRequestHeader 'Content-type' 'application/x-www-form-urlencoded'
    ..setRequestHeader 'pragma' 'no-cache'
    ..setRequestHeader 'cache-Control' 'no-cache,must-revalidate,max-age=0'
    ..onreadystatechange = ->
      if @readyState is 4
        document.querySelector \#signin-img
          ..src = ''
          ..style.visibility = \hidden
        if @status is 200
          location.href = '/dashboard'
        else
          if not (document.querySelector ".#{gz.Css \tip}")?
            for i in (document.querySelectorAll ".#{gz.Css \control-group}")
              i.className += " #{gz.Css \validation} #{gz.Css \error}"
            document.createElement \p
              ..className = "#{gz.Css \tip} #{gz.Css \push-left}"
              ..innerHTML = 'Usuario o clave incorrectos'
              i.firstElementChild.insertBefore ..
    ..send "username=#{form.'username'.value}&password=#{form.'password'.value}"
