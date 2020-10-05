SS_DiceRollFlow = function(skillName, params)
    if (params.beforeAll) then
        params.beforeAll();
    end;

    local diceCount = SS_GetDicesCount();

    if (params.onDiceCountGet) then
        params.onDiceCountGet(diceCount);
    end;

    local dices = {
        from = SS_GetMinimumDiceRoll(skillName),
        to = SS_GetMaximumDiceRoll(skillName),
    };

    dices.average = (dices.from + dices.to) / 2;

    if (params.onDicesGet) then
        params.onDicesGet(dices, diceCount);
    end;

    local maxResult = 0;
    local results = { }
    for i = 1, diceCount do
        local result = math.random(dices.from, dices.to);
        if (result > maxResult) then maxResult = result; end;
        table.insert(results, result);
    end;

    if (params.onRollResultGet) then
        params.onRollResultGet(results, dices, diceCount);
    end;

    local statModifier = SS_GetStatToSkillModifier(skillName);

    if (params.onStatModifierGet) then
        params.onStatModifierGet(statModifier, results, dices, diceCount);
    end;

    local armorModifier = SS_GetArmorModifier(skillName, dices);

    if (params.onArmorModifierGet) then
        params.onArmorModifierGet(armorModifier, statModifier, results, dices, diceCount);
    end;

    local finalResult = maxResult + statModifier + armorModifier;
    if (finalResult < dices.from) then finalResult = dices.from; end;

    if (params.afterAll) then
       params.afterAll(finalResult, armorModifier, statModifier, results, dices, diceCount);
    end;

    return finalResult;
end;

SS_EfficencyRollFlow = function(skillName, params)
    if (params.beforeAll) then
        params.beforeAll();
    end;

    local statValue = SS_Stats_GetValue(SS_Skills_GetStatOf(skillName));

    if (params.onStatValueGet) then
        params.onStatValueGet(statValue);
    end;

    local efficencyMaxValue = math.floor(statValue / 2);
    if (efficencyMaxValue < 1) then efficencyMaxValue = 1; end;

    if (params.onEfficencyMaxValueGet) then
        params.onEfficencyMaxValueGet(efficencyMaxValue, statValue);
    end;

    local finalResult = math.random(1, efficencyMaxValue);

    if (params.afterAll) then
        params.afterAll(finalResult, efficencyMaxValue, statValue);
    end;

    return finalResult;
end;