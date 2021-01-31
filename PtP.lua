SS_PtP_Direct = function(action, data, target)
  SS_Shared_SAM("SS-PtDM", action, data, target);
end;

SS_PtP_IsOnline = function(target, timestamp)
  SS_PtP_Direct('isOnline', timestamp, target);
end;

SS_PtP_ImOnline = function(target, timestamp)
  SS_PtP_Direct('iAmOnline', timestamp, target);
end;