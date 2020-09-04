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
          PlotPanel:Show();
          PlotPanel:EnableMouse();
          PlotPanel:SetWidth(200);
          PlotPanel:SetHeight(16);
          PlotPanel:SetBackdropColor(0, 0, 0, 1);
          PlotPanel:SetFrameStrata("FULLSCREEN_DIALOG");
          PlotPanel:SetPoint("RIGHT", SS_Controll_Menu, "TOPRIGHT", -92, -86 - 32 * counter);
          PlotPanel:SetNormalTexture("Interface\\AddOns\\STIK_DM\\IMG\\plot-background.blp");
          PlotPanel:SetHighlightTexture("Interface\\AddOns\\STIK_DM\\IMG\\plot-background.blp");

      local PlotName = PlotPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            PlotName:SetPoint("LEFT", PlotPanel, "LEFT", 0, 4);
            PlotName:SetText(plot.name);
            PlotName:Show();

      PlotPanel:SetScript("OnClick", function()
        
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