SS_getPlotsCount = function(plotType)
  if (not(plotType == 'plots') and not(plotType == 'leadingPlots')) then
    return 0;
  end;

  local count = 0;
  for index, plot in pairs(SS_User[plotType]) do
    count = count + 1;
  end;

  return count;
end;