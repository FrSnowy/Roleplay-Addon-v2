SS_Listeners_Player_OnGHIForceRollSkill = function(data, author)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(author == UnitName('player'))) then return nil; end;
  
  local skill, hidden = strsplit('+', data);
  hidden = hidden == 'true';

  if (not(hidden)) then
    SS_Log_GHIForceRoll();
  end;

  SS_Roll(skill, not(hidden));
end;