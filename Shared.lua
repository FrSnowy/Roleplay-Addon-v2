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

SS_Shared_SAM = function(prefix, action, data, target, channel)
  if (not(channel)) then channel = "WHISPER"; end;
  if (#data > 200) then
    messages = SS_Shared_SAM_Split_String(data);
    local timeStamp = SS_Shared_TimeStamp();
    SS_Shared_ForEach(messages)(function(msg, index)
      if (index == 1) then
        SendAddonMessage(prefix, '~'..action..'|'..timeStamp..'|'..msg, channel, target);
      elseif (index == #messages) then
        SendAddonMessage(prefix, action..'|'..timeStamp..'|'..msg..'~', channel, target);
      else
        SendAddonMessage(prefix, action..'|'..timeStamp..'|'..msg, channel, target);
      end;
    end);
  else
    SendAddonMessage(prefix, '~'..action..'|'..data..'~', channel, target);
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

  list = SS_Shared_SortTable(list);

  return function(callback)
    for index, element in pairs(list) do
      callback(element, index, list);
    end;
  end;
end;

SS_Shared_ForEachWithComparator = function(list, comparator)
  if (not(list)) then 
      return function()
        return nil;
      end;
  end;

  local finishedTable = {};

  SS_Shared_ForEach(list)(function(el, index)
    finishedTable[el.order] = el;
    finishedTable[el.order].index = index;
  end);

  return function(callback)
    for index, element in pairs(finishedTable) do
      callback(element, index, finishedTable);
    end;
  end;
end;

SS_Shared_Includes = function(list)
  list = SS_Shared_SortTable(list);

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

SS_Shared_IsPlayerInRaidOrParty = function(name)
  local isInParty = GetNumPartyMembers() > 0;
  local isInRaid = UnitInRaid("player") and GetNumRaidMembers() > 0;

  local targetIndex = nil;

  if (isInParty and not(isInRaid) and targetIndex == nil) then
    SS_Shared_ForEach({ 1, 2, 3, 4})(function(i)
      local lookFor = "party"..i;
      local n = UnitName(lookFor);
      if (n == name) then targetIndex = lookFor; end;
    end);
  elseif (isInRaid and targetIndex == nil) then
    local possilbleRaidMembers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 };
    SS_Shared_ForEach(possilbleRaidMembers)(function(i)
      local lookFor = "raid"..i;
      local n = UnitName(lookFor);
      if (n == name) then targetIndex = lookFor; end;
    end);
  end;

  return targetIndex;
end;

SS_Shared_IfOnline = function(target, callback)
  local playerInPartyIndex = SS_Shared_IsPlayerInRaidOrParty(target);

  if (playerInPartyIndex == nil) then
    -- Если юнит не в пати - используем систему с запрос-ответом
    if (not(SS_Shared_IfOnlineCallback)) then
      SS_Shared_IfOnlineCallback = { };
    end;
  
    local timestamp = SS_Shared_TimeStamp();
  
    SS_Shared_IfOnlineCallback[target..'+'..timestamp] = callback;
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", SS_Shared_IgnoreOfflineMsgFilter);
    SS_PtP_IsOnline(target, timestamp);
  else
    -- Если юнит в пати - можно по-другому
    local unitIsConnected = UnitIsConnected(playerInPartyIndex) == 1;
    if (not(unitIsConnected)) then return nil end;
    if (unitIsConnected) then callback(); end;
  end;
end;

SS_Shared_IsNumber = function(str)
  return string.match(str, "^%-?%d+$");
end;

SS_Shared_NumFromStr = function(strWithNum)
  return tonumber(string.match(strWithNum, "%-?%d+"));
end;