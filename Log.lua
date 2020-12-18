SS_Log_SkillRoll = function(finalResult, armorModifier, statModifier, results, dices, diceCount, skillName)
  print('-------------');
  print('|cffFFFF00Проверка навыка: |r'..SS_Locale(skillName).." "..diceCount..'d('..dices.from.."-"..dices.to..')');
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

  outputString = '';

  if (not(statModifier == 0)) then
    outputString = '|cffFFFF00Модификатор от |r'..SS_Locale(SS_Skills_GetStatOf(skillName))..': ';
    if (statModifier > 0) then
      outputString = outputString..'|cff00FF00'..statModifier..'|r';
    elseif (statModifier < 0) then
      outputString = outputString..'|cffFF0000'..statModifier..'|r';
    else
      outputString = outputString..statModifier;
    end;
    print(outputString);
  end;

  outputString = '';

  if (not(armorModifier == 0)) then
    local outputString = '|cffFFFF00Модификатор от снаряжения (|r'..SS_Locale(SS_Armor_GetType())..'|cffFFFF00): |r';
    if (armorModifier > 0) then
      outputString = outputString..'|cff00FF00'..armorModifier..'|r';
    elseif (armorModifier < 0) then
      outputString = outputString..'|cffFF0000'..armorModifier..'|r';
    else
      outputString = outputString..armorModifier;
    end;
    print(outputString);
  end;

  print('|cffFFFF00Итоговый результат проверки: |r|cff9999FF'..finalResult.."|r");
end;

SS_Log_EfficencyRoll = function(result, maxValue)
  if (maxValue == 1 and result == 1) then
    return nil;
  else
    local outputString = '|cffFFFF00Эффективность: |r';
    if (maxValue == 1) then
      outputString = outputString..'1. ';
    else
      outputString = outputString..'1d(1-'..maxValue..'). '
    end;

    outputString = outputString..'|cffFFFF00Итоговое: |r|cff9999FF'..result.."|r";
  
    print(outputString);
  end;
end;

SS_Log_DiceInfoShort = function(skillResult, efficencyResult, dices, skillName)
  local output = '|cffFFFF00'..UnitName('player')..' выбрасывает |r';

  if (skillResult < dices.average - (dices.average * 0.25)) then
    output = output.."|cFFFF0000"..skillResult.."|r";
  elseif (skillResult > dices.average + (dices.average * 0.25)) then
    output = output.."|cFF00FF00"..skillResult.."|r";
  else
    output = output..skillResult;
  end;
  
  output = output..' ('..SS_Locale(skillName)..').';
  if (efficencyResult > 1) then
    output = output..'|cffFFFF00 Эффективность: |r'..efficencyResult;
  end;

  print(output);
end;

SS_Log_NoTarget = function()
  print('|cffFF0000Ошибка: нет цели|r');
end;

SS_Log_NoCurrentPlot = function()
  print('|cffFF0000Ошибка: нет текущего сюжета|r');
end;

SS_Log_InviteSendedTo = function(player, plot)
  print('|cffFFFF00Приглашение в сюжет "|r'..plot..'"|cffFFFF00 отправлено игроку |r'..player);
end;

SS_Log_PlotAlreadyExistsFor = function(player, plot)
  if (UnitName("player") == player) then
    print('|cffFFFF00Вы не можете повторно пригласить себя в сюжет');
  else
    print('|cffFFFF00'..player..' уже принимает участие в сюжете |r"'..plot..'"');
  end;
end;

SS_Log_PlotInviteDeclinedBy = function(player, plot)
  if (UnitName("player") == player) then
    print('|cffFFFF00Вы отказались от участия в сюжете |r"'..plot..'"');
  else
    print('|cffFFFF00'..player..' отказался от участия в сюжете |r"'..plot..'"');
  end;
end;

SS_Log_PlotInviteAcceptedBy = function(player, plot)
  if (UnitName("player") == player) then
    print('|cffFFFF00Вы согласились на участие в сюжете |r"'..plot..'"');
  else
    print('|cffFFFF00'..player..' согласился на участие в сюжете |r"'..plot..'"');
  end;
end;

SS_Log_PlotRemovedBy = function(player, plot)
  print('|cffFFFF00'..player..' удалил сюжет |r"'..plot..'"|cffFFFF00 из сохрененных|r');
end;

SS_Log_PlotDeactivatedBy = function(player, plot)
  print('|cffFFFF00'..player..' покинул событие сюжета |r"'..plot..'"|r');
end;

SS_Log_PlotRemovedByDM = function(player, plot)
  print('|cffFFFF00Ведущий '..player..' удалил сюжет |r"'..plot..'"');
end;

SS_Log_KickedByDM = function(player, plot)
  print('|cffFFFF00Ведущий '..player..' исключил вас из сюжета |r"'..plot..'"');
end;

SS_Log_PlayerKickedSuccessfully = function(player)
  print('|cffFFFF00Игрок '..player..' успешно исключен.|r');
end;

SS_Log_EventStarting = function(plot)
  print('|cffFFFF00Начинается событие сюжета "|r'..plot..'"|cffFFFF00. Приглашение выслано участникам.|r');
end;

SS_Log_DeclineEventStart = function(plot)
  print('|cffFFFF00Вы отказались от участия в событии сюжета |r"'..plot..'"');
end;

SS_Log_AcceptEventStart = function(plot)
  print('|cffFFFF00Вы согласились на участие в событии сюжета |r"'..plot..'"');
end;

SS_Log_PlayerJoinedToEvent = function(player, plot)
  if (player == UnitName("player")) then return nil; end;
  print('|cffFFFF00Игрок |r'..player..'|cffFFFF00 присоединился к событию сюжета |r"'..plot..'"');
end;

SS_Log_PlayerDeclinedEventInvite = function(player, plot)
  print(player..'|cffFFFF00 отказался от участия в событии сюжета |r"'..plot..'"');
end;

SS_Log_PlayerAcceptedEventInvite = function(player, plot)
  print(player..'|cffFFFF00 согласился на участие в событии сюжета |r"'..plot..'"');
end;

SS_Log_EventEnd = function(plot)
  print('|cffFFFF00Вы завершили событие сюжета |r"'..plot..'"');
end;

SS_Log_ModifierAdded = function(name, stats, value, count)
  local outputString = '|cffFFFF00Добавлен модификатор |r"'..name..'" ';

  if (SS_User.settings.displayModifierInfo) then
    if (tonumber(value) >= 0) then
      outputString = outputString..'|cff00FF00(+'..value..')';
    else
      outputString = outputString..'|cffFF0000('..value..')';
    end;

    local statsStr = '';
    SS_Shared_ForEach(stats)(function(name)
      statsStr = statsStr..SS_Locale(name)..', ';
    end);
    statsStr = statsStr:sub(1, #statsStr - 2);

    outputString = outputString..'|cffFFFF00 для |r['..statsStr..']';
    if (tonumber(count) > 0) then
      outputString = outputString..'|cffFFFF00 на |r'..count..'|cffFFFF00 ходов|r';
    else
      outputString = outputString..'|cffFFFF00 до отмены|r';
    end;
  end;

  print(outputString);
end;

SS_Log_ModifierRemoved = function(name, stats, value)
  local outputString = '|cffFFFF00Потерян модификатор |r"'..name..'" ';
  
  if (SS_User.settings.displayModifierInfo) then
    if (tonumber(value) >= 0) then
      outputString = outputString..'|cff00FF00(+'..value..')';
    else
      outputString = outputString..'|cffFF0000('..value..')';
    end;

    local statsStr = '';
    SS_Shared_ForEach(stats)(function(name)
      statsStr = statsStr..SS_Locale(name)..', ';
    end);
    statsStr = statsStr:sub(1, #statsStr - 2);

    outputString = outputString..'|cffFFFF00 для |r['..statsStr..']';
  end;

  print(outputString);
end;

SS_Log_ModifierRemovedByDM = function(name, value)
  local outputString = '|cffFFFF00Модификатор |r"'..name..'" ';
  if (tonumber(value) >= 0) then
    outputString = outputString..'|cff00FF00(+'..value..')';
  else
    outputString = outputString..'|cffFF0000('..value..')';
  end;

  outputString = outputString..' |cffFF0000удалён мастером|r';
  print(outputString);
end;

SS_Log_ModifierRemovedByGHI = function(name, value)
  local outputString = '|cffFFFF00Модификатор |r"'..name..'" ';
  if (tonumber(value) >= 0) then
    outputString = outputString..'|cff00FF00(+'..value..')';
  else
    outputString = outputString..'|cffFF0000('..value..')';
  end;

  outputString = outputString..' |cffFF0000потерян|r |cffFFFF00после использования предмета|r';
  print(outputString);
end;

SS_Log_MasterForceRoll = function()
  print('|cff00FF00Следующий бросок по запросу ведущего|r');
end;

SS_Log_GHIForceRoll = function()
  print('|cff00FF00Следующий бросок по причние взаимодействия с предметом|r');
end;

SS_Log_RollResultOfOther = function(name, skill, result, efficency, diceMin, diceMax, diceCount, modifier)
  local diceAverage = (SS_Shared_NumFromStr(diceMin) + SS_Shared_NumFromStr(diceMax)) / 2;
  result = SS_Shared_NumFromStr(result);
  efficency = SS_Shared_NumFromStr(efficency);

  local output = '';

  if (SS_User.settings.displayDiceInfo) then
    output = '|cffFFFF00'..name..', проверка навыка: |r'..SS_Locale(skill)..".|cffFFFF00 Результат:|r";
    output = output..' '..diceCount..'d('..diceMin..'-'..diceMax..')';

    modifier = SS_Shared_NumFromStr(modifier);
    if (modifier > 0) then
      output = output..'|cff00FF00+'..modifier..'|r';
    elseif (modifier < 0) then
      output = output..'|cffFF0000'..modifier..'|r';
    end;

    output = output..'|cffFFFF00 -> |r';

    if (result > diceAverage + (diceAverage * 0.25)) then
      output = output..'|cFF00FF00'..result..'|r';
    elseif (result < diceAverage - (diceAverage * 0.25)) then
      output = output..'|cFFFF0000'..result..'|r';
    else
      output = output..result;
    end;

    output = output..'. |cffFFFF00Эффективность: |r|cff9999FF'..efficency..'|r';
  else
    output = '|cffFFFF00'..name..' выбрасывает |r';

    if (result < diceAverage - (diceAverage * 0.25)) then
      output = output.."|cFFFF0000"..result.."|r";
    elseif (result > diceAverage + (diceAverage * 0.25)) then
      output = output.."|cFF00FF00"..result.."|r";
    else
      output = output..result;
    end;
    
    output = output..' ('..SS_Locale(skill)..').';
    if (efficency > 1) then
      output = output..'|cffFFFF00 Эффективность: |r'..efficency;
    end;
  end;

  print(output);
  return;
end;

SS_Log_NoID = function()
  print('|cffFF0000Ошибка: не указан идентификатор|r');
end;

SS_Log_NoName = function()
  print('|cffFF0000Ошибка: не указано имя|r');
end;

SS_Log_NoValue = function()
  print('|cffFF0000Ошибка: не указано значение|r');
end;

SS_Log_NoCount = function()
  print('|cffFF0000Ошибка: не указано количество бросков|r');
end;

SS_Log_NoStats = function()
  print('|cffFF0000Ошибка: не выбрано ни одной характеристики или навыка|r');
end;

SS_Log_NoModifier = function()
  print('|cffFF0000Ошибка: не выбрано ни одного модификатора|r');
end;

SS_Log_CanNotInBattle = function()
  print('|cffFF0000Ошибка: нельзя совершать это действие в бою|r');
end;

SS_Log_NoMovementPoints = function()
  print('|cffFF0000Закончились очки перемещения!|r');
end;

SS_Log_PlayerGetModifier = function(name, value, stats, player)
  local outputString = player..'|cffFFFF00 получил модификатор |r"'..name..'" ';
  
  if (SS_User.settings.displayModifierInfo) then
    if (tonumber(value) >= 0) then
      outputString = outputString..'|cff00FF00(+'..value..')';
    else
      outputString = outputString..'|cffFF0000('..value..')';
    end;

    local statsStr = '';
    SS_Shared_ForEach(stats)(function(name)
      statsStr = statsStr..SS_Locale(name)..', ';
    end);
    statsStr = statsStr:sub(1, #statsStr - 2);

    outputString = outputString..'|cffFFFF00 для |r['..statsStr..']|cffFFFF00|r';
  end;
  print(outputString);
end;

SS_Log_PlayerLooseModifier = function(name, value, stats, player)
  local outputString = player..'|cffFFFF00 потерял модификатор |r"'..name..'" ';
  
  if (SS_User.settings.displayModifierInfo) then
    if (tonumber(value) >= 0) then
      outputString = outputString..'|cff00FF00(+'..value..')';
    else
      outputString = outputString..'|cffFF0000('..value..')';
    end;

    local statsStr = '';
    SS_Shared_ForEach(stats)(function(name)
      statsStr = statsStr..SS_Locale(name)..', ';
    end);
    statsStr = statsStr:sub(1, #statsStr - 2);

    outputString = outputString..'|cffFFFF00 для |r['..statsStr..']|cffFFFF00|r';
  end;
  print(outputString);
end;