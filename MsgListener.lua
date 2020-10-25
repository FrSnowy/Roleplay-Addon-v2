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

  local params = {
    health = SS_Params_GetHealth(),
    maxHealth = SS_Params_GetMaxHealth(),
    barrier = SS_Params_GetBarrier(),
    maxBarrier = SS_Params_GetMaxBarrier(),
    level = SS_Progress_GetLevel(),
  };

  SS_PtDM_Params(params, master);
end;

local onSendParams = function(params, player)
  -- У: Мастер, от: игрок, когда: игрок активного сюжета взят в таргет и отвечает на соообщение о своих статах
  if (not(params) or not(player)) then return nil; end;
  if (not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  local health, maxHealth, barrier, maxBarrier, level = strsplit('+', params);
  local params = {
    health = health,
    maxHealth = maxHealth,
    barrier = barrier,
    maxBarrier = maxBarrier,
    level = level,
  };
  SS_Draw_InfoAboutPlayer(params);
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

  local params = {
    health = SS_Params_GetHealth(),
    maxHealth = SS_Params_GetMaxHealth(),
    barrier = SS_Params_GetBarrier(),
    maxBarrier = SS_Params_GetMaxBarrier(),
    level = SS_Progress_GetLevel(),
    experience = SS_Progress_GetExp(),
    experienceForUp = SS_Progress_GetExpForUp(),
    armorType = SS_Armor_GetType(),
  };

  SS_PtDM_InspectInfo(params, master);
end;

local onSendInspectInfo = function(params, player)
  if (not(params) or not(player)) then return nil; end;
  if (not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  local health, maxHealth, barrier, maxBarrier, level, experience, experienceForUp, armorType = strsplit('+', params);
  local params = {
    health = health,
    maxHealth = maxHealth,
    barrier = barrier,
    maxBarrier = maxBarrier,
    level = level,
    experience = experience,
    experienceForUp = experienceForUp,
    armorType = armorType,
  };

  SS_Draw_PlayerControll(params, player);
end;

SS_MsgListener_Controller = function(prefix, text, channel, author)
  if (not(prefix == 'SS-DMtP') and not(prefix == 'SS-PtDM') and not(prefix == 'SS-PtP')) then
    return false;
  end;

  local action, data = strsplit('|', text);

  local actions = {
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
  };

  if (not(actions[action])) then
    return;
  end;

  actions[action](data, author);
end;