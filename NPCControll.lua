SS_NPCControll_Show = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_NPCControll_Menu:Show();
  SS_Event_Controll_NPCControll_Button:SetText("- NPC");
end;

SS_NPCControll_Hide = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_NPCControll_Menu:Hide();
  SS_Event_Controll_NPCControll_Button:SetText("+ NPC");
end;