SS_MembersControll_Show = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_MembersControll_DrawList();
  SS_Event_Controll_MembersControll_Button:SetText("- Участники");

  local activePlayers = SS_LeadingPlots_Current().activePlayers;

  SS_LeadingPlots_Current().activePlayers = { UnitName('player') };

  SS_Shared_ForEach(activePlayers, { UnitName('player') })(function(player)
    SS_Shared_IfOnline(player, function()
      table.insert(SS_LeadingPlots_Current().activePlayers, player);
      SS_MembersControll_DrawList();
    end);
  end);
end;

SS_MembersControll_Hide = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_MembersControll_Menu:Hide();
  SS_Event_Controll_MembersControll_Button:SetText("+ Участники");
end;

SS_MembersControll_DrawList = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_Shared_ForEach({ SS_MembersControll_Menu_Scroll_Content:GetChildren() })(function(child)
    child:Hide();
  end);

  SS_MembersControll_Menu:Hide();

  local counter = 0;

  SS_Shared_ForEach(SS_LeadingPlots_Current().players)(function(player)
    counter = counter + 1;
    local NPCPanel = CreateFrame("Frame", nil, SS_MembersControll_Menu_Scroll_Content, "SS_MemberElement_Template");
          NPCPanel:SetSize(245, 24);
          NPCPanel:SetPoint("TOPLEFT", SS_MembersControll_Menu_Scroll_Content, "TOPLEFT", 0, -60 * (counter - 1));
          NPCPanel.memberName = player;
  end);
  
  SS_MembersControll_Menu:Show();
end;