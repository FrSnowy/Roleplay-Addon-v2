local categories = {
  modifiers = 'Ролевая система от Снежка: Модификаторы',
  checks = 'Ролевая система от Снежка: Проверки',
  battle = 'Ролевая система от Снежка: Бой и урон',
  params = 'Ролевая система от Снежка: Показатели',
};

SS_LOAD_GHI_CONFIGURATION = function()
  if (not(GHI_MiscData)) then return nil; end;

  if (not(GHI_MiscData["WhiteList"])) then
    GHI_MiscData["WhiteList"] = {};
  end;
  
  SS_Shared_ForEach({
    'SS_Plots_Current',
    'SS_Roll',
    'SS_Modifiers_Register',
    'SS_Log_ModifierAdded',
    'SS_Log_ModifierRemovedByGHI',
    'SS_Modifiers_Get',
    'SS_Modifiers_Remove',
    'SS_PtDM_PlayerGetModifier',
    'SS_BattleControll_IsInBattle',
    'SS_BattleControll_IsInPhase',
    'SS_Log_MovementPointsAdded',
    'SS_PtDM_GetAdditionalMovementPoints',
    'SS_BattleControll_EndRound',
    'SS_DamageControll_RecieveDamage',
    'SS_Shared_IfOnline',
    'SS_Log_CanNotInBattle',
    'SS_PtDM_Params',
    'SS_PtDM_InspectInfo',
    'SS_PtDM_HPChanged',
    'SS_PtDM_BarrierChanged',
    'SS_PtDM_ExpChanged',
    'SS_PtDM_LevelChanged',
    'SS_Params_ChangeHealth',
    'SS_Params_ChangeBarrier',
    'SS_Progress_UpdateExp',
    'SS_Progress_UpdateLevel',
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
          { value = "charm", text = "Харизма" },
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
    category = categories.modifiers,
    description = "Добавить модификатор для ролевой характеристики",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
    
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
    category = categories.modifiers,
    description = "Добавить модификатор для ролевого навыка",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
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
    category = categories.modifiers,
    description = "Удалить модификатор хар-ки",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
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
    category = categories.modifiers,
    description = "Удалить модификатор навыка",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
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
    category = categories.checks,
    description = "Совершить бросок кубика навыка",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
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
  
  table.insert(GHI_ProvidedDynamicActions, {
    name = "Находится в бою",
    guid = "SS_Battle_Check",
    authorName = "FriendSnowy",
    authorGuid = "00x1",
    version = 1,
    category = categories.battle,
    description = "Находится ли персонаж в состоянии ролевого боя",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
      local battleType = dyn.GetInput("battleType");
      local result = false;
  
      if (battleType == 'all') then
        result = SS_BattleControll_IsInBattle()
      else
        result = SS_BattleControll_IsInBattle(battleType)
      end;
  
      if (result) then
        dyn.TriggerOutPort("isIn")
      else
        dyn.TriggerOutPort("isNotIn")
      end;
    ]],
    ports = {
      isIn = {
        name = "Находится в бою",
        direction = "out",
        description = "",
        order = 1,
      },
      isNotIn = {
        name = "Не находится в бою",
        direction = "out",
        description = "",
        order = 2,
      },
    },
    inputs = {
      battleType = {
        name = 'Тип боя',
        order = 1,
        type = "string",
        defaultValue = "all",
        specialGHM = "ghm_fromDDList",
        specialGHMScript = [[
          dataFunc = function()
            return {
              { value = "all", text = "Любой" },
              { value = "phases", text = "Послед. фазы" },
              { value = "initiative", text = "Инициатива" },
              { value = "free", text = "Свободный" },
            };
          end]],
      }
    },
  });
  
  table.insert(GHI_ProvidedDynamicActions, {
    name = "Находится в фазе боя",
    guid = "SS_Battle_PhaseCheck",
    authorName = "FriendSnowy",
    authorGuid = "00x1",
    version = 1,
    category = categories.battle,
    description = "Находится ли персонаж в нужной фазе ролевого боя",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
      local phase = dyn.GetInput("phase");
      local result = SS_BattleControll_IsInPhase(phase);
  
      if (result) then
        dyn.TriggerOutPort("isIn")
      else
        dyn.TriggerOutPort("isNotIn")
      end;
    ]],
    ports = {
      isIn = {
        name = "Находится в фазе",
        direction = "out",
        description = "",
        order = 1,
      },
      isNotIn = {
        name = "Не находится в фазе",
        direction = "out",
        description = "",
        order = 2,
      },
    },
    inputs = {
      phase = {
        name = 'Фаза',
        order = 1,
        type = "string",
        defaultValue = "active",
        specialGHM = "ghm_fromDDList",
        specialGHMScript = [[
          dataFunc = function()
            return {
              { value = "active", text = "Активное действие" },
              { value = "selfTurn", text = "Свой ход по инициативе" },
              { value = "defence", text = "Защита" },
            };
          end]],
      }
    },
  });
  
  table.insert(GHI_ProvidedDynamicActions, {
    name = "Добавить очков перемещения",
    guid = "SS_Battle_AddMovementPoints",
    authorName = "FriendSnowy",
    authorGuid = "00x1",
    version = 1,
    category = categories.battle,
    description = "Добавить дополнительные очки перемещения",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
      if (not(SS_Plots_Current().battle)) then return nil; end;
      if (SS_Plots_Current().battle.movementPoints == nil) then return nil; end;
      if (SS_BattleControll_IsInBattle('free')) then
        dyn.TriggerOutPort("added")
        return nil;
      end;
  
      local movementPoints = dyn.GetInput("movement");
      SS_Plots_Current().battle.movementPoints = SS_Plots_Current().battle.movementPoints + movementPoints;
      if (SS_Plots_Current().battle.movementPoints < 0) then
        SS_Plots_Current().battle.movementPoints = 0;
      end;
      SS_Log_MovementPointsAdded(movementPoints);
      SS_PtDM_GetAdditionalMovementPoints(movementPoints, SS_Plots_Current().author);
  
      dyn.TriggerOutPort("added")
    ]],
    ports = {
      added = {
        name = "ОП Добавлены",
        direction = "out",
        description = "",
        order = 1,
      },
    },
    inputs = {
      movement = {
        name = "Дополнительные очки",
        description = "",
        type = "number",
        defaultValue = "",
        order = 1,
      },
    },
  });
  
  table.insert(GHI_ProvidedDynamicActions, {
    name = "Завершить ход",
    guid = "SS_Battle_EndRound",
    authorName = "FriendSnowy",
    authorGuid = "00x1",
    version = 1,
    category = categories.battle,
    description = "Закончить текущий ход",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
      if (not(SS_Plots_Current().battle)) then return nil; end;
      if (SS_BattleControll_IsInBattle('free')) then return nil; end;
      SS_BattleControll_EndRound();
      dyn.TriggerOutPort("ended")
    ]],
    ports = {
      ended = {
        name = "Ход завершен",
        direction = "out",
        description = "",
        order = 1,
      },
    },
  });
  
  table.insert(GHI_ProvidedDynamicActions, {
    name = "Получить урон",
    guid = "SS_Battle_GetDamage",
    authorName = "FriendSnowy",
    authorGuid = "00x1",
    version = 1,
    category = categories.battle,
    description = "",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
      local dmg = dyn.GetInput("damage");
      local ignoreArmor = dyn.GetInput("ignoreArmor");
  
      SS_DamageControll_RecieveDamage(dmg, ignoreArmor, SS_Plots_Current().author);
      dyn.TriggerOutPort("damageSended")
    ]],
    ports = {
      damageSended = {
        name = "Урон нанесен",
        direction = "out",
        description = "",
        order = 1,
      },
    },
    inputs = {
      damage = {
        name = "Количество урона",
        type = "number",
        defaultValue = 0,
        order = 1,
      },
      ignoreArmor = {
        name = "Игнорировать броню",
        description = "Урон пройдет сразу по ОЗ",
        order = 2,
        type = "boolean",
        defaultValue = false,
      },
    },
  });
  
  table.insert(GHI_ProvidedDynamicActions, {
    name = "Изменить очки здоровья",
    guid = "SS_Battle_ChangeHealth",
    authorName = "FriendSnowy",
    authorGuid = "00x1",
    version = 1,
    category = categories.params,
    description = "",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
      local updateValue = dyn.GetInput("updateValue");
      if (not(updateValue == 0)) then
        SS_Params_ChangeHealth(updateValue, UnitName("player"));
      
        SS_Shared_IfOnline(SS_Plots_Current().author, function()
          SS_PtDM_Params(SS_Plots_Current().author);
          SS_PtDM_InspectInfo("update", SS_Plots_Current().author);
          SS_PtDM_HPChanged(updateValue, SS_Plots_Current().author);
        end);
      end;
  
      dyn.TriggerOutPort("healthChanged")
    ]],
    ports = {
      healthChanged = {
        name = "ОЗ изменилось",
        direction = "out",
        description = "",
        order = 1,
      },
    },
    inputs = {
      updateValue = {
        name = "Изменение ОЗ",
        type = "number",
        defaultValue = 0,
        order = 1,
      },
    },
  });
  
  table.insert(GHI_ProvidedDynamicActions, {
    name = "Изменить очки брони",
    guid = "SS_Battle_ChangeBarrier",
    authorName = "FriendSnowy",
    authorGuid = "00x1",
    version = 1,
    category = categories.params,
    description = "",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
      local updateValue = dyn.GetInput("updateValue");
      if (not(updateValue == 0)) then
        SS_Params_ChangeBarrier(updateValue, UnitName("player"));
    
        SS_Shared_IfOnline(SS_Plots_Current().author, function()
          SS_PtDM_Params(SS_Plots_Current().author);
          SS_PtDM_InspectInfo("update", SS_Plots_Current().author);
          SS_PtDM_BarrierChanged(updateValue, SS_Plots_Current().author);
        end);
      end;
      dyn.TriggerOutPort("barrierChanged")
    ]],
    ports = {
      barrierChanged = {
        name = "ОБ изменились",
        direction = "out",
        description = "",
        order = 1,
      },
    },
    inputs = {
      updateValue = {
        name = "Изменение ОБ",
        type = "number",
        defaultValue = 0,
        order = 1,
      },
    },
  });
  
  table.insert(GHI_ProvidedDynamicActions, {
    name = "Изменить опыт",
    guid = "SS_Battle_ChangeExp",
    authorName = "FriendSnowy",
    authorGuid = "00x1",
    version = 1,
    category = categories.params,
    description = "",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
      local cachedLevel = SS_Plots_Current().progress.level;
  
      local updateValue = dyn.GetInput("updateValue");
      if (updateValue < 0 and SS_BattleControll_IsInBattle()) then
        SS_Log_CanNotInBattle();
        dyn.TriggerOutPort("expWasntChanged")
        return;
      end;
  
      if (not(updateValue == 0)) then
        SS_Progress_UpdateExp(updateValue, UnitName("player"));
    
        SS_Shared_IfOnline(SS_Plots_Current().author, function()
          SS_PtDM_Params(SS_Plots_Current().author);
          SS_PtDM_InspectInfo("update", SS_Plots_Current().author);
          SS_PtDM_ExpChanged(updateValue, SS_Plots_Current().author);
  
          if (not(cachedLevel == SS_Plots_Current().progress.level)) then
            SS_PtDM_LevelChanged(SS_Plots_Current().author);
          end;
        end);
      end;
      dyn.TriggerOutPort("expChanged")
    ]],
    ports = {
      expChanged = {
        name = "Опыт изменился",
        direction = "out",
        description = "",
        order = 1,
      },
      expWasntChanged = {
        name = "Опыт не изменился",
        direction = "out",
        description = "",
        order = 2,
      },
    },
    inputs = {
      updateValue = {
        name = "Изменение опыта",
        type = "number",
        defaultValue = 0,
        order = 1,
      },
    },
  });
  
  table.insert(GHI_ProvidedDynamicActions, {
    name = "Изменить уровень",
    guid = "SS_Battle_ChangeLevel",
    authorName = "FriendSnowy",
    authorGuid = "00x1",
    version = 1,
    category = categories.params,
    description = "",
    icon = "Interface\\Icons\\achievement_guild_level10",
    gotOnSetupPort = false,
    setupOnlyOnce = false,
    script =
    [[
      if (not(SS_Plots_Current())) then return nil; end;
  
      local updateValue = dyn.GetInput("updateValue");
      
      if (updateValue < 0 and SS_BattleControll_IsInBattle()) then
        SS_Log_CanNotInBattle();
        dyn.TriggerOutPort("levelWasntChanged")
        return;
      end;
  
      if (not(updateValue == 0)) then
        SS_Progress_UpdateLevel(updateValue, UnitName("player"));
    
        SS_Shared_IfOnline(SS_Plots_Current().author, function()
          SS_PtDM_Params(SS_Plots_Current().author);
          SS_PtDM_InspectInfo("update", SS_Plots_Current().author);
          SS_PtDM_LevelChanged(SS_Plots_Current().author);
        end);
      end;
      dyn.TriggerOutPort("levelChanged")
    ]],
    ports = {
      levelChanged = {
        name = "Уровень изменился",
        direction = "out",
        description = "",
        order = 1,
      },
      levelWasntChanged = {
        name = "Уровень не изменился",
        direction = "out",
        description = "",
        order = 2,
      },
    },
    inputs = {
      updateValue = {
        name = "Изменение уровня",
        type = "number",
        defaultValue = 0,
        order = 1,
      },
    },
  });
  
  GHI_DynamicActionList().LoadActions();
end;