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
