SS_DMtP_Direct = function(action, data, target)
  SendAddonMessage("SS-DMtP", action..'|'..data, "WHISPER", target);
end;

SS_DMtP_InviteToPlot = function(playerName)
  if (not(playerName)) then
    playerName = UnitName('target');
  end;

  if (not(playerName)) then
    SS_Log_NoTarget();
    return;
  end;

  if (not(SS_User.settings.currentPlot)) then
    SS_Log_NoCurrentPlot();
    return;
  end;

  local plot = SS_LeadingPlots_Current();
  SS_Log_InviteSendedTo(playerName, plot.name);
  SS_DMtP_Direct('invite', SS_User.settings.currentPlot..'+'..plot.name, playerName);
end;