SS_Listeners_Player_OnDMGetInspectInfo = function(plotID, master)
  -- У: Игрок, от: Мастер, когда: мастер нажал кнопку "Подробнее" во фрейме цели
  if (not(plotID) or not(master)) then return nil; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if (not(SS_Plots_Current().author == master)) then return false; end;

  SS_PtDM_InspectInfo("create", master);
end;