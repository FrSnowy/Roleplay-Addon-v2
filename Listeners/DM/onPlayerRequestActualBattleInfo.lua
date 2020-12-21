SS_Listeners_DM_OnPlayerRequestActualBattleInfo = function(plotID, player)
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().battle) or not(SS_LeadingPlots_Current().battle.players) or not(SS_LeadingPlots_Current().battle.players[player])) then
    -- Конец боя
  end;

  SS_DMtP_SendActualBattleInfo(SS_LeadingPlots_Current().battle.battleType, SS_LeadingPlots_Current().battle.phase, SS_LeadingPlots_Current().battle.players[player].isTurnEnded, player);
end;