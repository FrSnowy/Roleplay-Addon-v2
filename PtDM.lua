SS_PtDM_Direct = function(action, data, target)
  SendAddonMessage("SS-PtDM", action.."|"..data, "WHISPER", target);
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
  local paramsString = params.health.."+"..params.maxHealth.."+"..params.barrier.."+"..params.maxBarrier.."+"..params.level.."+"..params.experience.."+"..params.experienceForUp.."+"..params.armorType;
  SS_PtDM_Direct('sendInspectInfo', paramsString, plotAuthor);
end;