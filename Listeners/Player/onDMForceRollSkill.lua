SS_Listeners_Player_OnDMForceRollSkill = function(data, master)
  -- У: игрок, от: мастер, когда: мастер вызывает бросок у игрока
  local plotID, visibility, skill = strsplit('+', data);

  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if (not(SS_Plots_Current().author == master)) then return false; end;

  if (visibility == 'true') then
    SS_Log_MasterForceRoll();
  end;

  SS_Roll(skill, visibility == 'true');
end;