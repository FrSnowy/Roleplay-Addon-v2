SS_Listeners_DM_OnPlayerGetDamage = function(data, player)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  
  local plotID, dmg, currentHP = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  dmg = SS_Shared_NumFromStr(dmg);
  currentHP = SS_Shared_NumFromStr(currentHP);

  SS_Log_PlayerRecievedDamage(dmg, currentHP, player);
end;