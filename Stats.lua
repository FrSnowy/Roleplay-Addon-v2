SS_Stats_GetList = function()
  return {  
    power = 0,
    accuracy = 0,
    wisdom = 0,
    morale = 0,
    empathy = 0,
    mobility = 0,
    precision = 0,
  }
end;

SS_Stats_GetValue = function(stat)
  if (SS_User.settings.currentPlot) then
    return SS_Plots_Current().stats[stat];
  end;

  return 0;
end;

SS_Stats_GetSpentedPoints = function()
  local statList = SS_Stats_GetList();

  local accum = 0;
  for name in pairs(statList) do
    accum = accum + SS_Stats_GetValue(name);
  end;

  return accum;
end;

SS_Stats_GetMaxPoints = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_Progress_GetLevel();
  end;
  return 5 * (1 + math.floor(playerLevel / 3.25));
end;

SS_Stats_GetMaxPointsInSingle = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_Progress_GetLevel();
  end;
  return math.floor(3 + ((playerLevel / 3.25) * 2));
end;

SS_Stats_GetAvaliablePoints = function()
  local baseStatPoints = SS_Stats_GetMaxPoints();
  local summaryPoints = SS_Stats_GetSpentedPoints();
  return baseStatPoints - summaryPoints;
end;

local UpdateHPOnPointAddToStat = function()
  SS_Plots_Current().params.health = SS_Params_GetMaxHealth();
  SS_Params_DrawHealth();
end;

local UpdateBarrierOnPointAddtoStat = function()
  SS_Plots_Current().params.barrier = SS_Params_GetMaxBarrier(SS_Armor_GetType());
  SS_Params_DrawBarrier();
end;

SS_Stats_AddPoint = function(value, stat, statView)
  if (SS_Stats_GetValue(stat) + value < -SS_Stats_GetMaxPointsInSingle(1)) then
    return 0;
  end;

  if (SS_Stats_GetAvaliablePoints() < 1 and value > 0) then
    return 0;
  end;

  if (SS_Stats_GetValue(stat) + value > SS_Stats_GetMaxPointsInSingle()) then
    return 0;
  end;

  SS_Plots_Current().stats[stat] = SS_Stats_GetValue(stat) + value;
  statView:SetText(SS_Locale(stat)..': '..SS_Stats_GetValue(stat));
  SS_Stats_Menu_Points_Value:SetText(SS_Stats_GetAvaliablePoints());
  UpdateHPOnPointAddToStat();
  UpdateBarrierOnPointAddtoStat();
end;

SS_Stats_GetModifierFor = function(skillName, statPoints)
  if (not(statPoints)) then
    statPoints = SS_Stats_GetValue(SS_Skills_GetStatOf(skillName))
  end;
  return math.floor(statPoints / 2.4);
end;