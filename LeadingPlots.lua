SS_LeadingPlots_Create = function(plotUniqueName, plotName, authorName)
  if (not SS_User) then return nil end;

  SS_User.leadingPlots[plotUniqueName] = {
    name = plotName,
    players = { authorName }
  };
end;

SS_LeadingPlots_Includes = function(plotIndex)
  return not(not(SS_User.leadingPlots[plotIndex]))
end;

SS_LeadingPlots_Count = function()
  local count = 0;
  for index in pairs(SS_User.plots) do
    count = count + 1;
  end;
  return count;
end;