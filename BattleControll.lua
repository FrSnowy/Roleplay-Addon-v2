SS_BattleControll_Show = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  if (not(SS_LeadingPlots_Current().battle) or not(SS_LeadingPlots_Current().battle.started)) then
    SS_BattleControll:Show();
    SS_BattleControll_Start:Show();
    SS_Event_Controll_Battle_Button:SetText("- Сражение");

    if (not(SS_LeadingPlots_Current().battle)) then
      SS_LeadingPlots_Current().battle = {
        started = false,
        battleType = 'phases',
        startFrom = 'active',
        authorFights = false,
      };
    end;

    SS_BattleControll_SelectBattleType(SS_LeadingPlots_Current().battle.battleType);
    SS_BattleControll_SelectStartFrom(SS_LeadingPlots_Current().battle.startFrom);
    SS_BattleControll_SelectAuthorFights(SS_LeadingPlots_Current().battle.authorFights);
  end;
end;

SS_BattleControll_ShowDMBattleMenuAfterRelog = function()
  if (SS_LeadingPlots_Current().battle and SS_LeadingPlots_Current().battle.started) then
    SS_BattleControll_DMBattleInterface:Show();
    SS_BattleControll_BattleInterface:Show();
    PlayerLevelText:SetTextColor(1, 0, 0);
    PlaySoundFile('Sound\\Interface\\PVPFlagTakenMono.ogg');
  end;
end;

SS_BattleControll_ShowPlayerBattleMenuAfterRelog = function()
  if (SS_Plots_Current().battle) then
    SS_BattleControll_BattleInterface:Show();
    PlayerLevelText:SetTextColor(1, 0, 0);
    PlaySoundFile('Sound\\Interface\\PVPFlagTakenMono.ogg');
  end;
end;

SS_BattleControll_Hide = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  if (not(SS_LeadingPlots_Current().battle) or not(SS_LeadingPlots_Current().battle.started)) then
    SS_BattleControll:Hide();
    SS_BattleControll_Start:Hide();
    SS_Event_Controll_Battle_Button:SetText("+ Сражение");

    SS_LeadingPlots_Current().battle = nil;
  end;
end;

SS_BattleControll_SelectBattleType = function(battleType)
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle)) then return nil; end;

  SS_LeadingPlots_Current().battle.battleType = battleType;

  SS_BattleControll_Start_Battle_Type_Phases:SetChecked(false);
  SS_BattleControll_Start_Battle_Type_Initiative:SetChecked(false);
  SS_BattleControll_Start_Battle_Type_Free:SetChecked(false);

  if (battleType == 'phases') then
    SS_BattleControll_Start_Battle_Type_Phases:SetChecked(true);
  elseif (battleType == 'initiative') then
    SS_BattleControll_Start_Battle_Type_Initiative:SetChecked(true);
  elseif (battleType == 'free') then
    SS_BattleControll_Start_Battle_Type_Free:SetChecked(true);
  end;
end;

SS_BattleControll_SelectStartFrom = function(startFrom)
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle)) then return nil; end;

  SS_LeadingPlots_Current().battle.startFrom = startFrom;

  SS_BattleControll_Start_Start_From_Active:SetChecked(false);
  SS_BattleControll_Start_Start_From_Defence:SetChecked(false);

  if (startFrom == 'active') then
    SS_BattleControll_Start_Start_From_Active:SetChecked(true);
  elseif (startFrom == 'defence') then
    SS_BattleControll_Start_Start_From_Defence:SetChecked(true);
  end;
end;


SS_BattleControll_SelectAuthorFights = function(isAuthorFight)
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle)) then return nil; end;

  SS_LeadingPlots_Current().battle.authorFights = isAuthorFight;
  SS_BattleControll_Start_Author_Fights:SetChecked(isAuthorFight);
end;

SS_BattleControll_BattleStart = function()
  if (SS_LeadingPlots_Current().battle.battleType == 'phases') then
    SS_DMtP_StartPhasesBattle(SS_LeadingPlots_Current().battle.startFrom, SS_LeadingPlots_Current().battle.authorFights);
  end;

  SS_LeadingPlots_Current().battle.started = true;
  SS_BattleControll_Start:Hide();
  SS_BattleControll_ShowDMBattleMenuAfterRelog();



  --[[
  local t = 1 -- do something 5 seconds from now
  local f = CreateFrame("Frame")
  f:SetScript("OnUpdate", function(self, elapsed)
    t = t - elapsed
    if t <= 0 then
      print(GetPlayerMapPosition("player"))
      f:Hide();
    end
  end)
  ]]--
end;