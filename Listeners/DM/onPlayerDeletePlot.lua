SS_Listeners_DM_OnPlayerDeletePlot = function(plotID, player)
  -- У: Мастер, от: игрок, когда: игрок удаляет текущий сюжет мастера
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  SS_Shared_RemoveFrom(SS_LeadingPlots_Current().players)(function(playerName)
    return player == playerName;
  end);
  SS_PlotController_DrawPlayers();
  SS_Log_PlotRemovedBy(player, SS_Plots_Current().name);

  if (player == UnitName("target")) then
    SS_Draw_HideCurrentTargetVisual()
  end;
end;