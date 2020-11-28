SS_Listeners_Player_OnIAmOnline = function(data, player)
  -- У: Игрок, от: игрок, когда: когда получен ответ на запрос проверки онлайна
  if (not(SS_Shared_IfOnlineCallback)) then return; end;
  if (not(SS_Shared_IfOnlineCallback[player])) then return; end;

  SS_Shared_IfOnlineCallback[player]();
  SS_Shared_IfOnlineCallback[player] = nil;
  ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", SS_Shared_IgnoreOfflineMsgFilter);
end;