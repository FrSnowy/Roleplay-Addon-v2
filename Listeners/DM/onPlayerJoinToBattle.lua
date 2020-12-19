SS_Listeners_DM_OnPlayerJoinToBattle = function(plotID, player)
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle) or not(SS_LeadingPlots_Current().battle.started) or not(SS_LeadingPlots_Current().battle.players)) then return nil; end;

  if (not(SS_User.settings.currentPlot == plotID)) then return nil; end;

  SS_LeadingPlots_Current().battle.players[player] = {
    isTurnEnded = false,
  };

  SS_Log_PlayerJoinedToBattle(player);
  SS_DMtP_PlayerJoinSuccess(player);
end;