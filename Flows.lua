function SS_DiceRollFlow(skillName, params)
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

    if (params.onModifierGet) then
        params.onModifierGet(statModifier, results, dices, diceCount);
    end;

    local finalResult = maxResult + statModifier;

    if (params.afterAll) then
       params.afterAll(finalResult, statModifier, results, dices, diceCount);
    end;

    return finalResult;
end;

function SS_EfficencyRollFlow(skillName, params)
    if (params.beforeAll) then
        params.beforeAll();
    end;

    local statValue = SS_GetStatValue(SS_GetAssociatedStatOfSkill(skillName));

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