module.exports = class UserView extends gz.GView

  tagName: \div

  /** @private */ @menuCaption = 'Usuario'
  /** @private */ @menuIcon = gz.Css \icon-user
  /** @private */ @menuTitle = 'Configuración de usuario'

  render: ->
    super!
