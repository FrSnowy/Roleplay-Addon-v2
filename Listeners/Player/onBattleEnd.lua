SS_Listeners_Player_OnBattleEnd = function(data)
  local plotID, kicked = strsplit("+", data);

  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;
  if (not(SS_Plots_Current().battle)) then return nil; end;

  SS_BattleControll_LeaveBattle();
  if (kicked) then
    SS_Log_BattleKicked();
  else
    SS_Log_BattleEnded();
  end;
end;