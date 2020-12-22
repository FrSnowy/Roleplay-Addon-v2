SS_Listeners_DM_OnPlayerBattleTurnEnd = function(plotID, player)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  if (not(SS_LeadingPlots_Current().battle) or not(SS_LeadingPlots_Current().battle.players) or not(SS_LeadingPlots_Current().battle.players[player])) then return nil; end;

  SS_LeadingPlots_Current().battle.players[player].isTurnEnded = true;

  local playersCount = 0;
  local completedTurnPlayers = 0;
  SS_Shared_ForEach(SS_LeadingPlots_Current().battle.players)(function(p)
    playersCount = playersCount + 1;
    if (p.isTurnEnded) then
      completedTurnPlayers = completedTurnPlayers + 1;
    end;
  end);

  SS_Log_BattlePlayerEndTurn(player, playersCount, completedTurnPlayers);

  
  if (SS_LeadingPlots_Current().battle.battleType == 'phases') then
    if (playersCount == completedTurnPlayers) then
      SS_BattleControll_RoundNext()
    end;
  elseif(SS_LeadingPlots_Current().battle.battleType == 'initiative') then
    SS_BattleControll_RoundNext()
  end;
end;