SS_Roll_SkillModifiers = {
  --[[
  {
    name = 'Бонус ништяка',
    value = 1,
    target = { 'range' },
    countOfRolls = 2,
    onFire = nil,
  },
  ]]
};

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

SS_Roll_RegisterModifier_NecessaryCheck = function(params)
  if (not(params)) then
    print('|cffFF0000Ошибка: Не получены нужные параметры при регистрации модификатора броска|r');
    return false;
  end;

  if (not(params.name)) then
    print('|cffFF0000Не найдено имя модификатора броска|r');
    return false;
  end;

  if (not(params.value)) then
    print('|cffFF0000Не найдено значение модификатора|r');
    return false;
  end;

  if (not(params.target)) then
    print('|cffFF0000Нет цели модификатора|r');
    return false;
  end;

  return true;
end;

SS_Roll_RegisterSkillModifier = function(params)
  if (not(SS_Roll_RegisterModifier_NecessaryCheck(params))) then return false; end;

  table.insert(SS_Roll_SkillModifiers, params);
  return true;
end;

SS_Roll_RegisterEfficencyModifier = function(params)
  if (not(SS_Roll_RegisterModifier_NecessaryCheck(params))) then return false; end;

  table.insert(SS_Roll_EfficencyModifiers, params);
  return true;
end;

SS_Roll_GetDicesCount = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_Progress_GetLevel();
  end;

  return math.floor(1 + (SS_Progress_GetLevel() / 10));
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

SS_Roll_GetOtherModifersSummary = function(modifiersList, skillName)
  local otherModifiers = 0;

  local applyModifier = function(modifier, index)
    otherModifiers = otherModifiers + modifier.value;
    modifier.countOfRolls = modifier.countOfRolls - 1;

    if (modifier.onFire) then
      modifier.onFire(modifier);
    end;
    
    if (modifier.countOfRolls <= 0) then
      table.remove(modifiersList, index);
    end;
  end;

  SS_Shared_ForEach(modifiersList)(function(modifier, index)
    local isForAny = modifier.target == 'any';
    local isForSame = modifier.target == skillName;
    local isTargetTable = type(modifier.target) == 'table';

    if (isForAny or isForSame) then applyModifier(modifier, index);
    elseif (isTargetTable) then
      local isCurrentSkillInTable = SS_Shared_Includes(modifier.target)(function(target)
        return target == skillName;
      end);
      if (isCurrentSkillInTable) then applyModifier(modifier, index); end;
    end;
  end)

  return otherModifiers;
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

  local otherModifiers = SS_Roll_GetOtherModifersSummary(SS_Roll_SkillModifiers, skillName);

  finalResult = finalResult + otherModifiers;

  if (SS_User.settings.displayDiceInfo) then
    SS_Log_SkillRoll(finalResult, otherModifiers, armorModifier, statModifier, results, dices, diceCount, skillName);
  end;

  return finalResult;
end;

SS_Roll_Efficency = function(skillName)
  local statValue = SS_Stats_GetValue(SS_Skills_GetStatOf(skillName));
  local efficencyMaxValue = math.floor(statValue / 2);
  if (efficencyMaxValue < 1) then efficencyMaxValue = 1; end;

  local finalResult = math.random(1, efficencyMaxValue);

  local otherModifiers = SS_Roll_GetOtherModifersSummary(SS_Roll_EfficencyModifiers, skillName);

  finalResult = finalResult + otherModifiers;

  if (SS_User.settings.displayDiceInfo) then
    SS_Log_EfficencyRoll(finalResult, otherModifiers, efficencyMaxValue);
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
end;
