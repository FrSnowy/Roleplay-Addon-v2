SS_Listeners_Player_OnDMGetTargetInfo = function(plotID, master)
  -- У: Игрок, от: мастер, когда: мастер берет игрока текущего события в цель
  if (not(SS_User) or not(SS_Plots_Includes(plotID))) then return false; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if(not(SS_Plots_Current().author == master)) then return false; end;

  SS_PtDM_Params(master);
end;