SS_Listeners_DM_OnPlayerHealthChange = function(data, player)
  if (not(data) or not(player)) then return nil; end;
  if (player == UnitName("player")) then return nil; end;
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  local plotID, updateValue = strsplit("+", data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  updateValue = SS_Shared_NumFromStr(updateValue);
  SS_Log_PlayerHealthChanged(updateValue, player);
end;