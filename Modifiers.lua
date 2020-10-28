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

  if (modifierType == 'stats') then
    SS_Plots_Current().modifiers.stats[modifier.id] = {
      name = modifier.name,
      stat = modifier.stat,
      value = modifier.value,
      count = modifier.count,
    }
  elseif (modifierType == 'skills') then
    SS_Plots_Current().modifiers.skills[modifier.id] = {
      name = modifier.name,
      stat = modifier.stat,
      value = modifier.value,
      count = modifier.count,
    }
	end;
end;

SS_Modifiers_ReadModifiersValue = function(modifierType)
  if (not(SS_Plots_Current())) then return 0; end;
  if (not(modifierType == 'stats') and not(modifierType == 'skills')) then return 0; end;

  local modifiers = SS_Plots_Current().modifiers[modifierType];

  return function(stat)
    if (not(stat)) then return 0; end;

    local summary = 0;

    SS_Shared_ForEach(SS_Plots_Current().modifiers.stats)(function(modifier, id)
      if (modifier.stat == stat) then
        summary = summary + modifier.value;
      end;
    end);

    return summary;
  end;
end; 

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
