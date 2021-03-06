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
error = on if window.'plaft'.\e == -1
document.body.innerHTML = "
<div class='#{gz.Css \navbar}
          \ #{gz.Css \navbar-inverse}
          \ #{gz.Css \navbar-fixed-top}' role='navigation'>

  <div class='#{gz.Css \container}'>

    <div class='#{gz.Css \navbar-header}'>
      <button type='button' class='#{gz.Css \navbar-toggle}'
          data-toggle='collapse' data-target='.#{gz.Css \navbar-collapse}'>
        <span class='#{gz.Css \sr-only}'>Toggle navigation</span>
        <span class='#{gz.Css \icon-bar}'></span>
        <span class='#{gz.Css \icon-bar}'></span>
        <span class='#{gz.Css \icon-bar}'></span>
      </button>
      <a class='#{gz.Css \navbar-brand}' href='#'>
        PLAFT<small>sw</small>
      </a>
    </div>

    <div class='#{gz.Css \navbar-collapse}
              \ #{gz.Css \collapse}'>

      <form class='#{gz.Css \navbar-form}
                 \ #{gz.Css \navbar-right}' role='form' method='post'>

        <div class='#{gz.Css \form-group}
                    #{if error
                    then " #{gz.Css \has-error} #{gz.Css \has-feedback}"
                    else ''}'>

          <input type='text' placeholder='Email' name='email'
              value='gcca@hub.io'
              class='#{gz.Css \form-control}'>


          #{if error
            then "<span class='#{gz.Css \glyphicon}
                             \ #{gz.Css \glyphicon-remove}
                             \ #{gz.Css \form-control-feedback}'></span>"
            else ''}

        </div>


        <div class='#{gz.Css \form-group}
                    #{if error
                    then " #{gz.Css \has-error} #{gz.Css \has-feedback}"
                    else ''}'>

          <input type='password' placeholder='Password' name='password'
              value='789'
              class='#{gz.Css \form-control}'>

          #{if error
            then "<span class='#{gz.Css \glyphicon}
                             \ #{gz.Css \glyphicon-remove}
                             \ #{gz.Css \form-control-feedback}'></span>"
            else ''}

        </div>

        <button type='submit' class='#{gz.Css \btn} #{gz.Css \btn-success}'>
          Ingresar
        </button>

      </form>

    </div>

  </div>

</div>

<div class='#{gz.Css \jumbotron}'>

  <div class='#{gz.Css \container}'>
    <h1>
      PLAFT<small>sw</small>
    </h1>

    <p>Prevención del Lavado de Activos y Financiamiento del Terrorismo.</p>

    <p class='#{gz.Css \jumbotron-options}'>
      <a class='#{gz.Css \btn}
              \ #{gz.Css \btn-primary}
              \ #{gz.Css \btn-lg}' role='button' href='/customer'>
        Declaración Jurada
        &nbsp;&nbsp;&nbsp;&nbsp;
        &raquo;
      </a>

      <a class='#{gz.Css \visible-xs}'>
        <form class='#{gz.Css \navbar-form}
                   \ #{gz.Css \navbar-right}' role='form' method='post'>

          <div class='#{gz.Css \form-group}
                      #{if error
                      then " #{gz.Css \has-error} #{gz.Css \has-feedback}"
                      else ''}'>

            <input type='text' placeholder='Email' name='email'
                value='gcca@hub.io'
                class='#{gz.Css \form-control}'>


            #{if error
              then "<span class='#{gz.Css \glyphicon}
                               \ #{gz.Css \glyphicon-remove}
                               \ #{gz.Css \form-control-feedback}'></span>"
              else ''}

          </div>


          <div class='#{gz.Css \form-group}
                      #{if error
                      then " #{gz.Css \has-error} #{gz.Css \has-feedback}"
                      else ''}'>

            <input type='password' placeholder='Password' name='password'
                value='789'
                class='#{gz.Css \form-control}'>

            #{if error
              then "<span class='#{gz.Css \glyphicon}
                               \ #{gz.Css \glyphicon-remove}
                               \ #{gz.Css \form-control-feedback}'></span>"
              else ''}

          </div>

          <button type='submit' class='#{gz.Css \btn} #{gz.Css \btn-success}'>
            Ingresar
          </button>

        </form>
      </a>
    </p>

  </div>

</div>

  <div class='#{gz.Css \container}'>

    <div class='#{gz.Css \row} #{gz.Css \publicity}'>
      <div class='#{gz.Css \col-md-4}'>
        <h4>¿Qué es el lavado de activos?</h4>
        <p style='text-align:justify'>
          Es el conjunto de operaciones realizadas por una o más personas
          \ naturales o jurídicas, tendientes a ocultar o disfrazar el origen
          \ ilícito de bienes o recursos...</p>
        <p>
          <a class='#{gz.Css \btn} #{gz.Css \btn-default}'
              href='#' role='button'>
            Ver más &raquo;
          </a>
        </p>
      </div>


      <div class='#{gz.Css \col-md-4}'>
        <h4>Sistema de prevención nacional</h4>
        <p style='text-align:justify'>
          De acuerdo al Decreto supremo N° 0018-2006 \"REGLAMENTO DE LA LEY
          \ QUE CREA LA UNIDAD DE INTELIGENCIA FINANCIERA DEL PERÚ\"...
        </p>
        <p>
          <a class='#{gz.Css \btn} #{gz.Css \btn-default}'
              href='#' role='button'>
            Ver más &raquo;
          </a>
        </p>
      </div>


      <div class='#{gz.Css \col-md-4}'>
        <h4>Transparencia operativa</h4>
        <p style='text-align:justify'>
          En esta sección podrá encontrar Estadística Operativa de la Unidad
          \ de Inteligencia Financiera del Perú (UIF-Perú).
          <br> &nbsp;
        </p>
        <p>
          <a class='#{gz.Css \btn} #{gz.Css \btn-default}'
              href='#' role='button'>
            Ver más &raquo;
          </a>
        </p>
     </div>

    </div>

    <hr>

    <footer>
      <p>&copy; CavaSoft 2014</p>
      <!-- cristHian Gz. (gcca) - http://gcca.tk -->
      <!-- Cristhian Alberto Gonzales Castillo -->
    </footer>
</div>
"

## document.querySelector 'form' .onsubmit = (evt) ->
##   evt.preventDefault!
##   document.querySelector \#signin-img .style.visibility = \visible
##   form = document.querySelector \form .elements
##   new XMLHttpRequest
##     ..open \post '/api/v1/signin'
##     ..setRequestHeader 'Content-type' 'application/x-www-form-urlencoded'
##     ..onreadystatechange = ->
##       if @readyState is 4
##         if @status is 200
##           toDashboard = ->
##               setTimeout (-> location.replace '/dashboard'), 200
##           setTimeout toDashboard, 700
##         else
##           document.querySelector \#signin-img .style.visibility = \hidden
##           if not (document.querySelector ".#{gz.Css \tip}")?
##             for i in (document.querySelectorAll ".#{gz.Css \control-group}")
##               i.className += " #{gz.Css \validation} #{gz.Css \error}"
##             document.createElement \p
##               ..className = "#{gz.Css \tip} #{gz.Css \push-left}"
##               ..innerHTML = 'Usuario o clave incorrectos'
##               i.insertBefore .., i.firstElementChild
##     ..send "username=#{form.'username'.value}&password=#{form.'password'.value}"
