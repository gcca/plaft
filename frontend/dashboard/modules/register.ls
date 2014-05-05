/** @module dashboard.modules.register */

Module = require '../module'

FieldType = App.builtins.Types.Field


/** --------
 *  Register
 *  --------
 * @class UiRegister
 * @extends Module
 */
class Register extends Module

  /** @protected */ @@_caption = 'Ingreso de Operación'
  /** @protected */ @@_icon    = gz.Css \glyphicon-file

  /** @override */
  render: ->
    @ui.desktop._search._focus!
    super!


/** @export */
module.exports = Register
