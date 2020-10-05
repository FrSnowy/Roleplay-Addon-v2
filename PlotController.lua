SS_PlotController_CreateBoth = function(plotName, authorName)
  local plotUniqueName = plotName..'-'..random(1, 1000000)..'-'..random(1, 1000000)..'-'..random(1, 1000000);

  SS_Plots_Create(plotUniqueName, plotName, authorName);
  SS_LeadingPlots_Create(plotUniqueName, plotName, authorName);
  return true;
end;

SS_PlotController_Select = function(plotIndex)
  if (plotIndex == nil) then SS_User.settings.selectedPlot = nil; return; end;
  if (not(SS_Plots_Includes(plotIndex)) or not(SS_LeadingPlots_Includes(plotIndex))) then return false; end;
  SS_User.settings.selectedPlot = plotIndex;
end;

SS_PlotController_MakeCurrent = function(plotIndex)
  if (plotIndex == nil) then SS_User.settings.currentPlot = nil; return; end;
  if (not(SS_Plots_Includes(plotIndex)) or not(SS_LeadingPlots_Includes(plotIndex))) then return false; end;
  SS_User.settings.currentPlot = plotIndex;
end;

SS_PlotController_GetCountOf = function(plotType)
  if (not(plotType == 'plots') and not(plotType == 'leadingPlots')) then
    return 0;
  end;

  if (plotType == 'plots') then return SS_Plots_Count(); end;
  if (plotType == 'leadingPlots') then return SS_LeadingPlots_Count(); end;
end;

SS_PlotController_GetSummaryOf = function(plotType)
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