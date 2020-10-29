SS_PlotController_CreateBoth = function(plotName, authorName)
  local plotUniqueName = plotName..'-'..random(1, 1000000)..'-'..random(1, 1000000)..'-'..random(1, 1000000);

  SS_Plots_Create(plotUniqueName, plotName, authorName);
  SS_LeadingPlots_Create(plotUniqueName, plotName, authorName);
  return true;
end;

SS_PlotController_Select = function(plotIndex)
  if (plotIndex == nil) then SS_User.settings.selectedPlot = nil; return; end;
  if (not(SS_Plots_Includes(plotIndex)) and not(SS_LeadingPlots_Includes(plotIndex))) then return false; end;
  SS_User.settings.selectedPlot = plotIndex;
end;

SS_PlotController_MakeCurrent = function(plotIndex)
  if (plotIndex == nil) then SS_User.settings.currentPlot = nil; return; end;
  if (not(SS_Plots_Includes(plotIndex)) and not(SS_LeadingPlots_Includes(plotIndex))) then return false; end;
  SS_User.settings.currentPlot = plotIndex;
end;

SS_PlotController_GetCountOf = function(plotType)
  if (not(plotType == 'plots') and not(plotType == 'leadingPlots')) then
    return 0;
  end;

  if (plotType == 'plots') then return SS_Plots_Count(); end;
  if (plotType == 'leadingPlots') then return SS_LeadingPlots_Count(); end;
end;

SS_PlotController_Remove = function(plotID)
  SS_PlotController_Select(nil);
  if (SS_User.settings.currentPlot == plotID) then
    SS_PlotController_MakeCurrent(nil);
    SS_PlotController_OnDeactivate();
  end;

  SS_User.plots[plotID] = nil;
  SS_Modal_Plot_Activate:Hide();
end;

SS_PlotController_Draw = function(categoryName)
  local plotType;
  if (categoryName == nil or categoryName == 'Все') then
    plotType = 'plots';
  else
    plotType = 'leadingPlots';
  end;
  
  local counter = 0;

  SS_Shared_DrawList(SS_Plots_Container, SS_User[plotType], function(plot, index, container)
    local PlotPanel = CreateFrame("Button", "OpenPlotPanel-"..plotType.."-"..index, container);
          PlotPanel:Show();
          PlotPanel:EnableMouse();
          PlotPanel:SetSize(224, 16);
          PlotPanel:SetBackdropColor(0, 0, 0, 1);
          PlotPanel:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -28 * counter);
          PlotPanel:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\plot-background.blp");
          PlotPanel:SetHighlightTexture("Interface\\AddOns\\SnowySystem\\IMG\\plot-background.blp");

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
      SS_Modal_Plot_Activate:Hide();
      SS_PlotController_Select(index);
      SS_Modal_Plot_Activate:Show();
    end);

    counter = counter + 1;
  end);

  SS_Plots_Container:SetSize(236, 10 * counter);
end;

SS_PlotController_DrawSinglePlayer = function(plot, player)
  SS_Plot_Controll_PlayerInfo:Hide();

  local role = '';
  if (SS_User.plots[plot].author == player) then
    role = 'Ведущий';
  else
    role = 'Игрок';
  end;

  SS_Plot_Controll_PlayerInfo_Role:SetText(role);
  SS_Plot_Controll_PlayerInfo_Name:SetText(player);

  if (role == 'Ведущий') then
    SS_Plot_Controll_PlayerInfo_NoActions:Show();
    SS_Plot_Controll_PlayerInfo_Kick_Button:Hide();
  else
    SS_Plot_Controll_PlayerInfo_NoActions:Hide();
    SS_Plot_Controll_PlayerInfo_Kick_Button:Show();

    SS_Plot_Controll_PlayerInfo_Kick_Button:SetScript("OnClick", function()
      SS_DMtP_KickFromPlot(player, plot);
    end);
  end;

  SS_Plot_Controll_PlayerInfo:Show();
end;

SS_PlotController_DrawPlayers = function(_plot)
  local plot;
  if (not(_plot)) then plot = SS_User.settings.currentPlot; end;
  if (plot == nil) then return nil end;
  if (not(SS_User.leadingPlots[plot])) then return nil end;

  local counter = 0;

  SS_Shared_DrawList(SS_Plot_Controll_List_Players, SS_User.leadingPlots[plot].players, function(player, index, container)
    local PlayerPanel = CreateFrame("Button", "SS_PlayerPanel-"..player.."-"..index, container);
          PlayerPanel:Show();
          PlayerPanel:EnableMouse();
          PlayerPanel:SetSize(224, 27);
          PlayerPanel:SetBackdropColor(0, 0, 0, 1);
          PlayerPanel:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -36 * counter);
          PlayerPanel:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\plot-background.blp");
          PlayerPanel:SetHighlightTexture("Interface\\AddOns\\SnowySystem\\IMG\\plot-background.blp");
          PlayerPanel:SetScript("OnClick", function()
            if (SS_Plot_Controll_PlayerInfo_Name:GetText() == player and SS_Plot_Controll_PlayerInfo:IsVisible()) then
              SS_Plot_Controll_PlayerInfo:Hide();
            else
              SS_PlotController_DrawSinglePlayer(plot, player)
            end;
          end);

    local name = player;
    if (name == UnitName("player")) then
      name = name..' (Вы)';
    end;

    local PlayerName = PlayerPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
          PlayerName:SetPoint("LEFT", PlayerPanel, "LEFT", 0, 4);
          PlayerName:SetText(name);
          PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 12);
          PlayerName:Show();
  
    counter = counter + 1;
  end);

  SS_Plot_Controll_List_Players:SetSize(236, 12 * counter);
end;

SS_PlotController_OnActivate = function()
  SS_Player_Menu:SetSize(84, 255);
  SS_Player_Menu_DicesIcon:Show();
  SS_Player_Menu_StatsIcon:Show();
  SS_Player_Menu_SkillsIcon:Show();
  SS_Player_Menu_ArmorIcon:Show();
  SS_Player_Menu_SettingsIcon:ClearAllPoints()
  SS_Player_Menu_SettingsIcon:SetPoint("BOTTOM", SS_Player_Menu, "BOTTOM", 0, 20);
  SS_Progress_DrawAddonLevel();
  SS_Progress_ShowExpBar();
  SS_PlayerFrame:Show();
  SS_Params_DrawHealth();

  if (SS_LeadingPlots_Current()) then
    if (SS_LeadingPlots_Current().isEventOngoing) then
      
    else
      SS_Plot_Controll:Show();

      local plot = SS_Plots_Current();
      local id = SS_User.settings.currentPlot;
    
      SS_Shared_IfOnline(plot.author, function()
        SS_PtDM_JoinToEvent(id, plot.author);
      end);
    end;
  end;
end;

SS_PlotController_OnDeactivate = function()
  if (SS_Plots_Selected()) then
    local plot = SS_Plots_Selected();
    local id = SS_User.settings.selectedPlot;
    SS_Shared_IfOnline(plot.author, function()
      SS_PtDM_DeactivePlot(id, plot.author);
    end);
  end;

  SS_Player_Menu:SetSize(84, 84);
  SS_Player_Menu_DicesIcon:Hide();
  SS_Player_Menu_StatsIcon:Hide();
  SS_Player_Menu_SkillsIcon:Hide();
  SS_Player_Menu_ArmorIcon:Hide();
  SS_Player_Menu_SettingsIcon:ClearAllPoints()
  SS_Player_Menu_SettingsIcon:SetPoint("CENTER", SS_Player_Menu, "CENTER", 0, 0);
  SS_Progress_DrawDefaultLevel();
  SS_Progress_HideExpBar();
  SS_PlayerFrame:Hide();

  SS_Plot_Controll:Hide();
end;