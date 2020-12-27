SS_Listeners_Player_OnSendDamage = function(data, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(master == SS_Plots_Current().author)) then return nil; end;

  local plotID, fullDMG, ignoreArmor = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  local dmg = SS_Shared_NumFromStr(fullDMG);
  ignoreArmor = ignoreArmor == 'true';

  local currentHP = SS_Params_GetHealth();
  local currentBarrier = SS_Params_GetBarrier();

  if (currentHP <= 0) then return nil; end;

  if (ignoreArmor) then
    if (currentHP <= dmg) then
      SS_Plots_Current().params.health = 0;
    else
      SS_Plots_Current().params.health = SS_Plots_Current().params.health - dmg;
    end;
    SS_Log_RecievedDamage(dmg, true);
  else
    if (currentBarrier > 0) then
      if (currentBarrier < dmg) then
        dmg = dmg - currentBarrier;
        SS_Plots_Current().params.barrier = 0;

        if (currentHP < dmg) then
          SS_Plots_Current().params.health = 0;
        else
          SS_Plots_Current().params.health = SS_Plots_Current().params.health - dmg;
        end;
        SS_Log_BarrierGetDMGDestoyedAndSendDMGToHP(currentBarrier, dmg);
      elseif (currentBarrier == dmg) then
        SS_Plots_Current().params.barrier = 0;
        SS_Log_BarrierGetDMGAndDestoyed(dmg);
      else
        SS_Plots_Current().params.barrier = SS_Plots_Current().params.barrier - dmg;
        SS_Log_BarrierGetDMG(dmg);
      end;
    else
      if (currentHP < dmg) then
        SS_Plots_Current().params.health = 0;
      else
        SS_Plots_Current().params.health = SS_Plots_Current().params.health - dmg;
      end;
      SS_Log_RecievedDamage(dmg, false);
    end;
  end;
  
  SS_Params_DrawHealth();
  SS_Params_DrawBarrier();

  if (SS_Plots_Current().params.health == 0) then
    SS_Log_NoHP(dmg);
    PlaySoundFile('Sound\\Interface\\AlarmClockWarning3.ogg');
  end;  

  SS_Shared_IfOnline(master, function()
    SS_PtDM_Params(master);
    SS_PtDM_InspectInfo("update", master);
    SS_PtDM_RecievedDamage(fullDMG, SS_Params_GetHealth(), master);
  end);
end;