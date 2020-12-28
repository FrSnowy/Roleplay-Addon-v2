SS_DamageControll_Show = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_DamageControll_Menu:Show();
  SS_Event_Controll_DamageControll_Button:SetText("- Урон");
  SS_DamageControll_Data = {
    target = 'player',
    ignoreArmor = false,
  };
end;

SS_DamageControll_Hide = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_DamageControll_Menu:Hide();
  SS_Event_Controll_DamageControll_Button:SetText("+ Урон");
  SS_DamageControll_Menu_Check_Target_Player:SetChecked(true);
  SS_DamageControll_Menu_Check_Target_Group:SetChecked(false);
  SS_DamageControll_Menu_Check_Ignore_Armor:SetChecked(false);
  SS_DamageControll_Menu_Dmg_Input:SetText("");
  SS_DamageControll_Data = nil;
end;

SS_DamageControll_SelectTarget = function(target)
  SS_DamageControll_Data.target = target;
  SS_DamageControll_Menu_Check_Target_Player:SetChecked(false);
  SS_DamageControll_Menu_Check_Target_Group:SetChecked(false);

  if (target == 'player') then
    SS_DamageControll_Menu_Check_Target_Player:SetChecked(true);
  elseif (target == 'group') then
    SS_DamageControll_Menu_Check_Target_Group:SetChecked(true);
  end;
end;

SS_DamageControll_SelectIgnoreArmor = function(ignoreArmor)
  SS_DamageControll_Data.ignoreArmor = ignoreArmor;
  SS_DamageControll_Menu_Check_Ignore_Armor:SetChecked(ignoreArmor);
end;

SS_DamageControll_SendDamage = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  local damage = SS_DamageControll_Menu_Dmg_Input:GetText();

  if (not(damage) or damage == '' or damage == '0') then
    SS_Log_NoDMGValue();
    return nil;
  end;

  SS_DMtP_SendDamage(damage);
end;

SS_DamageControll_RecieveDamage = function(damage, ignoreArmor, master)  
  local dmg = SS_Shared_NumFromStr(damage);

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
    SS_PtDM_RecievedDamage(damage, SS_Params_GetHealth(), master);
  end);
end;