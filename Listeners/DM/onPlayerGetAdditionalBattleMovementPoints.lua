SS_Listeners_DM_OnPlayerGetAdditionalBattleMovementPoints = function(data, player)
  if (not(SS_LeadingPlots_Current())) then return nil; end;

  local plotID, movementPoints = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  SS_Log_PlayerGetAdditionalBattleMovementPoints(SS_Shared_NumFromStr(movementPoints), player);
end;