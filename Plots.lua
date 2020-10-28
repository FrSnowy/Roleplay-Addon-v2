SS_Plots_Create = function(plotUniqueName, plotName, authorName)
  if (not SS_User) then return nil end;

  SS_User.plots[plotUniqueName] = {
    name = plotName,
    armor = SS_Armor_GetDefault(),
    skills = SS_Skills_GetList(),
    stats = SS_Stats_GetList(),
    params = SS_Params_GetList(),
    progress = SS_Progress_GetList(),
    modifiers = SS_Modifiers_GetList(),
    author = authorName,
  };
end;

SS_Plots_Includes = function(plotIndex)
  if (not(SS_User) or not(SS_User.plots)) then return false; end;
  return not(not(SS_User.plots[plotIndex]))
end;

SS_Plots_Current = function()
  if (not (SS_User) or not(SS_User.plots) or not(SS_User.settings) or not (SS_User.settings.currentPlot)) then return nil end;
  return SS_User.plots[SS_User.settings.currentPlot];
end;

SS_Plots_Selected = function()
  if (not (SS_User) or not(SS_User.plots) or not(SS_User.settings) or not (SS_User.settings.selectedPlot)) then return nil end;
  return SS_User.plots[SS_User.settings.selectedPlot];
end;

SS_Plots_Count = function()
  local count = 0;
  for index in pairs(SS_User.plots) do
    count = count + 1;
  end;
  return count;
end;