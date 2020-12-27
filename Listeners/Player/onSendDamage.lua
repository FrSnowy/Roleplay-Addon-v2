SS_Listeners_Player_OnSendDamage = function(data, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(master == SS_Plots_Current().author)) then return nil; end;

  local plotID, fullDMG, ignoreArmor = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  local dmg = SS_Shared_NumFromStr(fullDMG);
  ignoreArmor = ignoreArmor == 'true';

  SS_DamageControll_RecieveDamage(dmg, ignoreArmor, master);
end;