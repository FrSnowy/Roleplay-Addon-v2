SS_Listeners_Player_OnAddModifier = function(modifierType)
  -- У: Игрок, от: Мастер/GHI, когда: создается новый модификатор хар-ки
  return function(data, author, prefix)
    local allowModifier = false;
    if (not(SS_Plots_Current())) then return nil; end;
  
    if (prefix == 'SS-GHItP') then
      allowModifier = author == UnitName('player');
    else
      allowModifier = author == SS_Plots_Current().author;
    end;
  
    if (not(allowModifier)) then return nil; end;
  
    local id, name, statStr, value, count = strsplit('+', data);
    local stats = { strsplit('}', statStr) };
  
    SS_Modifiers_Register(modifierType, {
      id = id,
      name = name,
      stats = stats,
      value = value,
      count = count,
    });
  end;
end;