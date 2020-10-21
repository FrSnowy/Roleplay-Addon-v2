SS_Log_SkillRoll = function(finalResult, otherModifiers, armorModifier, statModifier, results, dices, diceCount, skillName)
  print('-------------');
  print('|cffFFFF00Проверка навыка: |r'..SS_Locale(skillName).."|cffFFFF00: |r"..diceCount..'d('..dices.from.."-"..dices.to..')');
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

  if (not(otherModifiers == 0)) then
    local outputString = '|cffFFFF00От сторонник модификаторов: |r';
    if (otherModifiers > 0) then
      outputString = outputString..'|cff00FF00'..otherModifiers..'|r';
    elseif (otherModifiers < 0) then
      outputString = outputString..'|cffFF0000'..otherModifiers..'|r';
    else
      outputString = outputString..otherModifiers;
    end;
    print(outputString);
  end;

  print('|cffFFFF00Итоговый результат проверки: |r|cff9999FF'..finalResult.."|r");
end;

SS_Log_EfficencyRoll = function(result, otherModifiers, maxValue)
  if (maxValue == 1 and result == 1) then
    return nil;
  else
    local outputString = '|cffFFFF00Эффективность: |r';
    if (maxValue == 1) then
      outputString = outputString..'1. ';
    else
      outputString = outputString..'1d(1-'..maxValue..'). '
    end;

    if (not(otherModifiers == 0)) then
      outputString = outputString..'|cffFFFF00От модиф.: |r';
      if (otherModifiers > 0) then
        outputString = outputString..'|cff00FF00'..otherModifiers..'. |r';
      elseif (otherModifiers < 0) then
        outputString = outputString..'|cffFF0000'..otherModifiers..'. |r';
      else
        outputString = outputString..otherModifiers..'. ';
      end;
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