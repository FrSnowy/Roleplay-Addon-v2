SS_Listeners_DM_OnSendInspectInfo = function(inspectStr, player)
  -- У: Мастер, от: Игрок, когда: игрок отдает свои характеристики для панели осмотра ИЛИ когда игрок обновляет свои параметры во время открытой панели просмотра
  if (not(inspectStr) or not(player)) then return nil; end;
  if (not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  local plotID, params, stats, activeSkills, passiveSkills, statModifiersStr, skillModifiersStr, isInBattle, actionType = strsplit('+', inspectStr);
  if (actionType == "update" and (not(SS_Target_TMPData) or not(SS_Target_TMPData.name == player))) then return nil; end;

  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;
  local health, maxHealth, barrier, maxBarrier, level, experience, experienceForUp, armorType = strsplit('}', params);
  local power, accuracy, wisdom, morale, empathy, mobility, precision = strsplit('}', stats);
  local melee, range, magic, religion, charm, missing, hands = strsplit('}', activeSkills);
  local athletics, observation, knowledge, controll, judgment, acrobats, stealth = strsplit('}', passiveSkills);
  isInBattle = isInBattle == 'true';

  local statModifiers = {};
  if (not(statModifiersStr == 'nothing')) then
    SS_Shared_ForEach({ strsplit('}', statModifiersStr) })(function(modifier)
      local id, name, statsStr, value, count = strsplit('/', modifier);
      local stats = { strsplit('\\', statsStr) }
      statModifiers[id] = { name = name, stats = stats, value = value, count = count };
    end);
  end;

  local skillModifiers = {};
  if (not(skillModifiersStr == 'nothing')) then
    SS_Shared_ForEach({ strsplit('}', skillModifiersStr) })(function(modifier)
      local id, name, statsStr, value, count = strsplit('/', modifier);
      local stats = { strsplit('\\', statsStr) };
      skillModifiers[id] = { name = name, stats = stats, value = value, count = count };
    end);
  end;

  SS_Target_TMPData = {
    name = player,
    health = health,
    maxHealth = maxHealth,
    barrier = barrier,
    maxBarrier = maxBarrier,
    level = level,
    experience = experience,
    experienceForUp = experienceForUp,
    armorType = armorType,
    battle = {
      isInBattle = isInBattle,
    },
    stats = {
      power = SS_Shared_NumFromStr(power),
      accuracy = SS_Shared_NumFromStr(accuracy),
      wisdom = SS_Shared_NumFromStr(wisdom),
      morale = SS_Shared_NumFromStr(morale),
      empathy = SS_Shared_NumFromStr(empathy),
      mobility = SS_Shared_NumFromStr(mobility),
      precision = SS_Shared_NumFromStr(precision),
    },
    skills = {
      melee = SS_Shared_NumFromStr(melee),
      range = SS_Shared_NumFromStr(range),
      magic = SS_Shared_NumFromStr(magic),
      religion = SS_Shared_NumFromStr(religion),
      charm = SS_Shared_NumFromStr(charm),
      missing = SS_Shared_NumFromStr(missing),
      hands = SS_Shared_NumFromStr(hands),
      athletics = SS_Shared_NumFromStr(athletics),
      observation = SS_Shared_NumFromStr(observation),
      knowledge = SS_Shared_NumFromStr(knowledge),
      controll = SS_Shared_NumFromStr(controll),
      judgment = SS_Shared_NumFromStr(judgment),
      acrobats = SS_Shared_NumFromStr(acrobats),
      stealth = SS_Shared_NumFromStr(stealth),
    },
    modifiers = {
      stats = statModifiers,
      skills = skillModifiers,
    },
  };

  SS_Draw_PlayerControll(player);
end;