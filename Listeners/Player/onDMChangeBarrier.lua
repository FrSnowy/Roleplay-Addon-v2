SS_Listeners_Player_OnDMChangeBarrier = function(data, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;

  local plotID, updateValue = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  updateValue = SS_Shared_NumFromStr(updateValue);

  local realUpdateValue = updateValue;
  
  if (realUpdateValue == 88005553535) then
    realUpdateValue = SS_Params_GetMaxBarrier() - SS_Params_GetBarrier();
  else
    if (SS_Params_GetBarrier() + realUpdateValue < 0) then
      realUpdateValue = -SS_Params_GetBarrier();
    end;
  end;

  if (not(realUpdateValue == 0)) then
    SS_Params_ChangeBarrier(realUpdateValue, master);
  end;
end;