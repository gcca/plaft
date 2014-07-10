/** @module dashboard.modules.register */

FieldType = App.builtins.Types.Field


/** -----------
 *  Stakeholder
 *  -----------
 * @class UiStakeholder
 * @extends View
 */
class Stakeholder extends App.View

  /** @override */
  _toJSON: -> @supplier-form._toJSON!
#    importer : @importer-form._toJSON!

  /**
   * Create supplier-importer busines-person stakeholder form.
   * @param {string} _legend
   * @param Array.<Options> stakeholder-fields
   * @see @render
   */
  stakeholder-form: (_legend, stakeholder-fields) ->
    _form = App.dom._new \form
      ..Class = gz.Css \col-md-6

    fbuilder = App.shared.shortcuts.xhtml._form.Builder.New _form
    fbuilder.fieldset _legend, stakeholder-fields
    fbuilder.render!
    fbuilder.free!

    _form

  /** @override */
  render: (customer, io-class, is-stakeholder-business) ->
    @clean!

#    if customer.isBusiness
#      supplier-fields = @stakeholder-business-supplier-fields
#      importer-fields = @stakeholder-business-importer-fields
#    else
#      supplier-fields = @stakeholder-person-supplier-importer-fields
#      importer-fields = @stakeholder-person-supplier-importer-fields

    if is-stakeholder-business
      supplier-fields = @stakeholder-business-importer-fields
    else
      supplier-fields = @stakeholder-person-supplier-importer-fields

    if io-class is \Ingreso
      supplier-label = 'Proveedor'
    else
      supplier-label = 'Destinatario Embarque'

    @supplier-form = @stakeholder-form supplier-label, supplier-fields
#    @supplier-form = @stakeholder-form 'Datos proveedor'  supplier-fields
#    @importer-form = @stakeholder-form 'Datos importador' importer-fields

    @el._append @supplier-form
#    @el._append @importer-form

    @supplier-form = $ @supplier-form
#    @importer-form = $ @importer-form

    super!

  /** @private */ supplier-form : null
  /** @private */ importer-form : null

  /**
   * Fields for business supplier stakeholder.
   * @type Array.<Options>
   * @see @addStakeholderForm
   * @private
   */
  stakeholder-business-supplier-fields:
    * _name  : 'name'
      _label : 'Razón social'
      _class : gz.Css \col-md-12

    * _name  : 'object'
      _label : 'Objeto social'
      _class : gz.Css \col-md-12

    * _name  : 'address'
      _label : 'Nombre y N&ordm; via dirección'
      _class : gz.Css \col-md-12

    * _name  : 'phone'
      _label : 'Teléfono de la persona'
      _class : gz.Css \col-md-12

  /**
   * Fields for business importer stakeholder.
   * @type Array.<Options>
   * @see @addStakeholderForm
   * @private
   */
  stakeholder-business-importer-fields:
    * _name  : 'name'
      _label : 'Razón social'
      _class : gz.Css \col-md-12

    * _name  : 'object'
      _label : 'Objeto social'
      _class : gz.Css \col-md-12

    * _name  : 'address'
      _label : 'Nombre y N&ordm; via dirección'
      _class : gz.Css \col-md-12

    * _name  : 'phone'
      _label : 'Teléfono de la persona'
      _class : gz.Css \col-md-12

    * _name  : 'document[number]'
      _label : 'RUC'
      _class : gz.Css \col-md-12

    * _name  : 'activity'
      _label : 'Actividad económica principal'
      _class : gz.Css \col-md-12

    * _name  : 'country'
      _label : 'Código país origen'
      _class : gz.Css \col-md-12
      _type  : FieldType.kComboBox
      _options : ['PE']

  /**
   * Fields for person supplier-importer stakeholder.
   * @type Array.<Options>
   * @see @addStakeholderForm
   * @private
   */
  stakeholder-person-supplier-importer-fields:
    * _name  : 'document[type]'
      _label : 'Tipo documento'
      _class : gz.Css \col-md-12
      _type  : FieldType.kComboBox
      _options : App.shared.lists.IDENTIFICATION

    * _name  : 'document[number]'
      _label : 'N&ordm; Documento identidad'
      _class : gz.Css \col-md-12

    * _name  : 'residence'
      _label : 'Condición residencia'
      _class : gz.Css \col-md-12

    * _name  : 'issuance'
      _label : 'País emisión documento'
      _class : gz.Css \col-md-12

    * _name  : 'pep'
      _label : 'Persona PEP'
      _class : gz.Css \col-md-12

    * _name  : 'pep_office'
      _label : 'PEP Cargo público'
      _class : gz.Css \col-md-12

    * _name  : 'surname_father'
      _label : 'Apellido paterno'
      _class : gz.Css \col-md-12

    * _name  : 'surname_mother'
      _label : 'Apellido materno'
      _class : gz.Css \col-md-12

    * _name  : 'names'
      _label : 'Nombres'
      _class : gz.Css \col-md-12

    * _name  : 'nationality'
      _label : 'Nacionalidad'
      _class : gz.Css \col-md-12

    * _name  : 'birthday'
      _label : 'Fecha nacimiento'
      _class : gz.Css \col-md-12

    * _name  : 'activity'
      _label : 'Ocupación, oficio'
      _class : gz.Css \col-md-12

    * _name  : 'employer'
      _label : 'Empleador/Dependiente'
      _class : gz.Css \col-md-12

    * _name  : 'mean-income'
      _label : 'Ingreso promedio/Dependiente'
      _class : gz.Css \col-md-12


/** @export */
module.exports = Stakeholder


# vim: ts=2 sw=2 sts=2 et:
