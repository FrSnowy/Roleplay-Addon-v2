SS_PtDM_Direct = function(action, data, target)
  SS_Shared_SAM("SS-PtDM", action, data, target);
end;

SS_PtDM_SayAll = function(action, data)
  if (not(SS_Plots_Current())) then return nil; end;
  SS_Shared_SAM("SS-PtDM", "playerToAll", action.."+"..data, SS_Plots_Current().author);
end;

SS_PtDM_PlotAlreadyExists = function(plotName, plotAuthor)
  SS_PtDM_Direct('plotExists', plotName, plotAuthor);
end;

SS_PtDM_DeclineInvite = function(plotName, plotAuthor)
  SS_PtDM_Direct('declinePlotInvite', plotName, plotAuthor);
end;

SS_PtDM_AcceptInvite = function(plotName, plotAuthor)
  SS_PtDM_Direct('acceptPlotInvite', plotName, plotAuthor);
end;

SS_PtDM_DeletePlot = function(plotID, plotAuthor)
  SS_PtDM_Direct('playerDeletePlot', plotID, plotAuthor);
end;

SS_PtDM_DeactivePlot = function(plotID, plotAuthor)
  SS_PtDM_Direct('playerDeactivatePlot', plotID, plotAuthor);
end;

SS_PtDM_KickAllright = function(plotID, plotAuthor)
  SS_PtDM_Direct('kickAllright', plotID, plotAuthor);
end;

SS_PtDM_DeclineEventStart = function(plotName, plotAuthor)
  SS_PtDM_Direct('declineEventStart', plotName, plotAuthor);
end;

SS_PtDM_AcceptEventStart = function(plotName, plotAuthor)
  SS_PtDM_Direct('acceptEventStart', plotName, plotAuthor);
end;

SS_PtDM_JoinToEvent = function(plotID, plotAuthor)
  SS_PtDM_Direct('joinToEvent', plotID, plotAuthor);
end;

SS_PtDM_Params = function(plotAuthor)
  if (not(SS_Plots_Current())) then return nil end;

  local isInBattle = not(SS_Plots_Current().battle == nil);
  if (isInBattle) then isInBattle = 'true' else isInBattle = 'false'; end;

  local paramsString = SS_User.settings.currentPlot.."+"..SS_Params_GetHealth().."+"..SS_Params_GetMaxHealth().."+"..SS_Params_GetBarrier().."+"..SS_Params_GetMaxBarrier().."+"..SS_Progress_GetLevel().."+"..isInBattle;
  SS_PtDM_Direct('sendParams', paramsString, plotAuthor);
end;

SS_PtDM_InspectInfo = function(actionType, plotAuthor)
  if (not(SS_Plots_Current())) then return nil end;

  local paramsString = SS_Params_GetHealth()..'}'..SS_Params_GetMaxHealth()..'}'..SS_Params_GetBarrier()..'}'..SS_Params_GetMaxBarrier()..'}'..SS_Progress_GetLevel()..'}'..SS_Progress_GetExp()..'}'..SS_Progress_GetExpForUp()..'}'..SS_Armor_GetType();
  local statsString =  SS_Stats_GetValue('power')..'}'..SS_Stats_GetValue('accuracy')..'}'..SS_Stats_GetValue('wisdom')..'}'..SS_Stats_GetValue('morale')..'}'..SS_Stats_GetValue('empathy')..'}'..SS_Stats_GetValue('mobility')..'}'..SS_Stats_GetValue('precision');
  local activeSkillsString = SS_Skills_GetValue('melee')..'}'..SS_Skills_GetValue('range')..'}'..SS_Skills_GetValue('magic')..'}'..SS_Skills_GetValue('religion')..'}'..SS_Skills_GetValue('charm')..'}'..SS_Skills_GetValue('missing')..'}'..SS_Skills_GetValue('hands');
  local passiveSkillsString = SS_Skills_GetValue('athletics')..'}'..SS_Skills_GetValue('observation')..'}'..SS_Skills_GetValue('knowledge')..'}'..SS_Skills_GetValue('controll')..'}'..SS_Skills_GetValue('judgment')..'}'..SS_Skills_GetValue('acrobats')..'}'..SS_Skills_GetValue('stealth');

  local statModifiersStr = '';
  SS_Shared_ForEach(SS_Plots_Current().modifiers.stats)(function(modifier, id)
    local modifierStatsAsStr = '';

    SS_Shared_ForEach(modifier.stats)(function(stat)
      modifierStatsAsStr = modifierStatsAsStr..stat..'\\';
    end);
    modifierStatsAsStr = modifierStatsAsStr:sub(1, #modifierStatsAsStr - 1);

    currentString = id..'/'..modifier.name..'/'..modifierStatsAsStr..'/'..modifier.value..'/'..modifier.count;
    statModifiersStr = statModifiersStr..currentString..'}';
  end);

  statModifiersStr = statModifiersStr:sub(1, #statModifiersStr - 1);
  if (statModifiersStr == '') then statModifiersStr = 'nothing'; end;

  local skillModifiersStr = '';
  SS_Shared_ForEach(SS_Plots_Current().modifiers.skills)(function(modifier, id)
    local modifierStatsAsStr = '';

    SS_Shared_ForEach(modifier.stats)(function(stat)
      modifierStatsAsStr = modifierStatsAsStr..stat..'\\';
    end);
    modifierStatsAsStr = modifierStatsAsStr:sub(1, #modifierStatsAsStr - 1);

    currentString = id..'/'..modifier.name..'/'..modifierStatsAsStr..'/'..modifier.value..'/'..modifier.count;
    skillModifiersStr = skillModifiersStr..currentString..'}';
  end);

  skillModifiersStr = skillModifiersStr:sub(1, #skillModifiersStr - 1);
  if (skillModifiersStr == '') then skillModifiersStr = 'nothing'; end;
  
  local isInBattle = not(SS_Plots_Current().battle == nil);
  if (isInBattle) then isInBattle = 'true' else isInBattle = 'false'; end;

  SS_PtDM_Direct('sendInspectInfo', SS_User.settings.currentPlot.."+"..paramsString.."+"..statsString.."+"..activeSkillsString.."+"..passiveSkillsString.."+"..statModifiersStr.."+"..skillModifiersStr.."+"..isInBattle.."+"..actionType, plotAuthor);
end;

SS_PtDM_PlayerGetModifier = function(modifier, master)
  if (not(modifier)) then return nil; end;
  if (not(modifier.stats)) then return nil; end;
  if (not(SS_Plots_Current())) then return nil; end;

  local modifierStatsAsStr = '';
  SS_Shared_ForEach(modifier.stats)(function(stat)
    modifierStatsAsStr = modifierStatsAsStr..stat..'\\';
  end);
  modifierStatsAsStr = modifierStatsAsStr:sub(1, #modifierStatsAsStr - 1);

  if (not(master == UnitName('player'))) then
    SS_Shared_IfOnline(master, function()
      SS_PtDM_Direct('playerGetModifier', SS_User.settings.currentPlot.."+"..modifier.name.."+"..modifier.value.."+"..modifierStatsAsStr, master);
    end);
  end;
end;

SS_PtDM_PlayerLooseModifier = function(modifier, master)
  if (not(modifier)) then return nil; end;
  if (not(modifier.stats)) then return nil; end;
  if (not(SS_Plots_Current())) then return nil; end;

  local modifierStatsAsStr = '';
  SS_Shared_ForEach(modifier.stats)(function(stat)
    modifierStatsAsStr = modifierStatsAsStr..stat..'\\';
  end);
  modifierStatsAsStr = modifierStatsAsStr:sub(1, #modifierStatsAsStr - 1);

  if (not(master == UnitName('player'))) then
    SS_Shared_IfOnline(master, function()
      SS_PtDM_Direct('playerLooseModifier', SS_User.settings.currentPlot.."+"..modifier.name.."+"..modifier.value.."+"..modifierStatsAsStr, master);
    end);
  end;
end;

SS_PtA_RollResult = function(params)
  local paramStr = params.skill.."+"..params.skillResult.."+"..params.efficencyResult.."+"..params.dices.from.."+"..params.dices.to.."+"..params.diceCount.."+"..params.modifier;
  SS_PtDM_SayAll('rollResult', UnitName("player").."+"..paramStr);
end;

SS_PtDM_UpdatePlayerInfo = function(master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (master == UnitName('player')) then return nil; end;

  SS_PtDM_Params(master);
  SS_PtDM_InspectInfo("update", master);
end;

SS_PtDM_JoinToBattle = function(master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (master == UnitName('player')) then return nil; end;

  SS_PtDM_Direct('playerJoinToBattle', SS_User.settings.currentPlot, master);
  SS_PtDM_Params(master);
  SS_PtDM_InspectInfo("update", master);
end;

SS_PtDM_EndBattleTurn = function(master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (master == UnitName('player')) then return nil; end;

  SS_Shared_IfOnline(master, function()
    SS_PtDM_Direct('playerBattleTurnEnd', SS_User.settings.currentPlot, master);
  end);
end;

SS_PtDM_RequestActualBattleInfo = function(master)
  if (not(SS_Plots_Current()) or not(SS_Plots_Current().battle)) then return nil; end;
  if (master == UnitName('player')) then return nil; end;

  SS_PtDM_Direct('playerRequestActualBattleInfo', SS_User.settings.currentPlot, master);
end;

SS_PtDM_SendBattleInitiative = function(initiative, master)
  if (not(SS_Plots_Current())) then return nil; end;
  SS_PtDM_Direct('playerSendBattleInitiative', SS_User.settings.currentPlot.."+"..initiative, master);
end;

SS_PtDM_SendMovementPointsEnd = function(master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().battle)) then return nil; end;

  SS_Shared_IfOnline(master, function()
    SS_PtDM_Direct('playerMovementPointsEnd', SS_User.settings.currentPlot, master);
  end);

end;

SS_PtDM_LeaveBattleSuccess = function(master)
  if (not(SS_Plots_Current())) then return nil; end;

  SS_Shared_IfOnline(master, function()
    SS_PtDM_Direct('playerLeaveBattle', SS_User.settings.currentPlot, master);
    SS_PtDM_Params(master);
    SS_PtDM_InspectInfo("update", master);
  end);
end;

SS_PtDM_GetAdditionalMovementPoints = function(points, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (master == UnitName("player")) then return nil; end;

  SS_Shared_IfOnline(master, function()
    SS_PtDM_Direct('playerGetAdditionalMovemetPoints', SS_User.settings.currentPlot.."+"..points, master);
  end);
end;

SS_PtDM_RecievedDamage = function(dmg, currentHP, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (master == UnitName("player")) then return nil; end;

  SS_PtDM_Direct('playerGetDamage', SS_User.settings.currentPlot.."+"..dmg.."+"..currentHP, master);
end;

SS_PtDM_HPChanged = function(updateValue, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (master == UnitName("player")) then return nil; end;

  SS_PtDM_Direct('playerHealthChange', SS_User.settings.currentPlot.."+"..updateValue, master);
end;

SS_PtDM_BarrierChanged = function(updateValue, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (master == UnitName("player")) then return nil; end;

  SS_PtDM_Direct('playerBarrierChange', SS_User.settings.currentPlot.."+"..updateValue, master);
end;

SS_PtDM_LevelChanged = function(master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (master == UnitName("player")) then return nil; end;

  SS_PtDM_Direct('playerLevelChange', SS_User.settings.currentPlot.."+"..SS_Plots_Current().progress.level, master);
end;

SS_PtDM_ExpChanged = function(updateValue, master)
  if (not(SS_Plots_Current())) then return nil; end;
  if (master == UnitName("player")) then return nil; end;

  SS_PtDM_Direct('playerExpChange', SS_User.settings.currentPlot.."+"..updateValue, master);
end;