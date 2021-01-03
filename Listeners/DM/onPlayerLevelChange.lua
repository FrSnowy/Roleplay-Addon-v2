SS_Listeners_DM_OnPlayerLevelChange = function(data, player)
  if (not(data) or not(player)) then return nil; end;
  if (player == UnitName("player")) then return nil; end;
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  local plotID, playerLevel = strsplit("+", data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  playerLevel = SS_Shared_NumFromStr(playerLevel);
  SS_Log_PlayerLevelChanged(playerLevel, player);
end;