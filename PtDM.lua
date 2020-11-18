SS_PtDM_Direct = function(action, data, target)
  SendAddonMessage("SS-PtDM", action.."|"..data, "WHISPER", target);
end;

SS_PtDM_SayAll = function(action, data)
  if (not(SS_Plots_Current())) then return nil; end;

  SendAddonMessage("SS-PtDM", "playerToAll".."|"..action.."+"..data, "WHISPER", SS_Plots_Current().author);
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

SS_PtDM_Params = function(params, plotAuthor)
  local paramsString = params.health.."+"..params.maxHealth.."+"..params.barrier.."+"..params.maxBarrier.."+"..params.level;
  SS_PtDM_Direct('sendParams', paramsString, plotAuthor);
end;

SS_PtDM_InspectInfo = function(params, plotAuthor)
  local paramsString = params.health..'}'..params.maxHealth..'}'..params.barrier..'}'..params.maxBarrier..'}'..params.level..'}'..params.experience..'}'..params.experienceForUp..'}'..params.armorType;
  local statsString =  params.power..'}'..params.accuracy..'}'..params.wisdom..'}'..params.morale..'}'..params.empathy..'}'..params.mobility..'}'..params.precision;
  local activeSkillsString = params.melee..'}'..params.range..'}'..params.magic..'}'..params.religion..'}'..params.perfomance..'}'..params.missing..'}'..params.hands;
  local passiveSkillsString = params.athletics..'}'..params.observation..'}'..params.knowledge..'}'..params.controll..'}'..params.judgment..'}'..params.acrobats..'}'..params.stealth;

  local statModifiersStr = '';
  SS_Shared_ForEach(params.statModifiers)(function(modifier, id)
    currentString = id..'/'..modifier.name..'/'..modifier.stat..'/'..modifier.value..'/'..modifier.count;
    statModifiersStr = statModifiersStr..currentString..'}';
  end);

  statModifiersStr = statModifiersStr:sub(1, #statModifiersStr - 1);
  if (statModifiersStr == '') then statModifiersStr = 'nothing'; end;

  local skillModifiersStr = '';
  SS_Shared_ForEach(params.skillModifiers)(function(modifier, id)
    currentString = id..'/'..modifier.name..'/'..modifier.stat..'/'..modifier.value..'/'..modifier.count;
    skillModifiersStr = skillModifiersStr..currentString..'}';
  end);

  skillModifiersStr = skillModifiersStr:sub(1, #skillModifiersStr - 1);
  if (skillModifiersStr == '') then skillModifiersStr = 'nothing'; end;

  SS_PtDM_Direct('sendInspectInfo', paramsString.."+"..statsString.."+"..activeSkillsString.."+"..passiveSkillsString.."+"..statModifiersStr.."+"..skillModifiersStr, plotAuthor);
end;

SS_PtDM_ModifierRemoved = function(params, plotAuthor)
  local paramsStr = params.modifierType.."+"..params.modifierID;
  SS_PtDM_Direct('playerModifierRemoved', paramsStr, plotAuthor);
end;

SS_PtA_RollResult = function(params)
  local paramStr = params.skill.."+"..params.skillResult.."+"..params.efficencyResult.."+"..params.dices.from.."+"..params.dices.to.."+"..params.diceCount.."+"..params.modifier;
  SS_PtDM_SayAll('rollResult', UnitName("player").."+"..paramStr);
end;