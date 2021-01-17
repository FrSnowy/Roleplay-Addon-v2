SS_Listeners_Player_OnDMStopMusic = function(plotID, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  StopMusic();
end;