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
errors = window[\params][\e]
existLoginError = errors? and (errors.indexOf 'login') != -1
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
      <li><a href='#'>CavaSoft</a></li>
      <li><a href='#'>Help</a></li>
      <li><a href='#'>Sign in</a></li>
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
    <h3>Lavado de Activos</h3>
  </div>

  <div class='#{gz.Css \large-55}
            \ #{gz.Css \medium-55}
            \ #{gz.Css \small-100}'>

    <a href='http://www.mozilla.org/es-ES/firefox/new' target='_blank' title='Firefox'>
      <img src='/static/firefox.png' alt='Firefox'
        class='#{gz.Css \large-100}
             \ #{gz.Css \medium-100}
             \ #{gz.Css \small-100}'>
    </a>

  </div>

    <div class='#{gz.Css \ink-navigation}
              \ #{gz.Css \large-45}
              \ #{gz.Css \medium-45}
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
            Anexo 5: Declaración jurada de clientes
            <i class='#{gz.Css \icon-pencil} #{gz.Css \push-right}'></i>
          </a>
        </li>
      </ul>

      <br><br>

      <form action='/signin' method='post' class='#{gz.Css \ink-form}'>
        <fieldset>
          <div class='#{gz.Css \control-group}
            #{if existLoginError
                then " #{gz.Css \validation} #{gz.Css \error}" else ''}'>
            <div class='#{gz.Css \control} #{gz.Css \append-symbol}'>
              <span>
                <input type='text' name='email' placeholder='Usuario' value='gcca@meil.io'>
                <i class='#{gz.Css \icon-envelope-alt}'></i>
              </span>
            </div>
          </div>

          <div class='#{gz.Css \control-group}
            #{if existLoginError
                then " #{gz.Css \validation} #{gz.Css \error}" else ''}'>
            <div class='#{gz.Css \control} #{gz.Css \append-symbol}'>
              <span>
                <input type='password' name='password' placeholder='Clave' value='123'>
                <i class='#{gz.Css \icon-asterisk}'></i>
              </span>
            </div>
          </div>

          <div class='#{gz.Css \control-group}
            #{if existLoginError
                then " #{gz.Css \validation} #{gz.Css \error}" else ''}'>
            <div class='#{gz.Css \control}'>
              #{if existLoginError then "
                      <p style='float:left'
                              class='#{gz.Css \tip}'>
                        Usuario o clave incorrectos
                      </p>" else ''}
              <button class='#{gz.Css \ink-button}
                           \ #{gz.Css \green}
                           \ #{gz.Css \push-right}'>
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

<footer style='padding: 0 1em 0 1em;font-size:0.8em'>
  <nav class='#{gz.Css \ink-navigation}'>
    <ul class='#{gz.Css \menu} #{gz.Css \horizontal}'>
      <li>
        © Copyright 2013, CavaSoft SAC. <a href='#'>&nbsp;</a>
      </li>
      <li class='#{gz.Css \push-right}'>
        Created by&nbsp;
        <a href='http://gcca.alwaysdata.net'>cristHian Gz. (gcca)</a>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <a href='/static/doc/index.html'>Doc</a>
      </li>
    </ul>
  </nav>
</footer>
"
