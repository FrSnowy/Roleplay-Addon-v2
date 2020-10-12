SS_LeadingPlots_Create = function(plotUniqueName, plotName, authorName)
  if (not SS_User) then return nil end;

  SS_User.leadingPlots[plotUniqueName] = {
    name = plotName,
    players = { authorName }
  };
end;

SS_LeadingPlots_Current = function()
  if (not (SS_User) or not(SS_User.leadingPlots) or not(SS_User.settings) or not (SS_User.settings.currentPlot)) then return nil end;
  return SS_User.leadingPlots[SS_User.settings.currentPlot];
end;

SS_LeadingPlots_Selected = function()
  if (not (SS_User) or not(SS_User.leadingPlots) or not(SS_User.settings) or not (SS_User.settings.selectedPlot)) then return nil end;
  return SS_User.leadingPlots[SS_User.settings.selectedPlot];
end;

SS_LeadingPlots_Includes = function(plotIndex)
  if (not(SS_User) or not(SS_User.leadingPlots)) then return false; end;
  return not(not(SS_User.leadingPlots[plotIndex]))
end;

SS_LeadingPlots_Count = function()
  local count = 0;
  for index in pairs(SS_User.plots) do
    count = count + 1;
  end;
  return count;
end;

SS_LeadingPlots_AddPlayer = function(playerName)
  local isPlayerOnPlot = SS_Shared_Includes(SS_LeadingPlots_Current().players)(function(player)
    return player == playerName;
  end);

  if (not(isPlayerOnPlot)) then
    table.insert(SS_LeadingPlots_Current().players, playerName);
    SS_PlotController_DrawPlayers();
  end;
end;