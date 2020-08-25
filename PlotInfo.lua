SS_createPlot = function(plotName, authorName)
  local plotUniqueName = plotName..'-'..random(1, 1000000)..'-'..random(1, 1000000)..'-'..random(1, 1000000);

  SS_PLAYER.plots[plotUniqueName] = {
    name = plotName,
    skills = {
      active = {
        melee = 0,
        range = 0,
        magic = 0,
        religion = 0,
      },
      social = {
        perfomance = 0,
        profession = 0,
        hands_agility = 0,
        stealth = 0,
      },
      passive = {
        observation = 0,
        self_control = 0,
        knowledge = 0,
        athletics = 0,
      }
    },
    author = authorName,
  };

  SS_PLAYER.leadingPlots[plotUniqueName] = {
    name = plotName,
    players = { authorName }
  };

  return true;
end;