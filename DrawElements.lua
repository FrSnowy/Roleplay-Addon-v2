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

SS_Draw_PlayerControll = function(player)
  -- Текст в главном меню осмотра цели
  SS_Player_Controll_Name:SetText(player);
  SS_Player_Controll_HP_Text:SetText(SS_Target_TMPData.health..'/'..SS_Target_TMPData.maxHealth);
  SS_Player_Controll_Barrier_Text:SetText(SS_Target_TMPData.barrier..'/'..SS_Target_TMPData.maxBarrier..', '..SS_Locale(SS_Target_TMPData.armorType));
  SS_Player_Controll_Level_Text:SetText("Уровень: "..SS_Target_TMPData.level);
  SS_Player_Controll_Exp_Text:SetText("Опыт: "..SS_Target_TMPData.experience..'/'..SS_Target_TMPData.experienceForUp);

  -- Статы в меню статов
  SS_Player_Controll_Stats_Power:SetText(SS_Locale('power')..': '..SS_Target_TMPData.stats.power);
  SS_Player_Controll_Stats_Accuracy:SetText(SS_Locale('accuracy')..': '..SS_Target_TMPData.stats.accuracy);
  SS_Player_Controll_Stats_Wisdom:SetText(SS_Locale('wisdom')..': '..SS_Target_TMPData.stats.wisdom);
  SS_Player_Controll_Stats_Morale:SetText(SS_Locale('morale')..': '..SS_Target_TMPData.stats.morale);
  SS_Player_Controll_Stats_Empathy:SetText(SS_Locale('empathy')..': '..SS_Target_TMPData.stats.empathy);
  SS_Player_Controll_Stats_Mobility:SetText(SS_Locale('mobility')..': '..SS_Target_TMPData.stats.mobility);
  SS_Player_Controll_Stats_Precision:SetText(SS_Locale('precision')..': '..SS_Target_TMPData.stats.precision);

  -- Скиллы в меню скиллов
  SS_Player_Controll_Skills_Melee:SetText(SS_Locale('melee')..': '..SS_Target_TMPData.skills.melee);
  SS_Player_Controll_Skills_Range:SetText(SS_Locale('range')..': '..SS_Target_TMPData.skills.range);
  SS_Player_Controll_Skills_Magic:SetText(SS_Locale('magic')..': '..SS_Target_TMPData.skills.magic);
  SS_Player_Controll_Skills_Religion:SetText(SS_Locale('religion')..': '..SS_Target_TMPData.skills.religion);
  SS_Player_Controll_Skills_Perfomance:SetText(SS_Locale('perfomance')..': '..SS_Target_TMPData.skills.perfomance);
  SS_Player_Controll_Skills_Missing:SetText(SS_Locale('missing')..': '..SS_Target_TMPData.skills.missing);
  SS_Player_Controll_Skills_Hands:SetText(SS_Locale('hands')..': '..SS_Target_TMPData.skills.hands);

  -- Дайсы возле скиллов
  local diceCount = SS_Roll_GetDicesCount(SS_Target_TMPData.level);
  local getDiceStr = function(skill)
    local paramsForRoll = {
      level = SS_Target_TMPData.level,
      skill = SS_Target_TMPData.skills[skill]
    };

    local rollString = diceCount.."d("..SS_Roll_GetMinimum(skill, paramsForRoll)..'-'..SS_Roll_GetMaximum(skill, paramsForRoll)..")";

    local statModifier = SS_Stats_GetModifierFor(skill, SS_Target_TMPData.stats[SS_Skills_GetStatOf(skill)]);

    local armorModifier = SS_Armor_GetModifierFor(skill, {
      from = SS_Roll_GetMinimum(skill, paramsForRoll),
      to = SS_Roll_GetMaximum(skill, paramsForRoll),
    }, SS_Target_TMPData.armorType);
  
    return rollString;
  end;
  SS_Player_Controll_Skills_Melee_DiceInfo:SetText(getDiceStr('melee'));
  SS_Player_Controll_Skills_Range_DiceInfo:SetText(getDiceStr('range'));
  SS_Player_Controll_Skills_Magic_DiceInfo:SetText(getDiceStr('magic'));
  SS_Player_Controll_Skills_Religion_DiceInfo:SetText(getDiceStr('religion'));
  SS_Player_Controll_Skills_Perfomance_DiceInfo:SetText(getDiceStr('perfomance'));
  SS_Player_Controll_Skills_Missing_DiceInfo:SetText(getDiceStr('missing'));
  SS_Player_Controll_Skills_Hands_DiceInfo:SetText(getDiceStr('hands'));

  SS_Player_Controll_Stats_Button:SetScript("OnClick", function()
    if (SS_Player_Controll_Stats:IsVisible()) then
      SS_Player_Controll_Stats:Hide();
    else
      SS_Player_Controll_Stats:Show();
    end;
  end);

  SS_Player_Controll_Skills_Button:SetScript("OnClick", function()
    if (SS_Player_Controll_Skills:IsVisible()) then
      SS_Player_Controll_Skills:Hide();
    else
      SS_Player_Controll_Skills:Show();
    end;
  end);

  SS_Player_Controll:Show();
end;
