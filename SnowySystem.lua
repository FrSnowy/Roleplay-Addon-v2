function SS_ApplicationLoad()
  SS_loadConfiguration();
end;

function SS_GetPlayerLevel()
  if (SS_User.settings.currentPlot) then
    return SS_User.plots[SS_User.settings.currentPlot].level;
  end;

  return 0;
end;

function SS_GetPlayerExperience()
  if (SS_User.settings.currentPlot) then
    return SS_User.plots[SS_User.settings.currentPlot].experience;
  end;

  return 0;
end;

function SS_GetExperienceForLevelUp()
  local levelWithPow = math.floor(math.pow(SS_GetPlayerLevel(), 1.566));
  local experienceForEvent = 100;

  return levelWithPow * experienceForEvent;
end;

function SS_GetStatValue(stat)
  if (SS_User.settings.currentPlot) then
    return SS_User.plots[SS_User.settings.currentPlot].stats[stat];
  end;
end;

function SS_GetSkillValue(skill)
  if (SS_User.settings.currentPlot) then
    return SS_User.plots[SS_User.settings.currentPlot].skills[skill];
  end;
end;

function SS_GetSummaryStatPoints()
  return SS_GetStatValue('power') + SS_GetStatValue('accuracy') + SS_GetStatValue('mobility') + SS_GetStatValue('wisdom')  + SS_GetStatValue('empathy') + SS_GetStatValue('morale');
end;

function SS_GetMaxStatPoints(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_GetPlayerLevel();
  end;
  return math.floor(3 + ((playerLevel / 3.25) * 2));
end;

function SS_GetSummarySkillPoints()
  local active = SS_GetSkillValue('melee') + SS_GetSkillValue('range') + SS_GetSkillValue('magic') + SS_GetSkillValue('religion') + SS_GetSkillValue('perfomance') + SS_GetSkillValue('hands');
  local passive = SS_GetSkillValue('stealth') + SS_GetSkillValue('observation') + SS_GetSkillValue('controll') + SS_GetSkillValue('knowledge') + SS_GetSkillValue('athletics') + SS_GetSkillValue('acrobats');

  return active + passive;
end;

function SS_GetMaxSkillPoints(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_GetPlayerLevel();
  end;
  return 5 + playerLevel * 10;
end;

function SS_GetMaxSkillPointsInSingleSkill(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_GetPlayerLevel();
  end;
  return playerLevel * 5;
end;

function SS_GetAvailableStatPoints()
  local baseStatPoints = SS_GetMaxStatPoints();
  local summaryPoints = SS_GetSummaryStatPoints();
  return baseStatPoints - summaryPoints;
end;

function SS_GetAvailableSkillPoints()
  local baseSkillPoints = SS_GetMaxSkillPoints();
  local summaryPoints = SS_GetSummarySkillPoints();
  return baseSkillPoints - summaryPoints;
end;

function UpdateHPOnPointAddToStat()
  SS_User.plots[SS_User.settings.currentPlot].health = SS_GetMaxHealth();
  SS_DrawHealthPoints();
end;

function SS_PointToStat(value, stat, statView)
  if (SS_GetStatValue(stat) + value < -SS_GetMaxStatPoints(1)) then
    return 0;
  end;

  if (SS_GetAvailableStatPoints() < 1 and value > 0) then
    return 0;
  end;

  if (SS_GetStatValue(stat) + value > SS_GetMaxStatPoints()) then
    return 0;
  end;

  SS_User.plots[SS_User.settings.currentPlot].stats[stat] = SS_GetStatValue(stat) + value;
  statView:SetText(SS_GetStatValue(stat));
  SS_Stats_Menu_Points_Value:SetText(SS_GetAvailableStatPoints());
  UpdateHPOnPointAddToStat();
end;

function SS_PointToSkill(value, skill, skillView)
  if (SS_GetSkillValue(skill) + value < 0) then
    return 0;
  end;

  if (SS_GetAvailableSkillPoints() < 1 and value > 0) then
    return 0;
  end;

  if (SS_GetSkillValue(skill) + value > SS_GetMaxSkillPointsInSingleSkill()) then
    return 0;
  end;

  SS_User.plots[SS_User.settings.currentPlot].skills[skill] = SS_GetSkillValue(skill) + value;
  skillView:SetText(SS_GetSkillValue(skill));
  SS_Skills_Menu_Points_Value:SetText(SS_GetAvailableSkillPoints());
end;

function SS_GetCurrentHealth()
  return SS_User.plots[SS_User.settings.currentPlot].health;
end;

function SS_GetMaxHealth()
  local sumOfStats = SS_GetStatValue('power') + SS_GetStatValue('mobility') + SS_GetStatValue('morale');
  local healthPoints = 2 + math.floor(sumOfStats / 3);
  if (healthPoints < 1) then healthPoints = 1 end;

  local isFullHP = SS_GetCurrentHealth() == healthPoints;

  if (SS_User.plots[SS_User.settings.currentPlot].armor == 'ignore') then
    healthPoints = math.floor(healthPoints + (healthPoints) * 0.3) + 1;
  end;

  if (SS_GetCurrentHealth() > healthPoints) then
    SS_User.plots[SS_User.settings.currentPlot].health = healthPoints;
  end;

  -- Ещё флаг, что не в бою
  if (isFullHP) then
    SS_User.plots[SS_User.settings.currentPlot].health = healthPoints;
  end;

  return healthPoints;
end;

function SS_GetCurrentBarrier()
  return SS_User.plots[SS_User.settings.currentPlot].barrier;
end;

function SS_GetMaxBarrier()
  local armorType = SS_GetArmorType();
  if (armorType == 'light' or armorType =='ignore') then return 0; end;

  local maxHP = SS_GetMaxHealth();
  local maxBarrier = 0;

  if (armorType == 'medium') then
    maxBarrier = math.floor(maxHP / 3);
  end;
  if (armorType == 'heavy') then
    maxBarrier = math.floor(maxHP / 2);
  end;

  -- Ещё флаг, что не в бою
  if (SS_GetCurrentBarrier() == 0 or SS_GetCurrentBarrier() > maxBarrier) then
    SS_User.plots[SS_User.settings.currentPlot].barrier = maxBarrier;
  end;

  return maxBarrier;
end;

function SS_GetArmorType()
  return  SS_User.plots[SS_User.settings.currentPlot].armor;
end;

function SS_SelectArmorType(armorType)
  SS_User.plots[SS_User.settings.currentPlot].armor = armorType;
  SS_DrawCheckmarkOnArmor();
  SS_DrawHealthPoints();
  SS_DrawBarrierPoints();
end;