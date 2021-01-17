SS_Listeners_Player_OnDMStartMusic = function(data, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;

  local plotID, category, group, track = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  PlayMusic(SS_LIST_OF_SOUNDS[category].list[group][track].track);
end;