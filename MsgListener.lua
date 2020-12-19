SS_MsgListener_Cache = {};

local isMessageStarts = function(text)
  return string.sub(text, 1, 1) == '~';
end;

local isMessageEnds = function(text)
  return string.sub(text, #text, #text) == '~'
end;

local isFullMessage = function(text)
  return isMessageStarts(text) and isMessageEnds(text);
end;

local actionFire = function(action, data, author, prefix)
  local actions = {
    playerToAll = SS_Listeners_DM_OnPlayerToAll,
    plotExists = SS_Listeners_DM_OnPlotExistsAnswer,
    acceptPlotInvite = SS_Listeners_DM_OnAcceptPlotInvite,
    declinePlotInvite = SS_Listeners_DM_OnDeclinePlotInvite,
    playerDeletePlot = SS_Listeners_DM_OnPlayerDeletePlot,
    playerDeactivatePlot = SS_Listeners_DM_OnPlayerDeactivatePlot,
    playerGetModifier = SS_Listeners_DM_OnPlayerGetModifier,
    playerLooseModifier = SS_Listeners_DM_OnPlayerLooseModifier,
    declineEventStart = SS_Listeners_DM_OnPlayerDeclineEventInvite,
    kickAllright = SS_Listeners_DM_OnKickAllright,
    joinToEvent = SS_Listeners_DM_OnPlayerJoinToEvent,
    sendParams = SS_Listeners_DM_OnPlayerSendParams,
    sendInspectInfo = SS_Listeners_DM_OnSendInspectInfo,
    rollResult = SS_Listeners_DM_OnRollResult,
    playerJoinToBattle = SS_Listeners_DM_OnPlayerJoinToBattle,
    playerBattleTurnEnd = SS_Listeners_DM_OnPlayerBattleTurnEnd,
    isOnline = SS_Listeners_Player_OnIsOnline,
    iAmOnline = SS_Listeners_Player_OnIAmOnline,
    invite = SS_Listeners_Player_OnInvite,
    dmDeletePlot = SS_Listeners_Player_OnDMDeletePlot,
    dmKickFromPlot = SS_Listeners_Player_OnDMKickFromPlot,
    dmStartEvent = SS_Listeners_Player_OnDMStartEvent,
    dmGetTargetInfo = SS_Listeners_Player_OnDMGetTargetInfo,
    dmStopEvent = SS_Listeners_Player_OnDMStopEvent,
    dmGetInspectInfo = SS_Listeners_Player_OnDMGetInspectInfo,
    addStatModifier = SS_Listeners_Player_OnAddModifier('stats'),
    addSkillModifier = SS_Listeners_Player_OnAddModifier('skills'),
    dmRemoveTargetModifier = SS_Listeners_Player_OnDMRemoveTargetModifier,
    dmForceRollSkill = SS_Listeners_Player_OnDMForceRollSkill,
    battleStart = SS_Listeners_Player_OnBattleStart,
    battleJoinSuccess = SS_Listeners_Player_OnBattleJoinSuccess,
    changeBattlePhase = SS_Listeners_Player_OnChangeBattlePhase,
  };

  if (not(actions[action])) then
    return;
  end;

  actions[action](data, author, prefix);
end;

SS_MsgListener_Controller = function(prefix, text, channel, author)
  if (not(prefix == 'SS-DMtP') and not(prefix == 'SS-PtDM') and not(prefix == 'SS-PtP') and not(prefix == 'SS-GHItP')) then
    return false;
  end;

  -- Если сообщение меньше 200
  if (isFullMessage(text)) then
    text = string.sub(text, 2, #text - 1);
    local action, data = strsplit('|', text);
    actionFire(action, data, author, prefix);
  -- Если больше - то приходит по кускам
  else
    -- Создаем в кэше запись об авторе
    if (not(SS_MsgListener_Cache[author])) then
      SS_MsgListener_Cache[author] = {};
    end;

    -- Если сообщение - первое из серии
    if (isMessageStarts(text)) then
      text = string.sub(text, 2, #text);
      local action, timeStamp, data = strsplit('|', text);

      -- Создаем запись опираясь на экшен
      SS_MsgListener_Cache[author][action] = {
        action = action,
        timeStamp = timeStamp,
        data = data,
      };
    -- Если сообщение не первое из серии
    else
      local action, timeStamp, data = strsplit('|', text);
      local cache = SS_MsgListener_Cache[author][action];
      -- Если нет записи в кэше - то игнорим
      if (not(cache)) then return nil; end;
    
      -- Если таймштамп не совпадает - очищаем кэш и игнорим дальнейшие сообщения
      if (not(cache.timeStamp == timeStamp)) then
        SS_MsgListener_Cache[author][action] = nil;
        return nil;
      end;

      -- Если сообщение - не первое, и не последнее
      if (not(isMessageEnds(data))) then
        cache.data = cache.data..data;
      -- Если сообщение последнее
      else
        data = string.sub(data, 1, #data - 1)
        cache.data = cache.data..data;

        actionFire(cache.action, cache.data, author, prefix);
        SS_MsgListener_Cache[author][action] = nil;
      end;
    end;
  end;
end;