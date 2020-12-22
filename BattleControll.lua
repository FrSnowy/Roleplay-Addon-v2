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
        players = {},
      };
    end;

    SS_BattleControll_SelectBattleType(SS_LeadingPlots_Current().battle.battleType);
    SS_BattleControll_SelectPhase(SS_LeadingPlots_Current().battle.phase);
    SS_BattleControll_SelectAuthorFights(SS_LeadingPlots_Current().battle.authorFights);
  else
    SS_BattleControll:Show();
    SS_BattleControll_DMBattleInterface:Show();
    SS_Event_Controll_Battle_Button:SetText("- Сражение");
  end;
end;

SS_BattleControll_Hide = function()
  if (not(SS_LeadingPlots_Current().battle) or not(SS_LeadingPlots_Current().battle.started)) then
    SS_BattleControll:Hide();
    SS_BattleControll_Start:Hide();
    SS_Event_Controll_Battle_Button:SetText("+ Сражение");
    SS_LeadingPlots_Current().battle = nil;
  else
    SS_BattleControll:Hide();
    SS_BattleControll_DMBattleInterface:Hide();
    SS_Event_Controll_Battle_Button:SetText("+ Сражение");
  end;
end;

-- Селекторы
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
-- Конец селекторов

SS_BattleControll_AmIPlayer = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return true; end;
  if (not(SS_LeadingPlots_Current().battle) or not(SS_LeadingPlots_Current().battle.players)) then return true; end;

  if (not(SS_LeadingPlots_Current().battle.players[UnitName('player')])) then
    return false;
  else
    return true;
  end;
end;

SS_BattleControll_AmIDM = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return false; end;
  if (not(SS_LeadingPlots_Current().battle) or not(SS_LeadingPlots_Current().battle.players)) then return false; end;

  return true;
end;

SS_BattleControll_BattleStart = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle)) then return nil; end;

  local startBattleByType = {
    phases = function()
      if (SS_LeadingPlots_Current().battle.authorFights) then
        SS_Listeners_Player_OnBattleStart_StartBattleByType.phases(SS_LeadingPlots_Current().battle.phase, UnitName('player'));
        SS_Listeners_DM_OnPlayerJoinToBattle(SS_User.settings.currentPlot, UnitName('player'));
      end;
      SS_DMtP_StartBattle('phases', SS_LeadingPlots_Current().battle.phase);
      SS_BattleControll_RoundStart('phases', SS_LeadingPlots_Current().battle.phase);
    end,
    initiative = function()
      SS_BattleControll_Start:Hide();
      if (SS_LeadingPlots_Current().battle.authorFights) then
        local DMInitiative = math.floor(math.random(0, SS_Stats_GetMaxMovementPoints()));
        SS_Listeners_Player_OnBattleStart_StartBattleByType.initiative(SS_LeadingPlots_Current().battle.phase, UnitName('player'));
        SS_Listeners_DM_OnPlayerSendBattleInitiative(SS_User.settings.currentPlot..'+'..DMInitiative, UnitName('player'))
      end;
      SS_DMtP_StartBattle('initiative', SS_LeadingPlots_Current().battle.phase);
    end,
  };

  SS_LeadingPlots_Current().battle.started = true;
  startBattleByType[SS_LeadingPlots_Current().battle.battleType]();
end;

SS_BattleControll_RoundStart = function(battleType, currentPhase, isCacheLoad)
  local startRoundByType = {
    phases = function()
      if (currentPhase == 'active') then
        SS_Plots_Current().battle.maxMovementPoints = SS_Stats_GetMaxMovementPoints();
        SS_Plots_Current().battle.movementPoints = SS_Stats_GetMaxMovementPoints();
      elseif (currentPhase == 'defence') then
        SS_Plots_Current().battle.maxMovementPoints = SS_Stats_GetMaxMovementPoints() / 2;
        SS_Plots_Current().battle.movementPoints = SS_Stats_GetMaxMovementPoints() / 2;
      else
        SS_Plots_Current().battle.maxMovementPoints = 0;
        SS_Plots_Current().battle.movementPoints = 0;
      end;
  
      SS_BattleControll_DrawBattleInterface('phases', currentPhase)
    end,
    initiative = function()
      if (currentPhase == 'defence') then
        SS_Plots_Current().battle.maxMovementPoints = SS_Stats_GetMaxMovementPoints() / 2;
        SS_Plots_Current().battle.movementPoints = SS_Stats_GetMaxMovementPoints() / 2;
      elseif (currentPhase == 'waiting') then
        SS_Plots_Current().battle.maxMovementPoints = 0;
        SS_Plots_Current().battle.movementPoints = 0;
      else
        if (UnitName('player') == currentPhase) then
          SS_Plots_Current().battle.maxMovementPoints = SS_Stats_GetMaxMovementPoints();
          SS_Plots_Current().battle.movementPoints = SS_Stats_GetMaxMovementPoints();
        else
          SS_Plots_Current().battle.maxMovementPoints = 0;
          SS_Plots_Current().battle.movementPoints = 0;
        end;
      end;

      SS_BattleControll_DrawBattleInterface('initiative', currentPhase)
    end,
  };

  startRoundByType[battleType]();
  if (SS_Plots_Current() and SS_Plots_Current().battle and SS_Plots_Current().battle.movementTimer and not(isCacheLoad)) then
    SS_BattleControll_ReloadMovementWatch();
  else
    SS_BattleControll_StartMovementWatch();
  end;

  PlaySoundFile('Sound\\Interface\\PVPFlagTakenMono.ogg');
end;

SS_BattleControll_RoundLoadFromCache = function(battleType, currentPhase)
  if (not(SS_Plots_Current()) or not(SS_Plots_Current().battle)) then return nil; end;

  if (not(battleType)) then
    battleType = SS_Plots_Current().battle.battleType;
  end;

  if (not(currentPhase)) then
    currentPhase = SS_Plots_Current().battle.phase;
  end;

  if (not(battleType) or not(currentPhase)) then return nil; end;
  
  SS_BattleControll_RoundStart(battleType, currentPhase, true);
  if (SS_BattleControll_AmIDM()) then return nil; end;
  SS_BattleControll_BattleInterface_Leave_Battle:Show();
  SS_PtDM_RequestActualBattleInfo(SS_Plots_Current().author);
end;

SS_BattleControll_RoundNext = function(battleType, currentPhase)
  if (not(battleType)) then
    battleType = SS_LeadingPlots_Current().battle.battleType;
  end;

  if (not(currentPhase)) then
    currentPhase = SS_LeadingPlots_Current().battle.phase;
  end;

  if (not(battleType) or not(currentPhase)) then return nil; end;

  local nextRoundByType = {
    phases = function()
      local nextPhase = nil;
      
      SS_Shared_ForEach(SS_LeadingPlots_Current().battle.players)(function(p)
        p.isTurnEnded = false;
      end);

      if (currentPhase == 'active' or currentPhase == 'waiting') then
        nextPhase = 'defence'
      elseif (currentPhase == 'defence') then
        nextPhase = 'active'
      end;

      SS_LeadingPlots_Current().battle.phase = nextPhase;
      SS_BattleControll_RoundStart('phases', nextPhase);
      SS_DMtP_ChangePhase('phases', nextPhase);
    end,
    initiative = function()
      local nextPhase = nil;

      if (currentPhase == 'defence') then
        SS_Shared_ForEach(SS_LeadingPlots_Current().battle.players)(function(p)
          p.isTurnEnded = false;
        end);

        nextPhase = SS_LeadingPlots_Current().battle.playersByInitiative[1].name;
      else        
        local currentIndex = 0;

        local counter = 0;
        SS_Shared_ForEach(SS_LeadingPlots_Current().battle.playersByInitiative)(function(p)
          counter = counter + 1;
          if (currentIndex == 0 and p.name == SS_LeadingPlots_Current().battle.phase) then
            currentIndex = counter;
          end;
        end);

        if (currentIndex + 1 <= #SS_LeadingPlots_Current().battle.playersByInitiative) then
          nextPhase = SS_LeadingPlots_Current().battle.playersByInitiative[currentIndex + 1].name;
        else
          nextPhase = 'defence';
        end;
      end;

      SS_LeadingPlots_Current().battle.phase = nextPhase;
      SS_BattleControll_RoundStart('initiative', nextPhase);
      SS_DMtP_ChangePhase('initiative', nextPhase);
    end,
  };

  nextRoundByType[battleType]();

end;

SS_BattleControll_RoundPrevious = function(battleType, currentPhase)
  if (not(battleType)) then
    battleType = SS_LeadingPlots_Current().battle.battleType;
  end;

  if (not(currentPhase)) then
    currentPhase = SS_LeadingPlots_Current().battle.phase;
  end;

  if (not(battleType) or not(currentPhase)) then return nil; end;

  SS_Shared_ForEach(SS_LeadingPlots_Current().battle.players)(function(p)
    p.isTurnEnded = false;
  end);

  local nextRoundByType = {
    phases = function()
      SS_BattleControll_RoundNext(battleType, currentPhase)
    end,
  };

  nextRoundByType[battleType]();
end;

SS_BattleControll_EndRound = function(battleType, currentPhase)
  if (not(SS_BattleControll_AmIPlayer())) then return nil; end;

  if (not(battleType)) then
    battleType = SS_Plots_Current().battle.battleType;
  end;

  if (not(currentPhase)) then
    currentPhase = SS_Plots_Current().battle.phase;
  end;

  if (not(battleType) or not(currentPhase)) then return nil; end;

  local changeRoundByType = {
    phases = function()
      SS_Plots_Current().battle.phase = 'waiting';
      SS_BattleControll_RoundStart('phases', SS_Plots_Current().battle.phase);
    end,
    initiative = function()
      SS_Plots_Current().battle.phase = 'waiting';
      SS_BattleControll_RoundStart('initiative', SS_Plots_Current().battle.phase);
    end,
  };

  SS_PtDM_EndBattleTurn(SS_Plots_Current().author);
  changeRoundByType[battleType]();
end;

local hidePlayerInterfacePartsIfNeed = function()
  if (not(SS_BattleControll_AmIPlayer())) then
    SS_BattleControll_BattleInterface_Movement_Icon:Hide();
    SS_BattleControll_BattleInterface.currentTurn.movement:Hide();
    SS_BattleControll_BattleInterface_End_Round:Hide();
    SS_BattleControll_BattleInterface_Leave_Battle:Hide();
  end;
end;

local drawDMInterfaceIfNeed = function()
  if (SS_BattleControll_AmIDM()) then
    SS_BattleControll_DMBattleInterface:Show();
  else
    SS_BattleControll_DMBattleInterface:Hide();
  end;
end;

local drawPhasesInterface = function(currentPhase)
  hidePlayerInterfacePartsIfNeed();
  drawDMInterfaceIfNeed();

  if (currentPhase == 'active') then
    SS_BattleControll_BattleInterface.currentTurn.text:SetText('Фаза активного действия');

    if (SS_BattleControll_AmIPlayer()) then
      SS_BattleControll_BattleInterface_End_Round:Show();
      SS_BattleControll_BattleInterface_Leave_Battle:Hide();
      
      SS_BattleControll_BattleInterface_Movement_Icon:Show();
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
      SS_BattleControll_BattleInterface.currentTurn.movement:Show();
    end;
  elseif (currentPhase == 'defence') then
    SS_BattleControll_BattleInterface.currentTurn.text:SetText('Фаза защиты');

    if (SS_BattleControll_AmIPlayer()) then
      SS_BattleControll_BattleInterface_End_Round:Hide();
      SS_BattleControll_BattleInterface_Leave_Battle:Hide();

      SS_BattleControll_BattleInterface_Movement_Icon:Show();
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
      SS_BattleControll_BattleInterface.currentTurn.movement:Show();
    end;
  elseif (currentPhase == 'waiting') then
    SS_BattleControll_BattleInterface.currentTurn.text:SetText('Ожидание других игроков');
    if (SS_BattleControll_AmIPlayer()) then
      SS_BattleControll_BattleInterface_End_Round:Hide();
      SS_BattleControll_BattleInterface_Leave_Battle:Hide();

      SS_BattleControll_BattleInterface_Movement_Icon:Show();
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
      SS_BattleControll_BattleInterface.currentTurn.movement:Show();
    end;
  end;
end;

local drawInitiativeInterface = function(currentPhase)
  hidePlayerInterfacePartsIfNeed();
  drawDMInterfaceIfNeed();

  if (currentPhase == 'defence') then
    SS_BattleControll_BattleInterface.currentTurn.text:SetText('Фаза защиты');

    if (SS_BattleControll_AmIPlayer()) then
      SS_BattleControll_BattleInterface_End_Round:Hide();
      SS_BattleControll_BattleInterface_Leave_Battle:Hide();

      SS_BattleControll_BattleInterface_Movement_Icon:Show();
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
      SS_BattleControll_BattleInterface.currentTurn.movement:Show();
    end;
  elseif (currentPhase == 'waiting') then
    SS_BattleControll_BattleInterface.currentTurn.text:SetText('Ожидание других игроков');
    if (SS_BattleControll_AmIPlayer()) then
      SS_BattleControll_BattleInterface_End_Round:Hide();
      SS_BattleControll_BattleInterface_Leave_Battle:Hide();

      SS_BattleControll_BattleInterface_Movement_Icon:Show();
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
      SS_BattleControll_BattleInterface.currentTurn.movement:Show();
    end;
  else
    if (currentPhase == UnitName('player')) then
      SS_BattleControll_BattleInterface.currentTurn.text:SetText('Ваш ход');
      
      if (SS_BattleControll_AmIPlayer()) then
        SS_BattleControll_BattleInterface_End_Round:Show();
      end;
    else
      SS_BattleControll_BattleInterface.currentTurn.text:SetText('Ход игрока '..currentPhase);
      
      if (SS_BattleControll_AmIPlayer()) then
        SS_BattleControll_BattleInterface_End_Round:Hide();
      end;
    end;

    if (SS_BattleControll_AmIPlayer()) then
      SS_BattleControll_BattleInterface_Leave_Battle:Hide();
      SS_BattleControll_BattleInterface_Movement_Icon:Show();
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
      SS_BattleControll_BattleInterface.currentTurn.movement:Show();
    end;
  end;
end;

SS_BattleControll_DrawBattleInterface = function(battleType, currentPhase)
  local drawInterfaceByType = {
    phases = drawPhasesInterface,
    initiative = drawInitiativeInterface,
  }

  SS_BattleControll_Start:Hide();
  SS_BattleControll_BattleInterface:Hide();

  drawInterfaceByType[battleType](currentPhase);
  SS_BattleControll_BattleInterface:Show();
end;

SS_BattleControll_LeaveBattle = function()
  SS_BattleControll_StopMovementWatch();
  SS_BattleControll_Reset();
end;

SS_BattleControll_Reset = function()
  SS_BattleControll:Hide();

  if (SS_BattleControll_AmIPlayer()) then
    SS_Plots_Current().battle = nil;
    SS_BattleControll_BattleInterface:Hide();
  end;

  if (SS_BattleControll_AmIDM()) then
    SS_LeadingPlots_Current().battle = nil;
    SS_BattleControll_DMBattleInterface:Hide();
    SS_Event_Controll_Battle_Button:SetText("+ Сражение");
  end;
end;

SS_BattleControll_StartMovementWatch = function()
  if (not(SS_BattleControll_AmIPlayer())) then return nil; end;

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
  
      SS_Plots_Current().battle.movementPoints = SS_Plots_Current().battle.movementPoints - spentedPoints;
      if (SS_Plots_Current().battle.movementPoints <= 0) then
        SS_Plots_Current().battle.movementPoints = 0;
        SS_BattleControll_BattleInterface.currentTurn.movement:SetTextColor(1, 0, 0);
        if (diffBetweenPosition.x > 0 or diffBetweenPosition.y > 0) then
          PlaySoundFile('Sound\\Interface\\RaidWarning.ogg');
          SS_Log_NoMovementPoints();
        end;
      else
        SS_BattleControll_BattleInterface.currentTurn.movement:SetTextColor(1, 0.6, 0);
      end;
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
      SS_Plots_Current().battle.previousPosition = currentPosition;
      if (SS_Plots_Current().battle.movementTimer) then
        SS_Plots_Current().battle.movementTimer:Hide();
      end;
      SS_BattleControll_StartMovementWatch();
    end
  end)
end;

SS_BattleControll_ReloadMovementWatch = function()
  local prevMovementFn = SS_BattleControll_StartMovementWatch;
  SS_BattleControll_StartMovementWatch = function()
    return nil;
  end;

  if (SS_Plots_Current().battle.movementTimer) then SS_Plots_Current().battle.movementTimer:Hide(); end;
  SS_Plots_Current().battle.movementTimer = nil;

  local t = 1;
  local f = CreateFrame("Frame")
  f:SetScript("OnUpdate", function(self, elapsed)
    t = t - elapsed
    if t <= 0 then
      SS_BattleControll_StartMovementWatch = prevMovementFn;
      SS_BattleControll_StartMovementWatch();
      f:Hide();
    end
  end)
end;

SS_BattleControll_StopMovementWatch = function()
  local prevMovementFn = SS_BattleControll_StartMovementWatch;
  SS_BattleControll_StartMovementWatch = function()
    return nil;
  end;

  
  if (SS_Plots_Current().battle.movementTimer) then SS_Plots_Current().battle.movementTimer:Hide(); end;
  SS_BattleControll_StartMovementWatch = prevMovementFn;
end;