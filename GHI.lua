local category = "Ролевая система от Snowy";

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
    local stat = dyn.GetInput("stat");
    local value = dyn.GetInput("value");
    local count = dyn.GetInput("count");
    SendAddonMessage('SS-GHItP', 'addStatModifier|'..id..'+'..name..'+'..stat..'+'..value..'+'..count, 'WHISPER', UnitName('player'));
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
		stat = {
			name = "Характеристика",
      description = "Модифицируемая характеристика",
      type = "string",
      defaultValue = false,
      order = 3,
			specialGHM = "ghm_fromDDList",
			specialGHMScript = [[
			dataFunc = function()
				return {
					{ value = "power", text = "Мощь" },
					{ value = "accuracy", text = "Точность" },
					{ value = "wisdom", text = "Мудрость" },
					{ value = "morale", text = "Мораль" },
          { value = "empathy", text = "Эмпатия" },
          { value = "mobility", text = "Подвижность" },
          { value = "precision", text = "Аккуратность" },
				};
			end]],
		},
		value = {
			name = "Значение",
			description = "Характеристика изменится на значение",
			type = "number",
      defaultValue = "",
      order = 4,
		},
		count = {
			name = "Количество до отмены",
			description = "Через сколько проверок модификатор перестанет действовать",
			type = "number",
      defaultValue = "",
      order = 5,
		},
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
    local skill = dyn.GetInput("skill");
    local value = dyn.GetInput("value");
    local count = dyn.GetInput("count");
    SendAddonMessage('SS-GHItP', 'addSkillModifier|'..id..'+'..name..'+'..skill..'+'..value..'+'..count, 'WHISPER', UnitName('player'));
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
		skill = {
			name = "Навык",
      description = "Модифицируемый навык",
      type = "string",
      defaultValue = false,
      order = 3,
			specialGHM = "ghm_fromDDList",
			specialGHMScript = [[
			dataFunc = function()
				return {
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
		},
		value = {
			name = "Значение",
			description = "Навык изменится на значение",
			type = "number",
      defaultValue = "",
      order = 4,
		},
		count = {
			name = "Количество до отмены",
			description = "Через сколько проверок модификатор перестанет действовать",
			type = "number",
      defaultValue = "",
      order = 5,
		},
	},
});

GHI_DynamicActionList().LoadActions();