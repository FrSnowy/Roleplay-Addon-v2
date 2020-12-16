local category = "Ролевая система от Snowy";

if (GHI_MiscData and not(GHI_MiscData["WhiteList"])) then
  GHI_MiscData["WhiteList"] = {};
end;

SS_Shared_ForEach({
  'SS_Roll',
  'SS_Modifiers_Register',
  'SS_Log_ModifierAdded',
  'SS_Log_ModifierRemovedByGHI',
  'SS_Modifiers_Get',
  'SS_Modifiers_Remove',
})(function(el)
  local isKeyIncluded = SS_Shared_Includes(GHI_MiscData["WhiteList"])(function(v)
    return v == el;
  end);

  if (not(isKeyIncluded)) then
    table.insert(GHI_MiscData["WhiteList"], el)
  end;
end);
GHI_ScriptEnvList().ReloadEnv(UnitGUID("player"));

local statMenuPoint = function(name, order)
  return {
    name = name,
    order = order,
    type = "string",
    defaultValue = "nothing",
    specialGHM = "ghm_fromDDList",
    specialGHMScript = [[
      dataFunc = function()
        return {
          { value = "nothing", text = "Нет" },
          { value = "power", text = "Мощь" },
          { value = "accuracy", text = "Точность" },
          { value = "wisdom", text = "Мудрость" },
          { value = "morale", text = "Мораль" },
          { value = "empathy", text = "Эмпатия" },
          { value = "mobility", text = "Подвижность" },
          { value = "precision", text = "Аккуратность" },
        };
      end]],
  }
end;

local skillMenuPoint = function(name, order)
  return {
    name = name,
    order = order,
    type = "string",
    defaultValue = "nothing",
    specialGHM = "ghm_fromDDList",
    specialGHMScript = [[
    dataFunc = function()
      return {
        { value = "nothing", text = "Нет" },
        { value = "melee", text = "Ближний бой" },
        { value = "range", text = "Дальний бой" },
        { value = "magic", text = "Чародейство" },
        { value = "religion", text = "Вера" },
        { value = "perfomance", text = "Выступление" },
        { value = "missing", text = "Избегание" },
        { value = "hands", text = "Ловкость рук" },
        { value = "athletics", text = "Атлетика" },
        { value = "observation", text = "Внимательность" },
        { value = "knowledge", text = "Знание" },
        { value = "controll", text = "Самоконтроль" },
        { value = "judgment", text = "Суждение" },
        { value = "acrobats", text = "Акробатика" },
        { value = "stealth", text = "Скрытность" },
      };
    end]],
  }
end;

table.insert(GHI_ProvidedDynamicActions, {
	name = "Добавить модификатор хар-ки",
	guid = "SS_Add_StatModifier",
	authorName = "FriendSnowy",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Добавить модификатор для ролевой характеристики",
	icon = "Interface\\Icons\\achievement_guild_level10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
    local id = dyn.GetInput("id");
    local name = dyn.GetInput("name");
    local value = dyn.GetInput("value");
    local count = dyn.GetInput("count");

    local stats = { dyn.GetInput("stat1"), dyn.GetInput("stat2"), dyn.GetInput("stat3"), dyn.GetInput("stat4"), dyn.GetInput("stat5"), dyn.GetInput("stat6"), dyn.GetInput("stat7") };
    local filteredStats = {};
    for i = 1, #stats do
      local stat = stats[i];
      if (not(stat == 'nothing')) then
        local isAlreadyIn = false;
        for j = 1, #filteredStats do
          local filteredStat = filteredStats[j];
          if (filteredStat == stat) then
            isAlreadyIn = true;
            break;
          end;
        end;

        if (not(isAlreadyIn)) then
          table.insert(filteredStats, stat)
        end;
      end;
    end

    if (#filteredStats == 0) then
      print('|cffFF0000Ошибка: Не указано ни одной характеристики для модификатора|r')
      return;
    end;

    SS_Modifiers_Register('stats', {
      id = id,
      name = name,
      stats = filteredStats,
      value = value,
      count = count,
    });
    
    SS_Log_ModifierAdded(name, filteredStats, value, count);
    dyn.TriggerOutPort("added")
	]],
	ports = {
		added = {
			name = "Модификатор добавлен",
			direction = "out",
			description = "",
		},
	},
	inputs = {
		id = {
			name = "id",
			description = "Идентификатор модификатора",
			type = "string",
      defaultValue = "",
      order = 1,
		},
		name = {
			name = "Имя",
			description = "Имя добавляемого модификатора",
			type = "string",
      defaultValue = "",
      order = 2, 
		},
		value = {
			name = "Значение",
			description = "Характеристика изменится на значение",
			type = "number",
      defaultValue = "",
      order = 3,
		},
		count = {
			name = "Количество до отмены",
			description = "Через сколько проверок модификатор перестанет действовать",
			type = "number",
      defaultValue = "",
      order = 4,
    },
    stat1 = statMenuPoint('Характеристика 1', 5),
    stat2 = statMenuPoint('Характеристика 2', 6),
    stat3 = statMenuPoint('Характеристика 3', 7),
    stat4 = statMenuPoint('Характеристика 4', 8),
    stat5 = statMenuPoint('Характеристика 5', 9),
    stat6 = statMenuPoint('Характеристика 6', 10),
    stat7 = statMenuPoint('Характеристика 7', 11),
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Добавить модификатор навыка",
	guid = "SS_Add_SkillModifier",
	authorName = "FriendSnowy",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Добавить модификатор для ролевого навыка",
	icon = "Interface\\Icons\\achievement_guild_level10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
    local id = dyn.GetInput("id");
    local name = dyn.GetInput("name");
    local value = dyn.GetInput("value");
    local count = dyn.GetInput("count");
  
    local stats = {
      dyn.GetInput("stat1"), dyn.GetInput("stat2"), dyn.GetInput("stat3"), dyn.GetInput("stat4"), dyn.GetInput("stat5"), dyn.GetInput("stat6"), dyn.GetInput("stat7"),
      dyn.GetInput("stat8"), dyn.GetInput("stat9"), dyn.GetInput("stat10"), dyn.GetInput("stat11"), dyn.GetInput("stat12"), dyn.GetInput("stat13"), dyn.GetInput("stat14"),
    };
  
    local filteredStats = {};
    for i = 1, #stats do
      local stat = stats[i];
      if (not(stat == 'nothing')) then
        local isAlreadyIn = false;
        for j = 1, #filteredStats do
          local filteredStat = filteredStats[j];
          if (filteredStat == stat) then
            isAlreadyIn = true;
            break;
          end;
        end;

        if (not(isAlreadyIn)) then
          table.insert(filteredStats, stat)
        end;
      end;
    end

    if (#filteredStats == 0) then
      print('|cffFF0000Ошибка: Не указано ни одного навыка для модификатора|r')
      return;
    end;

    SS_Modifiers_Register('skills', {
      id = id,
      name = name,
      stats = filteredStats,
      value = value,
      count = count,
    });
    
    SS_Log_ModifierAdded(name, filteredStats, value, count);
    dyn.TriggerOutPort("added")
	]],
	ports = {
		added = {
			name = "Модификатор добавлен",
			direction = "out",
			description = "",
		},
	},
	inputs = {
		id = {
			name = "id",
			description = "Идентификатор модификатора",
			type = "string",
      defaultValue = "",
      order = 1,
		},
		name = {
			name = "Имя",
			description = "Имя добавляемого модификатора",
			type = "string",
      defaultValue = "",
      order = 2,
		},
		value = {
			name = "Значение",
			description = "Навык изменится на значение",
			type = "number",
      defaultValue = "",
      order = 3,
		},
		count = {
			name = "Количество до отмены",
			description = "Через сколько проверок модификатор перестанет действовать",
			type = "number",
      defaultValue = "",
      order = 4,
		},
		stat1 = skillMenuPoint("Навык 1", 5),
		stat2 = skillMenuPoint("Навык 2", 6),
		stat3 = skillMenuPoint("Навык 3", 7),
		stat4 = skillMenuPoint("Навык 4", 8),
		stat5 = skillMenuPoint("Навык 5", 9),
		stat6 = skillMenuPoint("Навык 6", 10),
		stat7 = skillMenuPoint("Навык 7", 11),
		stat8 = skillMenuPoint("Навык 8", 12),
		stat9 = skillMenuPoint("Навык 9", 13),
		stat10 = skillMenuPoint("Навык 10", 14),
		stat11 = skillMenuPoint("Навык 11", 15),
		stat12 = skillMenuPoint("Навык 12", 16),
		stat13 = skillMenuPoint("Навык 13", 17),
		stat14 = skillMenuPoint("Навык 14", 18),
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Удалить модификатор хар-ки",
	guid = "SS_Remove_StatModifier",
	authorName = "FriendSnowy",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Удалить модификатор хар-ки",
	icon = "Interface\\Icons\\achievement_guild_level10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
    local id = dyn.GetInput("id");
    local mod = SS_Modifiers_Get('stats', id);
    if (mod) then
      SS_Modifiers_Remove('stats')(id);
      SS_Log_ModifierRemovedByGHI(mod.name, mod.value);
    end;
    dyn.TriggerOutPort("removed")
	]],
	ports = {
		removed = {
			name = "Модификатор удалён",
			direction = "out",
			description = "",
		},
	},
	inputs = {
		id = {
			name = "id",
			description = "Идентификатор модификатора",
			type = "string",
      defaultValue = "",
      order = 1,
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Удалить модификатор навыка",
	guid = "SS_Remove_SkillModifier",
	authorName = "FriendSnowy",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Удалить модификатор навыка",
	icon = "Interface\\Icons\\achievement_guild_level10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
    local id = dyn.GetInput("id");
    local mod = SS_Modifiers_Get('skills', id);
    if (mod) then
      SS_Modifiers_Remove('skills')(id);
      SS_Log_ModifierRemovedByGHI(mod.name, mod.value);
    end;
    dyn.TriggerOutPort("removed")
	]],
	ports = {
		removed = {
			name = "Модификатор удалён",
			direction = "out",
			description = "",
		},
	},
	inputs = {
		id = {
			name = "id",
			description = "Идентификатор модификатора",
			type = "string",
      defaultValue = "",
      order = 1,
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Проверка навыка",
	guid = "SS_Roll_Dice",
	authorName = "FriendSnowy",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Совершить бросок кубика навыка",
	icon = "Interface\\Icons\\achievement_guild_level10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
    local stat = dyn.GetInput("stat");
    local successOn = dyn.GetInput("successOn");
    local hidden = dyn.GetInput("hidden");

    if (stat == 'nothing') then
      print('|cffFF00000Ошибка: не указан навык для проверки|r');
      return nil;
    end;

    local result = SS_Roll(stat, not(hidden));
    if (result >= successOn) then
      dyn.TriggerOutPort("success")
    else
      dyn.TriggerOutPort("failed")
    end;
	]],
	ports = {
		success = {
			name = "Бросок успешен",
			direction = "out",
			description = "",
		},
		failed = {
			name = "Бросок провален",
			direction = "out",
			description = "",
		},
	},
	inputs = {
    stat = skillMenuPoint("Навык", 1),
		successOn = {
			name = "Порог",
			type = "number",
      defaultValue = 0,
      order = 2,
		},
		hidden = {
			name = "Скрытый",
			description = "Скрытый бросок не отображается у игрока",
			order = 3,
			type = "boolean",
			defaultValue = false,
		},
	},
});

GHI_DynamicActionList().LoadActions();