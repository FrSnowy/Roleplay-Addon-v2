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

SS_PtDM_DeletePlot = function(plotName, plotAuthor)
  SS_PtDM_Direct('playerDeletePlot', plotName, plotAuthor);
end;

SS_PtDM_KickAllright = function(plotID, plotAuthor)
  SS_PtDM_Direct('kickAllright', plotID, plotAuthor);
end;