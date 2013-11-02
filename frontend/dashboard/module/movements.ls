/** Movements View
 *
 * Cada declaración recepcionada y registrada, en el software, se convierte
 * en un movimiento.
 */
model = require '../../model'
BuilderTable = require './builder/table'

MovementCollection = model.Movements

class MovementsView extends BuilderTable

    initialize : ->
        # Constructor
        @el.innerHTML = "
        <h3>Movimientos</h3>
        "

        @createTable <[ Orden Cliente ]>

        movements = new MovementCollection
        movements.fetch do
            \success : gz.tie @, !(_, movements) ->
                for movement in movements
                    @addRow [
                        movement[\dispatchOrder]
                        movement[\customer][\name]
                    ]
                @showTable!

MovementsView.menuCaption = 'Movimientos'
module.exports = MovementsView
