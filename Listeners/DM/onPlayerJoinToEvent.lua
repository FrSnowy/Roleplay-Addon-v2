SS_Listeners_DM_OnPlayerJoinToEvent = function(plotID, player)
  -- У: Мастер, от: игрок, когда: игрок принял приглашение на событие
  if (player == UnitName("player")) then return nil; end;
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return nil; end;

  local plot = SS_Plots_Current();
  
  local isAlreadyActive = SS_Shared_Includes(SS_LeadingPlots_Current().activePlayers)(function(p)
    return p == player;
  end);

  if (not(isAlreadyActive)) then
    table.insert(SS_LeadingPlots_Current().activePlayers, player);
    if (SS_MembersControll_Menu:IsVisible()) then
      SS_MembersControll_DrawList();
    end;
  end;

  SS_Log_PlayerJoinedToEvent(player, plot.name);
  if (not(UnitInParty(player))) then
    InviteUnit(player);
  end;
  
  if (not(SS_User.settings.convertToRaid)) then
    SS_User.settings.convertToRaid = true;
  end;

  if (UnitName("target") == player) then
    SS_DMtP_DisplayTargetInfo(player);
  end;
end;