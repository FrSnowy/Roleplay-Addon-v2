SS_Listeners_Player_OnDMKickFromPlot = function(plotID, master)
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