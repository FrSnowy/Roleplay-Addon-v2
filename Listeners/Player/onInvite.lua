SS_Listeners_Player_OnInvite = function(data, master)
  -- У: Игрок, от: мастер, когда: когда ведущий приглашает в сюжет
  SS_Modal_Invite:Hide();
  local id, plotName = strsplit('+', data);

  if (SS_Plots_Includes(id)) then
    SS_PtDM_PlotAlreadyExists(plotName, master);
    return;
  end;

  if (not(SS_User.settings.acceptInvites)) then
    SS_PtDM_DeclineInvite(plotName, master);
    return;
  end;

  SS_Modal_Invite:Show();
  SS_Modal_Invite_Inviter:SetText('Ведущий '..master)
  SS_Modal_Invite_PlotName:SetText(plotName)
  SS_Modal_Invite_Decline_Button:SetScript('OnClick', function()
    SS_PtDM_DeclineInvite(plotName, master);
    SS_Log_PlotInviteDeclinedBy(UnitName("player"), plotName)
    SS_Modal_Invite:Hide();
  end);
  SS_Modal_Invite_Accept_Button:SetScript('OnClick', function()
    SS_Plots_Create(id, plotName, master);
    SS_Modal_Invite:Hide();
    SS_PtDM_AcceptInvite(plotName, master);
    SS_Log_PlotInviteAcceptedBy(UnitName("player"), plotName);
  end);

  PlaySound("LEVELUPSOUND", "SFX");
end;