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