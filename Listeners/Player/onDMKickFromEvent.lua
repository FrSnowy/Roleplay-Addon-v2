SS_Listeners_Player_OnDMKickFromEvent = function(plotID, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;
  
  SS_PlotController_MakeCurrent(nil);
  SS_PlotController_OnDeactivate();
  SS_Log_KickedFromEventByDM(master);
  SS_PtDM_PlayerKickedSuccessfully(plotID, master);
end;