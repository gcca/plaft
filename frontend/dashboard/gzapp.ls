# ----------
# Global App
# ----------
module.exports = gzApp = new Object
  _.\extend .., gz.GEvents

# Fecth models CustomsBroker and CustomsBrokerUser
gzApp.customsBroker = new model.CustomsBroker window.'gzps'.\a
  ..jurisdictions =
    names : [..\name for gzApp.customsBroker.get \jurisdictions]
    codes : [..\code for gzApp.customsBroker.get \jurisdictions]

gzApp.user = new model.User window.'gzps'.\b

/** ---------
 *  Shortcuts
 *  ---------
 */
gzApp.shortcuts =
  ui:
    jurisdictions:
      synchronizeSelects: (selectName, selectCode) ->
        selectName.onchange = (evt) ->
          gzApp.customsBroker.jurisdictions
            names = ..names
            codes = ..codes
          vName  = @value
          vIndex = names.indexOf vName
          selectCode.value = codes[vIndex]

        selectCode.onchange = (evt) ->
          gzApp.customsBroker.jurisdictions
            names = ..names
            codes = ..codes
          vName  = @value
          vIndex = codes.indexOf vName
          selectName.value = names[vIndex]

    iHtml:
      jurisdictions:
        optionsSelected: ->
          # Local vars
          gzApp.customsBroker.jurisdictions
            jurisdictionsNames = ..names
            jurisdictionsCodes = ..codes

          # map functions to eval selected
          mapSelected = (vRel, vVal) --> if vVal == vRel then \selected else ''
          mapSelectedName = mapSelected gzApp.user.get \jurisdictionName
          mapSelectedCode = mapSelected gzApp.user.get \jurisdictionCode

          # options Arrays
          optionsName = ["<option #{mapSelectedName vName}>#vName</option>" \
                         for vName in jurisdictionsNames]
          optionsCode = ["<option #{mapSelectedCode vCode}>#vCode</option>" \
                         for vCode in jurisdictionsCodes]

          # returns options
          optionsName       : optionsName
          optionsCode       : optionsCode
