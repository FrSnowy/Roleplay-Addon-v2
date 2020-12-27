SS_ParamsControll_Show = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_ParamsControll_Menu:Show();
  SS_Event_Controll_ParamsControll_Button:SetText("- Показатели");
  SS_ParamsControll_Data = {
    target = 'player',
    param = 'health',
  };
end;

SS_ParamsControll_Hide = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_ParamsControll_Menu:Hide();
  SS_Event_Controll_ParamsControll_Button:SetText("+ Показатели");
  SS_ParamsControll_Menu_Check_Target_Player:SetChecked(true);
  SS_ParamsControll_Menu_Check_Target_Group:SetChecked(false);
  
  SS_ParamsControll_Menu_Check_Params_Health:SetChecked(true);
  SS_ParamsControll_Menu_Check_Params_Barrier:SetChecked(false);
  SS_ParamsControll_Menu_Check_Params_Level:SetChecked(false);
  SS_ParamsControll_Menu_Check_Params_Exp:SetChecked(false);

  SS_ParamsControll_Menu_Value_Input:SetText("");
  SS_ParamsControll_Data = nil;
end;

SS_ParamsControll_SelectTarget = function(target)
  SS_ParamsControll_Data.target = target;
  SS_ParamsControll_Menu_Check_Target_Player:SetChecked(false);
  SS_ParamsControll_Menu_Check_Target_Group:SetChecked(false);

  if (target == 'player') then
    SS_ParamsControll_Menu_Check_Target_Player:SetChecked(true);
  elseif (target == 'group') then
    SS_ParamsControll_Menu_Check_Target_Group:SetChecked(true);
  end;
end;

SS_ParamsControll_SelectParam = function(target)
  SS_ParamsControll_Data.param = param;
  SS_ParamsControll_Menu_Check_Params_Health:SetChecked(false);
  SS_ParamsControll_Menu_Check_Params_Barrier:SetChecked(false);
  SS_ParamsControll_Menu_Check_Params_Level:SetChecked(false);
  SS_ParamsControll_Menu_Check_Params_Exp:SetChecked(false);

  if (target == 'health') then
    SS_ParamsControll_Menu_Check_Params_Health:SetChecked(true);
  elseif (target == 'barrier') then
    SS_ParamsControll_Menu_Check_Params_Barrier:SetChecked(true);
  elseif (target == 'level') then
    SS_ParamsControll_Menu_Check_Params_Level:SetChecked(true);
  elseif (target == 'exp') then
    SS_ParamsControll_Menu_Check_Params_Exp:SetChecked(true);
  end;
end;

SS_ParamsControll_SendUpdateInfo = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  local updateValue = SS_ParamsControll_Menu_Value_Input:GetText();

  if (not(updateValue) or updateValue == '' or updateValue == '0') then
    SS_Log_ValueMustBeNum();
    return nil;
  end;

  SS_DMtP_SendParamUpdate(damage);
end;