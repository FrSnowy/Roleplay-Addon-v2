local startPhasesBattle = function(startPhase)
  SS_Plots_Current().battle = {
    battleType = 'phases',
    phase = startPhase,
    isTurnEnded = false,
  }

  SS_BattleControll_RoundStart('phases', startPhase);
end;

local startBattleByType = {
  phases = startPhasesBattle,
};

SS_Listeners_Player_OnBattleStart = function(data, author)
  if (not(SS_Plots_Current())) then return nil; end;

  local battleType, startPhase = strsplit('+', data);
  startBattleByType[battleType](startPhase);
  SS_PtDM_JoinToBattle(author);
end;

SS_Listeners_Player_OnBattleJoinSuccess = function()
  SS_Log_BattleJoinSuccess();
end;


  --[[
    if (not(SS_Plots_Current().battle)) then
      SS_Plots_Current().battle = {
        battleType = battleType,
        isTurnEnded = false,
      }
    end;

    return function(phase, author)
      if (battleType == 'phases') then
        if (not(SS_Plots_Current().battle.phase)) then
          SS_Plots_Current().battle.phase = phase;
        end;
        SS_BattleControll_BattleInterface:Show();

        if (phase == 'active') then
          SS_BattleControll_StartPlayerActivePhase(true);
        elseif (phase == 'defence') then
          SS_BattleControll_StartPlayerDefencePhase(true);
        end;
      end;

      PlayerLevelText:SetTextColor(1, 0, 0);
      PlaySoundFile('Sound\\Interface\\PVPFlagTakenMono.ogg');
      SS_PtDM_JoinToBattle(author);
    end;
end;
--]]