SS_Listeners_Player_OnDMStopEvent = function(plotID, master)
  -- У: Игрок, от: Мастер, когда: мастер нажал кнопку "завершить событие"
  if (not(plotID) or not(master)) then return nil; end;

  if (SS_Modal_EventStart:IsVisible()) then
    local plot = SS_User.plots[plotID];
    if (not(plot)) then return nil; end;

    local name = plot.name;
    if (SS_Modal_EventStart_PlotName:GetText() == name) then
      SS_Modal_EventStart:Hide();
      SS_Log_DMStopEvent(name);
      return nil;
    end;
  end;

  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if (not(SS_Plots_Current().author == master)) then return false; end;

  local name = SS_Plots_Current().name;

  SS_PlotController_OnDeactivate();
  SS_User.settings.currentPlot = nil;
  SS_Log_DMStopEvent(name);
end;