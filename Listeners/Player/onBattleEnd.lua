SS_Listeners_Player_OnBattleEnd = function(plotID)
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;
  if (not(SS_Plots_Current().battle)) then return nil; end;

  SS_BattleControll_LeaveBattle();
  SS_Log_BattleEnded();
end;