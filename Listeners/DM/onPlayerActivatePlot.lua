SS_Listeners_DM_OnPlayerActivatePlot = function(plotID, player)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return nil; end;

  local isAlreadyActive = SS_Shared_Includes(SS_LeadingPlots_Current().activePlayers)(function(p)
    return p == player;
  end);

  if (not(isAlreadyActive)) then
    table.insert(SS_LeadingPlots_Current().activePlayers, player);

    if (SS_MembersControll_Menu:IsVisible()) then
      SS_MembersControll_DrawList();
    end;
  end;
end;