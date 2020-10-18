SS_DMtP_Direct = function(action, data, target)
  SendAddonMessage("SS-DMtP", action..'|'..data, "WHISPER", target);
end;

SS_DMtP_Every = function(action, data)
  return function(plotID)
    if (not(plotID)) then
      if (not(SS_User.settings.currentPlot)) then return nil; end;
      plotID = SS_User.settings.currentPlot;
    end;

    local leadingPlot = SS_User.leadingPlots[plotID];
    if (not(leadingPlot)) then return; end;

    local players = leadingPlot.players;
    if (not(players)) then return end;

    SS_Shared_ForEach(players)(function(player)
      if (not(player == UnitName("player"))) then
        SS_DMtP_Direct(action, data, player);
      end;
    end);
  end;
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

SS_DMtP_DeletePlot = function(plotID)
  if (not(plotID)) then return; end;
  SS_DMtP_Every('dmDeletePlot', plotID)(plotID);
end;

SS_DMtP_KickFromPlot = function(player, plotID)
  if (not(plotID) or not(player)) then return; end;

  local leadingPlot = SS_User.leadingPlots[plotID];
  if (not(leadingPlot)) then return; end;

  SS_DMtP_Direct('dmKickFromPlot', plotID, player);
end;