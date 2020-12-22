local startPhasesBattle = function(startPhase, author)
  SS_Plots_Current().battle = {
    battleType = 'phases',
    phase = startPhase,
    isTurnEnded = false,
  }

  SS_BattleControll_RoundStart('phases', startPhase);
  if (not(author == UnitName('player'))) then
    SS_PtDM_JoinToBattle(author);
  end;
end;

local startInitiativeBattle = function(startPhase, author)
  SS_Plots_Current().battle = {
    battleType = 'initiative',
    isTurnEnded = false,
  }

  local initiative = math.floor(math.random(0, SS_Stats_GetMaxMovementPoints()));
  if (not(author == UnitName('player'))) then
    SS_PtDM_SendBattleInitiative(initiative, SS_Plots_Current().author);
  end;
end;

SS_Listeners_Player_OnBattleStart_StartBattleByType = {
  phases = startPhasesBattle,
  initiative = startInitiativeBattle,
};

SS_Listeners_Player_OnBattleStart = function(data, author)
  if (not(SS_Plots_Current())) then return nil; end;

  local plotID, battleType, startPhase = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then
    return nil;
  end;

  SS_Listeners_Player_OnBattleStart_StartBattleByType[battleType](startPhase, author);
end;

SS_Listeners_Player_OnBattleJoinSuccess = function(battleType)
  if (not(SS_Plots_Current())) then return nil; end;

  return function(data)
    local plotID = strsplit('+', data);
    if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

    if (battleType == 'initiative') then
      local _, phase = strsplit('+', data);
      SS_Plots_Current().battle.phase = phase;
      SS_BattleControll_RoundStart(battleType, phase);
    end;
  
    SS_Log_BattleJoinSuccess();
  end;

end;