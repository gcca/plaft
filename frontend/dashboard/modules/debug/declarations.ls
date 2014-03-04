Module = require '../../module'


class Declarations extends App.Collection

  model   : App.model.Declaration
  urlRoot : 'declarations'


class UiDeclarations extends Module

  render: ->
    xtable = App.dom._new \table
      ..Class = gz.Css \table

    xthead = App.dom._new \thead
      ..html "<tr>
                <th>Código</th>
                <th>Cliente</th>
                <th>Documento</th>
                <th>&nbsp;</th>
              </tr>"

    xtbody = App.dom._new \tbody

    declarations = new Declarations
    declarations.fetch do
      _success: (_, declarations) ~>
        for declaration in declarations
          xtr = App.dom._new \tr
          xtr.html "
            <td>#{declaration.\tracking}</td>
            <td>#{declaration.'customer'.\name}</td>
            <td>#{declaration.'customer'.'document'.\type}</td>
            <td>#{declaration.'customer'.'document'.\number}</td>"
          xtbody._append xtr
        xtable._append xthead
        xtable._append xtbody
        @el._append xtable

      _error: ->

    super!

  @@_caption = 'Declaraciones'

module.exports = UiDeclarations
