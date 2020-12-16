SS_Listeners_Player_OnGHIRemoveTargetModifier = function(data, author)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(author == UnitName('player'))) then return nil; end;

  local modifierID, modifierType = strsplit('+', data);
  if (not(modifierType == 'stats') and not(modifierType == 'skills')) then return nil; end;

  local modifier = SS_Plots_Current().modifiers[modifierType][modifierID];
  if (not(modifier)) then return nil; end;
end;