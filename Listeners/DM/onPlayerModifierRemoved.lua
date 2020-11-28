SS_Listeners_DM_OnPlayerModifierRemoved = function(data, player)
  -- У: Мастер, от: Игрок, когда: мастер успешно дропнул модификатор игрока
  local modifierType, modifierID = strsplit('+', data);
  if (not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  local modifier = SS_Target_TMPData.modifiers[modifierType][modifierID];
  SS_Log_ModifierRemovedSuccessfully(modifier.name, player);
  SS_DMtP_DisplayInspectInfo(SS_Target_TMPData.name);
end;