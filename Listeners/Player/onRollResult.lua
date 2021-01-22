SS_Listeners_Player_OnRollResult = function(data, master)
  -- У: мастер, от: игрок, когда: игрок бросает кубик
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().author == master)) then return nil; end;

  local name, skill, result, efficency, diceMin, diceMax, diceCount, modifier = strsplit('+', data);
  SS_Log_RollResultOfOther(name, skill, result, efficency, diceMin, diceMax, diceCount, modifier);

  if (SS_LeadingPlots_Current()) then
    local isActivePlayer = SS_Shared_Includes(SS_LeadingPlots_Current().activePlayers)(function(p)
      return p == name;
    end);

    if (not(SS_LeadingPlots_Current().lastDices[name])) then
      SS_LeadingPlots_Current().lastDices[name] = {};
    end;

    if (#SS_LeadingPlots_Current().lastDices[name] < 5) then
      table.insert(SS_LeadingPlots_Current().lastDices[name], result);
    else
      table.remove(SS_LeadingPlots_Current().lastDices[name], 1);
      table.insert(SS_LeadingPlots_Current().lastDices[name], result);
    end;
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