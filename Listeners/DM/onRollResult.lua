SS_Listeners_DM_OnRollResult = function(data, master)
  -- У: мастер, от: игрок, когда: игрок бросает кубик
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;

  local name, skill, result, efficency, diceMin, diceMax, diceCount, modifier = strsplit('+', data);
  SS_Log_RollResultOfOther(name, skill, result, efficency, diceMin, diceMax, diceCount, modifier);
end;