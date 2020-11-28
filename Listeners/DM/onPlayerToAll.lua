SS_Listeners_DM_OnPlayerToAll = function(data, player)
  -- У: Мастер, от: Игрок, когда: игрок хочет разослать сообщение всем остальным игрокам
  local action, content = strsplit('+', data, 2);
  SS_DMtP_Every(action, content, { player })();
end;
