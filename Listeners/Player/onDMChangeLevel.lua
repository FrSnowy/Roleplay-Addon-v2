SS_Listeners_Player_OnDMChangeLevel = function(data, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;

  local plotID, updateValue = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  updateValue = SS_Shared_NumFromStr(updateValue);

  SS_Progress_UpdateLevel(updateValue, master);
end;