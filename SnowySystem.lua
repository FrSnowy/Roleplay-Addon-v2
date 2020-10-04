SS_ApplicationLoad = function()
  SS_Load_Configuration();
end;

SS_GetPlayerLevel = function()
  if (SS_User.settings.currentPlot) then
    return SS_User.plots[SS_User.settings.currentPlot].level;
  end;

  return 0;
end;

SS_GetPlayerExperience = function()
  if (SS_User.settings.currentPlot) then
    return SS_User.plots[SS_User.settings.currentPlot].experience;
  end;

  return 0;
end;

SS_GetExperienceForLevelUp = function()
  local levelWithPow = math.floor(math.pow(SS_GetPlayerLevel(), 1.566));
  local experienceForEvent = 100;

  return levelWithPow * experienceForEvent;
end;

SS_GetStatValue = function(stat)
  if (SS_User.settings.currentPlot) then
    return SS_User.plots[SS_User.settings.currentPlot].stats[stat];
  end;
end;

SS_GetSkillValue = function(skill)
  if (SS_User.settings.currentPlot) then
    return SS_User.plots[SS_User.settings.currentPlot].skills[skill];
  end;
end;

SS_GetSummaryStatPoints = function()
  return SS_GetStatValue('power') + SS_GetStatValue('accuracy') + SS_GetStatValue('wisdom')  + SS_GetStatValue('empathy') + SS_GetStatValue('morale')+ SS_GetStatValue('mobility') + SS_GetStatValue('precision');
end;

SS_GetMaxStatPoints = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_GetPlayerLevel();
  end;
  return 5 * (1 + math.floor(playerLevel / 3.25));
end;

SS_GetMaxStatPointsInSingleStat = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_GetPlayerLevel();
  end;
  return math.floor(3 + ((playerLevel / 3.25) * 2));
end;

SS_GetSummarySkillPoints = function()
  local active = SS_GetSkillValue('melee') + SS_GetSkillValue('range') + SS_GetSkillValue('magic') + SS_GetSkillValue('religion') + SS_GetSkillValue('perfomance') + SS_GetSkillValue('hands') + SS_GetSkillValue('missing');
  local passive = SS_GetSkillValue('stealth') + SS_GetSkillValue('observation') + SS_GetSkillValue('controll') + SS_GetSkillValue('knowledge') + SS_GetSkillValue('athletics') + SS_GetSkillValue('acrobats') + SS_GetSkillValue('judgment');

  return active + passive;
end;

SS_GetMaxSkillPoints = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_GetPlayerLevel();
  end;
  return 10 + playerLevel * 10;
end;

SS_GetMaxSkillPointsInSingleSkill = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_GetPlayerLevel();
  end;
  return playerLevel * 5;
end;

SS_GetAvailableStatPoints = function()
  local baseStatPoints = SS_GetMaxStatPoints();
  local summaryPoints = SS_GetSummaryStatPoints();
  return baseStatPoints - summaryPoints;
end;

SS_GetAvailableSkillPoints = function()
  local baseSkillPoints = SS_GetMaxSkillPoints();
  local summaryPoints = SS_GetSummarySkillPoints();
  return baseSkillPoints - summaryPoints;
end;

local UpdateHPOnPointAddToStat = function()
  SS_User.plots[SS_User.settings.currentPlot].health = SS_GetMaxHealth();
  SS_Draw_HealthPoints();
end;

local UpdateBarrierOnPointAddtoStat = function()
  SS_User.plots[SS_User.settings.currentPlot].barrier = SS_GetMaxBarrier(SS_GetArmorType());
  SS_Draw_BarrierPoints();
end;

SS_PointToStat = function(value, stat, statView)
  if (SS_GetStatValue(stat) + value < -SS_GetMaxStatPointsInSingleStat(1)) then
    return 0;
  end;

  if (SS_GetAvailableStatPoints() < 1 and value > 0) then
    return 0;
  end;

  if (SS_GetStatValue(stat) + value > SS_GetMaxStatPointsInSingleStat()) then
    return 0;
  end;

  SS_User.plots[SS_User.settings.currentPlot].stats[stat] = SS_GetStatValue(stat) + value;
  statView:SetText(SS_Locale(stat)..': '..SS_GetStatValue(stat));
  SS_Stats_Menu_Points_Value:SetText(SS_GetAvailableStatPoints());
  UpdateHPOnPointAddToStat();
  UpdateBarrierOnPointAddtoStat();
end;

SS_PointToSkill = function(value, skill, skillView)
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
  skillView:SetText(SS_Locale(skill)..": "..SS_GetSkillValue(skill));
  SS_Skills_Menu_Points_Value:SetText(SS_GetAvailableSkillPoints());
end;

SS_GetCurrentHealth = function()
  return SS_User.plots[SS_User.settings.currentPlot].health;
end;

SS_GetMaxHealth = function()
  local sumOfStats = SS_GetStatValue('power') + SS_GetStatValue('mobility');
  local healthPoints = 2 + math.floor(sumOfStats / 3);
  if (healthPoints < 1) then healthPoints = 1 end;

  local isFullHP = SS_GetCurrentHealth() == healthPoints;

  if (SS_GetCurrentHealth() > healthPoints) then
    SS_User.plots[SS_User.settings.currentPlot].health = healthPoints;
  end;

  -- Ещё флаг, что не в бою
  if (isFullHP) then
    SS_User.plots[SS_User.settings.currentPlot].health = healthPoints;
  end;

  return healthPoints;
end;

SS_GetCurrentBarrier = function()
  return SS_User.plots[SS_User.settings.currentPlot].barrier;
end;

SS_GetMaxBarrier = function(previousArmorType)
  local armorType = SS_GetArmorType();

  local maxHP = SS_GetMaxHealth();
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
  if (SS_GetCurrentBarrier() == 0 or SS_GetCurrentBarrier() > maxBarrier or (previousArmorType and SS_GetCurrentBarrier() == previousMaxBarrier)) then
    SS_User.plots[SS_User.settings.currentPlot].barrier = maxBarrier;
  end;

  return maxBarrier;
end;

SS_GetArmorType = function()
  return SS_User.plots[SS_User.settings.currentPlot].armor;
end;

SS_SelectArmorType = function(armorType, previousArmorType)
  SS_User.plots[SS_User.settings.currentPlot].armor = armorType;
  SS_Draw_CheckOnArmor();
  SS_Draw_HealthPoints();
  SS_Draw_BarrierPoints(previousArmorType);
end;

SS_GetAssociatedStatOfSkill = function(skill)
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

SS_GetDicesCount = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_GetPlayerLevel();
  end;

  return math.floor(1 + ( SS_GetPlayerLevel() / 10));
end;

SS_GetStatToSkillModifier = function(skillName)
  local statPoints = SS_GetStatValue(SS_GetAssociatedStatOfSkill(skillName));
  return math.floor(statPoints / 2.4);
end;

SS_GetArmorModifier = function(skillName, dices)
  local armorType = SS_GetArmorType();

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

SS_GetMinimumDiceRoll = function(skillName)
  local levelModifier = math.floor((SS_GetPlayerLevel() / 5) - SS_GetMaxSkillPointsInSingleSkill(1)) + 5;
  local skillModifier = (math.floor(SS_GetSkillValue(skillName) / 5) - math.floor(SS_GetSkillValue(skillName) / 8));
  
  return levelModifier + skillModifier;
end;

SS_GetMaximumDiceRoll = function(skillName)
  local levelModifier = math.floor(SS_GetPlayerLevel() / 8) + 4 + math.floor(0.5 * SS_GetPlayerLevel());
  local skillModifier = math.floor((SS_GetSkillValue(skillName) / 2) / math.pow(SS_GetPlayerLevel(), 0.3));
  return levelModifier + skillModifier;
end;

SS_DiceRoll = function(skillName)
  local singleLineOutput;
  local rollFlow = { };
  local efficencyFlow = { };

  -- Если показываем инфу, то большой подробный логгер по кубику
  if (SS_User.settings.displayDiceInfo) then
    rollFlow = {
      beforeAll = function()
        print('-------------');
      end,
      onDicesGet = function(dices, diceCount)
        print('|cffFFFF00Проверка навыка: |r'..SS_Locale(skillName).."|cffFFFF00, от уровня и характеристик: |r"..diceCount..'d('..dices.from.."-"..dices.to..')');
      end,
      onRollResultGet = function(results, dices, diceCount)
        local outputString = '|cffFFFF00Результаты броска куба: [|r';
        local maxResult = 0;
        for i = 1, diceCount do
          local result = 0;
          if (maxResult < results[i]) then maxResult = results[i]; end;
          if (results[i] < dices.average - (dices.average * 0.25)) then
            result = "|cFFFF0000"..results[i].."|r";
          elseif (results[i] > dices.average + (dices.average * 0.25)) then
            result = "|cFF00FF00"..results[i].."|r";
          else
            result = results[i];
          end;
  
          if (not(i == diceCount)) then
            result = result..", ";
          end;
  
          outputString = outputString..result;
        end;
  
        if (diceCount > 1) then
          outputString = outputString.."|cffFFFF00]. Наибольшее: |r";
          if (maxResult < dices.average - (dices.average * 0.25)) then
            outputString = outputString.."|cFFFF0000"..maxResult.."|r";
          elseif (maxResult > dices.average + (dices.average * 0.25)) then
            outputString = outputString.."|cFF00FF00"..maxResult.."|r";
          else
            outputString = outputString..maxResult;
          end;
        else
          outputString = outputString.."|cffFFFF00]|r";
        end;
  
        print(outputString);
      end,
      onStatModifierGet = function(statModifier)
        if (not(statModifier == 0)) then
          local outputString = '|cffFFFF00Модификатор от |r'..SS_Locale(SS_GetAssociatedStatOfSkill(skillName))..': ';
          if (statModifier > 0) then
            outputString = outputString..'|cff00FF00'..statModifier..'|r';
          elseif (statModifier < 0) then
            outputString = outputString..'|cffFF0000'..statModifier..'|r';
          else
            outputString = outputString..statModifier;
          end;
          print(outputString);
        end;
      end,
      onArmorModifierGet = function(armorModifier)
        if (not(armorModifier == 0)) then
          local outputString = '|cffFFFF00Модификатор от брони (|r'..SS_Locale(SS_GetArmorType())..'|cffFFFF00): |r';
          if (armorModifier > 0) then
            outputString = outputString..'|cff00FF00'..armorModifier..'|r';
          elseif (armorModifier < 0) then
            outputString = outputString..'|cffFF0000'..armorModifier..'|r';
          else
            outputString = outputString..armorModifier;
          end;
          print(outputString);
        end;
      end,
      afterAll = function(finalResult)
        print('|cffFFFF00Итоговый результат проверки: |r|cff9999FF'..finalResult.."|r");
      end,
    }
  -- Если нет - мелкого хватит в одну строку
  else
    rollFlow = {
      afterAll = function(finalResult, armorModifier, statModifier, results, dices)
        singleLineOutput = '|cffFFFF00'..UnitName('player')..' бросок (|r'..SS_Locale(skillName).."|cffFFFF00): |r";
        if (finalResult < dices.average - (dices.average * 0.25)) then
          singleLineOutput = singleLineOutput.."|cFFFF0000"..finalResult.."|r";
        elseif (finalResult > dices.average + (dices.average * 0.25)) then
          singleLineOutput = singleLineOutput.."|cFF00FF00"..finalResult.."|r";
        else
          singleLineOutput = singleLineOutput..finalResult;
        end;
      end,
    }
  end;

  -- Подробный логгер по эффективности
  if (SS_User.settings.displayDiceInfo) then
    efficencyFlow = {
      afterAll = function(result, maxValue)
        if (maxValue == 1) then
          print('|cffFFFF00Эффективность: |r'..result);
        else
          print('|cffFFFF00Эффективность:|r 1-'..maxValue..'|cffFFFF00. Итоговое: |r|cff9999FF'..result.."|r");
        end;
      end,
    }
  -- Однострочный логгер
  else
    efficencyFlow = {
      afterAll = function(result)
        singleLineOutput = singleLineOutput..'|cffFFFF00. Эффективность: |r'..result;
        print(singleLineOutput);
      end,
    }
  end;

  -- Роллим куб и прогоняем этапы через флоу для логгирования
  local result = SS_DiceRollFlow(skillName, rollFlow);
  local efficency = SS_EfficencyRollFlow(skillName, efficencyFlow);
end;