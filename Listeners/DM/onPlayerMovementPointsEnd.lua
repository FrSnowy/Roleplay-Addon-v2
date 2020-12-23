SS_Listeners_DM_OnPlayerMovementPointsEnd = function(plotID, player)
  if (player == UnitName("player")) then return nil; end;
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle) or not(SS_LeadingPlots_Current().battle.started)) then return nil; end;
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  SS_Log_PlayerMovingWithoutPoints(player);
end;