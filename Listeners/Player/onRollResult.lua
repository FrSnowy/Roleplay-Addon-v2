SS_Listeners_Player_OnRollResult = function(data, master)
  -- У: мастер, от: игрок, когда: игрок бросает кубик
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;

  local name, skill, result, efficency, diceMin, diceMax, diceCount, modifier = strsplit('+', data);
  SS_Log_RollResultOfOther(name, skill, result, efficency, diceMin, diceMax, diceCount, modifier);
  SS_Roll_SaveResultToMembersTable(name, result);
end;

SS_Listeners_Player_OnNPCRollResult = function(data, master)
  -- У: мастер, от: игрок, когда: игрок бросает кубик
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;

  local plotID, name, result = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  SS_Log_RollResultOfNPC(name, result);
end;