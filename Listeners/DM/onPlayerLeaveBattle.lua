SS_Listeners_DM_OnPlayerLeaveBattle = function(plotID, player)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  SS_Log_PlayerLeavesBattle(player);
end;