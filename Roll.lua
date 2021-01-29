SS_Roll_EfficencyModifiers = {
  --[[
  {
    name = 'Test',
    value = 1,
    target = 'melee',
    countOfRolls = 1,
    onFire = nil,
  },
  ]]--
};

SS_Roll_GetDicesCount = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_Progress_GetLevel();
  end;

  return math.floor(1 + (playerLevel / 10));
end;

SS_Roll_GetMinimum = function(skillName, params)
  -- params: чтобы считать для других игроков, опционально
  if (not(params)) then
    params = {
      level = SS_Progress_GetLevel(),
      skill = SS_Skills_GetValue(skillName),
    }
  end;

  local levelModifier = math.floor((params.level / 5) - SS_Skills_GetMaxPointsInSingle(1)) + 5;
  local skillModifier = math.floor(params.skill / 5) - math.floor(params.skill / 8);

  if (levelModifier + skillModifier < 0) then return 0; end;
  
  return levelModifier + skillModifier;
end;

SS_Roll_GetMaximum = function(skillName, params)
  -- params: чтобы считать для других игроков, опционально
  if (not(params)) then
    params = {
      level = SS_Progress_GetLevel(),
      skill = SS_Skills_GetValue(skillName),
    }
  end;

  local levelModifier = math.floor(params.level / 8) + 4 + math.floor(0.5 * params.level);
  local skillModifier = math.floor((params.skill / 2) / math.pow(params.level, 0.3));
  if (levelModifier + skillModifier < 1) then return 1; end;

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

SS_Roll_Skill = function(skillName, visibility)
  local diceCount = SS_Roll_GetDicesCount();
  local dices = SS_Roll_GetDices(skillName);

  local maxResult = 0;
  local results = { }
  for i = 1, diceCount do
    local result = math.random(dices.from, dices.to);
    if (result > maxResult) then maxResult = result; end;
    table.insert(results, result);
  end;

  maxResult = SS_Params_GetHealthModifier(maxResult);
  local statModifier = SS_Stats_GetModifierFor(skillName);
  local armorModifier = SS_Armor_GetModifierFor(skillName, dices);

  local finalResult = maxResult + statModifier + armorModifier;

  if (finalResult < dices.from) then finalResult = dices.from; end;

  if (SS_User.settings.displayDiceInfo) then
    if (visibility == true) then
      SS_Log_SkillRoll(finalResult, armorModifier, statModifier, results, dices, diceCount, skillName);
    end;
  end;

  return finalResult;
end;

SS_Roll_Efficency = function(skillName, visibility)
  local statValue = SS_Stats_GetValue(SS_Skills_GetStatOf(skillName));
  local efficencyMaxValue = math.floor(statValue / 2);
  if (efficencyMaxValue < 1) then efficencyMaxValue = 1; end;

  local finalResult = math.random(1, efficencyMaxValue);

  if (SS_User.settings.displayDiceInfo) then
    if (visibility == 'true') then
      SS_Log_EfficencyRoll(finalResult, efficencyMaxValue);
    end;
  end;

  return finalResult;
end;

SS_Roll = function(skillName, visibility)
  local skillResult = SS_Roll_Skill(skillName, visibility);
  local efficencyResult = SS_Roll_Efficency(skillName, visibility);
  local dices = SS_Roll_GetDices(skillName);

  if (not(SS_User.settings.displayDiceInfo)) then
    if (visibility == true) then
      SS_Log_DiceInfoShort(skillResult, efficencyResult, dices, skillName);
    end;
  end;
  
  SS_PtA_RollResult({
    skill = skillName,
    skillResult = skillResult,
    efficencyResult = efficencyResult,
    dices = dices,
    diceCount = SS_Roll_GetDicesCount(),
    modifier = SS_Stats_GetModifierFor(skillName) + SS_Armor_GetModifierFor(skillName, dices),
  });
  
  SS_Modifiers_Fire('stats')(SS_Skills_GetStatOf(skillName));
  SS_Modifiers_Fire('skills')(skillName);

  SS_Roll_SaveResultToMembersTable(UnitName('player'), skillResult);

  return skillResult;
end;

SS_Roll_SaveResultToMembersTable = function(name, result)
  if (not(SS_LeadingPlots_Current())) then return nil; end;

  local isActivePlayer = SS_Shared_Includes(SS_LeadingPlots_Current().activePlayers)(function(p)
    return p == name;
  end);

  if (not(isActivePlayer)) then return nil; end;

  if (not(SS_LeadingPlots_Current().lastDices[name])) then
    SS_LeadingPlots_Current().lastDices[name] = {};
  end;

  if (#SS_LeadingPlots_Current().lastDices[name] < 5) then
    table.insert(SS_LeadingPlots_Current().lastDices[name], result);
  else
    table.remove(SS_LeadingPlots_Current().lastDices[name], 1);
    table.insert(SS_LeadingPlots_Current().lastDices[name], result);
  end;

  if (SS_MembersControll_Menu:IsVisible()) then
    SS_MembersControll_DrawList();
  end;
end;

SS_Roll_AsNPC = function(name, diceCount, rollParams, expectationText)
  local maxResult = -1;
  local result = maxResult;

  if (expectationText and SS_Shared_IsNumber(expectationText)) then
    maxResult = SS_Shared_NumFromStr(expectationText);
    if (maxResult < rollParams.minimum + rollParams.statModifier) then
      maxResult = rollParams.minimum + rollParams.statModifier;
    elseif (maxResult > rollParams.maximum + rollParams.statModifier) then
      maxResult = rollParams.maximum + rollParams.statModifier;
    end;

    result = maxResult;
  else
    for i = 1, diceCount do
      local rnd = math.random(rollParams.minimum, rollParams.maximum);
      if (rnd > maxResult) then maxResult = rnd; end;
    end;
    result = maxResult + rollParams.statModifier;
  end;

  SS_DMtP_SendNPCRoll(name, result);
end;