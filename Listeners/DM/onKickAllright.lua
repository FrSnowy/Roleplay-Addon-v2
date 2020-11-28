SS_Listeners_DM_OnKickAllright = function(plotID, player)
  -- У: Мастер, от: игрок, когда: игрок успешно исключился из сюжета
  if (plotID == SS_User.settings.currentPlot) then
    SS_Shared_RemoveFrom(SS_LeadingPlots_Current().players)(function(playerName)
      return player == playerName;
    end);
    SS_PlotController_DrawPlayers();
  end;
  SS_Plot_Controll_PlayerInfo:Hide();

  if (player == UnitName("target")) then
    SS_Draw_HideCurrentTargetVisual()
  end;

  SS_Log_PlayerKickedSuccessfully(player);
end;