SS_Listeners_Player_OnRecieveActualBattleInfo = function(data, master)
  if (not(SS_Plots_Current())) then return nil; end;

  if (not(SS_Plots_Current().battle)) then return nil; end;

  local plotID, battleType, phase, isTurnEnded = strsplit('+', data);

  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  isTurnEnded = isTurnEnded == 'true';

  SS_Plots_Current().battle.battleType = battleType;
  SS_Plots_Current().battle.isTurnEnded = isTurnEnded;

  if (battleType == 'phases') then
    if (isTurnEnded) then
      SS_Plots_Current().battle.phase = 'waiting';
    else
      SS_Plots_Current().battle.phase = phase;
    end;
  else
    SS_Plots_Current().battle.phase = phase;
  end;

  SS_BattleControll_RoundStart(SS_Plots_Current().battle.battleType, SS_Plots_Current().battle.phase, true);
end;