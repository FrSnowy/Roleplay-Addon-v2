SS_Armor_GetDefault = function()
  return 'light';
end;

SS_Armor_GetType = function()
  if (not (SS_Plots_Current())) then return 0; end;
  return SS_Plots_Current().armor;
end;

SS_Armor_SelectType = function(armorType, previousArmorType)
  SS_Plots_Current().armor = armorType;
  SS_Armor_DrawCheck();
  SS_Params_DrawHealth();
  SS_Params_DrawBarrier(previousArmorType);
end;

SS_Armor_DrawCheck = function()
  local armorType = SS_Plots_Current().armor;
  SS_Armor_Menu_Armor_Light:SetChecked('false');
  SS_Armor_Menu_Armor_Medium:SetChecked('false');
  SS_Armor_Menu_Armor_Heavy:SetChecked('false');
  SS_Armor_Menu_Armor_Light_Visual:Hide();
  SS_Armor_Menu_Armor_Medium_Visual:Hide();
  SS_Armor_Menu_Armor_Heavy_Visual:Hide();

  if (armorType == 'light') then
    SS_Armor_Menu_Armor_Light:SetChecked('true')
    SS_Armor_Menu_Armor_Light_Visual:Show();
  elseif (armorType == 'medium') then
    SS_Armor_Menu_Armor_Medium:SetChecked('true')
    SS_Armor_Menu_Armor_Medium_Visual:Show();
  elseif (armorType == 'heavy') then
    SS_Armor_Menu_Armor_Heavy:SetChecked('true')
    SS_Armor_Menu_Armor_Heavy_Visual:Show();
  end;
end;