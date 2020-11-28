SS_Listeners_Player_OnDMRemoveTargetModifier = function(data, master)
  -- У: Игрок, от: Мастер, когда: мастер удаляет модификатор через меню осмотра
  local plotID, modifierType, modifierID = strsplit('+', data);
  if (not(plotID) or not(modifierType) or not(modifierID)) then return false; end;

  if (not(SS_User.settings.currentPlot == plotID)) then return false; end;
  if (not(SS_Plots_Current().author == master)) then return false; end;

  local modifier = SS_Plots_Current().modifiers[modifierType][modifierID];
  if (not(modifier)) then
    SS_PtDM_ModifierRemoved({
      modifierID = modifierID,
      modifierType = modifierType,
    }, master);

    return false;
  end;

  local stat = modifier.stat;
  SS_Log_ModifierRemovedByDM(modifier.name, modifier.value);
  SS_Modifiers_Remove(modifierType)(modifierID);

  SS_PtDM_ModifierRemoved({
    modifierID = modifierID,
    modifierType = modifierType,
  }, master);
end;