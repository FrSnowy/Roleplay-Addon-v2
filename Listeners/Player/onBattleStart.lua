SS_Listeners_Player_OnBattleStart = function(battleType)
  return function(phase, author)
    if (battleType == 'phases') then
      SS_BattleControll_BattleInterface:Show();

      if (phase == 'active') then
        SS_BattleControll_StartPlayerActivePhase();
      elseif (phase == 'defence') then
        SS_BattleControll_StartPlayerDefencePhase();
      end;
    end;

    if (not(SS_Plots_Current().battle)) then
      SS_Plots_Current().battle = {}
    end;

    SS_Plots_Current().battle.battleType = battleType;
    SS_Plots_Current().battle.phase = phase;

    PlayerLevelText:SetTextColor(1, 0, 0);
    
    PlaySoundFile('Sound\\Interface\\PVPFlagTakenMono.ogg');
  end;
end;