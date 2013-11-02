model = require '../../model'
BuilderTable = require './builder/table'

DeclarationCollection = model.Declarations

class DeclarationsView extends BuilderTable
    tagName: \div

    initialize: !->
        @el.innerHTML = '<h3>Lista de declaraciones juradas</h3>'

        @createTable <[ ID Cliente Documento ]>

        declarations = new DeclarationCollection
        declarations.fetch do
            \success : gz.tie @, !(_, declarations) ->
                for declaration in declarations
                    @addRow [
                        "<b>#{declaration[\trackingId]}</b>"
                        declaration[\customer][\name]
                        declaration[\customer][\documentNumber]
                    ]
                @showTable!

DeclarationsView.menuCaption = 'Declaraciones'
module.exports = DeclarationsView
