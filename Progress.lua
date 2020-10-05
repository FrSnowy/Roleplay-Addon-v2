SS_Progress_GetList = function()
  return {
    level = 1,
    experience = 0,
  };
end;

SS_Progress_GetLevel = function()
  if (SS_User.settings.currentPlot) then
    return SS_Plots_Current().progress.level;
  end;

  return 0;
end;

SS_Progress_GetExp = function()
  if (SS_User.settings.currentPlot) then
    return SS_Plots_Current().progress.experience;
  end;

  return 0;
end;

SS_Progress_GetExpForUp = function()
  local levelWithPow = math.floor(math.pow(SS_Progress_GetLevel(), 1.566));
  local experienceForEvent = 100;

  return levelWithPow * experienceForEvent;
end;

SS_Progress_DrawAddonLevel = function()
  PlayerLevelText:SetTextColor(1, 1, 1);
  PlayerLevelText:SetText(SS_Progress_GetLevel());
  PlayerLevelText:SetFont("Fonts\\FRIZQT__.TTF", 11);
end;

SS_Progress_DrawDefaultLevel = function()
  PlayerLevelText:SetText(UnitLevel("player"));
  PlayerLevelText:SetTextColor(0.82, 0.71, 0);
  PlayerLevelText:SetFont("Fonts\\FRIZQT__.TTF", 10);
end;

SS_Progress_DrawExp = function()
  local fullWidth = MainMenuExpBar:GetWidth() - 180;
  local progress = (SS_Progress_GetExp() / SS_Progress_GetExpForUp())
  SS_Exp_Bar_Progress:SetWidth(fullWidth * progress);
  SS_Exp_Bar_Experience:SetText(SS_Progress_GetExp().."/"..SS_Progress_GetExpForUp());
end;

SS_Progress_ShowExpBar = function()
  SS_Exp_Bar:Show();
  SS_Progress_DrawExp();
end;

SS_Progress_HideExpBar = function()
  SS_Exp_Bar:Hide();
end;