local onInvite = function(data, author)
  local id, plotName = strsplit('+', data);

  if (SS_Plots_Includes(id)) then
    SS_PtDM_PlotAlreadyExists(plotName, author);
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
    SS_Log_PlotInviteAcceptedBy(UnitName("player"), plotName);
    SS_Plots_Create(id, plotName, author);
    SS_Modal_Invite:Hide();
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
  };

  if (not(actions[action])) then
    return;
  end;

  actions[action](data, author);
end;