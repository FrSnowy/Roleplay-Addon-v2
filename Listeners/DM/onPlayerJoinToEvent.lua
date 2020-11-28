SS_Listeners_DM_OnPlayerJoinToEvent = function(plotID, player)
  -- У: Мастер, от: игрок, когда: игрок принял приглашение на событие
  if (player == UnitName("player")) then return nil; end;
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_User.settings.currentPlot == plotID)) then return nil; end;

  local plot = SS_Plots_Current();

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