SS_Minimap_LoadFromDefaults = function()
  if (not(SS_User.settings.minimap)) then return nil; end;
  SS_Minimap_Button:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", SS_User.settings.minimap.x, SS_User.settings.minimap.y);
end;

SS_Minimap_ToggleContentVisibility = function()
  if (SS_Player_Menu:IsVisible()) then
    SS_Player_Menu:Hide();
    SS_Dices_Menu:Hide();
    SS_Stats_Menu:Hide();
    SS_Skills_Menu:Hide();
    SS_Armor_Menu:Hide();
    SS_Controll_Menu:Hide();
    if (SS_LeadingPlots_Current() and SS_Plot_Controll:IsVisible()) then
      SS_Plot_Controll:Hide();
    end;
  else
    SS_Player_Menu:Show();
    if (SS_LeadingPlots_Current() and not(SS_Plot_Controll:IsVisible()) and not(SS_Event_Controll:IsVisible())) then
      SS_Plot_Controll:Show();
    end;
  end;
end;

SS_Minimap_Drag = function()
  local xpos,ypos = GetCursorPosition()
  local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()
  xpos = xmin-xpos/UIParent:GetScale()+70 
  ypos = ypos/UIParent:GetScale()-ymin-70

  local locationAngle = math.deg(math.atan2(ypos,xpos))
  local x = 52-(80*cos(locationAngle))
  local y = ((80*sin(locationAngle))-52)
  SS_Minimap_Button:SetPoint("TOPLEFT","Minimap","TOPLEFT",x,y)

  if (not(SS_User.settings.minimap)) then
    SS_User.settings.minimap = {};
  end;

  SS_User.settings.minimap = { x = x, y = y };
end;