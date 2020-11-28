SS_PtP_Direct = function(action, data, target)
  SS_Shared_SAM("SS-PtDM", action, data, target);
end;

SS_PtP_IsOnline = function(target)
  SS_PtP_Direct('isOnline', '', target);
end;

SS_PtP_ImOnline = function(target)
  SS_PtP_Direct('iAmOnline', '', target);
end;