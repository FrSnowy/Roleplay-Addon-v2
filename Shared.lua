SS_getPlotsCount = function(plotType)
  if (not(plotType == 'plots') and not(plotType == 'leadingPlots')) then
    return 0;
  end;

  local count = 0;
  for index, plot in pairs(SS_User[plotType]) do
    count = count + 1;
  end;

  return count;
end;

SS_MakePlotSelected = function(plotIndex)
  SS_User.settings.selectedPlot = plotIndex;
end;

SS_MakePlotCurrent = function(plotIndex)
  SS_User.settings.currentPlot = plotIndex;
end;

SS_GetPlotSummary = function(plotType)
  if (not(plotType == 'current') and not(plotType == "selected")) then
    return { };
  end;
 
  local plot = { };

  local lookFor = nil;
  if (plotType == 'current') then
    lookFor = 'currentPlot';
  else
    lookFor = 'selectedPlot';
  end;

  if (SS_User.settings[lookFor] == nil) then
    return nil;
  end;

  if (SS_User.plots[SS_User.settings[lookFor]]) then
    plot.name = SS_User.plots[SS_User.settings[lookFor]].name;
    plot.playerInfo = {
      skills = SS_User.plots[SS_User.settings[lookFor]].skills,
    };
  end;

  if (SS_User.leadingPlots[SS_User.settings[lookFor]]) then
    plot.name = SS_User.leadingPlots[SS_User.settings[lookFor]].name;
    plot.leaderInfo = {
      players = SS_User.leadingPlots[SS_User.settings[lookFor]].players;
    };
  end;

  return plot;
end;