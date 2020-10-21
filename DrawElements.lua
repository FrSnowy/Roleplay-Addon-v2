SS_Draw_HideEmptyPlotsText = function(plotType)
  if (not(plotType == 'plots') and not(plotType == 'leadingPlots')) then
    return 0;
  end;

  if (SS_PlotController_GetCountOf(plotType) == 0) then
    SS_Controll_Menu_Settings_EmptyPlot:Show();
    SS_Controll_Menu_Settings_EmptyPlot:SetText("Сюжетов не найдено");
  else
    SS_Controll_Menu_Settings_EmptyPlot:Hide();
  end;
end;

SS_Draw_HideSubmenus = function()
  SS_Stats_Menu:Hide();
  SS_Skills_Menu:Hide();
  SS_Controll_Menu:Hide();
  SS_Armor_Menu:Hide();
  SS_Dices_Menu:Hide();
end;

SS_Draw_HidePlayerInfoPlates = function()
  if(SS_TargetHealthPanel) then
    SS_TargetHealthPanel:Hide();
  end;

  if (SS_TargetBarrierPanel) then
    SS_TargetBarrierPanel:Hide();
  end;

  if (SS_TargetSettingsPanel) then
    SS_TargetSettingsPanel:Hide();
  end;
end;

SS_Draw_InfoAboutPlayer = function(params)
  TargetFrame.levelText:SetText(params.level);
  TargetFrame.levelText:SetTextColor(1, 1, 1);
  TargetFrame.levelText:SetFont("Fonts\\FRIZQT__.TTF", 11);

  if (not(SS_TargetHealthPanel)) then
    SS_TargetHealthPanel = CreateFrame("Button", "TargetHealthPanel", TargetFrame);
    SS_TargetHealthPanel:Show();
    SS_TargetHealthPanel:EnableMouse();
    SS_TargetHealthPanel:SetSize(60, 27);
    SS_TargetHealthPanel:SetBackdropColor(0, 0, 0, 1);
    SS_TargetHealthPanel:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", 28, -16);
  else
    SS_TargetHealthPanel:Show();
  end;

  local TargetHealthIcon = CreateFrame("Button", "TargetHealthIcon", SS_TargetHealthPanel);
        TargetHealthIcon:Show();
        TargetHealthIcon:EnableMouse(false);
        TargetHealthIcon:SetSize(12, 12);
        TargetHealthIcon:SetPoint("TOPLEFT", SS_TargetHealthPanel, "TOPLEFT", 0, 0);
        TargetHealthIcon:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\hp.blp");

  local TargetHealthText = SS_TargetHealthPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        TargetHealthText:SetPoint("LEFT", SS_TargetHealthPanel, "LEFT", 16, 8);
        TargetHealthText:SetText(params.health..'/'..params.maxHealth);
        TargetHealthText:SetFont("Fonts\\FRIZQT__.TTF", 11);
        TargetHealthText:Show();

  if (tonumber(params.maxBarrier) > 0) then
    if (not(SS_TargetBarrierPanel)) then
      SS_TargetBarrierPanel = CreateFrame("Button", "TargetBarrierPanel", TargetFrame);
      SS_TargetBarrierPanel:Show();
      SS_TargetBarrierPanel:EnableMouse();
      SS_TargetBarrierPanel:SetSize(60, 27);
      SS_TargetBarrierPanel:SetBackdropColor(0, 0, 0, 1);
      SS_TargetBarrierPanel:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", 28, -37);
    else
      SS_TargetBarrierPanel:Show();
    end;
      
    local TargetBarrierIcon = CreateFrame("Button", "TargetBarrierIcon", SS_TargetBarrierPanel);
          TargetBarrierIcon:Show();
          TargetBarrierIcon:EnableMouse(false);
          TargetBarrierIcon:SetSize(12, 12);
          TargetBarrierIcon:SetPoint("TOPLEFT", SS_TargetBarrierPanel, "TOPLEFT", 0, 0);
          TargetBarrierIcon:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\shield.blp");

    local TargetBarrierText = SS_TargetBarrierPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
          TargetBarrierText:SetPoint("LEFT", SS_TargetBarrierPanel, "LEFT", 16, 7);
          TargetBarrierText:SetText(params.barrier..'/'..params.maxBarrier);
          TargetBarrierText:SetFont("Fonts\\FRIZQT__.TTF", 11);
          TargetBarrierText:Show();
  end;

  if (not(SS_TargetSettingsPanel)) then
    SS_TargetSettingsPanel = CreateFrame("Button", "TargetSettingsPanel", TargetFrame);
    SS_TargetSettingsPanel:Show();
    SS_TargetSettingsPanel:EnableMouse();
    SS_TargetSettingsPanel:SetSize(60, 27);
    SS_TargetSettingsPanel:SetBackdropColor(0, 0, 0, 1);
    if (tonumber(params.maxBarrier) > 0) then
      SS_TargetSettingsPanel:SetPoint("BOTTOMRIGHT", TargetFrame, "BOTTOMRIGHT", 28, 14);
    else
      SS_TargetSettingsPanel:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", 28, -37);
    end;

  else
    SS_TargetSettingsPanel:Show();
  end;
  
  local TargetSettingsIcon = CreateFrame("Button", "TargetSettingsIcon", SS_TargetSettingsPanel);
        TargetSettingsIcon:Show();
        TargetSettingsIcon:EnableMouse(false);
        TargetSettingsIcon:SetSize(12, 12);
        TargetSettingsIcon:SetPoint("TOPLEFT", SS_TargetSettingsPanel, "TOPLEFT", 0, 0);
        TargetSettingsIcon:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\settings_normal.blp");
        TargetSettingsIcon:SetHighlightTexture("Interface\\AddOns\\SnowySystem\\IMG\\settings_hover.blp");

  local TargetSettingsText = SS_TargetSettingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        TargetSettingsText:SetPoint("LEFT", SS_TargetSettingsPanel, "LEFT", 16, 7);
        TargetSettingsText:SetText("Управление");
        TargetSettingsText:SetFont("Fonts\\FRIZQT__.TTF", 11);
        TargetSettingsText:Show();
end;