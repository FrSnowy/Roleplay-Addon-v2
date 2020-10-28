local IconsForBuff = {
  power = 'Interface\\Icons\\Spell_Nature_Strength',
  accuracy = 'Interface\\Icons\\Ability_Hunter_SniperShot',
  wisdom = 'Interface\\Icons\\Spell_Shadow_ManaFeed',
  morale = 'Interface\\Icons\\INV_Relics_TotemofRage',
  empathy = 'Interface\\Icons\\Spell_Misc_EmotionHappy',
  mobility = 'Interface\\Icons\\Rogue_BurstofSpeed',
  precision = 'Interface\\Icons\\Ability_Seal',
  melee = 'Interface\\Icons\\Ability_DualWield',
  range = 'Interface\\Icons\\Ability_Hunter_LockAndLoad',
  magic = 'Interface\\Icons\\Spell_Arcane_FocusedPower',
  religion = 'Interface\\Icons\\Spell_Holy_SealOfWisdom',
  perfomance = 'Interface\\Icons\\Spell_Shadow_PsychicScream',
  missing = 'Interface\\Icons\\Ability_Vanish',
  hands = 'Interface\\Icons\\INV_Misc_Desecrated_ClothGlove',
  athletics = 'Interface\\Icons\\Spell_Holy_FistOfJustice',
  observation = 'Interface\\Icons\\Ability_EyeOfTheOwl',
  knowledge = 'Interface\\Icons\\INV_Misc_Book_05',
  controll = 'Interface\\Icons\\Spell_Holy_DivineSpirit',
  judgment = 'Interface\\Icons\\INV_Mask_01',
  acrobats = 'Interface\\Icons\\Achievement_BG_captureflag_WSG',
};

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

    --[[
    GHI_ActionAPI().GetAPI().GHI_ApplyBuff(
      modifier.name,
      'Описание',
      IconsForBuff[modifier.stat],
      true,
      'Helpful',
      '',
      30,
      false,
      true,
      tonumber(modifier.count)
    );
    ]]--

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
