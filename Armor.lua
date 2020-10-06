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

SS_Armor_GetModifierFor = function(skillName, dices)
  local armorType = SS_Armor_GetType();

  if (armorType == 'light') then return 0; end;

  local penaltyFor = {
    medium = {
      magic = -0.1,
      missing = -0.05,
      hands = -0.05,
      acrobats = -0.05,
      stealth = -0.05,
    },
    heavy = {
      range = -0.12,
      magic = -0.25,
      missing = -0.2,
      hands = -0.3,
      observation = -0.12,
      acrobats = -0.25,
      stealth = -0.3,
    }
  }

  if (not(penaltyFor[armorType]) or not(penaltyFor[armorType][skillName])) then
    return 0;
  end;

  local modifier = dices.to * penaltyFor[armorType][skillName];
  return SS_Shared_MathRound(modifier);
end;