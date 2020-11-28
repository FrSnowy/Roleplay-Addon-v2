SS_Listeners_DM_OnAcceptPlotInvite = function(plotName, player)
  -- У: Мастер, от: игрок, когда: игрок принял приглашение участвовать в сюжете
  SS_Log_PlotInviteAcceptedBy(player, plotName);
  SS_LeadingPlots_AddPlayer(player);
end;