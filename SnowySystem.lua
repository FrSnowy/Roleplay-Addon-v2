function SS_ApplicationLoad()
  SS_loadConfiguration();
end;

function SS_PointToStat(value, stat, statView)
  if (SS_User.plots[SS_User.settings.currentPlot].stats[stat] + value < 0) then
    return 0;
  end;
  SS_User.plots[SS_User.settings.currentPlot].stats[stat] = SS_User.plots[SS_User.settings.currentPlot].stats[stat] + value;
  statView:SetText(SS_User.plots[SS_User.settings.currentPlot].stats[stat]);
end;