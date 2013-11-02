class NewOperationView extends gz.GView
        tagName: \div

        initialize: !->
                @el.innerHTML = '<h3>New Operation</h3>'

NewOperationView.menuCaption = 'Nueva operación'
