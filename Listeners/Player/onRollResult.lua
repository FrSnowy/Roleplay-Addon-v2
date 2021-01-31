SS_TMP_ROLL_REPEAT_FILTER = {}

SS_Listeners_Player_OnRollResult = function(data, author, prefix)
  -- У: мастер, от: игрок, когда: игрок бросает кубик
  if (not(SS_Plots_Current())) then return nil; end;

  local name, plotID, skill, result, efficency, diceMin, diceMax, diceCount, modifier, timestamp = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then
    return nil;
  end;

  if (SS_TMP_ROLL_REPEAT_FILTER[data..'+'..timestamp]) then
    SS_TMP_ROLL_REPEAT_FILTER[data..'+'..timestamp] = nil;
  else
    SS_TMP_ROLL_REPEAT_FILTER[data..'+'..timestamp] = true;
    if (prefix == 'SS-PtDM' and not(UnitName('player') == author)) then
      SS_Log_RollResultOfOther(name, skill, result, efficency, diceMin, diceMax, diceCount, modifier);
    elseif (prefix == 'SS-DMtP') then
      SS_Log_RollResultOfOther(name, skill, result, efficency, diceMin, diceMax, diceCount, modifier);
    end;
    SS_Roll_SaveResultToMembersTable(name, result);

    local t = 1;
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(self, elapsed)
      t = t - elapsed
      if t <= 0 then
        if (SS_TMP_ROLL_REPEAT_FILTER[data..'+'..timestamp]) then
          SS_TMP_ROLL_REPEAT_FILTER[data..'+'..timestamp] = nil;
        end;
        f:Hide();
      end
    end)
  end;
end;

SS_Listeners_Player_OnNPCRollResult = function(data, master)
  -- У: мастер, от: игрок, когда: игрок бросает кубик
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;

  local plotID, name, result = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  SS_Log_RollResultOfNPC(name, result);
end;