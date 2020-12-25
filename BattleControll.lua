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
        authorFights = true,
        withoutDefence = false,
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

  if (battleType == 'free') then
    SS_BattleControll_Start_Start_From_Active:Hide();
    SS_BattleControll_Start_Start_From_Defence:Hide();
    SS_BattleControll_Start_Author_Fights:Hide();
    SS_BattleControll_Start_Label_StartFrom:Hide();
    SS_BattleControll_Start_Label_StartFromActive:Hide();
    SS_BattleControll_Start_Label_StartFromDefence:Hide();
    SS_BattleControll_Start_Label_AuthorFights:Hide();
    SS_BattleControll_Start_Label_Specials:Hide();

    SS_BattleControll_SelectPhase('active');
    SS_BattleControll_SelectAuthorFights(true);

    SS_BattleControll_Start:SetSize(240, 200);
  else
    SS_BattleControll_Start_Start_From_Active:Show();
    SS_BattleControll_Start_Start_From_Defence:Show();
    SS_BattleControll_Start_Author_Fights:Show();
    SS_BattleControll_Start_Label_StartFrom:Show();
    SS_BattleControll_Start_Label_StartFromActive:Show();
    SS_BattleControll_Start_Label_StartFromDefence:Show();
    SS_BattleControll_Start_Label_AuthorFights:Show();
    SS_BattleControll_Start_Label_Specials:Show();
    SS_BattleControll_Start:SetSize(590, 200);
  end;

  if (battleType == 'initiative') then
    SS_BattleControll_Start_Label_StartFromActive:SetText('Броска инициативы');
    SS_BattleControll_Start_Label_No_Defence:Show();
    SS_BattleControll_Start_No_Defence:Show();
  else
    SS_BattleControll_Start_Label_StartFromActive:SetText('Активного действия');
    SS_BattleControll_Start_Label_No_Defence:Hide();
    SS_BattleControll_Start_No_Defence:Hide();
    SS_BattleControll_SelectWithoutDefence(false);
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

SS_BattleControll_SelectWithoutDefence = function(withoutDefence)
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle)) then return nil; end;

  SS_LeadingPlots_Current().battle.withoutDefence = withoutDefence;
  SS_BattleControll_Start_No_Defence:SetChecked(withoutDefence);

  if (withoutDefence) then
    SS_BattleControll_Start_Start_From_Defence:Hide();
    SS_BattleControll_Start_Label_StartFromDefence:Hide();

    if (SS_LeadingPlots_Current().battle.battleType == 'free') then
      SS_BattleControll_SelectPhase('');
    else
      SS_BattleControll_SelectPhase('active');
    end;
  else
    if (SS_LeadingPlots_Current().battle.battleType == 'free') then
      SS_BattleControll_Start_Start_From_Defence:Hide();
      SS_BattleControll_Start_Label_StartFromDefence:Hide();
    else
      SS_BattleControll_Start_Start_From_Defence:Show();
      SS_BattleControll_Start_Label_StartFromDefence:Show();
    end;
  end;
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
        SS_Listeners_DM_OnPlayerJoinToBattle(SS_User.settings.currentPlot, UnitName('player'));
      end;
      SS_Listeners_Player_OnBattleStart_StartBattleByType.phases(SS_LeadingPlots_Current().battle.phase, UnitName('player'));
      SS_DMtP_StartBattle('phases', SS_LeadingPlots_Current().battle.phase);
      SS_BattleControll_RoundStart('phases', SS_LeadingPlots_Current().battle.phase);
  
      SS_BattleControll_StartMovementWatch();
    end,
    initiative = function()
      SS_BattleControll_Start:Hide();
      if (SS_LeadingPlots_Current().battle.authorFights) then
        local DMInitiative = math.floor(math.random(0, SS_Stats_GetMaxMovementPoints()));
        SS_Listeners_DM_OnPlayerSendBattleInitiative(SS_User.settings.currentPlot..'+'..DMInitiative, UnitName('player'))
      end;
      SS_Listeners_Player_OnBattleStart_StartBattleByType.initiative(SS_LeadingPlots_Current().battle.phase, UnitName('player'));
      SS_DMtP_StartBattle('initiative', SS_LeadingPlots_Current().battle.phase);
      SS_BattleControll_RoundStart('initiative', SS_LeadingPlots_Current().battle.phase);
  
      SS_BattleControll_StartMovementWatch();
    end,
    free = function()
      SS_Listeners_Player_OnBattleStart_StartBattleByType.free('', UnitName('player'));
      SS_DMtP_StartBattle('free', '');
      SS_BattleControll_RoundStart('free');
    end,
  };

  SS_LeadingPlots_Current().battle.started = true;
  startBattleByType[SS_LeadingPlots_Current().battle.battleType]();
end;

SS_BattleControll_CalculateMovementPoints = function(battleType, currentPhase)
  local movementPointsByType = {
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
    end,
    initiative = function()
      if (currentPhase == 'active') then
        SS_Plots_Current().battle.maxMovementPoints = 0;
        SS_Plots_Current().battle.movementPoints = 0;
      elseif (currentPhase == 'defence') then
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
    end,
  };

  movementPointsByType[battleType]();
end;

SS_BattleControll_RoundStart = function(battleType, currentPhase, isCacheLoad)
  local startRoundByType = {
    phases = function()
      if (not(isCacheLoad)) then
        SS_Plots_Current().battle.fullRoundMovement = false;
        SS_BattleControll_CalculateMovementPoints('phases', currentPhase)
      end;

      SS_BattleControll_DrawBattleInterface('phases', currentPhase)
    end,
    initiative = function()
      if (not(isCacheLoad)) then
        SS_Plots_Current().battle.fullRoundMovement = false;
        SS_BattleControll_CalculateMovementPoints('initiative', currentPhase)
      end;

      SS_BattleControll_DrawBattleInterface('initiative', currentPhase);
    end,
    free = function()
      SS_BattleControll_DrawBattleInterface('free');
    end,
  };

  if (not(battleType == 'free')) then
    if (not(SS_Plots_Current().battle.movementTimer) or not(SS_Plots_Current().battle.movementTimer['Hide'])) then
      SS_Plots_Current().battle.movementTimer = nil;
      SS_BattleControll_ReloadMovementWatch();
    end;
  end;

  startRoundByType[battleType]();
  PlaySoundFile('Sound\\Interface\\PVPFlagTakenMono.ogg');
end;

SS_BattleControll_RoundLoadFromCache = function(battleType, currentPhase)
  if (not(SS_Plots_Current()) or not(SS_Plots_Current().battle)) then return nil; end;

  if (not(battleType)) then
    battleType = SS_Plots_Current().battle.battleType;
  end;

  if (not(currentPhase)) then
    if (SS_BattleControll_AmIDM()) then
      currentPhase = SS_LeadingPlots_Current().battle.phase
    else
      currentPhase = SS_Plots_Current().battle.phase;
    end;
  end;

  if (not(battleType) or (not(battleType == 'free') and not(currentPhase))) then return nil; end;
  
  if (not(SS_BattleControll_AmIDM())) then
    SS_BattleControll_RoundStart(battleType, currentPhase, true);
    SS_BattleControll_BattleInterface_Leave_Battle:Show();
    SS_PtDM_RequestActualBattleInfo(SS_Plots_Current().author);
  end;

  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().battle)) then return nil; end;
  SS_BattleControll_RoundStart(battleType, currentPhase, true);

  if (battleType == 'free') then
    SS_DMtP_ChangePhase('free', '');
  else
    SS_DMtP_ChangePhase(battleType, currentPhase);
  end;

  SS_Shared_ForEach(SS_LeadingPlots_Current().battle.players)(function(p)
    p.isMovementNotifyShowed = false;
  end);
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
        p.isMovementNotifyShowed = false;
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
          p.isMovementNotifyShowed = false;
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
          if (SS_LeadingPlots_Current().battle.withoutDefence) then
            SS_Shared_ForEach(SS_LeadingPlots_Current().battle.players)(function(p)
              p.isTurnEnded = false;
              p.isMovementNotifyShowed = false;
            end);
    
            nextPhase = SS_LeadingPlots_Current().battle.playersByInitiative[1].name;
          else
            nextPhase = 'defence';
          end;
        end;
      end;

      SS_LeadingPlots_Current().battle.phase = nextPhase;
      SS_Plots_Current().battle.phase = nextPhase;
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
    p.isMovementNotifyShowed = false;
  end);

  local nextRoundByType = {
    phases = function()
      SS_BattleControll_RoundNext(battleType, currentPhase)
    end,
    initiative = function()
      local nextPhase = nil;

      if (currentPhase == 'defence') then
        SS_Shared_ForEach(SS_LeadingPlots_Current().battle.players)(function(p)
          p.isTurnEnded = false;
          p.isMovementNotifyShowed = false;
        end);

        nextPhase = SS_LeadingPlots_Current().battle.playersByInitiative[#SS_LeadingPlots_Current().battle.playersByInitiative].name;
      else        
        local currentIndex = 0;
        local counter = 0;
        SS_Shared_ForEach(SS_LeadingPlots_Current().battle.playersByInitiative)(function(p)
          counter = counter + 1;
          if (currentIndex == 0 and p.name == SS_LeadingPlots_Current().battle.phase) then
            currentIndex = counter;
          end;
        end);

        if (currentIndex -1 <= 0) then
          nextPhase = 'defence';
        else
          nextPhase = SS_LeadingPlots_Current().battle.playersByInitiative[currentIndex - 1].name;
        end;
      end;

      SS_LeadingPlots_Current().battle.phase = nextPhase;
      SS_Plots_Current().battle.phase = nextPhase;
      SS_BattleControll_RoundStart('initiative', nextPhase);
      SS_DMtP_ChangePhase('initiative', nextPhase);
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
      SS_BattleControll_BattleInterface_End_Round:Hide();
      -- Тут ничего не делаем. Фазы меняются последовательно без ожидания других игроков
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
    SS_Event_Controll_Battle_Button:SetText("- Сражение");

    if (SS_LeadingPlots_Current().battle.battleType == 'free') then
      SS_BattleControll_DMBattleInterface_Next_Round:Hide();
      SS_BattleControll_DMBattleInterface_Prev_Round:Hide();
      SS_BattleControll_DMBattleInterface:SetSize(200, 180);
    
    else
      SS_BattleControll_DMBattleInterface_Next_Round:Show();
      SS_BattleControll_DMBattleInterface_Prev_Round:Show();
      SS_BattleControll_DMBattleInterface:SetSize(280, 180);
    end;
  else
    SS_BattleControll_DMBattleInterface:Hide();
    SS_Event_Controll_Battle_Button:SetText("+ Сражение");
  end;
end;

local drawPhasesInterface = function(currentPhase)
  hidePlayerInterfacePartsIfNeed();
  drawDMInterfaceIfNeed();

  if (currentPhase == 'active') then
    SS_BattleControll_BattleInterface.currentTurn.text:SetText('Фаза активного действия');
    SS_BattleControll_BattleInterface_Double_Move:Hide();

    if (SS_BattleControll_AmIPlayer()) then
      SS_BattleControll_BattleInterface_End_Round:Show();
      if (SS_Plots_Current().battle.movementPoints == SS_Plots_Current().battle.maxMovementPoints and not(SS_Plots_Current().battle.fullRoundMovement)) then
        SS_BattleControll_BattleInterface_Double_Move:Show();
      end;
      SS_BattleControll_BattleInterface_Leave_Battle:Hide();
      
      SS_BattleControll_BattleInterface_Movement_Icon:Show();
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
      SS_BattleControll_BattleInterface.currentTurn.movement:Show();
    end;
  elseif (currentPhase == 'defence') then
    SS_BattleControll_BattleInterface.currentTurn.text:SetText('Фаза защиты');
    SS_BattleControll_BattleInterface_Double_Move:Hide();

    if (SS_BattleControll_AmIPlayer()) then
      SS_BattleControll_BattleInterface_End_Round:Hide();
      SS_BattleControll_BattleInterface_Leave_Battle:Hide();

      SS_BattleControll_BattleInterface_Movement_Icon:Show();
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
      SS_BattleControll_BattleInterface.currentTurn.movement:Show();
    end;
  elseif (currentPhase == 'waiting') then
    SS_BattleControll_BattleInterface.currentTurn.text:SetText('Ожидание других игроков');
    SS_BattleControll_BattleInterface_Double_Move:Hide();
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
    SS_BattleControll_BattleInterface_Double_Move:Hide();

    if (SS_BattleControll_AmIPlayer()) then
      SS_BattleControll_BattleInterface_End_Round:Hide();
      SS_BattleControll_BattleInterface_Leave_Battle:Hide();

      SS_BattleControll_BattleInterface_Movement_Icon:Show();
      SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
      SS_BattleControll_BattleInterface.currentTurn.movement:Show();
    end;
  elseif (currentPhase == 'active') then
    SS_BattleControll_BattleInterface.currentTurn.text:SetText('Определяем порядок ходов');
    SS_BattleControll_BattleInterface_Double_Move:Hide();
  elseif (currentPhase == 'waiting') then
    SS_BattleControll_BattleInterface.currentTurn.text:SetText('Ожидание других игроков');
    SS_BattleControll_BattleInterface_Double_Move:Hide();
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
      SS_BattleControll_BattleInterface_Double_Move:Hide();
      
      if (SS_BattleControll_AmIPlayer()) then
        SS_BattleControll_BattleInterface_End_Round:Show();
        if (SS_Plots_Current().battle.movementPoints == SS_Plots_Current().battle.maxMovementPoints and not(SS_Plots_Current().battle.fullRoundMovement)) then
          SS_BattleControll_BattleInterface_Double_Move:Show();
        end;
      end;
    else
      SS_BattleControll_BattleInterface.currentTurn.text:SetText('Ход игрока '..currentPhase);
      SS_BattleControll_BattleInterface_Double_Move:Hide();
      
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

local drawFreeInterface = function()
  drawDMInterfaceIfNeed();

  SS_BattleControll_BattleInterface_End_Round:Hide();
  SS_BattleControll_BattleInterface_Double_Move:Hide();
  SS_BattleControll_BattleInterface_Movement_Icon:Hide();
  SS_BattleControll_BattleInterface.currentTurn.text:SetText('В бою');
  SS_BattleControll_BattleInterface_Leave_Battle:Hide();
  SS_BattleControll_BattleInterface.currentTurn.movement:Hide();
end;

SS_BattleControll_DrawBattleInterface = function(battleType, currentPhase)
  local drawInterfaceByType = {
    phases = drawPhasesInterface,
    initiative = drawInitiativeInterface,
    free = drawFreeInterface,
  }

  SS_BattleControll_Start:Hide();
  SS_BattleControll_BattleInterface:Hide();
  PlayerLevelText:SetTextColor(1, 0, 0);

  drawInterfaceByType[battleType](currentPhase);
  SS_BattleControll_BattleInterface:Show();
end;

SS_BattleControll_LeaveBattle = function()
  SS_BattleControll_StopMovementWatch();
  SS_BattleControll_Reset();

  PlayerLevelText:SetTextColor(1, 1, 1);

  if (not(SS_Plots_Current().author == UnitName('player'))) then
    SS_PtDM_LeaveBattleSuccess(SS_Plots_Current().author);
  end;
end;

SS_BattleControll_Reset = function()
  SS_BattleControll:Hide();
  SS_BattleControll_BattleInterface:Hide();

  if (SS_BattleControll_AmIPlayer()) then
    SS_Plots_Current().battle = nil;
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
      if (SS_Plots_Current().battle and SS_Plots_Current().battle.maxMovementPoints) then
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
        if (SS_Plots_Current().battle.movementPoints < SS_Plots_Current().battle.maxMovementPoints) then
          SS_BattleControll_BattleInterface_Double_Move:Hide();
        end;

        if (SS_Plots_Current().battle.movementPoints <= 0) then
          SS_Plots_Current().battle.movementPoints = 0;
          SS_BattleControll_BattleInterface.currentTurn.movement:SetTextColor(1, 0, 0);
          if (SS_Plots_Current().battle.fullRoundMovement) then
            SS_BattleControll_EndRound();
          else
            if (diffBetweenPosition.x > 0 or diffBetweenPosition.y > 0) then
              PlaySoundFile('Sound\\Interface\\RaidWarning.ogg');
              SS_Log_NoMovementPoints();
              if (not(SS_Plots_Current().author == UnitName('player'))) then
                SS_PtDM_SendMovementPointsEnd(SS_Plots_Current().author);
              end;
            end;
          end;
        else
          SS_BattleControll_BattleInterface.currentTurn.movement:SetTextColor(1, 0.6, 0);
        end;
        SS_BattleControll_BattleInterface.currentTurn.movement:SetText(SS_Plots_Current().battle.movementPoints.." / "..SS_Plots_Current().battle.maxMovementPoints);
        SS_Plots_Current().battle.previousPosition = currentPosition;
      end;

      if (SS_Plots_Current().battle.movementTimer) then
        SS_Plots_Current().battle.movementTimer:Hide();
        SS_Plots_Current().battle.movementTimer = nil;
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

  if (SS_Plots_Current().battle.movementTimer and SS_Plots_Current().battle.movementTimer['Hide']) then SS_Plots_Current().battle.movementTimer:Hide(); end;
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

SS_BattleControll_DoubleMovement = function()
  if (not(SS_Plots_Current()) or not(SS_Plots_Current().battle)) then return nil; end;
  if (SS_Plots_Current().battle.fullRoundMovement) then return nil; end;

  SS_Plots_Current().battle.fullRoundMovement = true;
  SS_BattleControll_CalculateMovementPoints(SS_Plots_Current().battle.battleType, SS_Plots_Current().battle.phase);
  
  SS_BattleControll_BattleInterface_Double_Move:Hide();
end;

SS_BattleControll_AddNewPlayer = function(player)
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle)) then return nil; end;
  if (not(player)) then
    SS_Log_NoTarget();
    return nil;
  end;

  if (UnitName("player") == player) then return nil; end;

  local isPlayerInBattle = not(SS_LeadingPlots_Current().battle.players[player] == nil);

  if (isPlayerInBattle) then
    SS_Log_PlayerAlreadyInBattle(player);
    return nil;
  end;
  
  SS_DMtP_AddToBattle(SS_LeadingPlots_Current().battle.battleType, SS_LeadingPlots_Current().battle.phase, player);
end;

SS_BattleControll_KickFromBattle = function(player)
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle)) then return nil; end;

  if (not(player)) then
    SS_Log_NoTarget();
    return nil;
  end;

  SS_DMtP_KickFromBattle(player);
end;

SS_BattleControll_IsInBattle = function(searchingBattleType)
  if (not(searchingBattleType)) then
    return not(SS_Plots_Current().battle == nil);
  else
    if (SS_Plots_Current().battle == nil) then return false; end;

    return SS_Plots_Current().battle.battleType == searchingBattleType;
  end;
end;

SS_BattleControll_IsInPhase = function(searchingPhase)
  if (not(SS_BattleControll_IsInBattle())) then return false; end;
  if (SS_BattleControll_IsInBattle('free')) then return false; end;

  if (searchingPhase == 'active') then
    if (SS_BattleControll_IsInBattle('phases')) then
      return SS_Plots_Current().battle.phase == 'active';
    else
      return false;
    end;
  end;

  if (searchingPhase == 'selfTurn') then
    if (SS_BattleControll_IsInBattle('initiative')) then
      return SS_Plots_Current().battle.phase == UnitName("player");
    elseif (SS_BattleControll_IsInBattle('phases')) then
      return SS_Plots_Current().battle.phase == 'active';
    else
      return false;
    end;
  end;

  if (searchingPhase == 'defence') then
    return SS_Plots_Current().battle.phase == 'defence';
  end;
end;