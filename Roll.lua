SS_Roll_Listeners = { }

SS_Roll_GetDicesCount = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_Progress_GetLevel();
  end;

  return math.floor(1 + ( SS_Progress_GetLevel() / 10));
end;

SS_Roll_GetMinimum = function(skillName)
  local levelModifier = math.floor((SS_Progress_GetLevel() / 5) - SS_Skills_GetMaxPointsInSingle(1)) + 5;
  local skillModifier = (math.floor(SS_Skills_GetValue(skillName) / 5) - math.floor(SS_Skills_GetValue(skillName) / 8));
  
  return levelModifier + skillModifier;
end;

SS_Roll_GetMaximum = function(skillName)
  local levelModifier = math.floor(SS_Progress_GetLevel() / 8) + 4 + math.floor(0.5 * SS_Progress_GetLevel());
  local skillModifier = math.floor((SS_Skills_GetValue(skillName) / 2) / math.pow(SS_Progress_GetLevel(), 0.3));
  return levelModifier + skillModifier;
end;

SS_Roll_GetDices = function(skillName)
  local dices = {
    from = SS_Roll_GetMinimum(skillName),
    to = SS_Roll_GetMaximum(skillName),
  };

  dices.average = (dices.from + dices.to) / 2;

  return dices;
end;

SS_Roll_Skill = function(skillName)
  local diceCount = SS_Roll_GetDicesCount();
  local dices = SS_Roll_GetDices(skillName);

  local maxResult = 0;
  local results = { }
  for i = 1, diceCount do
    local result = math.random(dices.from, dices.to);
    if (result > maxResult) then maxResult = result; end;
    table.insert(results, result);
  end;

  local statModifier = SS_Stats_GetModifierFor(skillName);
  local armorModifier = SS_Armor_GetModifierFor(skillName, dices);

  local finalResult = maxResult + statModifier + armorModifier;
  if (finalResult < dices.from) then finalResult = dices.from; end;

  if (SS_User.settings.displayDiceInfo) then
    SS_Log_SkillRoll(finalResult, armorModifier, statModifier, results, dices, diceCount, skillName);
  end;

  return finalResult;
end;

SS_Roll_Efficency = function(skillName)
  local statValue = SS_Stats_GetValue(SS_Skills_GetStatOf(skillName));
  local efficencyMaxValue = math.floor(statValue / 2);
  if (efficencyMaxValue < 1) then efficencyMaxValue = 1; end;

  local finalResult = math.random(1, efficencyMaxValue);

  if (SS_User.settings.displayDiceInfo) then
    SS_Log_EfficencyRoll(finalResult, efficencyMaxValue);
  end;

  return finalResult;
end;

SS_Roll = function(skillName)
  local skillResult = SS_Roll_Skill(skillName);
  local efficencyResult = SS_Roll_Efficency(skillName);
  local dices = SS_Roll_GetDices(skillName);

  if (not(SS_User.settings.displayDiceInfo)) then
    SS_Log_DiceInfoShort(skillResult, efficencyResult, dices, skillName);
  end;

  local finalResult = math.random(1, efficencyMaxValue);
end;
