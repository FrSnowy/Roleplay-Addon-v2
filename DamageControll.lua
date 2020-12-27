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