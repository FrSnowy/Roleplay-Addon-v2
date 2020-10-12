SS_Skills_GetList = function()
  return {
    melee = 0,
    range = 0,
    magic = 0,
    religion = 0,
    perfomance = 0,
    missing = 0,
    hands = 0,
    athletics = 0,
    observation = 0,
    knowledge = 0,
    controll = 0,
    judgment = 0,
    acrobats = 0,
    stealth = 0,
  }
end;

SS_Skills_GetValue = function(skill)
  if (SS_User.settings.currentPlot) then
    return SS_Plots_Current().skills[skill];
  end;

  return 0;
end;

SS_Skills_GetSpentedPoints = function()
  local skillList = SS_Skills_GetList();

  local accum = 0;
  for name in pairs(skillList) do
    accum = accum + SS_Skills_GetValue(name);
  end;

  return accum;
end;

SS_Skills_GetMaxPoints = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_Progress_GetLevel();
  end;
  return 10 + playerLevel * 10;
end;

SS_Skills_GetMaxPointsInSingle = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_Progress_GetLevel();
  end;
  return playerLevel * 5;
end;

SS_Skills_GetAvaliablePoints = function()
  local baseSkillPoints = SS_Skills_GetMaxPoints();
  local summaryPoints = SS_Skills_GetSpentedPoints();
  return baseSkillPoints - summaryPoints;
end;

SS_Skills_AddPoint = function(value, skill, skillView)
  if (SS_Skills_GetValue(skill) + value < 0) then
    return 0;
  end;

  if (SS_Skills_GetAvaliablePoints() < 1 and value > 0) then
    return 0;
  end;

  if (SS_Skills_GetValue(skill) + value > SS_Skills_GetMaxPointsInSingle()) then
    return 0;
  end;

  SS_Plots_Current().skills[skill] = SS_Skills_GetValue(skill) + value;
  skillView:SetText(SS_Locale(skill)..": "..SS_Skills_GetValue(skill));
  SS_Skills_Menu_Points_Value:SetText(SS_Skills_GetAvaliablePoints());
end;

SS_Skills_GetStatOf = function(skill)
  local association = {
    melee = 'power',
    range = 'accuracy',
    magic = 'wisdom',
    religion = 'morale',
    perfomance = 'empathy',
    missing = 'mobility',
    hands = 'precision',
    athletics = 'power',
    observation = 'accuracy',
    knowledge = 'wisdom',
    controll = 'morale',
    judgment = 'empathy',
    acrobats = 'mobility',
    stealth = 'precision',
  };

  return association[skill];
end;