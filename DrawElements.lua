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

  if (SS_TargetHealthIcon) then
    SS_TargetHealthIcon:Hide();
  end;

  if (SS_TargetHealthText) then
    SS_TargetHealthText:Hide();
  end;

  if (SS_TargetBarrierPanel) then
    SS_TargetBarrierPanel:Hide();
  end;

  if (SS_TargetSettingsPanel) then
    SS_TargetSettingsPanel:Hide();
  end;

  if (SS_TargetSettingsIcon) then
    SS_TargetSettingsIcon:Hide();
  end;

  if (SS_TargetSettingsText) then
    SS_TargetSettingsText:Hide();
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

  if (not(SS_TargetHealthIcon)) then
    SS_TargetHealthIcon = CreateFrame("Button", "TargetHealthIcon", SS_TargetHealthPanel);
    SS_TargetHealthIcon:EnableMouse(false);
    SS_TargetHealthIcon:SetSize(12, 12);
    SS_TargetHealthIcon:SetPoint("TOPLEFT", SS_TargetHealthPanel, "TOPLEFT", 0, 0);
    SS_TargetHealthIcon:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\hp.blp");
  end;
  SS_TargetHealthIcon:Show();

  if (not(SS_TargetHealthText)) then
    SS_TargetHealthText = SS_TargetHealthPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    SS_TargetHealthText:SetPoint("LEFT", SS_TargetHealthPanel, "LEFT", 16, 8);
    SS_TargetHealthText:SetFont("Fonts\\FRIZQT__.TTF", 11);
  end;
  SS_TargetHealthText:SetText(params.health..'/'..params.maxHealth);
  SS_TargetHealthText:Show();

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
      
    if (not(SS_TargetBarrierIcon)) then
      SS_TargetBarrierIcon = CreateFrame("Button", "TargetBarrierIcon", SS_TargetBarrierPanel);
      SS_TargetBarrierIcon:EnableMouse(false);
      SS_TargetBarrierIcon:SetSize(12, 12);
      SS_TargetBarrierIcon:SetPoint("TOPLEFT", SS_TargetBarrierPanel, "TOPLEFT", 0, 0);
      SS_TargetBarrierIcon:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\shield.blp");
    end;
    SS_TargetBarrierIcon:Show();

    if (not(SS_TargetBarrierText)) then
      SS_TargetBarrierText = SS_TargetBarrierPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
      SS_TargetBarrierText:SetPoint("LEFT", SS_TargetBarrierPanel, "LEFT", 16, 7);
      SS_TargetBarrierText:SetFont("Fonts\\FRIZQT__.TTF", 11);
    end;
    SS_TargetBarrierText:SetText(params.barrier..'/'..params.maxBarrier);
    SS_TargetBarrierText:Show();
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
  
  if (not(SS_TargetSettingsIcon)) then
    SS_TargetSettingsIcon = CreateFrame("Button", "TargetSettingsIcon", SS_TargetSettingsPanel);
    SS_TargetSettingsIcon:EnableMouse(false);
    SS_TargetSettingsIcon:SetSize(12, 12);
    SS_TargetSettingsIcon:SetPoint("TOPLEFT", SS_TargetSettingsPanel, "TOPLEFT", 0, 0);
    SS_TargetSettingsIcon:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\settings_normal.blp");
    SS_TargetSettingsIcon:SetHighlightTexture("Interface\\AddOns\\SnowySystem\\IMG\\settings_hover.blp");
  end;
  SS_TargetSettingsIcon:Show();

  if(not(SS_TargetSettingsText)) then
    SS_TargetSettingsText = SS_TargetSettingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    SS_TargetSettingsText:SetPoint("LEFT", SS_TargetSettingsPanel, "LEFT", 16, 7);
    SS_TargetSettingsText:SetFont("Fonts\\FRIZQT__.TTF", 11);
    SS_TargetSettingsText:SetText("Управление");
  end;
  SS_TargetSettingsText:Show();
end;