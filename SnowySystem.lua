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

function SS_GetSummaryStatsValue()
  return SS_GetStatValue('power') + SS_GetStatValue('vigilance') + SS_GetStatValue('wisdom') + SS_GetStatValue('reaction') + SS_GetStatValue('empathy') + SS_GetStatValue('stamina');
end;

function SS_GetMaxStatPoints(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_GetPlayerLevel();
  end;
  return math.floor(3 + ((playerLevel / 3.25) * 2));
end;

function SS_GetAvailableStatPoints()
  local baseStatPoints = SS_GetMaxStatPoints();
  local summaryPoints = SS_GetSummaryStatsValue();
  return baseStatPoints - summaryPoints;
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
end;