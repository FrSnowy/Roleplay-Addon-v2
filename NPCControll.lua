SS_NPCDicesViews = {};

SS_NPCControll_Show = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_NPCControll_DrawList();
  SS_NPCControll_Menu:Show();
  SS_Event_Controll_NPCControll_Button:SetText("- NPC");
end;

SS_NPCControll_Hide = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_NPCControll_Menu:Hide();
  SS_NPCCreate_Menu:Hide();
  SS_NPCControll_Menu_Create_Button:SetText("+ Создать");
  SS_Event_Controll_NPCControll_Button:SetText("+ NPC");
end;

SS_NPCControll_DrawList = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_Shared_ForEach({ SS_NPCControll_Menu_Scroll_Content:GetChildren() })(function(child)
    child:Hide();
  end);

  local counter = 0;

  SS_Shared_ForEach(SS_LeadingPlots_Current().npc)(function(npc, id)
    counter = counter + 1;
    local NPCPanel = CreateFrame("Frame", nil, SS_NPCControll_Menu_Scroll_Content, "SS_NPCElement_Template");
          NPCPanel:SetSize(245, 24);
          NPCPanel:SetPoint("TOPLEFT", SS_NPCControll_Menu_Scroll_Content, "TOPLEFT", 0, -60 * (counter - 1));
          NPCPanel.npcID = id;
  end);

  if (counter > 0) then
    SS_NPCControll_Menu_Empty:Hide();
  else
    SS_NPCControll_Menu_Empty:Show();
  end;
end;

SS_NPCControll_DrawNPCDiceMenu = function(npcID)
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().npc[npcID])) then return nil; end;

  local npc = SS_LeadingPlots_Current().npc[npcID];

  local NPCRollPanel = CreateFrame("Frame", nil, UIParent, "SS_CloseableFrameWithoutBG_Template");
        NPCRollPanel:SetMovable(true);
        NPCRollPanel:EnableMouse(true)
        NPCRollPanel:RegisterForDrag("LeftButton")
        NPCRollPanel:SetSize(280, 180);
        NPCRollPanel:SetPoint("CENTER", UIParent);
        NPCRollPanel:SetToplevel(true);
        NPCRollPanel:SetBackdropColor(0, 0, 0, 1);
        NPCRollPanel:SetFrameStrata("FULLSCREEN_DIALOG");
        NPCRollPanel.title:SetText('Броски от лица NPC');
        NPCRollPanel:SetScript("OnDragStart", NPCRollPanel.StartMoving)
        NPCRollPanel:SetScript("OnDragStop", NPCRollPanel.StopMovingOrSizing)

  NPCRollPanel.closeBtn:SetScript("OnClick", function()
    SS_NPCDicesViews[npcID]:Hide();
    SS_NPCDicesViews[npcID] = nil;
  end);

  local npcName = NPCRollPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        npcName:SetPoint("TOP", NPCRollPanel, "TOP", 0, -40);
        npcName:SetText(npc.name..', ур. '..npc.level);
        npcName:SetTextColor(0.82, 0.71, 0);
        npcName:SetFont("Fonts\\FRIZQT__.TTF", 12);

  local diceCount = SS_Roll_GetDicesCount(npc.level);

  local skillDices = {
    weak = {
      minimum = SS_Roll_GetMinimum('', {
        level = npc.level,
        skill = 0,
      }),
      maximum = SS_Roll_GetMaximum('', {
        level = npc.level,
        skill = 0,
      }),
      statModifier = math.floor(SS_Stats_GetModifierFor('', 0)),
    },
    normal = {
      minimum = SS_Roll_GetMinimum('', {
        level = npc.level,
        skill = SS_Skills_GetMaxPointsInSingle(npc.level) / 2,
      }),
      maximum = SS_Roll_GetMaximum('', {
        level = npc.level,
        skill = SS_Skills_GetMaxPointsInSingle(npc.level) / 2,
      }),
      statModifier = math.floor(SS_Stats_GetModifierFor('', SS_Stats_GetMaxPointsInSingle(npc.level)) / 2),
    },
    strong = {
      minimum = SS_Roll_GetMinimum('', {
        level = npc.level,
        skill = SS_Skills_GetMaxPointsInSingle(npc.level),
      }),
      maximum = SS_Roll_GetMaximum('', {
        level = npc.level,
        skill = SS_Skills_GetMaxPointsInSingle(npc.level),
      }),
      statModifier = math.floor(SS_Stats_GetModifierFor('', SS_Stats_GetMaxPointsInSingle(npc.level))),
    }
  }

  local rollAsString = {
    weak = diceCount..'d'..skillDices.weak.minimum..'-'..skillDices.weak.maximum..'+'..skillDices.weak.statModifier,
    normal = diceCount..'d'..skillDices.normal.minimum..'-'..skillDices.normal.maximum..'+'..skillDices.normal.statModifier,
    strong = diceCount..'d'..skillDices.strong.minimum..'-'..skillDices.strong.maximum..'+'..skillDices.strong.statModifier,
  };

  local expectation = NPCRollPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        expectation:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 170, -70);
        expectation:SetText('Ожидание:');
        expectation:SetFont("Fonts\\FRIZQT__.TTF", 12);

  local expectationInput = CreateFrame("EditBox", "input", NPCRollPanel, "SS_Form_EditBox");
        expectationInput:SetScript("OnEscapePressed", function() expectationInput:ClearFocus(); end);
        expectationInput:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 170, -88)
        expectationInput:SetFont("Fonts\\FRIZQT__.TTF", 11)
        expectationInput:SetSize(80, 24);
        expectationInput:SetNumeric(true);
        expectationInput:SetMaxLetters(2);

  local weakRollButton = CreateFrame("Button", nil, NPCRollPanel, "UIPanelButtonTemplate");
        weakRollButton:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 20, -70);
        weakRollButton:SetSize(75, 24);
        weakRollButton:SetText("Слабый");
        weakRollButton:RegisterForClicks("AnyUp");
        weakRollButton:SetScript("OnClick", function()
          SS_Roll_AsNPC(npc.name, diceCount, skillDices.weak, expectationInput:GetText());
          expectationInput:SetText('');
        end);

  local weakRollDesc = NPCRollPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        weakRollDesc:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 100, -75);
        weakRollDesc:SetText(rollAsString.weak);
        weakRollDesc:SetFont("Fonts\\FRIZQT__.TTF", 10);

  local normalRollButton = CreateFrame("Button", nil, NPCRollPanel, "UIPanelButtonTemplate");
        normalRollButton:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 20, -100);
        normalRollButton:SetSize(75, 24);
        normalRollButton:SetText("Норма");
        normalRollButton:RegisterForClicks("AnyUp");
        normalRollButton:SetScript("OnClick", function()
          SS_Roll_AsNPC(npc.name, diceCount, skillDices.normal, expectationInput:GetText());
          expectationInput:SetText('');
        end);

  local normalRollDesc = NPCRollPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        normalRollDesc:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 100, -106);
        normalRollDesc:SetText(rollAsString.normal);
        normalRollDesc:SetFont("Fonts\\FRIZQT__.TTF", 10);

  local strongRollButton = CreateFrame("Button", nil, NPCRollPanel, "UIPanelButtonTemplate");
        strongRollButton:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 20, -130);
        strongRollButton:SetSize(75, 24);
        strongRollButton:SetText("Сильный");
        strongRollButton:RegisterForClicks("AnyUp");
        strongRollButton:SetScript("OnClick", function()
          SS_Roll_AsNPC(npc.name, diceCount, skillDices.strong, expectationInput:GetText());
          expectationInput:SetText('');
        end);

  local strongRollDesc = NPCRollPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        strongRollDesc:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 100, -137);
        strongRollDesc:SetText(rollAsString.strong);
        strongRollDesc:SetFont("Fonts\\FRIZQT__.TTF", 10);

  SS_NPCDicesViews[npcID] = NPCRollPanel;
end;

SS_NPCControll_Remove = function(npcID)
  if (SS_LeadingPlots_Current().npcConnections) then
    SS_Shared_ForEach(SS_LeadingPlots_Current().npcConnections)(function(info, guid)
      if (info.id == npcID) then
        SS_LeadingPlots_Current().npcConnections[guid] = nil;

        if (SS_Shared_TargetIsNPC()) then
          local targetGUID = SS_NPCControll_GetGUID();
          if (guid == targetGUID) then
            SS_Draw_HidePlayerInfoPlates();
          end;
        end;
      end;
    end);
  end;

  SS_LeadingPlots_Current().npc[npcID] = nil;
  SS_NPCControll_Menu_Scroll_Content:Hide();
  SS_NPCControll_DrawList();
  SS_NPCControll_Menu_Scroll_Content:Show();
end;

SS_NPCControll_Clear = function()
  SS_LeadingPlots_Current().npc = {};
  SS_LeadingPlots_Current().npcConnections = {};
  
  if (SS_Shared_TargetIsNPC()) then
    SS_Draw_HidePlayerInfoPlates();
  end;

  SS_NPCControll_Menu_Empty:Hide();
  SS_NPCControll_DrawList();
  SS_NPCControll_Menu_Empty:Show();
end;

SS_NPCControll_GetGUID = function()
  if (not(SS_LeadingPlots_Current())) then return nil end;
  if (UnitName('target') == nil) then SS_Log_NoTarget(); return nil; end;
  if (UnitIsPlayer('target')) then SS_Log_TargetIsNotCreature(); return nil end;
  local guid = UnitGUID("target");

  return guid;
end;

SS_NPCControll_ShowDicesMenu = function(npcID)
  if (not(SS_NPCDicesViews[npcID])) then
    SS_NPCControll_DrawNPCDiceMenu(npcID);
  else
    SS_NPCDicesViews[npcID]:Hide();
    SS_NPCDicesViews[npcID] = nil;
  end;
end;

SS_NPCControll_ShowTargetDicesMenu = function(npcID)
  if (not(SS_Shared_TargetIsConnectedNPC())) then return nil; end;

  local guid = SS_NPCControll_GetGUID();
  local npcInfo = SS_LeadingPlots_Current().npcConnections[guid];
  SS_NPCControll_ShowDicesMenu(npcInfo.id);
end;

SS_NPCControll_ConnectWithTarget = function(npcID)
  if (not(SS_LeadingPlots_Current())) then return nil end;
  local npc = SS_LeadingPlots_Current().npc[npcID];
  if (not(npc)) then return nil; end;

  local guid = SS_NPCControll_GetGUID();
  if (not(guid)) then return nil; end;

  if (not(SS_LeadingPlots_Current().npcConnections)) then
    SS_LeadingPlots_Current().npcConnections = {};
  end;

  SS_LeadingPlots_Current().npcConnections[guid] = {
    id = npcID,
    level = npc.level,
    health = npc.health,
    barrier = npc.barrier,
  };

  SS_Draw_NPCInfoPlates();
end;

SS_NPCControll_DisconnectFromTarget = function(npcID)
  if (not(SS_LeadingPlots_Current())) then return nil end;
  if (not(SS_LeadingPlots_Current().npcConnections)) then return nil; end;

  local guid = SS_NPCControll_GetGUID();
  if (not(guid)) then return nil; end;
  if (not(SS_LeadingPlots_Current().npcConnections[guid])) then return nil; end;

  SS_LeadingPlots_Current().npcConnections[guid] = nil;
  SS_Draw_HidePlayerInfoPlates();
end;

SS_NPCCreate_Show = function()
  SS_NPCCreate_Menu.name:SetText('');
  SS_NPCCreate_Menu.level:SetText('');

  SS_NPCCreate_Menu:Show();
end;

SS_NPCCreate_SetHealthByLevelInput = function()
  local level = SS_NPCCreate_Menu.level:GetText();
  if (level == '') then 
    SS_NPCCreate_Menu.health:SetText('');
    SS_NPCCreate_Menu.armor:SetText('');
    return nil;
  end;
  if (not(SS_Shared_IsNumber(level))) then
    SS_NPCCreate_Menu.health:SetText('');
    SS_NPCCreate_Menu.armor:SetText('');
    return nil;
  end;
  level = SS_Shared_NumFromStr(level);

  if (level < 1 or level > 20) then
    SS_NPCCreate_Menu.health:SetText('');
    SS_NPCCreate_Menu.armor:SetText('');
    return nil;
  end;

  local averageStatsByLevel = { 3, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 16, 17, 18, 20, 21, 21, 22, 24 };
  local healthPoints = 2 + math.floor(averageStatsByLevel[level] / 3);
  if (healthPoints < 1) then healthPoints = 1 end;

  SS_NPCCreate_Menu.health:SetText(healthPoints);
  SS_NPCCreate_Menu.armor:SetText(math.floor(healthPoints / 2));
end;

SS_NPCCreate_Create = function()
  local name = SS_NPCCreate_Menu.name:GetText();
  local level = SS_NPCCreate_Menu.level:GetText();
  local health = SS_NPCCreate_Menu.health:GetText();
  local armor = SS_NPCCreate_Menu.armor:GetText();

  if (name == '' or level == '') then
    SS_Log_NoValue();
    return;
  end;

  if (not(SS_Shared_IsNumber(level))) then
    SS_Log_ValueMustBeNum();
    return;
  end;

  if (not(SS_Shared_IsNumber(health))) then
    SS_Log_ValueMustBeNum();
    return;
  end;

  if (not(SS_Shared_IsNumber(armor))) then
    SS_Log_ValueMustBeNum();
    return;
  end;

  level = SS_Shared_NumFromStr(level);
  health = SS_Shared_NumFromStr(health);
  armor = SS_Shared_NumFromStr(armor);

  if (level < 1 or level > 20) then
    SS_Log_ValueIsNotLevel();
    return;
  end;

  local id = random(1, 99999999)..'-'..random(1, 99999999);

  SS_LeadingPlots_Current().npc[id] = {
    name = name,
    level = level,
    health = health,
    barrier = armor,
  };

  SS_NPCCreate_Menu:Hide();
  SS_NPCControll_Menu_Create_Button:SetText("+ Создать");

  SS_NPCControll_Menu_Scroll_Content:Hide();
  SS_NPCControll_DrawList();
  SS_NPCControll_Menu_Scroll_Content:Show();
end;