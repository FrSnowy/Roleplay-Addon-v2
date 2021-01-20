SS_Listeners_DM_OnPlayerDeactivatePlot = function(plotID, player)
  -- У: Мастер, от: игрок, когда: игрок деактивирует текущий сюжет
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  local activePlayerIndex = -1;
  local isActivePlayer = SS_Shared_Includes(SS_LeadingPlots_Current().activePlayers)(function(p, i)
    if (p == player) then
      activePlayerIndex = i;
    end;

    return p == player;
  end);

  if (isActivePlayer) then
    SS_LeadingPlots_Current().activePlayers[activePlayerIndex] = nil;
    table.remove(SS_LeadingPlots_Current().activePlayers, activePlayerIndex);
    
    if (SS_MembersControll_Menu:IsVisible()) then
      SS_MembersControll_DrawList();
    end;
  end;

  local plotName = SS_LeadingPlots_Current().name;
  SS_Log_PlotDeactivatedBy(player, plotName);

  if (player == UnitName("target")) then
    SS_Draw_HideCurrentTargetVisual()
  end;
end;