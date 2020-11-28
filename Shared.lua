local SS_Shared_SAM_Split_String = function(str)
  local msgs = {};

  local currentMsg = 1;
  for i = 1, #str do
    if (not(msgs[currentMsg])) then msgs[currentMsg] = ''; end;
    local letter = string.sub(str, i, i);
    msgs[currentMsg] = msgs[currentMsg]..letter;

    if (#msgs[currentMsg] > 200) then currentMsg = currentMsg + 1; end;
  end;

  return msgs;
end;

SS_Shared_TimeStamp = function()
  local cTime = GetTime();
  local baseStamp = SS_Shared_NumFromStr(string.reverse(''..cTime * 1000));
  baseStamp = baseStamp + SS_Shared_MathRound(baseStamp / 1000) + SS_Shared_MathRound(baseStamp / 10);
  
  return string.sub(''..baseStamp, 1, 8);
end;

SS_Shared_SAM = function(prefix, action, data, target)
  if (#data > 200) then
    messages = SS_Shared_SAM_Split_String(data);
    local timeStamp = SS_Shared_TimeStamp();
    SS_Shared_ForEach(messages)(function(msg, index)
      if (index == 1) then
        SendAddonMessage(prefix, '~'..action..'|'..timeStamp..'|'..msg, "WHISPER", target);
      elseif (index == #messages) then
        SendAddonMessage(prefix, action..'|'..timeStamp..'|'..msg..'~', "WHISPER", target);
      else
        SendAddonMessage(prefix, action..'|'..timeStamp..'|'..msg, "WHISPER", target);
      end;
    end);
  else
    SendAddonMessage(prefix, '~'..action..'|'..data..'~', "WHISPER", target);
  end;
end;

SS_Shared_MathRound = function(number)
  if (number == 0) then return 0; end;

  local rounded = 0;
  
  if (math.abs(math.ceil(number) - number) > 0.5) then
    rounded = math.floor(number);
  else
    rounded = math.ceil(number);
  end;

  if (rounded == 0) then return 0; end;
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
  if (not(list)) then 
      return function()
        return nil;
      end;
  end;

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

  SS_Shared_ForEach({ target:GetChildren() })(function(child)
    child:Hide();
  end);
  
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

SS_Shared_NumFromStr = function(strWithNum)
  return tonumber(string.match(strWithNum, "%-?%d+"));
end;