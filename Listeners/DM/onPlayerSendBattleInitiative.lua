SS_Listeners_DM_OnPlayerSendBattleInitiative = function(data, player)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle)) then return nil; end;

  local plotID, initiative = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  initiative = SS_Shared_NumFromStr(initiative);

  if (not(SS_LeadingPlots_Current().battle.playersByInitiative)) then
    SS_LeadingPlots_Current().battle.playersByInitiative = {}; 
  end;

  local isPlayerInTable = SS_Shared_Includes(SS_LeadingPlots_Current().battle.playersByInitiative)(function (p)
    return p.name == player
  end);

  if (not(isPlayerInTable)) then
    table.insert(SS_LeadingPlots_Current().battle.playersByInitiative, { name = player, initiative = initiative });
    table.sort(SS_LeadingPlots_Current().battle.playersByInitiative, function(player, nextPlayer)
      return player.initiative > nextPlayer.initiative
    end);

    local syncTime = 1;
    if (SS_LeadingPlots_Current().battle.syncTimer) then
      SS_LeadingPlots_Current().battle.syncTimer:Hide();
      SS_LeadingPlots_Current().battle.syncTimer = nil;
    end;

    SS_LeadingPlots_Current().battle.syncTimer = CreateFrame("Frame")
    SS_LeadingPlots_Current().battle.syncTimer:SetScript("OnUpdate", function(self, elapsed)
      syncTime = syncTime - elapsed
      if syncTime <= 0 then
        SS_LeadingPlots_Current().battle.syncTimer:Hide();
        SS_LeadingPlots_Current().battle.syncTimer = nil;
      end
    end)
  end;
end;