SS_Modifiers_GetList = function()
	return {
		stats = {
      --[[
        id = {
          name = 'Бонус ништяка',
          stat = 'power',
          value = 1,
          count = 2,
        },
      ]]
    },
		skills = {
      --[[
        id = {
          name = 'Бонус ништяка',
          stat = 'range',
          value = 1,
          count = 2,
        },
      ]]
    },
	};
end;

SS_Modifiers_CheckParameters = function(params)
  if (not(params)) then
    print('|cffFF0000Ошибка: Не получены нужные параметры при регистрации модификатора броска|r');
    return false;
  end;

  if (not(params.id)) then
    print('|cffFF0000Не найден идентификатор модификатора|r');
    return false;
  end;

  if (not(params.name)) then
    print('|cffFF0000Не найдено имя модификатора|r');
    return false;
  end;

  if (not(params.stat)) then
    print('|cffFF0000Нет характеристики или навыка модификатора|r');
    return false;
	end;

  if (not(params.value)) then
    print('|cffFF0000Не найдено значение модификатора|r');
    return false;
  end;
	
	if (not(params.count)) then
    print('|cffFF0000Не указано количество бросков|r');
		return false;
	end;

  return true;
end;

SS_Modifiers_Register = function(modifierType, modifier)
  if (not(SS_User) or not(SS_Plots_Current())) then return nil; end;
  if (not(modifierType == 'stats') and not(modifierType == 'skills')) then return nil; end;
  if (not(SS_Modifiers_CheckParameters(modifier))) then return nil; end;
  
  SS_Plots_Current().modifiers[modifierType][modifier.id] = {
    name = modifier.name,
    stat = modifier.stat,
    value = modifier.value,
    count = modifier.count,
  };

  SS_PtDM_UpdatePlayerInfo(SS_Plots_Current().author);
end;

SS_Modifiers_ReadModifiersValue = function(modifierType, modifiersList)
  local withLog = false;
  if (not(SS_Plots_Current())) then return 0; end;
  if (not(modifierType == 'stats') and not(modifierType == 'skills')) then return 0; end;

  if (modifiersList) then withLog = true; end;
  
  if (not(modifiersList)) then
    modifiersList = SS_Plots_Current().modifiers;
  end;

  local modifiers = modifiersList[modifierType];

  return function(stat)
    if (not(stat)) then return 0; end;
    local summary = 0;

    SS_Shared_ForEach(modifiers)(function(modifier, id)
      if (modifier.stat == stat) then
        summary = summary + modifier.value;
      end;
    end);

    return summary;
  end;
end;

SS_Modifiers_GetModifiersOf = function(modifierType)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(modifierType == 'stats') and not(modifierType == 'skills')) then return nil; end;

  local modifiers = SS_Plots_Current().modifiers[modifierType];

  return function(stat)
    if (not(stat)) then return nil; end;
    local output = nil;

    SS_Shared_ForEach(modifiers)(function(modifier, id)
      if (modifier.stat == stat) then
        if (output == nil) then output = { }; end;
        output[id] = modifier;
      end;
    end);

    return output;
  end;
end;

SS_Modifiers_Fire = function(modifierType)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(modifierType == 'stats') and not(modifierType == 'skills')) then return nil; end;

  local modifiers = SS_Plots_Current().modifiers[modifierType];

  return function(stat)
    if (not(stat)) then return nil; end;
    SS_Shared_ForEach(modifiers)(function(modifier, id)
      if (modifier.stat == stat) then
        if (tonumber(modifier.count) > 0) then
          modifier.count = modifier.count - 1;
          if (modifier.count <= 0) then
            SS_Log_StatModifierRemoved(modifier.name, modifier.stat, modifier.value)
            modifiers[id] = nil;
          end;
        end;
      end;
    end);
  
  end;
end;

SS_Modifiers_Clear = function()
  SS_Plots_Current().modifiers = SS_Modifiers_GetList();
end;

--[[
SS_Modifiers_RecieveModifiersValue = function(modifierType)
  if (not(SS_Plots_Current())) then return 0; end;
  if (not(modifierType == 'stats') and not(modifierType == 'skills')) then return 0; end;

  local modifiers = SS_Plots_Current().modifiers[modifierType];

  return function(stat)
    if (not(stat)) then return 0; end;

    local summary = 0;

    SS_Shared_ForEach(SS_Plots_Current().modifiers.stats)(function(modifier, id)
      if (modifier.stat == stat) then
        summary = summary + modifier.value;

        if (tonumber(modifier.count) >= 0) then
          modifier.count = modifier.count - 1;
          if (modifier.count <= 0) then modifiers[id] = nil; end;
        end;
      end;
    end);

    return summary;
  end;
end;
--]]