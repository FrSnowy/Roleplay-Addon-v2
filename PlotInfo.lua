SS_createPlot = function(plotName, authorName)
  local plotUniqueName = plotName..'-'..random(1, 1000000)..'-'..random(1, 1000000)..'-'..random(1, 1000000);

  SS_User.plots[plotUniqueName] = {
    name = plotName,
    skills = {
      melee = 0,
      range = 0,
      magic = 0,
      religion = 0,
      perfomance = 0,
      hands = 0,
      stealth = 0,
      observation = 0,
      controll = 0,
      knowledge = 0,
      athletics = 0,
      acrobats = 0,
    },
    stats = {
      power = 0,
      accuracy = 0,
      mobility = 0,
      wisdom = 0,
      empathy = 0,
      morale = 0,
    },
    level = 1,
    experience = 0,
    author = authorName,
  };

  SS_User.leadingPlots[plotUniqueName] = {
    name = plotName,
    players = { authorName }
  };

  return true;
end;