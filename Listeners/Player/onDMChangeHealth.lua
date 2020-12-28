SS_Listeners_Player_OnDMChangeHealth = function(data, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;

  local plotID, updateValue = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  updateValue = SS_Shared_NumFromStr(updateValue);

  local realUpdateValue = updateValue;
  if (SS_Params_GetHealth() + realUpdateValue > SS_Params_GetMaxHealth()) then
    realUpdateValue = SS_Params_GetMaxHealth() - SS_Params_GetHealth();
  elseif (SS_Params_GetHealth() + realUpdateValue < 0) then
    realUpdateValue = -SS_Params_GetHealth();
  end;

  if (not(realUpdateValue == 0)) then
    SS_Params_ChangeHealth(realUpdateValue, master);
    SS_Log_HealthChanged(realUpdateValue, master);
  end;
end;