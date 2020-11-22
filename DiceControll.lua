SS_DiceControll_Show = function()
  SS_DicesControll_Menu:Show();
  SS_Event_Controll_DiceControll_Button:SetText("- Проверки");
  SS_DiceControll_Data = {
    target = 'player',
    isVisible = true,
  };
end;

SS_DiceControll_Hide = function()
  SS_DicesControll_Menu:Hide();
  SS_Event_Controll_DiceControll_Button:SetText("+ Проверки");
  SS_DicesControll_Menu_Check_Target_Player:SetChecked(true);
  SS_DicesControll_Menu_Check_Target_Group:SetChecked(false);
  SS_DicesControll_Menu_Check_Visibility_Visible:SetChecked(true);
  SS_DicesControll_Menu_Check_Visibility_Invisible:SetChecked(false);
  SS_DiceControll_Data = nil;
end;

SS_DiceControll_SelectTarget = function(target)
  SS_DiceControll_Data.target = target;
  SS_DicesControll_Menu_Check_Target_Player:SetChecked(false);
  SS_DicesControll_Menu_Check_Target_Group:SetChecked(false);

  if (target == 'player') then
    SS_DicesControll_Menu_Check_Target_Player:SetChecked(true);
  elseif (target == 'group') then
    SS_DicesControll_Menu_Check_Target_Group:SetChecked(true);
  end;
end;

SS_DiceControll_SelectVisibility = function(isVisible)
  SS_DiceControll_Data.isVisible = isVisible;
  SS_DicesControll_Menu_Check_Visibility_Visible:SetChecked(false);
  SS_DicesControll_Menu_Check_Visibility_Invisible:SetChecked(false);

  if (isVisible == true) then
    SS_DicesControll_Menu_Check_Visibility_Visible:SetChecked(true);
  elseif (isVisible == false) then
    SS_DicesControll_Menu_Check_Visibility_Invisible:SetChecked(true);
  end;
end;