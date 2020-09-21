function SS_DiceRollConvey(skillName, params)
    if (params.beforeAll) then
        params.beforeAll();
    end;

    if (params.beforeDiceCountGeneration) then
        params.beforeDiceCountGeneration();
    end;

    local diceCount = SS_GetDicesCount();

    if (params.afterDiceCountGeneration) then
        params.afterDiceCountGeneration(diceCount);
    end;

    if (params.beforeDiceGeneration) then
        params.beforeDiceCountGeneration(diceCount);
    end;

    local dices = {
        from = SS_GetMinimumDiceRoll(skillName),
        to = SS_GetMaximumDiceRoll(skillName),
    };

    dices.average = (dices.from + dices.to) / 2;

    if (params.afterDiceGeneration) then
        params.afterDiceGeneration(dices, diceCount);
    end;

    if (params.beforeDiceRoll) then
        params.beforeDiceRoll(dices, diceCount);
    end;

    local maxResult = 0;
    local results = { }
    for i = 1, diceCount do
        local result = math.random(dices.from, dices.to);
        if (result > maxResult) then maxResult = result; end;
        table.insert(results, result);
    end;

    if (params.afterDiceRoll) then
        params.afterDiceRoll(results, dices, diceCount);
    end;

    if (params.beforeStatModifierGeneration) then
        params.beforeStatModifierGeneration();
    end;

    local statModifier = SS_GetStatToSkillModifier(skillName);

    if (params.afterStatModifierGeneration) then
        params.afterStatModifierGeneration(statModifier, results, dices, diceCount);
    end;

    if (params.beforeFinalResultGeneration) then
        params.beforeFinalResultGeneration();
    end;

    local finalResult = maxResult + statModifier;

    if (params.afterFinalResultGeneration) then
       params.afterFinalResultGeneration(finalResult, statModifier, results, dices, diceCount);
    end;

    return finalResult;
end;