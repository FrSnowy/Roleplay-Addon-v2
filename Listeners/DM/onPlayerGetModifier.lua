SS_Listeners_DM_OnPlayerGetModifier = function(data, player)
  if (not(data) or not(player)) then return nil; end;
  if (player == UnitName("player")) then return nil; end;
  if (not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  
  local plotID, name, value, statStr = strsplit('+', data);
  local stats = { strsplit('\\', statStr) };

  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;
  SS_Log_PlayerGetModifier(name, value, stats, player);

  if (UnitName("target") == player) then
    SS_DMtP_DisplayTargetInfo(player);
  end;

  if (SS_Player_Controll:IsVisible() and SS_Player_Controll_Name:GetText() == player) then
    SS_DMtP_DisplayInspectInfo(player);
  end;
end;