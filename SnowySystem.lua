SS_ApplicationLoad = function()
  SS_Load_Configuration();
end;

SS_GetDicesCount = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_Progress_GetLevel();
  end;

  return math.floor(1 + ( SS_Progress_GetLevel() / 10));
end;

SS_GetStatToSkillModifier = function(skillName)
  local statPoints = SS_Stats_GetValue(SS_Skills_GetStatOf(skillName));
  return math.floor(statPoints / 2.4);
end;

SS_GetArmorModifier = function(skillName, dices)
  local armorType = SS_Armor_GetType();

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
  local levelModifier = math.floor((SS_Progress_GetLevel() / 5) - SS_Skills_GetMaxPointsInSingle(1)) + 5;
  local skillModifier = (math.floor(SS_Skills_GetValue(skillName) / 5) - math.floor(SS_Skills_GetValue(skillName) / 8));
  
  return levelModifier + skillModifier;
end;

SS_GetMaximumDiceRoll = function(skillName)
  local levelModifier = math.floor(SS_Progress_GetLevel() / 8) + 4 + math.floor(0.5 * SS_Progress_GetLevel());
  local skillModifier = math.floor((SS_Skills_GetValue(skillName) / 2) / math.pow(SS_Progress_GetLevel(), 0.3));
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
          local outputString = '|cffFFFF00Модификатор от |r'..SS_Locale(SS_Skills_GetStatOf(skillName))..': ';
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
          local outputString = '|cffFFFF00Модификатор от брони (|r'..SS_Locale(SS_Armor_GetType())..'|cffFFFF00): |r';
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