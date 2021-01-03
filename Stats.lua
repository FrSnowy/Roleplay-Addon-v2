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

SS_Stats_IsStat = function(name)
  return SS_Shared_Includes(SS_Stats_GetList())(function(value, statName)
    return statName == name
  end);
end;

SS_Stats_GetValue = function(stat)
  if (not(SS_Plots_Current())) then return 0; end;
  local statValue = SS_Plots_Current().stats[stat];
  local modifierOfStat = SS_Modifiers_ReadModifiersValue('stats')(stat);

  return statValue + modifierOfStat;
end;

SS_Stats_GetMaxMovementPoints = function()
  if (SS_Params_GetHealth() == 0) then
    return 1;
  end;

  local movementPoints = 4 + math.floor(SS_Stats_GetValue('mobility') / 2.4);
  if (SS_Plots_Current() and SS_Plots_Current().battle and SS_Plots_Current().battle.fullRoundMovement) then
    movementPoints = movementPoints * 2;
  end;

  return movementPoints;
end;

SS_Stats_GetValueWithoutModifier = function(stat)
  if (not(SS_Plots_Current())) then return 0; end;
  return SS_Plots_Current().stats[stat];
end;

SS_Stats_GetSpentedPoints = function()
  local statList = SS_Stats_GetList();

  local accum = 0;
  for name in pairs(statList) do
    accum = accum + SS_Stats_GetValueWithoutModifier(name);
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
  if (SS_Plots_Current().battle) then
    SS_Log_CanNotInBattle();
    return;
  end;

  if (SS_Stats_GetValueWithoutModifier(stat) + value < -SS_Stats_GetMaxPointsInSingle(1)) then
    return 0;
  end;

  if (SS_Stats_GetAvaliablePoints() < 1 and value > 0) then
    return 0;
  end;

  if (SS_Stats_GetValueWithoutModifier(stat) + value > SS_Stats_GetMaxPointsInSingle()) then
    return 0;
  end;

  SS_Plots_Current().stats[stat] = SS_Stats_GetValueWithoutModifier(stat) + value;
  statView:SetText(SS_Locale(stat)..': '..SS_Stats_GetValue(stat));
  SS_Stats_Menu_Points_Value:SetText(SS_Stats_GetAvaliablePoints());
  UpdateHPOnPointAddToStat();
  UpdateBarrierOnPointAddtoStat();
  SS_PtDM_UpdatePlayerInfo(SS_Plots_Current().author)
end;

SS_Stats_GetModifierFor = function(skillName, statPoints)
  if (not(statPoints)) then
    statPoints = SS_Stats_GetValue(SS_Skills_GetStatOf(skillName))
  end;
  return math.floor(statPoints / 2.4);
end;

SS_Stats_DrawValue = function(stat, view)
  view:SetText(SS_Locale(stat)..': '..SS_Stats_GetValue(stat));

  if (SS_Stats_GetValue(stat) - SS_Stats_GetValueWithoutModifier(stat) > 0) then
    view:SetTextColor(0.25, 0.75, 0.25);
  elseif (SS_Stats_GetValue(stat) - SS_Stats_GetValueWithoutModifier(stat) < 0) then
    view:SetTextColor(0.75, 0.15, 0.15);
  else
    view:SetTextColor(1, 1, 1);
  end;
end;

SS_Stats_DrawAll = function()
  SS_Stats_DrawValue('power', SS_Stats_Menu_Stat_Power);
  SS_Stats_DrawValue('accuracy', SS_Stats_Menu_Stat_Accuracy);
  SS_Stats_DrawValue('wisdom', SS_Stats_Menu_Stat_Wisdom);
  SS_Stats_DrawValue('empathy', SS_Stats_Menu_Stat_Empathy);
  SS_Stats_DrawValue('morale', SS_Stats_Menu_Stat_Morale);
  SS_Stats_DrawValue('mobility', SS_Stats_Menu_Stat_Mobility);
  SS_Stats_DrawValue('precision', SS_Stats_Menu_Stat_Precision);
end;

SS_Stats_ResetStats = function(stat)
  if (not(SS_Plots_Current())) then return 0; end;

  SS_Shared_ForEach(SS_Stats_GetList())(function(value, statName)
    SS_Plots_Current().stats[statName] = 0;
  end);

  if (SS_Params_GetHealth() > SS_Params_GetMaxHealth()) then
    SS_Plots_Current().params.health = SS_Params_GetMaxHealth();
  end;

  if (SS_Params_GetBarrier() > SS_Params_GetMaxBarrier()) then
    SS_Plots_Current().params.barrier = SS_Params_GetMaxBarrier();
  end;
end;