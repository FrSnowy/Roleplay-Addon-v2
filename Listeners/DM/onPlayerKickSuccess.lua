SS_Listeners_DM_OnPlayerKickSuccess = function(plotID, player)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return nil; end;

  SS_Log_PlayerKickedFromEventSuccessfully(player);

  local playerIndex = -1;
  local isActivePlayer = SS_Shared_Includes(SS_LeadingPlots_Current().activePlayers)(function(p, i)
    if (p == player) then playerIndex = i; end;
    return p == player;
  end);

  if (isActivePlayer) then
    SS_LeadingPlots_Current().activePlayers[playerIndex] = nil;
    table.remove(SS_LeadingPlots_Current().activePlayers, playerIndex);

    if (SS_MembersControll_Menu:IsVisible()) then
      SS_MembersControll_DrawList();
    end;
  end;
end;