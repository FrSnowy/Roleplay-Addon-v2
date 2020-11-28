SS_Listeners_DM_OnPlayerDeactivatePlot = function(plotID, player)
  -- У: Мастер, от: игрок, когда: игрок деактивирует текущий сюжет
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  local plotName = SS_LeadingPlots_Current().name;
  SS_Log_PlotDeactivatedBy(player, plotName);

  if (player == UnitName("target")) then
    SS_Draw_HideCurrentTargetVisual()
  end;
end;