SS_Progress_GetList = function()
  return {
    level = 1,
    experience = 0,
  };
end;

SS_Progress_GetLevel = function()
  if (SS_Plots_Current() and SS_Plots_Current().progress and SS_Plots_Current().progress.level) then
    return SS_Plots_Current().progress.level;
  end;

  return 0;
end;

SS_Progress_GetExp = function()
  if (SS_Plots_Current() and SS_Plots_Current().progress and SS_Plots_Current().progress.experience) then
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
  MainMenuExpBar:Hide();
  SS_Exp_Bar:Show();
  SS_Progress_DrawExp();
end;

SS_Progress_HideExpBar = function()
  MainMenuExpBar:Show();
  SS_Exp_Bar:Hide();
end;

SS_Progress_UpdateLevel = function(updateValue, master)
  if (not(SS_Plots_Current())) then return nil; end;
  
  if (not(SS_Shared_IsNumber(updateValue))) then
    SS_Log_ValueMustBeNum();
    return nil;
  end;

  local previousLevel = SS_Plots_Current().progress.level;
  SS_Plots_Current().progress.level = SS_Plots_Current().progress.level + updateValue;

  if (SS_Plots_Current().progress.level > 20) then
    SS_Plots_Current().progress.level = 20;
  elseif (SS_Plots_Current().progress.level < 1) then
    SS_Plots_Current().progress.level = 1;
  end;

  SS_Log_LevelChanged(updateValue, master);

  if (updateValue < 0 and not(previousLevel == SS_Plots_Current().progress.level)) then
    SS_Stats_ResetStats();
    SS_Stats_ResetSkills();
    SS_Log_PointsReset();
  end;

  SS_Progress_DrawAddonLevel();
  SS_Stats_DrawAll();
  SS_Stats_Menu_Points_Value:SetText(SS_Stats_GetAvaliablePoints());
  SS_Skills_DrawAll();
  SS_Skills_Menu_Points_Value:SetText(SS_Skills_GetAvaliablePoints());
  SS_Params_DrawHealth();
  SS_Params_DrawBarrier();
  SS_Progress_DrawExp();
  PlaySoundFile('Sound\\INTERFACE\\LevelUp.ogg');

  if (not(master == UnitName("player"))) then
    SS_Shared_IfOnline(master, function()
      SS_PtDM_Params(master);
      SS_PtDM_InspectInfo("update", master);
      SS_PtDM_LevelChanged(master);
    end);
  end;
end;