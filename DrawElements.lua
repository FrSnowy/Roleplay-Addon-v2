SS_DrawPlots = function(categoryName)
  local plotType;
  if (categoryName == nil or categoryName == 'Участник') then
    plotType = 'plots';
  else
    plotType = 'leadingPlots';
  end;

  local childs = { SS_Plots_Container:GetChildren() };

  for _, child in pairs(childs) do
    child:Hide();
  end

  local counter = 0;
  for index, plot in pairs(SS_User[plotType]) do
    local panelName = "OpenPlotPanel-"..plotType.."-"..index;
    local PlotPanel = CreateFrame("Button", panelName, SS_Plots_Container);
          PlotPanel:SetToplevel(false);
          PlotPanel:Show();
          PlotPanel:EnableMouse();
          PlotPanel:SetWidth(200);
          PlotPanel:SetHeight(16);
          PlotPanel:SetBackdropColor(0, 0, 0, 1);
          PlotPanel:SetPoint("RIGHT", SS_Controll_Menu, "TOPRIGHT", -85, -82 - 30 * counter);
          PlotPanel:SetNormalTexture("Interface\\AddOns\\STIK_DM\\IMG\\plot-background.blp");
          PlotPanel:SetHighlightTexture("Interface\\AddOns\\STIK_DM\\IMG\\plot-background.blp");

      local PlotName = PlotPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            PlotName:SetPoint("LEFT", PlotPanel, "LEFT", 0, 4);
            PlotName:SetText(plot.name);
            PlotName:SetFont("Fonts\\FRIZQT__.TTF", 11);
            PlotName:Show();

      if (SS_User.leadingPlots[index]) then
        local PlotButton = CreateFrame("Button", nil, PlotPanel, "SecureHandlerClickTemplate");
              PlotButton:SetSize(16, 16);
              PlotButton:SetPoint("RIGHT", PlotPanel, "RIGHT", 0, 4);
              PlotButton:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\crown.blp");
              PlotButton:Show();
      end;

      if (index == SS_User.settings.currentPlot) then
        local PlotButton = CreateFrame("Button", nil, PlotPanel, "SecureHandlerClickTemplate");
              PlotButton:SetSize(12, 12);
              if (SS_User.leadingPlots[index]) then
                PlotButton:SetPoint("RIGHT", PlotPanel, "RIGHT", -24, 4);
              else
                PlotButton:SetPoint("RIGHT", PlotPanel, "RIGHT", 0, 4);
              end;
              PlotButton:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\green-check.blp");
              PlotButton:Show();

        PlotName:SetTextColor(0.901, 0.494, 0.133, 1)
      end;

      PlotPanel:SetScript("OnClick", function()
        SS_Controll_Menu:Hide();
        SS_Plot_Activate:Hide();
        SS_MakePlotSelected(index);
        SS_Plot_Activate:Show();
      end);

      counter = counter + 1;
  end;
end;

SS_HideEmptyPlotsText = function(plotType)
  if (not(plotType == 'plots') and not(plotType == 'leadingPlots')) then
    return 0;
  end;

  if (SS_getPlotsCount(plotType) == 0) then
    SS_Controll_Menu_Settings_EmptyPlot:Show();
    SS_Controll_Menu_Settings_EmptyPlot:SetText("Сюжетов не найдено");
  else
    SS_Controll_Menu_Settings_EmptyPlot:Hide();
  end;
end;

SS_DrawExprienceProgress = function()
  local fullWidth = MainMenuExpBar:GetWidth() - 180;
  local progress = (SS_GetPlayerExperience() / SS_GetExperienceForLevelUp())
  SS_Exp_Bar_Progress:SetWidth(fullWidth * progress);
  SS_Exp_Bar_Experience:SetText(SS_GetPlayerExperience().."/"..SS_GetExperienceForLevelUp());
end;

SS_ResizePlayerMenuOnPlotActivate = function()
  SS_Player_Menu:SetSize(84, 255);
  SS_Player_Menu_DicesIcon:Show();
  SS_Player_Menu_StatsIcon:Show();
  SS_Player_Menu_SkillsIcon:Show();
  SS_Player_Menu_ArmorIcon:Show();
  SS_Player_Menu_SettingsIcon:ClearAllPoints()
  SS_Player_Menu_SettingsIcon:SetPoint("BOTTOM", SS_Player_Menu, "BOTTOM", 0, 20);
end;

SS_ResizePlayerMenuOnPlotDeactivate = function()
  SS_Player_Menu:SetSize(84, 84);
  SS_Player_Menu_DicesIcon:Hide();
  SS_Player_Menu_StatsIcon:Hide();
  SS_Player_Menu_SkillsIcon:Hide();
  SS_Player_Menu_ArmorIcon:Hide();
  SS_Player_Menu_SettingsIcon:ClearAllPoints()
  SS_Player_Menu_SettingsIcon:SetPoint("CENTER", SS_Player_Menu, "CENTER", 0, 0);
end;

function SS_DrawHealthPoints()
  local maxHP = SS_GetMaxHealth();
  local currentHP = SS_GetCurrentHealth();
  SS_PlayerFrame_HP:SetText(currentHP.."/"..maxHP);
end;

function SS_DrawBarrierPoints(previousArmorType)
  local maxBarrierPoints = SS_GetMaxBarrier(previousArmorType);
  if (maxBarrierPoints == 0 and SS_GetCurrentBarrier() == 0) then
    SS_PlayerFrame_Barrier:Hide();
    SS_PlayerFrame_Barrier_Icon:Hide();
    return;
  end;

  SS_PlayerFrame_Barrier:Show();
  SS_PlayerFrame_Barrier_Icon:Show();

  local currentBarrier = SS_GetCurrentBarrier();
  SS_PlayerFrame_Barrier:SetText(currentBarrier.."/"..maxBarrierPoints)
end;

function SS_DrawCheckmarkOnArmor()
  local armorType = SS_User.plots[SS_User.settings.currentPlot].armor;
  SS_Armor_Menu_Armor_Light:SetChecked('false');
  SS_Armor_Menu_Armor_Medium:SetChecked('false');
  SS_Armor_Menu_Armor_Heavy:SetChecked('false');
  SS_Armor_Menu_Armor_Light_Visual:Hide();
  SS_Armor_Menu_Armor_Medium_Visual:Hide();
  SS_Armor_Menu_Armor_Heavy_Visual:Hide();

  if (armorType == 'light') then
    SS_Armor_Menu_Armor_Light:SetChecked('true')
    SS_Armor_Menu_Armor_Light_Visual:Show();
  elseif (armorType == 'medium') then
    SS_Armor_Menu_Armor_Medium:SetChecked('true')
    SS_Armor_Menu_Armor_Medium_Visual:Show();
  elseif (armorType == 'heavy') then
    SS_Armor_Menu_Armor_Heavy:SetChecked('true')
    SS_Armor_Menu_Armor_Heavy_Visual:Show();
  end;
end;

SS_HideAllSubmenus = function()
  SS_Stats_Menu:Hide();
  SS_Skills_Menu:Hide();
  SS_Controll_Menu:Hide();
  SS_Armor_Menu:Hide();
  SS_Dices_Menu:Hide();
end;

SS_UpdatePlayerFrameOnPlotActivate = function()
  --https://www.wowinterface.com/forums/showthread.php?t=48319
  PlayerLevelText:SetTextColor(1, 1, 1);
  PlayerLevelText:SetText(SS_GetPlayerLevel());
  PlayerLevelText:SetFont("Fonts\\FRIZQT__.TTF", 11);
  SS_Exp_Bar:Show();
  SS_DrawExprienceProgress();
  SS_PlayerFrame:Show();
  SS_DrawHealthPoints();
end;

SS_UpdatePlayerFrameOnPlotDeactivate = function()
  PlayerLevelText:SetText(UnitLevel("player"));
  PlayerLevelText:SetTextColor(0.82, 0.71, 0);
  PlayerLevelText:SetFont("Fonts\\FRIZQT__.TTF", 10);
  SS_Exp_Bar:Hide();
  SS_PlayerFrame:Hide();
end;