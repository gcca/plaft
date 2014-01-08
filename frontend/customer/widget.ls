class ComboBox extends gz.GView
    tagName : \div

    events :
        'click li a' : !(event) ->
            a  = event.currentTarget
            li = a.parentElement
            @updateChoice li

    selected : (label) ->
        length = @maxChoiceLength - label.length + 1
        length = Array length .join '&nbsp;'
        @btn.innerHTML = "
            <label>#label</label>#length&nbsp;
            <span class='#{gz.Css \icon-caret-down}'></span>"

    updateChoice : !(li) ->
        if li isnt @currentChoice
            li.classList.add gz.Css \active
            @currentChoice.classList.remove gz.Css \active if @currentChoice
            @currentChoice = li
            @selected li.choiceValue
            @trigger \change

    choice : (currentChoice) ->
        if currentChoice?
            li = @liBy[currentChoice]
            @updateChoice li
        else
            @currentChoice.choiceValue

    initialize : !(@options) ->
        @el.className = "#{gz.Css \ink-dropdown} #{gz.Css \green}"

        # Button label
        btn = gz.newel \button
        btn.type = \button
        btn.className = "#{gz.Css \ink-button} #{gz.Css \toggle}"
        btn.style.padding = '0.16em 0.5em'
        btn.style.textTransform = 'uppercase'
        @btn = btn

        # Choice list
        ul = gz.newel \ul
        ul.className = gz.Css \dropdown-menu
        ul.innerHTML = "
            <li class='#{gz.Css \heading}'
                style='border-bottom:1px solid rgba(0,0,0,0.15);margin-bottom:0'>
              #{@options.caption}
            </li>"
        # Adding choices
        choices = @options.choices
        liBy = new Object
        maxChoiceLength = 0
        for value of choices
            li = gz.newel \li
            a  = gz.newel \a

            #li.className = gz.Css \separator-above
            li.style.background = 'initial'
            li.choiceValue = value

            a.href = 'javascript:void(0)'
            a.style.borderRadius = '0'
            a.style.borderBottom = '1px solid rgba(0,0,0,0.15)'
            a.innerHTML = choices[value]
            liBy[value] = li

            length = value.length
            maxChoiceLength = length if length > maxChoiceLength

            li.appendChild a
            ul.appendChild li
        @liBy = liBy
        @maxChoiceLength = maxChoiceLength

        currentChoice = @options.choice
        (for currentChoice of choices then break) if not currentChoice
        @choice currentChoice

        # Internal Values
        @el.appendChild btn
        @el.appendChild ul
        new gz.Ink.UI.Toggle btn, \target : ul

class EditableLabel extends gz.GView
    tagName : \span

    events :
        'click label' : !->
            @isinput = true
            @el.innerHTML = "
                <input type='text' value='#{@options.label}'>"
            el = @el.firstElementChild
            el.focus!
            el.select!

        'blur input' : !(event) ->
            @release event if @isinput

        'keyup input' : !(event) ->
            if 13 == event.keyCode or 27 == event.keyCode
                @release event if @isinput

    release : !(event) ->
        @isinput = false
        label = event.currentTarget.value
        iconHTML = ''
        if not label
            iconHTML = "
                 &nbsp;&nbsp;<span class='#{gz.Css \icon-edit-sign}'></span>"
            label = 'Editar'
        pad = if label.length < 5 then '&nbsp;' * 16 else ''
        @options.label = label
        @el.innerHTML = "<label>#label#pad#iconHTML</label>"
        @trigger \change

    initialize : !(@options) ->
        @isinput = false
        iconHTML = if @options.icon
             then  "&nbsp;&nbsp;<span class='#{gz.Css \icon-edit-sign}'></span>"
             else ''
        @el.innerHTML = "<label>#{@options.label}#iconHTML</label>"

exports <<<
    ComboBox      : ComboBox
    EditableLabel : EditableLabel
