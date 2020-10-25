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
  SS_TargetFrame:Hide();
  SS_TargetFrame_HP_Icon:Hide();
  SS_TargetFrame_Barrier_Icon:Hide();
  SS_TargetFrame_Settings_Icon:Hide();
  SS_TargetFrame_HP_Text:SetText(nil);
  SS_TargetFrame_Barrier_Text:SetText(nil);
  SS_TargetFrame_Settings_Text:SetText(nil);
end;

SS_Draw_InfoAboutPlayer = function(params)
  TargetFrame.levelText:SetText(params.level);
  TargetFrame.levelText:SetTextColor(1, 1, 1);
  TargetFrame.levelText:SetFont("Fonts\\FRIZQT__.TTF", 11);

  SS_TargetFrame_HP_Text:SetText(params.health..'/'..params.maxHealth);
  SS_TargetFrame_Barrier_Text:SetText(params.barrier..'/'..params.maxBarrier);
  SS_TargetFrame_Settings_Text:SetText("Подробнее");

  SS_TargetFrame_HP_Icon:Show();
  SS_TargetFrame_Barrier_Icon:Show();
  SS_TargetFrame_Settings_Icon:Show();
  SS_TargetFrame:Show();
end;

SS_Draw_HideCurrentTargetVisual = function()
  SS_Draw_HidePlayerInfoPlates();
  TargetFrame.levelText:SetText(UnitLevel("player"));
  TargetFrame.levelText:SetTextColor(0.82, 0.71, 0);
  TargetFrame.levelText:SetFont("Fonts\\FRIZQT__.TTF", 10);
end;

SS_Draw_OnEventStarts = function()
  SS_Plot_Controll:Hide();
  SS_Event_Controll:Show();
end;

SS_Draw_OnEventStop = function()
  SS_Event_Controll:Hide();
  SS_Plot_Controll:Show();
end;

SS_Draw_PlayerControll = function(params, player)
  SS_Player_Controll_Name:SetText(player);
  SS_Player_Controll_HP_Text:SetText(params.health..'/'..params.maxHealth);
  SS_Player_Controll_Barrier_Text:SetText(params.barrier..'/'..params.maxBarrier..', '..SS_Locale(params.armorType));
  SS_Player_Controll:Show();
end;