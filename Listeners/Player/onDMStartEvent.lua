SS_Listeners_Player_OnDMStartEvent = function(plotID, master)
  -- У: Игрок, от: мастер, когда: мастер начинает событие в сюжете
  SS_Modal_EventStart:Hide();
  if (not(plotID) or not(SS_Plots_Includes(plotID))) then return; end;

  local plot = SS_User.plots[plotID];
  if (not(plot) or not(plot.author == master)) then return; end;

  if (not(SS_User.settings.acceptInvites)) then
    SS_PtDM_DeclineInvite(SS_User.plots[plotID].name, master);
    return;
  end;

  SS_Modal_EventStart_Leader:SetText('Ведущий '..master);
  SS_Modal_EventStart_PlotName:SetText(plot.name);
  PlaySound("LEVELUPSOUND", "SFX");
  SS_Modal_EventStart:Show();
  
  SS_Modal_EventStart_Decline_Button:SetScript('OnClick', function()
    SS_Modal_EventStart:Hide();
    SS_Log_DeclineEventStart(plot.name);
    SS_PtDM_DeclineEventStart(plot.name, master);
  end);
  
  SS_Modal_EventStart_Accept_Button:SetScript('OnClick', function()
    SS_Plot_Controll:Hide();
    SS_Event_Controll:Hide();
    SS_LeadingPlots_HideAllWindows();
    SS_LeadingPlots_ResetTemporalData();

    SS_PlotController_MakeCurrent(plotID);
    SS_PlotController_OnActivate();
    SS_Modal_EventStart:Hide();

    SS_User.settings.acceptNextPartyInvite = true;
    SS_Log_AcceptEventStart(plot.name);
  end);
end;