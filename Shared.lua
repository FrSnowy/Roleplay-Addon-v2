SS_Shared_MathRound = function(number)
  if (number == 0) then return 0; end;

  local rounded = 0;
  
  if (math.abs(math.ceil(number) - number) > 0.5) then
    rounded = math.floor(number);
  else
    rounded = math.ceil(number);
  end;

  return rounded;
end;

SS_Shared_SortTable = function(dict)
  local keys = { };
  for key in pairs(dict) do table.insert(keys, key) end;
  table.sort(keys)

  local sortedDict = { };
  for _, key in ipairs(keys) do sortedDict[key] = dict[key] end;
  return sortedDict;
end;

SS_Shared_ForEach = function(list)
  return function(callback)
    for index, element in pairs(list) do
      callback(element, index, list);
    end;
  end;
end;

SS_Shared_Includes = function(list)
  return function(checkFn)
    for index, element in pairs(list) do
      if (checkFn(element, index, list)) then
        return true;
      end;
    end;

    return false;
  end;
end;

SS_Shared_RemoveFrom = function(list)
  return function(checkFn)
    for index, element in pairs(list) do
      if (checkFn(element, index, list)) then
        list[index] = nil;
      end;
    end;

    return false;
  end;
end;

SS_Shared_DrawList = function(target, list, drawSingle)
  if (not(target) or not(list)) then return nil end;

  local childs = { target:GetChildren() };
  for _, child in pairs(childs) do
    child:Hide();
  end
  
  local sortedList = SS_Shared_SortTable(list);
  local counter = 0;
  SS_Shared_ForEach(sortedList)(function(element, index)
    drawSingle(element, index, target);
  end);
end;

SS_Shared_IgnoreOfflineMsgFilter = function(self, event, msg)
  return msg:find("в игре не найден");
end;

SS_Shared_IfOnline = function(target, callback)
  if (not(SS_Shared_IfOnlineCallback)) then
    SS_Shared_IfOnlineCallback = { };
  end;

  SS_Shared_IfOnlineCallback[target] = callback;
  ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", SS_Shared_IgnoreOfflineMsgFilter);
  SS_PtP_IsOnline(target);
end;