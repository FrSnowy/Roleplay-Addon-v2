SS_Params_GetList = function()
  return {
    health = 2,
    barrier = 0,
  };
end;

SS_Params_GetHealth = function()
  if (not (SS_Plots_Current())) then return 0; end;
  return SS_Plots_Current().params.health;
end;

SS_Params_GetBarrier = function()
  if (not (SS_Plots_Current())) then return 0; end;
  return SS_Plots_Current().params.barrier;
end;

SS_Params_GetMaxHealth = function()
  local sumOfStats = SS_Stats_GetValue('power') + SS_Stats_GetValue('mobility');
  local healthPoints = 2 + math.floor(sumOfStats / 3);
  if (healthPoints < 1) then healthPoints = 1 end;

  local isFullHP = SS_Params_GetHealth() == healthPoints;

  if (SS_Params_GetHealth() > healthPoints) then
    SS_Plots_Current().params.health = healthPoints;
  end;

  -- Ещё флаг, что не в бою
  if (isFullHP) then
    SS_Plots_Current().params.health = healthPoints;
  end;

  return healthPoints;
end;

SS_Params_GetMaxBarrier = function(previousArmorType)
  if (not (SS_Plots_Current())) then return 0; end;

  local armorType = SS_Armor_GetType();

  local maxHP = SS_Params_GetMaxHealth();
  local maxBarrier = 0;

  if (armorType == 'light') then maxBarrier = 0; end;
  if (armorType == 'medium') then
    maxBarrier = math.floor(maxHP / 2);
  end;
  if (armorType == 'heavy') then
    maxBarrier = math.floor(maxHP / 1.5);
  end;

  local previousMaxBarrier = 0;
  if (previousArmorType) then
    if (previousArmorType == 'light') then previousMaxBarrier = 0; end;
    if (previousArmorType == 'medium') then
      previousMaxBarrier = math.floor(maxHP / 2);
    end;
    if (previousArmorType == 'heavy') then
      previousMaxBarrier = math.floor(maxHP / 1.5);
    end;
  end;

  -- Ещё флаг, что не в бою
  if (SS_Params_GetBarrier() == 0 or SS_Params_GetBarrier() > maxBarrier or (previousArmorType and SS_Params_GetBarrier() == previousMaxBarrier)) then
    SS_Plots_Current().params.barrier = maxBarrier;
  end;

  return maxBarrier;
end;

SS_Params_DrawHealth = function()
  local maxHP = SS_Params_GetMaxHealth();
  local currentHP = SS_Params_GetHealth();
  SS_PlayerFrame_HP:SetText(currentHP.."/"..maxHP);
end;

SS_Params_DrawBarrier = function(previousArmorType)
  local maxBarrierPoints = SS_Params_GetMaxBarrier(previousArmorType);
  if (maxBarrierPoints == 0 and SS_Params_GetBarrier() == 0) then
    SS_PlayerFrame_Barrier:Hide();
    SS_PlayerFrame_Barrier_Icon:Hide();
    return;
  end;

  SS_PlayerFrame_Barrier:Show();
  SS_PlayerFrame_Barrier_Icon:Show();

  local currentBarrier = SS_Params_GetBarrier();
  SS_PlayerFrame_Barrier:SetText(currentBarrier.."/"..maxBarrierPoints)
end;