SS_Listeners_DM_OnPlayerLeaveBattle = function(plotID, player)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  SS_Log_PlayerLeavesBattle(player);
  
  if (not(SS_LeadingPlots_Current().battle) or not(SS_LeadingPlots_Current().battle.players)) then return nil; end;
  
  SS_LeadingPlots_Current().battle.players[player] = nil;

  local playersCount = 0;
  SS_Shared_ForEach(SS_LeadingPlots_Current().battle.players)(function()
    playersCount = playersCount + 1;
  end);

  if (playersCount == 0) then
    SS_BattleControll_LeaveBattle();
    SS_Log_AllPlayersLeavedBattle();
    return;
  end;

  if (SS_LeadingPlots_Current().battle.battleType == 'initiative') then
    if (SS_LeadingPlots_Current().battle.phase == player) then
      SS_BattleControll_RoundNext();
    end;
    SS_BattleControll_RemovePlayerFromInitiative(player);
  end;
end;