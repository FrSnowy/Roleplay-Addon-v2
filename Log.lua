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

SS_Log_DMStopEvent = function(plot)
  print('|cffFFFF00Мастер завершил событие сюжета |r"'..plot..'"');
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

SS_Log_NoDMGValue = function()
  print('|cffFF0000Ошибка: не указано количество наносимых очков урона|r');
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

SS_Log_ValueMustBeNum = function()
  print('|cffFF0000Значение должно быть числом|r');
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

SS_Log_PlayerJoinedToBattle = function(name)
  print(name..'|cffFFFF00 присоединился к сражению|r');
end;

SS_Log_BattleJoinSuccess = function(name)
  print('|cffFFFF00Начинается бой!|r');
end;

SS_Log_BattlePlayerEndTurn = function(name, fullCount, completedCount)
  if (not(fullCount == completedCount)) then
    print(name..'|cffFFFF00 закончил ход. Всего |r['..completedCount..'/'..fullCount..']');
  else
    print(name..'|cffFFFF00 закончил ход. Все игроки закончили ход|r');
  end;
end;

SS_Log_PlayerMovingWithoutPoints = function(name)
  print(name..'|cffFFFF00 потерял все доступные очки перемещения!|r');
end;

SS_Log_BattleKicked = function()
  print('|cffFFFF00Вы были исключены из сражения|r');
end;

SS_Log_BattleEnded = function()
  print('|cffFFFF00Бой завершён|r');
end;

SS_Log_PlayerAlreadyInBattle = function(name)
  print(name..'|cffFF0000 уже находится в состоянии боя.|r');
end;

SS_Log_PlayerLeavesBattle = function(name)
  print(name..'|cffFFFF00 покинул бой.|r');
end;

SS_Log_AllPlayersLeavedBattle = function()
  print('|cffFFFF00Все игроки покинули сражение. Битва завершена автоматически.|r');
end;

SS_Log_MovementPointsAdded = function(points)
  if (points >= 0) then
    print('|cffFFFF00Добавлено |r'..points..'|cffFFFF00 очков перемещения.|r');
  else
    print('|cffFF0000Потеряно |r'..math.abs(points)..'|cffFF0000 очков перемещения.|r');
  end;
end;

SS_Log_PlayerGetAdditionalBattleMovementPoints = function(points, player)
  if (points >= 0) then
    print(player..'|cffFFFF00 получил |r'..points..'|cffFFFF00 очко перемещения от использования предмета GHI.|r');
  else
    print(player..'|cffFF0000 потерял |r'..math.abs(points)..'|cffFF0000 очков перемещения от использования предмета GHI.|r');
  end;
end;

SS_Log_RecievedDamage = function(damage, ignoreArmor)
  if (ignoreArmor) then
    print('|cffFF0000Вы получили |r'..damage..'|cffFF0000 ед. урона, игнорирующего броню.|r');
  else
    print('|cffFF0000Вы получили |r'..damage..'|cffFF0000 ед. урона.|r');
  end;
end;

SS_Log_BarrierGetDMG = function(damage)
  print('|cff55AAFFБарьер впитал |r'..damage..'|cff55AAFF ед. урона.|r');
end;

SS_Log_BarrierGetDMGDestoyedAndSendDMGToHP = function(barrierDMG, hpDMG)
  print('|cffFF0000Барьер впитал |r'..barrierDMG..'|cffFF0000 ед. урона и был разрушен. Вы получили |r'..hpDMG..'|cffFF0000 ед. урона.|r');
end;

SS_Log_BarrierGetDMGAndDestoyed = function(damage)
  print('|cff55AAFFБарьер впитал |r'..damage..'|cff55AAFF ед. урона и был разрушен.|r');
end;

SS_Log_NoHP = function()
  print('|cffFF0000Вы потеряли все ОЗ и не можете совершать активных действий.|r');
end;

SS_Log_PlayerRecievedDamage = function(dmg, currentHP, player)
  local output = player..'|cffFFFF00 получает |r'..dmg..'|cffFFFF00 ед. урона|r';
  if (currentHP == 0) then
    output = output..'|cffFFFF00 и не может совершать активных действий.|r';
  else
    output = output..'|cffFFFF00.|r'
  end;

  print(output);
end;

SS_Log_HealthChanged = function(updateValue, master)
  if (master == UnitName('player')) then
    if (updateValue >= 0) then
      print('|cff00FF00Ваше текущее здоровье увеличено на |r'..updateValue..'|cff00FF00 [|r'..SS_Params_GetHealth()..'/'..SS_Params_GetMaxHealth()..'|cff00FF00]|r');
    else
      print('|cffFF0000Ваше текущее здоровье уменьшено на |r'..math.abs(updateValue)..'|cffFF0000 [|r'..SS_Params_GetHealth()..'/'..SS_Params_GetMaxHealth()..'|cffFF0000]|r');
    end;
  else
    if (updateValue >= 0) then
      print(master..'|cff00FF00 увеличил ваше текущее здоровье на |r'..updateValue..'|cff00FF00 [|r'..SS_Params_GetHealth()..'/'..SS_Params_GetMaxHealth()..'|cff00FF00]|r');
    else
      print(master..'|cffFF0000 уменьшил ваше текущее здоровье на |r'..math.abs(updateValue)..'|cffFF0000 [|r'..SS_Params_GetHealth()..'/'..SS_Params_GetMaxHealth()..'|cffFF0000]|r');
    end;
  end;
end;

SS_Log_BarrierChanged = function(updateValue, master)
  local output = '';
  if (master == UnitName('player')) then
    if (updateValue >= 0) then
      output = '|cff00FF00Текущая броня увеличена на |r'..updateValue;
      if (SS_Params_GetMaxBarrier() > 0) then
        output = output..'|cff00FF00 [|r'..SS_Params_GetBarrier()..'/'..SS_Params_GetMaxBarrier()..'|cff00FF00]|r';
      end;
    else
      output = '|cffFF0000Текущая броня уменьшена на |r'..math.abs(updateValue);

      if (SS_Params_GetMaxBarrier() > 0) then
        output = output..'|cffFF0000 [|r'..SS_Params_GetBarrier()..'/'..SS_Params_GetMaxBarrier()..'|cffFF0000]|r';
      end;
    end;
  else
    if (updateValue >= 0) then
      output = master..'|cff00FF00 увеличил вашу броню на |r'..updateValue;
      if (SS_Params_GetMaxBarrier() > 0) then
        output = output..'|cff00FF00 [|r'..SS_Params_GetBarrier()..'/'..SS_Params_GetMaxBarrier()..'|cff00FF00]|r';
      end;
    else
      output = master..'|cffFF0000 уменьшил вашу броню на |r'..math.abs(updateValue);
      if (SS_Params_GetMaxBarrier() > 0) then
        output = output..'|cffFF0000 [|r'..SS_Params_GetBarrier()..'/'..SS_Params_GetMaxBarrier()..'|cffFF0000]|r';
      end;
    end;
  end;

  print(output);
end;

SS_Log_LevelChanged = function(updateValue)
  local output = '';
  if (updateValue >= 0) then
    output = '|cff00FF00Вы перешли на уровень |r'..SS_Plots_Current().progress.level;
  else
    output = '|cffFF0000Вы перешли на уровень |r'..SS_Plots_Current().progress.level;
  end;

  print(output);
end;

SS_Log_ExpChanged = function(updateValue)
  local output = '';
  if (updateValue >= 0) then
    output = '|cff00FF00Вы получили |r'..updateValue..'|cff00FF00 ед. опыта|r';
  else
    output = '|cffFF0000Вы потеряли |r'..math.abs(updateValue)..'|cffFF0000 ед. опыта|r';
  end;

  print(output);
end;

SS_Log_PlayerHealthChanged = function(updateValue, player)
  if (updateValue >= 0) then
    print(player..'|cff00FF00 увеличил текущее здоровье на |r'..updateValue..'|cff00FF00.|r');
  else
    print(player..'|cffFF0000 уменьшил текущее здоровье на |r'..math.abs(updateValue)..'|cffFF0000.|r');
  end;
end;

SS_Log_PlayerBarrierChanged = function(updateValue, player)
  if (updateValue >= 0) then
    print(player..'|cff00FF00 получил |r'..updateValue..'|cff00FF00 очков брони.|r');
  else
    print(player..'|cffFF0000 потерял |r'..math.abs(updateValue)..'|cffFF0000 очков брони.|r');
  end;
end;


SS_Log_PlayerLevelChanged = function(playerLevel, player)
  print('|cffFFFF00Уровень игрока |r'..player..'|cffFFFF00 установлен на |r'..playerLevel..'|cffFFFF00.|r');
end;

SS_Log_PlayerExpChanged = function(updateValue, player)
  if (updateValue >= 0) then
    print(player..'|cff00FF00 получил |r'..updateValue..'|cff00FF00 ед. опыта.|r');
  else
    print(player..'|cffFF0000 потерял |r'..math.abs(updateValue)..'|cffFF0000 ед опыта.|r');
  end;  
end;

SS_Log_PointsReset = function()
  print('|cffFFFF00Очки навыков и характеристик были сброшены.|r');
end;