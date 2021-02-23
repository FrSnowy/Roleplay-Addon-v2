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

SS_Progress_GetExpForUp = function(level)
  if (not(level)) then level = SS_Progress_GetLevel(); end;

  local levelWithPow = math.floor(math.pow(level, 1.566));
  local experienceForEvent = 100;

  return levelWithPow * experienceForEvent;
end;

SS_Progress_UpdateExp = function(updateValue, master)
  if (not(SS_Plots_Current())) then return nil; end;
  
  SS_Log_ExpChanged(updateValue);

  if (SS_Progress_GetExp() == 0 and SS_Progress_GetLevel() == 1 and updateValue < 0) then return nil; end;
  if (SS_Progress_GetLevel() == 20 and updateValue > 0) then
    SS_Plots_Current().progress.experience = 0;
    return nil;
  end;

  local cachedValue = updateValue;
  local cachedLevel = SS_Plots_Current().progress.level;

  local addExp = function(updValue)
    SS_Plots_Current().progress.experience = SS_Progress_GetExp() + updValue;
  end;

  if (SS_Progress_GetExp() + updateValue > 0 and SS_Progress_GetExp() + updateValue < SS_Progress_GetExpForUp()) then
    addExp(updateValue);
  elseif (SS_Progress_GetExp() + updateValue > SS_Progress_GetExpForUp()) then
    local gettedLevels = 0;

    while updateValue > (SS_Progress_GetExpForUp(SS_Progress_GetLevel() + gettedLevels) - SS_Progress_GetExp()) do
      local differenceBetweenMaxAndCurrent = SS_Progress_GetExpForUp(SS_Progress_GetLevel() + gettedLevels) - SS_Progress_GetExp();
      gettedLevels = gettedLevels + 1;
      updateValue = updateValue - differenceBetweenMaxAndCurrent;
      SS_Plots_Current().progress.experience = 0;
    end;

    SS_Progress_UpdateLevel(gettedLevels, master, true);
    addExp(updateValue);
  elseif (SS_Progress_GetExp() + updateValue == SS_Progress_GetExpForUp()) then
    SS_Plots_Current().progress.experience = 0;
    SS_Progress_UpdateLevel(1, master, true);
  elseif (SS_Progress_GetExp() + updateValue < 0 and SS_Progress_GetLevel() > 1) then
    local loosedLevels = 1;
    local cachedExp = 0;

    updateValue = updateValue + SS_Progress_GetExp();
    addExp(-SS_Progress_GetExp());

    while updateValue < 0 do
      local previousLevelMaxExp = SS_Progress_GetExpForUp(SS_Progress_GetLevel() - loosedLevels);

      if (math.abs(updateValue) < previousLevelMaxExp) then
        cachedExp = previousLevelMaxExp + updateValue;
        updateValue = 0;
        break;
      else
        SS_Plots_Current().progress.experience = 0;
        updateValue = updateValue + previousLevelMaxExp;
        loosedLevels = loosedLevels + 1;
      end;
    end;

    SS_Progress_UpdateLevel(-loosedLevels, master, true);
    SS_Plots_Current().progress.experience = cachedExp;
  elseif (SS_Progress_GetExp() + updateValue < 0 and SS_Progress_GetLevel() == 1) then
    SS_Plots_Current().progress.experience = 0;
  elseif (SS_Progress_GetExp() + updateValue == 0) then
    SS_Plots_Current().progress.experience = 0;
  end;

  SS_Progress_DrawExp();

  if (not(master == UnitName("player"))) then
    SS_Shared_IfOnline(master, function()
      SS_PtDM_Params(master);
      SS_PtDM_InspectInfo("update", master);
      SS_PtDM_ExpChanged(cachedValue, master);

      if (not(cachedLevel == SS_Plots_Current().progress.level)) then
        SS_PtDM_LevelChanged(master);
      end;
    end);
  end;
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
  local fullWidth = MainMenuExpBar:GetWidth();
  local progress = (SS_Progress_GetExp() / SS_Progress_GetExpForUp())

  if (SS_Progress_GetLevel() == 20) then
    SS_Progress_HideExpBar();
    return;
  else
    MainMenuExpBar:Hide();
    SS_Exp_Bar:Show();
  end;

  if (progress == 0) then
    SS_Exp_Bar_Progress:SetWidth(1);
  else
    SS_Exp_Bar_Progress:SetWidth(fullWidth * progress);
  end;    
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
  SS_Exp_Bar_Progress:SetWidth(1);
end;

SS_Progress_UpdateLevel = function(updateValue, master, noMasterMsg)
  if (not(SS_Plots_Current())) then return nil; end;
  
  if (not(SS_Shared_IsNumber(updateValue))) then
    SS_Log_ValueMustBeNum();
    return nil;
  end;

  local previousLevel = SS_Plots_Current().progress.level;
  SS_Plots_Current().progress.level = SS_Plots_Current().progress.level + updateValue;
  SS_Plots_Current().progress.experience = 0;

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

  if (not(noMasterMsg)) then
    if (not(master == UnitName("player"))) then
      SS_Shared_IfOnline(master, function()
        SS_PtDM_Params(master);
        SS_PtDM_InspectInfo("update", master);
        SS_PtDM_LevelChanged(master);
      end);
    end;
  end;
end;