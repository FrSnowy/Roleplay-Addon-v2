SS_ApplicationLoad = function()
  SS_User = SS_User or {
    plots = { },
    leadingPlots = { },
    battle = nil,
    settings = {
      currentPlot = nil,
      selectedPlot = nil,
      acceptInvites = true,
      displayDiceInfo = false,
      displayModifierInfo = true,
    },
  };
  if (SS_User.plots == nil) then SS_User.plots = { }; end;
  if (SS_User.leadingPlots == nil) then SS_User.leadingPlots = { }; end;
  if (SS_User.settings == nil) then SS_User.settings = { currentPlot = nil, selectedPlot = nil, displayDiceInfo = false, acceptInvites = false }; end;
end;