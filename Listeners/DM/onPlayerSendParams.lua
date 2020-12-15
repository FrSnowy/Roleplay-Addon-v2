SS_Listeners_DM_OnPlayerSendParams = function(params, player)
  -- У: Мастер, от: игрок, когда: игрок активного сюжета взят в таргет и отвечает на соообщение о своих статах ИЛИ когда игрок обновляет свои параметры во время открытой панели просмотра
  if (not(params) or not(player)) then return nil; end;
  if (player == UnitName("player")) then return nil; end;
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