local onPlayerToAll = function(data, player)
  -- У: Мастер, от: Игрок, когда: игрок хочет разослать сообщение всем остальным игрокам
  local action, content = strsplit('+', data, 2);
  SS_DMtP_Every(action, content, { player })();
end;

local onIsOnline = function(data, player)
  -- У: игрок, от: игрок, когда: при запросе на проверку онлайна
  SS_PtP_ImOnline(player);
end;

local onIAmOnline = function(data, player)
  -- У: Игрок, от: игрок, когда: когда получен ответ на запрос проверки онлайна
  if (not(SS_Shared_IfOnlineCallback)) then return; end;
  if (not(SS_Shared_IfOnlineCallback[player])) then return; end;

  SS_Shared_IfOnlineCallback[player]();
  SS_Shared_IfOnlineCallback[player] = nil;
  ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", SS_Shared_IgnoreOfflineMsgFilter);
end;

local onInvite = function(data, master)
  -- У: Игрок, от: мастер, когда: когда ведущий приглашает в сюжет
  SS_Modal_Invite:Hide();
  local id, plotName = strsplit('+', data);

  if (SS_Plots_Includes(id)) then
    SS_PtDM_PlotAlreadyExists(plotName, master);
    return;
  end;

  if (not(SS_User.settings.acceptInvites)) then
    SS_PtDM_DeclineInvite(plotName, master);
    return;
  end;

  SS_Modal_Invite:Show();
  SS_Modal_Invite_Inviter:SetText('Ведущий '..master)
  SS_Modal_Invite_PlotName:SetText(plotName)
  SS_Modal_Invite_Decline_Button:SetScript('OnClick', function()
    SS_PtDM_DeclineInvite(plotName, master);
    SS_Log_PlotInviteDeclinedBy(UnitName("player"), plotName)
    SS_Modal_Invite:Hide();
  end);
  SS_Modal_Invite_Accept_Button:SetScript('OnClick', function()
    SS_Plots_Create(id, plotName, master);
    SS_Modal_Invite:Hide();
    SS_PtDM_AcceptInvite(plotName, master);
    SS_Log_PlotInviteAcceptedBy(UnitName("player"), plotName);
  end);

  PlaySound("LEVELUPSOUND", "SFX");
end;

local onPlotExistsAnswer = function(plotName, player)
  -- У: Мастер, от: игрок, когда: при попытке пригласить, если у игрока уже есть этот сюжет
  SS_Log_PlotAlreadyExistsFor(player, plotName);
  SS_LeadingPlots_AddPlayer(player);
end;

local onDeclinePlotInvite = function(plotName, player)
  -- У: Мастер, от: игрок, когда: игрок отклонил приглашение на участие в сюжете
  SS_Log_PlotInviteDeclinedBy(player, plotName);
end;

local onAcceptPlotInvite = function(plotName, player)
  -- У: Мастер, от: игрок, когда: игрок принял приглашение участвовать в сюжете
  SS_Log_PlotInviteAcceptedBy(player, plotName);
  SS_LeadingPlots_AddPlayer(player);
end;

local onPlayerDeletePlot = function(plotID, player)
  -- У: Мастер, от: игрок, когда: игрок удаляет текущий сюжет мастера
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  SS_Shared_RemoveFrom(SS_LeadingPlots_Current().players)(function(playerName)
    return player == playerName;
  end);
  SS_PlotController_DrawPlayers();
  SS_Log_PlotRemovedBy(player, plotName);

  if (player == UnitName("target")) then
    SS_Draw_HideCurrentTargetVisual()
  end;
end;

local onPlayerDeactivatePlot = function(plotID, player)
  -- У: Мастер, от: игрок, когда: игрок деактивирует текущий сюжет
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  local plotName = SS_LeadingPlots_Current().name;
  SS_Log_PlotDeactivatedBy(player, plotName);

  if (player == UnitName("target")) then
    SS_Draw_HideCurrentTargetVisual()
  end;
end;

local onDMDeletePlot = function(plotID, master)
  -- У: Игрок, от: мастер, когда: мастер удаляет сюжет
  if (not(plotID) or not(SS_Plots_Includes(plotID))) then return; end;
  
  local plot = SS_User.plots[plotID];
  local name = plot.name;
  local author = plot.author;

  if (not(master == author)) then return; end;
  SS_PlotController_Remove(plotID);
  SS_Log_PlotRemovedByDM(master, name);
end;

local onDMKickFromPlot = function(plotID, master)
  -- У: Игрок, от: мастер, когда: мастер исключил из сюжета
  if (not(plotID) or not(SS_Plots_Includes(plotID))) then return; end;

  local plot = SS_User.plots[plotID];
  local name = plot.name;
  local author = plot.author;

  if (not(master == author)) then return; end;
  SS_PlotController_Remove(plotID);
  SS_Log_KickedByDM(master, name);
  SS_PtDM_KickAllright(plotID, master);
end;

local onKickAllright = function(plotID, player)
  -- У: Мастер, от: игрок, когда: игрок успешно исключился из сюжета
  if (plotID == SS_User.settings.currentPlot) then
    SS_Shared_RemoveFrom(SS_LeadingPlots_Current().players)(function(playerName)
      return player == playerName;
    end);
    SS_PlotController_DrawPlayers();
  end;
  SS_Plot_Controll_PlayerInfo:Hide();

  if (player == UnitName("target")) then
    SS_Draw_HideCurrentTargetVisual()
  end;

  SS_Log_PlayerKickedSuccessfully(player);
end;

local onDMStartEvent = function(plotID, master)
  -- У: Игрок, от: мастер, когда: мастер начинает событие в сюжете
  SS_Modal_EventStart:Hide();
  if (not(plotID) or not(SS_Plots_Includes(plotID))) then return; end;

  local plot = SS_User.plots[plotID];
  if (not(plot.author == master)) then return; end;

  SS_Modal_EventStart_Leader:SetText('Ведущий '..master);
  SS_Modal_EventStart_PlotName:SetText(plot.name);
  SS_Modal_EventStart:Show();
  
  SS_Modal_EventStart_Decline_Button:SetScript('OnClick', function()
    SS_Modal_EventStart:Hide();
    SS_Log_DeclineEventStart(plot.name);
    SS_PtDM_DeclineEventStart(plot.name, master);
  end);
  
  SS_Modal_EventStart_Accept_Button:SetScript('OnClick', function()
    SS_PlotController_MakeCurrent(plotID);
    SS_PlotController_OnActivate();
    SS_Modal_EventStart:Hide();

    SS_User.settings.acceptNextPartyInvite = true;
    SS_Log_AcceptEventStart(plot.name);
    if (plotID == SS_User.settings.currentPlot) then
      SS_Shared_IfOnline(plot.author, function()
        SS_PtDM_JoinToEvent(plotID, plot.author);
      end);
  
      return nil;
    end;
  end);
end;

local onPlayerDeclineEventInvite = function(plot, player)
  -- У: Мастер, от: игрок, когда: игрок отклоняет приглашение на событие
  SS_Log_PlayerDeclinedEventInvite(player, plot);
end;

local onPlayerJoinToEvent = function(plotID, player)
  -- У: Мастер, от: игрок, когда: игрок принял приглашение на событие
  if (player == UnitName("player")) then return nil; end;
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return nil; end;

  local plot = SS_Plots_Current();

  SS_Log_PlayerJoinedToEvent(player, plot.name);
  if (not(UnitInParty(player))) then
    InviteUnit(player);
  end;
  
  if (not(SS_User.settings.convertToRaid)) then
    SS_User.settings.convertToRaid = true;
  end;

  if (UnitName("target") == player) then
    SS_DMtP_DisplayTargetInfo(player);
  end;
end;

local onDMGetTargetInfo = function(plotID, master)
  -- У: Игрок, от: мастер, когда: мастер берет игрока текущего события в цель
  if (not(SS_User) or not(SS_Plots_Includes(plotID))) then return false; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if(not(SS_Plots_Current().author == master)) then return false; end;

  SS_PtDM_Params(master);
end;

local onSendParams = function(params, player)
  -- У: Мастер, от: игрок, когда: игрок активного сюжета взят в таргет и отвечает на соообщение о своих статах ИЛИ когда игрок обновляет свои параметры во время открытой панели просмотра
  if (not(params) or not(player)) then return nil; end;
  if (not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(UnitName("target") == player)) then return nil; end;
  local plotID, health, maxHealth, barrier, maxBarrier, level = strsplit('+', params);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  SS_Draw_InfoAboutPlayer({
    health = health,
    maxHealth = maxHealth,
    barrier = barrier,
    maxBarrier = maxBarrier,
    level = level,
  });
end;

local onDMStopEvent = function(plotID, master)
  -- У: Игрок, от: Мастер, когда: мастер нажал кнопку "завершить событие"
  if (not(plotID) or not(master)) then return nil; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if (not(SS_Plots_Current().author == master)) then return false; end;

  SS_User.settings.currentPlot = nil;
  SS_PlotController_OnDeactivate();
end;

local onDMGetInspectInfo = function(plotID, master)
  -- У: Игрок, от: Мастер, когда: мастер нажал кнопку "Подробнее" во фрейме цели
  if (not(plotID) or not(master)) then return nil; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if (not(SS_Plots_Current().author == master)) then return false; end;

  SS_PtDM_InspectInfo("create", master);
end;

local onSendInspectInfo = function(inspectStr, player)
  -- У: Мастер, от: Игрок, когда: игрок отдает свои характеристики для панели осмотра ИЛИ когда игрок обновляет свои параметры во время открытой панели просмотра
  if (not(inspectStr) or not(player)) then return nil; end;
  if (not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  local plotID, params, stats, activeSkills, passiveSkills, statModifiersStr, skillModifiersStr, actionType = strsplit('+', inspectStr);
  if (actionType == "update" and (not(SS_Target_TMPData) or not(SS_Target_TMPData.name == player))) then return nil; end;

  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;
  local health, maxHealth, barrier, maxBarrier, level, experience, experienceForUp, armorType = strsplit('}', params);
  local power, accuracy, wisdom, morale, empathy, mobility, precision = strsplit('}', stats);
  local melee, range, magic, religion, perfomance, missing, hands = strsplit('}', activeSkills);
  local athletics, observation, knowledge, controll, judgment, acrobats, stealth = strsplit('}', passiveSkills);

  local statModifiers = {};
  if (not(statModifiersStr == 'nothing')) then
    SS_Shared_ForEach({ strsplit('}', statModifiersStr) })(function(modifier)
      local id, name, stat, value, count = strsplit('/', modifier);
      statModifiers[id] = { name = name, stat = stat, value = value, count = count };
    end);
  end;

  local skillModifiers = {};
  if (not(skillModifiersStr == 'nothing')) then
    SS_Shared_ForEach({ strsplit('}', skillModifiersStr) })(function(modifier)
      local id, name, stat, value, count = strsplit('/', modifier);
      skillModifiers[id] = { name = name, stat = stat, value = value, count = count };
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
      perfomance = SS_Shared_NumFromStr(perfomance),
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

local onAddStatModifier = function(data, author, prefix)
  -- У: Игрок, от: Мастер/GHI, когда: создается новый модификатор хар-ки
  local allowModifier = false;
  if (not(SS_Plots_Current())) then return nil; end;

  if (prefix == 'SS-GHItP') then
    allowModifier = author == UnitName('player');
  else
    allowModifier = author == SS_Plots_Current().author;
  end;

  if (not(allowModifier)) then return nil; end;

  local id, name, stat, value, count = strsplit('+', data);

  SS_Modifiers_Register('stats', {
    id = id,
    name = name,
    stat = stat,
    value = value,
    count = count,
  });

  if (SS_Stats_Menu:IsVisible()) then
    SS_Stats_DrawAll();
    if (SS_Stats_Menu_Info:IsVisible() and SS_Stats_Menu_Info.title:GetText() == SS_Locale(stat)) then
      SS_Draw_StatInfo(stat, SS_Stats_Menu_Info_Inner_Content_Description:GetText());
    end;
  end;

  SS_Log_StatModifierAdded(name, stat, value, count);
end;

local onAddSkillModifier = function(data, author, prefix)
  -- У: Игрок, от: Мастер/GHI, когда: создается новый модификатор навыыка
  local allowModifier = false;
  if (not(SS_Plots_Current())) then return nil; end;

  if (prefix == 'SS-GHItP') then
    allowModifier = author == UnitName('player');
  else
    allowModifier = author == SS_Plots_Current().author;
  end;

  if (not(allowModifier)) then return nil; end;

  local id, name, stat, value, count = strsplit('+', data);

  SS_Modifiers_Register('skills', {
    id = id,
    name = name,
    stat = stat,
    value = value,
    count = count,
  });

  if (SS_Skills_Menu:IsVisible()) then
    SS_Skills_DrawAll();
    if (SS_Skills_Menu_Info:IsVisible() and SS_Skills_Menu_Info.title:GetText() == SS_Locale(stat)) then
      SS_Draw_SkillInfo(stat, SS_Skills_Menu_Info_Inner_Content_Description:GetText(), SS_Skills_Menu_Info_Inner_Content_Examples:GetText());
    end;
  end;

  SS_Log_SkillModifierAdded(name, stat, value, count);
end;

local onDMRemoveTargetModifier = function(data, master)
  -- У: Игрок, от: Мастер, когда: мастер удаляет модификатор через меню осмотра
  local plotID, modifierType, modifierID = strsplit('+', data);
  if (not(plotID) or not(modifierType) or not(modifierID)) then return false; end;

  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if (not(SS_Plots_Current().author == master)) then return false; end;

  local modifier = SS_Plots_Current().modifiers[modifierType][modifierID];
  if (not(modifier)) then
    SS_PtDM_ModifierRemoved({
      modifierID = modifierID,
      modifierType = modifierType,
    }, master);

    return false;
  end;

  local stat = modifier.stat;
  SS_Log_ModifierRemovedByDM(modifier.name, modifier.stat, modifier.value);
  SS_Modifiers_Remove(modifierType)(modifierID);

  SS_PtDM_ModifierRemoved({
    modifierID = modifierID,
    modifierType = modifierType,
  }, master);
end;

local onPlayerModifierRemoved = function(data, player)
  -- У: Мастер, от: Игрок, когда: мастер успешно дропнул модификатор игрока
  local modifierType, modifierID = strsplit('+', data);
  if (not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  local modifier = SS_Target_TMPData.modifiers[modifierType][modifierID];
  SS_Log_ModifierRemovedSuccessfully(modifier.name, player);
  SS_DMtP_DisplayInspectInfo(SS_Target_TMPData.name);
end;

local onDMForceRollSkill = function(data, master)
  local plotID, skill = strsplit('+', data);

  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if (not(SS_Plots_Current().author == master)) then return false; end;

  SS_Log_MasterForceRoll();
  SS_Roll(skill);
end;

local onRollResult = function(data, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;

  local name, skill, result, efficency, diceMin, diceMax, diceCount, modifier = strsplit('+', data);
  SS_Log_RollResultOfOther(name, skill, result, efficency, diceMin, diceMax, diceCount, modifier);
end;

SS_MsgListener_Controller = function(prefix, text, channel, author)
  if (not(prefix == 'SS-DMtP') and not(prefix == 'SS-PtDM') and not(prefix == 'SS-PtP') and not(prefix == 'SS-GHItP')) then
    return false;
  end;

  local action, data = strsplit('|', text);

  local actions = {
    playerToAll = onPlayerToAll,
    isOnline = onIsOnline,
    iAmOnline = onIAmOnline,
    invite = onInvite,
    plotExists = onPlotExistsAnswer,
    acceptPlotInvite = onAcceptPlotInvite,
    declinePlotInvite = onDeclinePlotInvite,
    playerDeletePlot = onPlayerDeletePlot,
    playerDeactivatePlot = onPlayerDeactivatePlot,
    dmDeletePlot = onDMDeletePlot,
    dmKickFromPlot = onDMKickFromPlot,
    kickAllright = onKickAllright,
    dmStartEvent = onDMStartEvent,
    declineEventStart = onPlayerDeclineEventInvite,
    joinToEvent = onPlayerJoinToEvent,
    dmGetTargetInfo = onDMGetTargetInfo,
    sendParams = onSendParams,
    dmStopEvent = onDMStopEvent,
    dmGetInspectInfo = onDMGetInspectInfo,
    sendInspectInfo = onSendInspectInfo,
    addStatModifier = onAddStatModifier,
    addSkillModifier = onAddSkillModifier,
    dmRemoveTargetModifier = onDMRemoveTargetModifier,
    playerModifierRemoved = onPlayerModifierRemoved,
    dmForceRollSkill = onDMForceRollSkill,
    rollResult = onRollResult,
  };

  if (not(actions[action])) then
    return;
  end;

  actions[action](data, author, prefix);
end;