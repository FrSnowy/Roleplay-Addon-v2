SS_Listeners_DM_OnPlotExistsAnswer = function(plotName, player)
  -- У: Мастер, от: игрок, когда: при попытке пригласить, если у игрока уже есть этот сюжет
  SS_Log_PlotAlreadyExistsFor(player, plotName);
  SS_LeadingPlots_AddPlayer(player);
end;