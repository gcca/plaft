builtins = require '../builtins'

FieldType = builtins.Types.Field


# Form group
form_group = ->
  tdiv = App.dom.newel \div
  tdiv.Class.add gz.Css \form-group
  tdiv

form_group.withLabel = (labelText) ->
  tdiv = form_group!

  tlabel = App.dom.newel \label
  tlabel.html labelText

  tdiv._append tlabel
  tdiv

_new_field = (_type) ->
  | _type is FieldType.kComboBox => App.dom.newel \select
  | _type is FieldType.kTextEdit => App.dom.newel \textarea
  | _type is FieldType.kCheckBox => App.dom.newel \input
                                      ..type = \checkbox
  | otherwise                    => App.dom.newel \input

form_group.field = (_type) ->
  xfield = _new_field _type
    ..Class = gz.Css \form-control


# Form: two
_form-two-xgroup = (_label) ->
  form_group.withLabel _label
    ..Class += " #{gz.Css \col-lg-6} #{gz.Css \col-md-6}"


# Public
exports <<<
  /**
   * @return {Array<HTMLElement, HTMLElement>}
   *
   * @example
   * <div></div>
   * <button type='button'>
   *   Agregar
   *   <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-plus}'></i>
   * </button>
   */
  addToContainer: ->
    xContainer = App.dom.newel \div

    xButton = App.dom.newel \button
      ..Class = "#{gz.Css \btn} #{gz.Css \btn-default}"
      .._type = 'button'

      ..html "Agregar
              \ <i class='#{gz.Css \glyphicon} #{gz.Css \glyphicon-plus}'>
                </i>"

    [xContainer, xButton]


  _form:
    _group: form_group

    one: '666' # Pending


    half:
      lineEdit: (_name, _label) ->
        _form-two-xgroup _label
          .._append (form_group.field FieldType.kLineEdit).withName _name

      pairSelect: (_nameLeft, _nameRight, _listLeft, _listRight, _label) ->
        xgroup = form_group.withLabel _label
        xgroup.Class += " #{gz.Css \col-lg-6} #{gz.Css \col-md-6}"

        pairSelects = App.shared.shortcuts.xhtml.pairSelects
        [selectLeft, selectRight] = pairSelects _listLeft, _listRight

        selectLeft._name  = _nameLeft
        selectRight._name = _nameRight

        selectLeft.Class  = gz.Css \form-control
        selectRight.Class = gz.Css \form-control

        container = App.dom.newel \div
        subLeft   = App.dom.newel \div
        subRight  = App.dom.newel \div

        subLeft.Class   = "#{gz.Css \col-sm-3}
                         \ #{gz.Css \col-md-3}
                         \ #{gz.Css \col-lg-3}"
        subRight.Class  = "#{gz.Css \col-sm-8}
                         \ #{gz.Css \col-md-8}
                         \ #{gz.Css \col-lg-8}"

        subLeft.css._padding  = '0'
        subRight.css._padding = '0'

        subLeft._append  selectLeft
        subRight._append selectRight

        hspace = App.dom.newel \div
          ..Class = "#{gz.Css \col-sm-1}
                   \ #{gz.Css \col-md-1}
                   \ #{gz.Css \col-lg-1}"

        container._append subLeft
        container._append hspace
        container._append subRight

        xgroup._append container
        xgroup

      checkBox: (_name, _label) ->
        ## xGroup _label
        ##   .._append (form_group.field FieldType.kCheckBox).withName _name

        xgroup = form_group!
          ..Class += " #{gz.Css \col-lg-6} #{gz.Css \col-md-6}"
        tcheck = App.dom.newel \div
                  ..Class = "#{gz.Css \checkbox}"
                  ..html "<label>
                            #_label
                            \ <input type='checkbox' name='#name'>
                          </label>"
        xgroup._append tcheck
        xgroup

    savePatched: ->
      App.shared.shortcuts.xhtml._form.saveButton!
        App.shared._form.patch.saveButton .._first

    saveButton: ->
      xgroup = form_group!
      xgroup.Class += " #{gz.Css \col-md-12}"
      xgroup.html "<button class='#{gz.Css \btn} #{gz.Css \btn-primary}
                                \ #{gz.Css \pull-right}'>
                     Guardar
                   </button>"
      xgroup


  pairSelects: (listLeft, listRight) ->
    optionsFrom = App.shared.shortcuts.html.optionsFrom

    # Create option tags
    optionsLeft  = optionsFrom listLeft
    optionsRight = optionsFrom listRight

    # Create pair selects
    selectLeft  = App.dom.newel \select
    selectRight = App.dom.newel \select

    # Set options
    selectLeft.html  optionsLeft
    selectRight.html optionsRight

    # Synchronize events
    selectLeft.onChange (evt) !->
      xselect = evt._target
      val = @value
      i   = listLeft._index val
      selectRight._value = listRight[i]

    selectRight.onChange (evt) !->
      xselect = evt._target
      val = @value
      i   = listRight._index val
      selectLeft._value = listLeft[i]

    # Return pair array
    [selectLeft, selectRight]
