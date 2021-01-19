SS_Listeners_Player_OnBattleEnd = function(data, master)
  local plotID, kicked = strsplit("+", data);

  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;
  if (not(master == SS_Plots_Current().author)) then return nil; end;
  if (not(SS_Plots_Current().battle)) then return nil; end;

  print(SS_Plots_Current().battle.battleType);

  if (kicked) then
    if (SS_Plots_Current().battle.battleType == 'phases' and SS_Plots_Current().battle.phase == 'active') then
      SS_PtDM_EndBattleTurn(master);
    end;
  end;
  SS_BattleControll_LeaveBattle();
  if (kicked) then
    SS_Log_BattleKicked();
  else
    SS_Log_BattleEnded();
  end;
end;