model = require '../../model'
BuilderTable = require './builder/table'
OperationEdit = require './operation-edit'

OperationCollection = model.Operations

class OperationsView extends BuilderTable

    events:
        "click button.#{gz.Css \button-edit}": !(event) ->
            btn = event.currentTarget
            @desktop.changeDesktop OperationEdit, do
                operationId : btn.dataset[\id]

    createStatusButton: ->
        dd = gz.newel \div
        dd.className = "#{gz.Css \ink-dropdown} #{gz.Css \red}"

        btn = gz.newel \button
        btn.className = "#{gz.Css \ink-button} #{gz.Css \toggle}"
        btn.style.padding = '0.16em 0.5em'
        btn.innerHTML = "En progreso
            &nbsp;<span class='#{gz.Css \icon-caret-down}'></span>"

        ul = gz.newel \ul
        ul.className = gz.Css \dropdown-menu
        ul.innerHTML = "
            <li class='#{gz.Css \heading}'>
              Estado
            </li>
            <li class='#{gz.Css \separator-above}
                     \ #{gz.Css \active}'>
              <a href='javascript:void(0)'>En progreso</a>
            </li>
            <li>
              <a href='javascript:void(0)'>Finalizado</a>
            </li>"

        dd.appendChild btn
        dd.appendChild ul

        new gz.Ink.UI.Toggle btn, \target : ul

        dd

    createBarProgress: ->
        # (-o-)
        per = Math.random! * 100
        color = if per < 20 then gz.Css \red else if 20 <= per < 69 then gz.Css \orange else gz.Css \green # :)
        "<div class='#{gz.Css \ink-progress-bar}' style='margin-bottom:0'><span class='#{gz.Css \caption}'>#{Math.ceil per}%</span><div class='#{gz.Css \bar} #color' style='width:#per%'></div></div>"

    createOptionsButton: (operation) ->
        # (-o-)
        "<button class='#{gz.Css \ink-button} #{gz.Css \button-edit}' style='padding:0.16em 0.5em' data-id='#{operation[\id]}'><span class='#{gz.Css \icon-edit}' style='margin-right:-0.1em'></span></button>"

    initialize: !(_, @desktop) ->
        @el.innerHTML = '<h3>Registro de operaciones</h3>'

        @createTable <[ Cliente Estado Progreso &nbsp; ]>

        operations = new OperationCollection
        operations.fetch do
            \success : gz.tie @, !(_, operations) ->
                for operation in operations
                    # (-o-) improve add DOM element
                    #       to table
                    @addRow [
                        operation[\customer][\name]
                        @createStatusButton!
                        @createBarProgress!
                        @createOptionsButton operation
                    ]
                @showTable!

OperationsView.menuCaption = 'Operaciones'
module.exports = OperationsView
