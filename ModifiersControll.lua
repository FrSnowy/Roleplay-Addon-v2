SS_ModifierControll_Show = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_ModifiersControll_Menu:Show();
  SS_Event_Controll_ModifiersControll_Button:SetText("- Модифик.");

  SS_ModifierCreate_TMPData = {
    modifierType = nil,
    stats = {},
    selectedID = nil,
    selectedModifier = nil,
    selectedModifierType = nil,
    target = 'player'
  };
  SS_ModifierCreate_DrawList()
end;

SS_ModifierControll_Hide = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_ModifiersControll_Menu:Hide();
  SS_ModifiersCreate_Menu:Hide();
  SS_ModifiersControll_Menu_Create_Button:SetText("+ Создать");
  SS_Event_Controll_ModifiersControll_Button:SetText("+ Модифик.");
end;

SS_ModifierControll_SelectModifier = function(id, modifierType)
  if (SS_LeadingPlots_Current().modifiers.stats) then
    SS_Shared_ForEach(SS_LeadingPlots_Current().modifiers.stats)(function(modifier, id)
      SS_ModifiersControll_Menu_Scroll_Content['stats-'..id]:SetChecked(false);
    end);
  end;

  if (SS_LeadingPlots_Current().modifiers.skills) then
    SS_Shared_ForEach(SS_LeadingPlots_Current().modifiers.skills)(function(modifier, id)
      SS_ModifiersControll_Menu_Scroll_Content['skills-'..id]:SetChecked(false);
    end);
  end;

  SS_ModifiersControll_Menu_Scroll_Content[modifierType..'-'..id]:SetChecked(true);
  SS_ModifierCreate_TMPData.selectedID = id;
  SS_ModifierCreate_TMPData.selectedModifier = SS_LeadingPlots_Current().modifiers[modifierType][id];
  SS_ModifierCreate_TMPData.selectedModifierType = modifierType
end;

SS_ModifierControll_Unselect = function(id, modifierType)
  if (not(id) or not(modifierType)) then return nil; end;
  if (not(SS_ModifierCreate_TMPData.selectedID == id)) then return nil end;
  if (not(SS_ModifierCreate_TMPData.selectedModifierType == modifierType)) then return nil; end;

  SS_ModifierCreate_TMPData.selectedID = nil
  SS_ModifierCreate_TMPData.selectedModifier = nil;
  SS_ModifierCreate_TMPData.selectedModifierType = nil;
end;

SS_ModifierControll_SelectTarget = function(target)
  SS_ModifierCreate_TMPData.target = target;
  SS_ModifiersControll_Menu_Check_Target_Player:SetChecked(false);
  SS_ModifiersControll_Menu_Check_Target_Group:SetChecked(false);

  if (target == 'player') then
    SS_ModifiersControll_Menu_Check_Target_Player:SetChecked(true);
  elseif (target == 'group') then
    SS_ModifiersControll_Menu_Check_Target_Group:SetChecked(true);
  end;
end;

SS_ModifierCreate_Show = function()
  SS_ModifiersCreate_Menu.id:SetText('');
  SS_ModifiersCreate_Menu.name:SetText('');
  SS_ModifiersCreate_Menu.value:SetText('');
  SS_ModifiersCreate_Menu.count:SetText('');

  SS_Shared_ForEach(SS_Stats_GetList())(function(_, stat)
    SS_ModifiersCreate_Menu_Scroll_Content[stat].check:SetChecked(false);
  end);

  SS_ModifiersCreate_Menu:Show();
end;

SS_ModifierCreate_Select = function(stat)
  if (not(stat)) then return nil; end;

  local statType = nil;

  if (SS_Skills_IsSkill(stat)) then
    statType = 'skills';
  elseif (SS_Stats_IsStat(stat)) then
    statType = 'stats';
  end;

  if (not(statType)) then return nil end;

  local isAnyStatSaved = SS_Shared_Includes(SS_ModifierCreate_TMPData.stats)(function(stat)
    return SS_Stats_IsStat(stat)
  end);

  local isAnySkillSaved = SS_Shared_Includes(SS_ModifierCreate_TMPData.stats)(function(stat)
    return SS_Skills_IsSkill(stat)
  end);

  if (statType == 'skills' and isAnyStatSaved) then
    SS_ModifierCreate_TMPData.stats = {};
    SS_Shared_ForEach(SS_Stats_GetList())(function(_, stat)
      SS_ModifiersCreate_Menu_Scroll_Content[stat].check:SetChecked(false);
    end);
  elseif (statType == 'stats' and isAnySkillSaved) then
    SS_ModifierCreate_TMPData.stats = {};
    SS_Shared_ForEach(SS_Skills_GetList())(function(_, skill)
      SS_ModifiersCreate_Menu_Scroll_Content[skill].check:SetChecked(false);
    end);
  end;

  SS_ModifierCreate_TMPData.modifierType = statType;
  table.insert(SS_ModifierCreate_TMPData.stats, stat);
end;

SS_ModifierCreate_Unselect = function(stat)
  if (not(stat)) then return nil; end;

  SS_Shared_RemoveFrom(SS_ModifierCreate_TMPData.stats)(function(savedStat)
    return savedStat == stat
  end);

  if (#SS_ModifierCreate_TMPData.stats == 0) then
    SS_ModifierCreate_TMPData.modifierType = nil;
  end;
end;

SS_ModifierCreate_Create = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  local id = SS_ModifiersCreate_Menu.id:GetText();
  local name = SS_ModifiersCreate_Menu.name:GetText();
  local value = SS_ModifiersCreate_Menu.value:GetText();
  local count = SS_ModifiersCreate_Menu.count:GetText();

  if (not(SS_Shared_IsNumber(value))) then
    SS_Log_ValueMustBeNum();
    return nil;
  end;

  if (id == '') then SS_Log_NoID(); return nil; end;
  if (name == '') then SS_Log_NoName(); return nil; end;
  if (value == '') then SS_Log_NoValue(); return nil; end;
  if (count == '') then SS_Log_NoCount(); return nil; end;
  if (#SS_ModifierCreate_TMPData.stats == 0) then SS_Log_NoStats(); return nil; end;

  if (not(SS_LeadingPlots_Current().modifiers[SS_ModifierCreate_TMPData.modifierType])) then
    SS_LeadingPlots_Current().modifiers[SS_ModifierCreate_TMPData.modifierType] = {};
  end;

  SS_LeadingPlots_Current().modifiers[SS_ModifierCreate_TMPData.modifierType][id] = {
    name = name,
    stats = SS_ModifierCreate_TMPData.stats,
    value = value,
    count = count,
  };

  SS_ModifierCreate_DrawList();
  SS_ModifiersCreate_Menu:Hide();

  SS_ModifierCreate_TMPData = {
    modifierType = nil,
    target = SS_ModifierCreate_TMPData.target or 'player',
    stats = {},
  };

  SS_Shared_ForEach(SS_Stats_GetList())(function(_, stat)
    SS_ModifiersCreate_Menu_Scroll_Content[stat].check:SetChecked(false);
  end);
  SS_Shared_ForEach(SS_Skills_GetList())(function(_, skill)
    SS_ModifiersCreate_Menu_Scroll_Content[skill].check:SetChecked(false);
  end);

  SS_ModifiersCreate_Menu.id:SetText('');
  SS_ModifiersCreate_Menu.name:SetText('');
  SS_ModifiersCreate_Menu.value:SetText('');
  SS_ModifiersCreate_Menu.count:SetText('');

  SS_ModifiersControll_Menu_Create_Button:SetText("+ Создать");
end;

SS_Modifiers_RemoveStatsModifier = function(id)
  SS_ModifiersControll_Menu_Scroll_Content:Hide();
  SS_ModifierControll_Unselect(id, 'stats');
  SS_DMtP_RemoveModifier('stats', id, 'group');
  SS_LeadingPlots_Current().modifiers.stats[id] = nil;
  SS_ModifiersControll_Menu_Scroll_Content:Show();
  SS_ModifierCreate_DrawList();
end;

SS_Modifiers_RemoveSkillModifier = function(id)
  SS_ModifiersControll_Menu_Scroll_Content:Hide();
  SS_ModifierControll_Unselect(id, 'skills');
  SS_DMtP_RemoveModifier('skills', id, 'group');
  SS_LeadingPlots_Current().modifiers.skills[id] = nil;
  SS_ModifiersControll_Menu_Scroll_Content:Show();
  SS_ModifierCreate_DrawList();
end;

SS_ModifierCreate_Clear = function()
  SS_Shared_ForEach(SS_LeadingPlots_Current().modifiers.stats)(function(modifier, id)
    SS_Modifiers_RemoveStatsModifier(id);
  end);

  SS_Shared_ForEach(SS_LeadingPlots_Current().modifiers.skills)(function(modifier, id)
    SS_Modifiers_RemoveSkillModifier(id);
  end);
  SS_ModifierCreate_DrawList();
end;

SS_ModifierCreate_DrawList = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().modifiers)) then return nil; end;
  SS_Shared_ForEach({ SS_ModifiersControll_Menu_Scroll_Content:GetChildren() })(function(child)
    child:Hide();
  end);

  local counter = 0;

  if (SS_LeadingPlots_Current().modifiers.stats) then
    SS_Shared_ForEach(SS_LeadingPlots_Current().modifiers.stats)(function(modifier, id)
      local ModifierPanel = CreateFrame("Frame", nil, SS_ModifiersControll_Menu_Scroll_Content, "SS_TargetModifier_Template");
            ModifierPanel:SetSize(180, 23);
            ModifierPanel:SetPoint("TOPLEFT", SS_ModifiersControll_Menu_Scroll_Content, "TOPLEFT", 20, -50 * counter);
            ModifierPanel.modifier = modifier;
            ModifierPanel.modifierID = id;

      ModifierPanel.removeBtn:SetScript('OnClick', function()
        SS_Modifiers_RemoveStatsModifier(id)
      end);

      SS_ModifiersControll_Menu_Scroll_Content['stats-'..id] = CreateFrame("CheckButton", nil, SS_ModifiersControll_Menu_Scroll_Content, "OptionsCheckButtonTemplate");
      SS_ModifiersControll_Menu_Scroll_Content['stats-'..id]:SetSize(20, 20);
      SS_ModifiersControll_Menu_Scroll_Content['stats-'..id]:SetPoint("TOPLEFT", SS_ModifiersControll_Menu_Scroll_Content, "TOPLEFT", 0, -50 * counter + 3);

      SS_ModifiersControll_Menu_Scroll_Content['stats-'..id]:SetScript("OnClick", function()
        SS_ModifierControll_SelectModifier(id, 'stats');
      end);
    
      ModifierPanel:Hide();
      ModifierPanel:Show();

      counter = counter + 1;
    end);
  end;

  if (SS_LeadingPlots_Current().modifiers.skills) then
    SS_Shared_ForEach(SS_LeadingPlots_Current().modifiers.skills)(function(modifier, id)
      local ModifierPanel = CreateFrame("Frame", nil, SS_ModifiersControll_Menu_Scroll_Content, "SS_TargetModifier_Template");
            ModifierPanel:SetSize(140, 23);
            ModifierPanel:SetPoint("TOPLEFT", SS_ModifiersControll_Menu_Scroll_Content, "TOPLEFT", 20, -50 * counter);
            ModifierPanel.modifier = modifier;
            ModifierPanel.modifierID = id;

      ModifierPanel.removeBtn:SetScript('OnClick', function()
        SS_Modifiers_RemoveSkillModifier(id);
      end);

      SS_ModifiersControll_Menu_Scroll_Content['skills-'..id] = CreateFrame("CheckButton", nil, SS_ModifiersControll_Menu_Scroll_Content, "OptionsCheckButtonTemplate");
      SS_ModifiersControll_Menu_Scroll_Content['skills-'..id]:SetSize(20, 20);
      SS_ModifiersControll_Menu_Scroll_Content['skills-'..id]:SetPoint("TOPLEFT", SS_ModifiersControll_Menu_Scroll_Content, "TOPLEFT", 0, -50 * counter + 2);

      SS_ModifiersControll_Menu_Scroll_Content['skills-'..id]:SetScript("OnClick", function()
        SS_ModifierControll_SelectModifier(id, 'skills');
      end);

      ModifierPanel:Hide();
      ModifierPanel:Show();

      counter = counter + 1;
    end);
  end;

  if (counter > 0) then
    SS_ModifiersControll_Menu_Empty:Hide();
  end;

  if (counter == 0) then
    SS_ModifiersControll_Menu_Empty:Show();
  end;
end;