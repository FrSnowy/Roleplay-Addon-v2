SS_Minimap_LoadFromDefaults = function()
  if (not(SS_User.settings.minimap)) then return nil; end;
  SS_Minimap_Button:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", SS_User.settings.minimap.x, SS_User.settings.minimap.y);
end;

SS_Minimap_ToggleContentVisibility = function()
  if (SS_User.settings.interfaceHidden == false) then
    SS_User.settings.interfaceHidden = true;
    SS_Player_Menu:Hide();
    SS_Dices_Menu:Hide();
    SS_Stats_Menu:Hide();
    SS_Skills_Menu:Hide();
    SS_Armor_Menu:Hide();
    SS_Controll_Menu:Hide();
  
    SS_DiceControll_Hide();
    SS_ModifierControll_Hide();
    SS_BattleControll_Hide();
    SS_BattleControll_BattleInterface:Hide();
    SS_DamageControll_Hide();
    SS_ParamsControll_Hide();
    SS_NPCControll_Hide();
    SS_AtmosphereControll_Hide();
    SS_MembersControll_Hide();

    if (SS_LeadingPlots_Current()) then
      SS_Plot_Controll:Hide();

      if (SS_LeadingPlots_Current().isEventOngoing) then
        SS_Event_Controll:Hide();
      end;
    end;
  else
    SS_User.settings.interfaceHidden = false;
    SS_Player_Menu:Show();
    if (SS_LeadingPlots_Current() and not(SS_LeadingPlots_Current().isEventOngoing)) then
      SS_Plot_Controll:Show();
    end;

    if (SS_LeadingPlots_Current() and SS_LeadingPlots_Current().isEventOngoing) then
      SS_Event_Controll:Show();
    end;

    if (SS_Plots_Current() and SS_Plots_Current().battle) then
      SS_BattleControll_DrawBattleInterface(SS_Plots_Current().battle.battleType, SS_Plots_Current().battle.phase);
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