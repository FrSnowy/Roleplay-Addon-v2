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
          NPCPanel:SetSize(245, 23);
          NPCPanel:SetPoint("TOPLEFT", SS_NPCControll_Menu_Scroll_Content, "TOPLEFT", 0, -50 * (counter - 1));
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
        NPCRollPanel:SetScript("OnDragStart", self.StartMoving)
        NPCRollPanel:SetScript("OnDragStop", self.StopMovingOrSizing)

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

  local weakRollButton = CreateFrame("Button", nil, NPCRollPanel, "UIPanelButtonTemplate");
        weakRollButton:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 20, -70);
        weakRollButton:SetSize(95, 24);
        weakRollButton:SetText("Слабый");
        weakRollButton:RegisterForClicks("AnyUp");

  local weakRollDesc = NPCRollPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        weakRollDesc:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 120, -75);
        weakRollDesc:SetText(rollAsString.weak);
        weakRollDesc:SetFont("Fonts\\FRIZQT__.TTF", 11);

  local normalRollButton = CreateFrame("Button", nil, NPCRollPanel, "UIPanelButtonTemplate");
        normalRollButton:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 20, -100);
        normalRollButton:SetSize(95, 24);
        normalRollButton:SetText("Нормальный");
        normalRollButton:RegisterForClicks("AnyUp");

  local normalRollDesc = NPCRollPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        normalRollDesc:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 120, -106);
        normalRollDesc:SetText(rollAsString.normal);
        normalRollDesc:SetFont("Fonts\\FRIZQT__.TTF", 11);

  local strongRollButton = CreateFrame("Button", nil, NPCRollPanel, "UIPanelButtonTemplate");
        strongRollButton:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 20, -130);
        strongRollButton:SetSize(95, 24);
        strongRollButton:SetText("Сильный");
        strongRollButton:RegisterForClicks("AnyUp");

  local strongRollDesc = NPCRollPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        strongRollDesc:SetPoint("TOPLEFT", NPCRollPanel, "TOPLEFT", 120, -137);
        strongRollDesc:SetText(rollAsString.strong);
        strongRollDesc:SetFont("Fonts\\FRIZQT__.TTF", 11);
        --weakRollButton:SetScript("OnClick", parameters.clickHandler);
end;

SS_NPCControll_Clear = function()
  SS_LeadingPlots_Current().npc = {};
  SS_NPCControll_Menu_Empty:Hide();
  SS_NPCControll_DrawList();
  SS_NPCControll_Menu_Empty:Show();
end;

SS_NPCCreate_Show = function()
  SS_NPCCreate_Menu.name:SetText('');
  SS_NPCCreate_Menu.level:SetText('');

  SS_NPCCreate_Menu:Show();
end;

SS_NPCCreate_Create = function()
  local name = SS_NPCCreate_Menu.name:GetText();
  local level = SS_NPCCreate_Menu.level:GetText('');

  if (name == '' or level == '') then
    SS_Log_NoValue();
    return;
  end;

  if (not(SS_Shared_IsNumber(level))) then
    SS_Log_ValueMustBeNum();
    return;
  end;

  level = SS_Shared_NumFromStr(level);
  if (level < 1 or level > 20) then
    SS_Log_ValueIsNotLevel();
    return;
  end;

  local id = random(1, 99999999)..'-'..random(1, 99999999);

  SS_LeadingPlots_Current().npc[id] = {
    name = name,
    level = level,
  };

  SS_NPCCreate_Menu:Hide();
  SS_NPCControll_Menu_Create_Button:SetText("+ Создать");

  SS_NPCControll_Menu_Scroll_Content:Hide();
  SS_NPCControll_DrawList();
  SS_NPCControll_Menu_Scroll_Content:Show();
end;