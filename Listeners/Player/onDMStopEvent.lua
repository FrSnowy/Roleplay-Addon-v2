SS_Listeners_Player_OnDMStopEvent = function(plotID, master)
  -- У: Игрок, от: Мастер, когда: мастер нажал кнопку "завершить событие"
  if (not(plotID) or not(master)) then return nil; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if (not(SS_Plots_Current().author == master)) then return false; end;

  local name = SS_Plots_Current().name;

  SS_User.settings.currentPlot = nil;
  SS_PlotController_OnDeactivate();
  SS_Log_DMStopEvent(name);
end;