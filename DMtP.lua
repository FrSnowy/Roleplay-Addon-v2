SS_DMtP_Direct = function(action, data, target)
  SS_Shared_SAM("SS-DMtP", action, data, target);
end;

SS_DMtP_Every = function(action, data, except)
  if (not(except)) then
    except = {};
  end;

  return function(plotID)
    if (not(plotID)) then
      if (not(SS_User.settings.currentPlot)) then return nil; end;
      plotID = SS_User.settings.currentPlot;
    end;

    local leadingPlot = SS_User.leadingPlots[plotID];
    if (not(leadingPlot)) then return; end;

    local players = leadingPlot.players;
    if (not(players)) then return end;

    SS_Shared_ForEach(players)(function(player)
      local isPlayerIgnored = SS_Shared_Includes(except)(function(name)
        return name == player
      end);

      SS_Shared_IfOnline(player, function()
        if (not(isPlayerIgnored)) then
          SS_DMtP_Direct(action, data, player);
        end;
      end);
    end);
  end;
end;

SS_DMtP_InviteToPlot = function(playerName)
  if (not(playerName)) then
    playerName = UnitName('target');
  end;

  if (not(playerName)) then
    SS_Log_NoTarget();
    return;
  end;

  if (not(SS_User.settings.currentPlot)) then
    SS_Log_NoCurrentPlot();
    return;
  end;

  local plot = SS_LeadingPlots_Current();
  SS_Log_InviteSendedTo(playerName, plot.name);
  SS_DMtP_Direct('invite', SS_User.settings.currentPlot..'+'..plot.name, playerName);
end;

SS_DMtP_DeletePlot = function(plotID)
  if (not(plotID)) then return; end;
  SS_DMtP_Every('dmDeletePlot', plotID, { UnitName('player') })(plotID);
end;

SS_DMtP_KickFromPlot = function(player, plotID)
  if (not(plotID) or not(player)) then return; end;

  local leadingPlot = SS_User.leadingPlots[plotID];
  if (not(leadingPlot)) then return; end;

  SS_DMtP_Direct('dmKickFromPlot', plotID, player);
end;

SS_DMtP_StartEvent = function(plotID)
  if (not(plotID)) then
    if (not(SS_User.settings.currentPlot)) then return; end;
    plotID = SS_User.settings.currentPlot
  end;

  local plot = SS_User.leadingPlots[plotID];
  if (not(plot)) then return; end;

  SS_Log_EventStarting(plot.name);
  SS_DMtP_Every('dmStartEvent', plotID, { UnitName('player') })(plotID);
  PlaySound("LEVELUPSOUND", "SFX");
  SS_Draw_OnEventStarts();
end;

SS_DMtP_DisplayTargetInfo = function(player)
  if (not(SS_User) or not(SS_LeadingPlots_Current())) then return nil; end;

  if (not(player)) then
    player = UnitName("target");
  end;

  if (player == UnitName("player") or not(player)) then return nil; end;

  local isPlayerInCurrentPlot = SS_Shared_Includes(SS_LeadingPlots_Current().players)(function(playerInPlot)
    return playerInPlot == player
  end);

  if (not(isPlayerInCurrentPlot)) then return nil; end;

  SS_Shared_IfOnline(player, function()
    SS_DMtP_Direct('dmGetTargetInfo', SS_User.settings.currentPlot, player);
  end)
end;

SS_DMtP_StopEvent = function(plotID)
  if (not(plotID)) then
    if (not(SS_User.settings.currentPlot)) then return; end;
    plotID = SS_User.settings.currentPlot
  end;

  local plot = SS_User.leadingPlots[plotID];
  if (not(plot)) then return; end;

  plot.isEventOngoing = false;
  SS_Log_EventEnd(plot.name);

  SS_DMtP_Every('dmStopEvent', plotID, { UnitName('player') })(plotID);
  SS_Draw_OnEventStop();
end;

SS_DMtP_DisplayInspectInfo = function(player)
  if (not(SS_User) or not(SS_LeadingPlots_Current())) then return nil; end;

  if(not(player)) then
    player = UnitName("target");
  end;

  if (player == UnitName("player") or not(player)) then return nil; end;

  local isPlayerInCurrentPlot = SS_Shared_Includes(SS_LeadingPlots_Current().players)(function(playerInPlot)
    return playerInPlot == player
  end);

  if (not(isPlayerInCurrentPlot)) then return nil; end;

  SS_Shared_IfOnline(player, function()
    SS_DMtP_Direct('dmGetInspectInfo', SS_User.settings.currentPlot, player);
    SS_DMtP_Direct('dmGetInspectStats', SS_User.settings.currentPlot, player);
    SS_DMtP_Direct('dmGetInspectSkills', SS_User.settings.currentPlot, player);
  end)
end;

SS_DMtP_AddModifier = function(modifierType, modifierID)
  if (not(SS_User.settings.currentPlot)) then return nil; end;
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(modifierType) or not(modifierID)) then
    SS_Log_NoModifier();
    return;
  end;

  local modifier = SS_LeadingPlots_Current().modifiers[modifierType][modifierID];
  if (not(modifier)) then return; end;

  local statsAsStr = '';
  for i = 1, #modifier.stats do
    statsAsStr = statsAsStr..modifier.stats[i]..'}';
  end;
  statsAsStr = statsAsStr:sub(1, #statsAsStr - 1);

  local action = nil;
  if (modifierType == 'stats') then
    action = 'addStatModifier'
  else
    action = 'addSkillModifier'
  end;

  local data =  modifierID..'+'..modifier.name..'+'..statsAsStr..'+'..modifier.value..'+'..modifier.count;

  if (SS_ModifierCreate_TMPData.target == 'player') then
    if (not(UnitName("target"))) then
      SS_Log_NoTarget();
      return nil;
    end;

    SS_DMtP_Direct(action, data, UnitName('target'));
    SS_Log_ModifierAddToPlayer(modifier.name, modifier.stats, modifier.value, modifier.count, UnitName('target'));
  end;

  if (SS_ModifierCreate_TMPData.target == 'group') then
    SS_DMtP_Every(action, data)(SS_User.settings.currentPlot);
    SS_Log_ModifierAddToGroup(modifier.name, modifier.stats, modifier.value, modifier.count);
  end;
end;

SS_DMtP_RemoveInspectPlayerModifier = function(modifierType, modifierID)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(SS_Target_TMPData) or not(SS_Target_TMPData.name)) then return nil; end;
  return SS_DMtP_RemoveTargetModifier(modifierType, modifierID, SS_Target_TMPData.name);
end;

SS_DMtP_RemoveTargetModifier = function(modifierType, modifierID, player)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(modifierType) or not(modifierID)) then return nil; end;

  if (not(player)) then
    player = UnitName('target');
  end;

  if (not(player)) then
    SS_Log_NoTarget();
    return false;
  end;

  local dataStr = SS_User.settings.currentPlot..'+'..modifierType..'+'..modifierID;
  SS_DMtP_Direct('dmRemoveTargetModifier', dataStr, player);
end;


SS_DMtP_RemoveModifier = function(modifierType, modifierID)
  if (not(SS_User.settings.currentPlot)) then return nil; end;
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(modifierType) or not(modifierID)) then
    SS_Log_NoModifier();
    return;
  end;

  local modifier = SS_LeadingPlots_Current().modifiers[modifierType][modifierID];
  if (not(modifier)) then return; end;

  local action = 'dmRemoveTargetModifier';
  local dataStr = SS_User.settings.currentPlot..'+'..modifierType..'+'..modifierID;

  if (SS_ModifierCreate_TMPData.target == 'player') then
    if (not(UnitName("target"))) then
      SS_Log_NoTarget();
      return nil;
    end;

    SS_DMtP_Direct(action, dataStr, UnitName('target'));
    SS_Log_ModifierRemovedFromPlayer(modifier.name, modifier.stats, modifier.value, UnitName('target'))
  end;

  if (SS_ModifierCreate_TMPData.target == 'group') then
    SS_DMtP_Every(action, dataStr)(SS_User.settings.currentPlot);
    SS_Log_ModifierRemovedFromGroup(modifier.name, modifier.stats, modifier.value);
  end;
end;

SS_DMtP_ForceRollInspectTargetSkill = function(skillName, visibility)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(SS_Target_TMPData) or not(SS_Target_TMPData.name)) then return nil; end;

  return SS_DMtP_ForceRollSkill(skillName, visibility, SS_Target_TMPData.name);
end;

SS_DMtP_ForceRollDiceControllSkill = function(skillName)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(SS_DiceControll_Data)) then return nil; end;

  local visibility = 'true';
  if (not(SS_DiceControll_Data.isVisible)) then visibility = 'false'; end;

  if (SS_DiceControll_Data.target == 'player') then
    if (not(UnitName("target"))) then
      SS_Log_NoTarget();
      return nil;
    end;

    return SS_DMtP_ForceRollSkill(skillName, visibility, UnitName("target"));
  end;

  if (SS_DiceControll_Data.target == 'group') then
    return SS_Shared_ForEach(SS_LeadingPlots_Current().players)(function(player)
      if (player == UnitName("player")) then return nil; end;

      return SS_Shared_IfOnline(player, function()
        return SS_DMtP_ForceRollSkill(skillName, visibility, player);
      end);
    end);
  end;
end;

SS_DMtP_ForceRollSkill = function(skillName, visibility, player)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(skillName)) then return nil; end;

  if (not(player)) then
    player = UnitName('target');
  end;

  if (not(player)) then
    SS_Log_NoTarget();
    return false;
  end;
  
  local dataStr = SS_User.settings.currentPlot..'+'..visibility.."+"..skillName;
  SS_DMtP_Direct('dmForceRollSkill', dataStr, player);
end;