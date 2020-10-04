SS_Shared_GetPlotsCount = function(plotType)
  if (not(plotType == 'plots') and not(plotType == 'leadingPlots')) then
    return 0;
  end;

  local count = 0;
  for index, plot in pairs(SS_User[plotType]) do
    count = count + 1;
  end;

  return count;
end;

SS_Shared_MakePlotSelected = function(plotIndex)
  SS_User.settings.selectedPlot = plotIndex;
end;

SS_Shared_MakePlotCurrent = function(plotIndex)
  SS_User.settings.currentPlot = plotIndex;
end;

SS_Shared_GetPlotSummary = function(plotType)
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

SS_Shared_MathRound = function(number)
  if (number == 0) then return 0; end;

  local rounded = 0;
  
  if (math.abs(math.ceil(number) - number) > 0.5) then
    rounded = math.floor(number);
  else
    rounded = math.ceil(number);
  end;

  return rounded;
end;

SS_Shared_SortTable = function(dict)
  local keys = { };
  for key in pairs(dict) do table.insert(keys, key) end;
  table.sort(keys)

  local sortedDict = { };
  for _, key in ipairs(keys) do sortedDict[key] = dict[key] end;
  return sortedDict;
end;

SS_Shared_DrawList = function(target, list, drawSingle)
  if (not(target) or not(list)) then return nil end;

  local childs = { target:GetChildren() };
  for _, child in pairs(childs) do
    child:Hide();
  end
  
  local sortedList = SS_Shared_SortTable(list);
  local counter = 0;
  for index, element in pairs(sortedList) do
      drawSingle(element, index, target);
  end;
end;
