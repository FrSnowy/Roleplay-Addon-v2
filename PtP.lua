SS_PtP_Direct = function(action, data, target)
	SendAddonMessage("SS-PtP", action.."|"..data, "WHISPER", target);
end;

SS_PtP_IsOnline = function(target)
  SS_PtP_Direct('isOnline', '', target);
end;

SS_PtP_ImOnline = function(target)
  SS_PtP_Direct('iAmOnline', '', target);
end;