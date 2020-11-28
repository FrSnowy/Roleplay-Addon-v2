local category = "Ролевая система от Snowy";

local statModifierMenuPoint = function(name, order)
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

local skillModifierMenuPoint = function(name, order)
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

    local statsAsStr = '';
    for i = 1, #filteredStats do
      statsAsStr = statsAsStr..filteredStats[i]..'}';
    end;
    statsAsStr = statsAsStr:sub(1, #statsAsStr - 1);

    local value = dyn.GetInput("value");
    local count = dyn.GetInput("count");
    SendAddonMessage('SS-GHItP', '~addStatModifier|'..id..'+'..name..'+'..statsAsStr..'+'..value..'+'..count..'~', 'WHISPER', UnitName('player'));

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
    stat1 = statModifierMenuPoint('Характеристика 1', 5),
    stat2 = statModifierMenuPoint('Характеристика 2', 6),
    stat3 = statModifierMenuPoint('Характеристика 3', 7),
    stat4 = statModifierMenuPoint('Характеристика 4', 8),
    stat5 = statModifierMenuPoint('Характеристика 5', 9),
    stat6 = statModifierMenuPoint('Характеристика 6', 10),
    stat7 = statModifierMenuPoint('Характеристика 7', 11),
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

    local statsAsStr = '';
    for i = 1, #filteredStats do
      statsAsStr = statsAsStr..filteredStats[i]..'}';
    end;
    statsAsStr = statsAsStr:sub(1, #statsAsStr - 1);
  
    local value = dyn.GetInput("value");
    local count = dyn.GetInput("count");
    SendAddonMessage('SS-GHItP', '~addSkillModifier|'..id..'+'..name..'+'..statsAsStr..'+'..value..'+'..count..'~', 'WHISPER', UnitName('player'));
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
		stat1 = skillModifierMenuPoint("Навык 1", 5),
		stat2 = skillModifierMenuPoint("Навык 2", 6),
		stat3 = skillModifierMenuPoint("Навык 3", 7),
		stat4 = skillModifierMenuPoint("Навык 4", 8),
		stat5 = skillModifierMenuPoint("Навык 5", 9),
		stat6 = skillModifierMenuPoint("Навык 6", 10),
		stat7 = skillModifierMenuPoint("Навык 7", 11),
		stat8 = skillModifierMenuPoint("Навык 8", 12),
		stat9 = skillModifierMenuPoint("Навык 9", 13),
		stat10 = skillModifierMenuPoint("Навык 10", 14),
		stat11 = skillModifierMenuPoint("Навык 11", 15),
		stat12 = skillModifierMenuPoint("Навык 12", 16),
		stat13 = skillModifierMenuPoint("Навык 13", 17),
		stat14 = skillModifierMenuPoint("Навык 14", 18),
	},
});

GHI_DynamicActionList().LoadActions();