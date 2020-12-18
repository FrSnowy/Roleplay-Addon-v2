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
        phase = 'active',
        authorFights = false,
      };
    end;

    SS_BattleControll_SelectBattleType(SS_LeadingPlots_Current().battle.battleType);
    SS_BattleControll_SelectPhase(SS_LeadingPlots_Current().battle.phase);
    SS_BattleControll_SelectAuthorFights(SS_LeadingPlots_Current().battle.authorFights);
  end;
end;

SS_BattleControll_ShowDMBattleMenuAfterRelog = function()
  if (SS_LeadingPlots_Current().battle and SS_LeadingPlots_Current().battle.started) then
    SS_BattleControll_DMBattleInterface:Show();
    SS_BattleControll_BattleInterface:Show();
    PlayerLevelText:SetTextColor(1, 0, 0);
    PlaySoundFile('Sound\\Interface\\PVPFlagTakenMono.ogg');

    if (SS_LeadingPlots_Current().battle.phase == 'active') then
      SS_BattleControll_BattleInterface.currentTurn.text:SetText("Фаза активного действия");
    else
      SS_BattleControll_BattleInterface.currentTurn.text:SetText("Фаза защиты");
    end;
  end;
end;

SS_BattleControll_ShowPlayerBattleMenuAfterRelog = function()
  if (SS_Plots_Current().battle.phase) then
    SS_BattleControll_BattleInterface:Show();
    PlayerLevelText:SetTextColor(1, 0, 0);
    PlaySoundFile('Sound\\Interface\\PVPFlagTakenMono.ogg');

    if (SS_Plots_Current().battle.phase == 'active') then
      SS_BattleControll_StartPlayerActivePhase();
    else
      SS_BattleControll_StartPlayerDefencePhase();
    end;
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

SS_BattleControll_SelectPhase = function(phase)
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle)) then return nil; end;

  SS_LeadingPlots_Current().battle.phase = phase;

  SS_BattleControll_Start_Start_From_Active:SetChecked(false);
  SS_BattleControll_Start_Start_From_Defence:SetChecked(false);

  if (phase == 'active') then
    SS_BattleControll_Start_Start_From_Active:SetChecked(true);
  elseif (phase == 'defence') then
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
    SS_DMtP_StartPhasesBattle(SS_LeadingPlots_Current().battle.phase, SS_LeadingPlots_Current().battle.authorFights);
  end;

  SS_LeadingPlots_Current().battle.started = true;
  SS_BattleControll_Start:Hide();
  SS_BattleControll_ShowDMBattleMenuAfterRelog();
end;

SS_BattleControll_WatchMovement = function()
  local t = 0.5;
  SS_Plots_Current().battle.movementTimer = CreateFrame("Frame")
  SS_Plots_Current().battle.movementTimer:SetScript("OnUpdate", function(self, elapsed)
    t = t - elapsed
    if t <= 0 then
      local x, y = GetPlayerMapPosition("player");
      
      local currentPosition = { x = math.floor(x * 10000), y =  math.floor(y * 10000) }

      if (not(SS_Plots_Current().battle.previousPosition)) then
        SS_Plots_Current().battle.previousPosition = currentPosition;
      end;

      local diffBetweenPosition = {
        x = math.abs(currentPosition.x - SS_Plots_Current().battle.previousPosition.x),
        y =  math.abs(currentPosition.y - SS_Plots_Current().battle.previousPosition.y)
      }

      local spentedPoints = math.floor(math.sqrt(math.pow(diffBetweenPosition.x, 2) + math.pow(diffBetweenPosition.y, 2)));
      if (spentedPoints > 1) then spentedPoints = 1; end;
      SS_Plots_Current().battle.movement = SS_Plots_Current().battle.movement - spentedPoints;
      if (SS_Plots_Current().battle.movement <= 0) then 
        SS_Plots_Current().battle.movement = 0;
        SS_BattleControll_BattleInterface.currentTurn.movement:SetTextColor(1, 0, 0);

        if (diffBetweenPosition.x > 0 or diffBetweenPosition.y > 0) then
          PlaySoundFile('Sound\\Interface\\RaidWarning.ogg');
          SS_Log_NoMovementPoints();
        end;
      end;
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movement.." / "..SS_Plots_Current().battle.maxMovement);
      SS_Plots_Current().battle.previousPosition = currentPosition;

      SS_Plots_Current().battle.movementTimer:Hide();
      SS_BattleControll_WatchMovement();
    end
  end)
end;

SS_BattleControll_StartPlayerActivePhase = function()
  SS_BattleControll_BattleInterface.currentTurn.text:SetText("Фаза активного действия");

  SS_Plots_Current().battle.maxMovement = 6 + math.floor(SS_Stats_GetValue('mobility') / 2.4);
  SS_Plots_Current().battle.movement = SS_Plots_Current().battle.movement or SS_Plots_Current().battle.maxMovement;
  SS_Plots_Current().battle.previousPosition = nil;

  SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movement.." / "..SS_Plots_Current().battle.maxMovement);
  SS_BattleControll_WatchMovement();
end;

SS_BattleControll_StartPlayerDefencePhase = function()
  SS_BattleControll_BattleInterface.currentTurn.text:SetText("Фаза защиты");
end;