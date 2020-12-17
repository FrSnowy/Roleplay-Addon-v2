SS_Listeners_Player_OnBattleStart = function(battleType)
  return function(firstStep, author)
    if (battleType == 'phases') then
      SS_BattleControll_BattleInterface:Show();
    end;

    if (not(SS_Plots_Current().battle)) then
      SS_Plots_Current().battle = {}
    end;

    SS_Plots_Current().battle.battleType = battleType;
    SS_Plots_Current().battle.step = firstStep;

    PlayerLevelText:SetTextColor(1, 0, 0);
    
    PlaySoundFile('Sound\\Interface\\PVPFlagTakenMono.ogg');
  end;
end;