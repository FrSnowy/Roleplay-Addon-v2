local startPhasesBattle = function(startPhase)
  SS_Plots_Current().battle = {
    battleType = 'phases',
    phase = startPhase,
    isTurnEnded = false,
  }

  SS_BattleControll_RoundStart('phases', startPhase);
end;

SS_Listeners_Player_OnBattleStart_StartBattleByType = {
  phases = startPhasesBattle,
};

SS_Listeners_Player_OnBattleStart = function(data, author)
  if (not(SS_Plots_Current())) then return nil; end;

  local plotID, battleType, startPhase = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then
    return nil;
  end;
  SS_Listeners_Player_OnBattleStart_StartBattleByType[battleType](startPhase);
  SS_PtDM_JoinToBattle(author);
end;

SS_Listeners_Player_OnBattleJoinSuccess = function(plotID)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  SS_Log_BattleJoinSuccess();
end;