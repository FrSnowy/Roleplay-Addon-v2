local onInvite = function(data, author)
  SS_Modal_Invite:Hide();
  local id, plotName = strsplit('+', data);

  if (SS_Plots_Includes(id)) then
    SS_PtDM_PlotAlreadyExists(plotName, author);
    return;
  end;

  if (not(SS_User.settings.acceptInvites)) then
    SS_PtDM_DeclineInvite(plotName, author);
    return;
  end;

  SS_Modal_Invite:Show();
  SS_Modal_Invite_Inviter:SetText('Ведущий '..author)
  SS_Modal_Invite_PlotName:SetText(plotName)
  SS_Modal_Invite_Decline_Button:SetScript('OnClick', function()
    SS_PtDM_DeclineInvite(plotName, author);
    SS_Log_PlotInviteDeclinedBy(UnitName("player"), plotName)
    SS_Modal_Invite:Hide();
  end);
  SS_Modal_Invite_Accept_Button:SetScript('OnClick', function()
    SS_Plots_Create(id, plotName, author);
    SS_Modal_Invite:Hide();
    SS_PtDM_AcceptInvite(plotName, author);
    SS_Log_PlotInviteAcceptedBy(UnitName("player"), plotName);
  end);

  PlaySound("LEVELUPSOUND", "SFX");
end;

local onPlotExistsAnswer = function(plotName, player)
  SS_Log_PlotAlreadyExistsFor(player, plotName);
  SS_LeadingPlots_AddPlayer(player);
end;

local onDeclinePlotInvite = function(plotName, player)
  SS_Log_PlotInviteDeclinedBy(player, plotName);
end;

local onAcceptPlotInvite = function(plotName, player)
  SS_Log_PlotInviteAcceptedBy(player, plotName);
  SS_LeadingPlots_AddPlayer(player);
end;

local onPlayerDeletePlot = function(plotName, player)
  if (plotName == SS_Plots_Current().name) then
    SS_Shared_RemoveFrom(SS_LeadingPlots_Current().players)(function(playerName)
      return player == playerName;
    end);
    SS_PlotController_DrawPlayers();
    SS_Log_PlotRemovedBy(player, plotName);
  end;
end;

local onDMDeletePlot = function(plotID, plotAuthor)
  if (not(plotID) or not(SS_Plots_Includes(plotID))) then return; end;
  
  local plot = SS_User.plots[plotID];
  local name = plot.name;
  local author = plot.author;

  if (not(plotAuthor == author)) then return; end;
  SS_PlotController_Remove(plotID);
  SS_Log_PlotRemovedByDM(plotAuthor, name);
end;

local onDMKickFromPlot = function(plotID, plotAuthor)
  if (not(plotID) or not(SS_Plots_Includes(plotID))) then return; end;

  local plot = SS_User.plots[plotID];
  local name = plot.name;
  local author = plot.author;

  if (not(plotAuthor == author)) then return; end;
  SS_PlotController_Remove(plotID);
  SS_Log_KickedByDM(plotAuthor, name);
  SS_PtDM_KickAllright(plotID, plotAuthor);
end;

local onKickAllright = function(plotID, player)
  if (plotID == SS_User.settings.currentPlot) then
    SS_Shared_RemoveFrom(SS_LeadingPlots_Current().players)(function(playerName)
      return player == playerName;
    end);
    SS_PlotController_DrawPlayers();
  end;
  SS_Plot_Controll_PlayerInfo:Hide();
  SS_Log_PlayerKickedSuccessfully(player);
end;

local onDMStartEvent = function(plotID, plotAuthor)
  SS_Modal_EventStart:Hide();
  if (not(plotID) or not(SS_Plots_Includes(plotID))) then return; end;

  local plot = SS_User.plots[plotID];
  if (not(plot.author == plotAuthor)) then return; end;

  SS_Modal_EventStart_Leader:SetText('Ведущий '..plot.author);
  SS_Modal_EventStart_PlotName:SetText(plot.name);
  SS_Modal_EventStart:Show();
end;

SS_MsgListener_Controller = function(prefix, text, channel, author)
  if (not(prefix == 'SS-DMtP') and not(prefix == 'SS-PtDM')) then
    return false;
  end;

  local action, data = strsplit('|', text);

  local actions = {
    invite = onInvite,
    plotExists = onPlotExistsAnswer,
    acceptPlotInvite = onAcceptPlotInvite,
    declinePlotInvite = onDeclinePlotInvite,
    playerDeletePlot = onPlayerDeletePlot,
    dmDeletePlot = onDMDeletePlot,
    dmKickFromPlot = onDMKickFromPlot,
    kickAllright = onKickAllright,
    dmStartEvent = onDMStartEvent,
  };

  if (not(actions[action])) then
    return;
  end;

  actions[action](data, author);
end;