SS_Modifiers_GetList = function()
	return {
		stats = {
      --[[
        id = {
          name = 'Бонус ништяка',
          stats = { 'power' },
          value = 1,
          count = 2,
        },
      ]]
    },
		skills = {
      --[[
        id = {
          name = 'Бонус ништяка',
          stats = { 'range' },
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

  if (not(params.stats)) then
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

local SS_Modifiers_DrawStatModifierInfo = function(stats)
  if (not(stats) or #stats == 0) then return nil; end;
  if (not(SS_Stats_IsStat(stats[1]))) then return nil; end;

  if (SS_Stats_Menu:IsVisible()) then
    SS_Stats_DrawAll();

    if (SS_Stats_Menu_Info:IsVisible()) then
      local stat = nil;
      local isSomeStatInTitle = SS_Shared_Includes(stats)(function(name)
        if (SS_Stats_Menu_Info.title:GetText() == SS_Locale(name)) then
          stat = name;
        end;

        return SS_Stats_Menu_Info.title:GetText() == SS_Locale(name)
      end);

      if (isSomeStatInTitle) then
        SS_Draw_StatInfo(stat, SS_Stats_Menu_Info_Inner_Content_Description:GetText());
      end;
    end;
  end;
end;

local SS_Modifiers_DrawSkillModifierInfo = function(stats)
  if (not(stats) or #stats == 0) then return nil; end;
  if (not(SS_Skills_IsSkill(stats[1]))) then return nil; end;

  if (SS_Skills_Menu:IsVisible()) then
    SS_Skills_DrawAll();

    if (SS_Skills_Menu_Info:IsVisible()) then
      local stat = nil;
      local isSomeStatInTitle = SS_Shared_Includes(stats)(function(name)
        if (SS_Skills_Menu_Info.title:GetText() == SS_Locale(name)) then
          stat = name;
        end;
        return SS_Skills_Menu_Info.title:GetText() == SS_Locale(name)
      end);

      if (isSomeStatInTitle) then
        SS_Draw_SkillInfo(stat, SS_Skills_Menu_Info_Inner_Content_Description:GetText(), SS_Skills_Menu_Info_Inner_Content_Examples:GetText());
      end;
    end;
  end;
end;

SS_Modifiers_Register = function(modifierType, modifier)
  if (not(SS_User) or not(SS_Plots_Current())) then return nil; end;
  if (not(modifierType == 'stats') and not(modifierType == 'skills')) then return nil; end;
  if (not(SS_Modifiers_CheckParameters(modifier))) then return nil; end;
  
  SS_Plots_Current().modifiers[modifierType][modifier.id] = {
    name = modifier.name,
    stats = modifier.stats,
    value = modifier.value,
    count = modifier.count,
  };

  SS_Params_DrawHealth();
  SS_Params_DrawBarrier();

  SS_Modifiers_DrawStatModifierInfo(modifier.stats);
  SS_Modifiers_DrawSkillModifierInfo(modifier.stats);
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
      local isStatIncluded = SS_Shared_Includes(modifier.stats)(function(statName)
        return statName == stat
      end);

      if (isStatIncluded) then
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
      local isStatIncluded = SS_Shared_Includes(modifier.stats)(function(statName)
        return statName == stat
      end);
    
      if (isStatIncluded) then
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
      local isStatIncluded = SS_Shared_Includes(modifier.stats)(function(statName)
        return statName == stat
      end);

      if (isStatIncluded) then
        if (tonumber(modifier.count) > 0) then
          modifier.count = modifier.count - 1;
          if (modifier.count <= 0) then
            SS_Log_ModifierRemoved(modifier.name, modifier.stats, modifier.value)
            SS_Modifiers_Remove(modifierType)(id);
          end;
        end;
      end;
    end);
  
  end;
end;

SS_Modifiers_Remove = function(modifierType)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(modifierType == 'stats') and not(modifierType == 'skills')) then return nil; end;

  return function(modifierID)
    if (not(modifierID) or not(SS_Plots_Current().modifiers[modifierType][modifierID])) then return nil; end;
    local stats = SS_Plots_Current().modifiers[modifierType][modifierID].stats;

    SS_Plots_Current().modifiers[modifierType][modifierID] = nil;
    SS_Modifiers_DrawStatModifierInfo(stats);
    SS_Modifiers_DrawSkillModifierInfo(stats);

    SS_Params_DrawHealth();
    SS_Params_DrawBarrier();
    SS_PtDM_UpdatePlayerInfo(SS_Plots_Current().author);
  end;
end;

SS_Modifiers_Get = function(modifierType, modifierID)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().modifiers)) then return nil end;
  if (not(SS_Plots_Current().modifiers[modifierType])) then return nil; end;
  if (not(SS_Plots_Current().modifiers[modifierType][modifierID])) then return nil; end;

  return SS_Plots_Current().modifiers[modifierType][modifierID];
end;

SS_Modifiers_Clear = function()
  SS_Plots_Current().modifiers = SS_Modifiers_GetList();
end;
