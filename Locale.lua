local SS_TEXT = {
    melee = 'Ближний бой',
    meleeDescription = 'Применяется для всех атак, проводимых в ближнем бою.',
    meleeExample = 'Ударить дубиной, парировать атаку.',
    range = 'Дальний бой',
    rangeDescription = 'Применяется для всех атак, проводимых в дальнем бою.',
    rangeExample = 'Выстрел, бросок предмета',
    magic = 'Чародейство',
    magicDescription = 'Применяется для атак с использованием магии.',
    magicExample = 'Заклинания колдунов, магов.',
    religion = 'Вера',
    religionDescription = 'Применяется для атак, основанных на веровании персонажа.',
    religionExample = 'Свет, шаманизм, друидизм.',
    perfomance = 'Выступление',
    perfomanceDescription = 'Применяется для действий связанных с психологическим воздействием на других персонажей.',
    perfomanceExample = 'Обман, убеждение, привлечение внимания.',
    missing = 'Избегание',
    missingDescription = 'Применяется для проверок побега и отклонения от урона по области.',
    missingExample = 'Избегание атаки, урона от ловушки, побег.',
    hands = 'Ловкость рук',
    handsDescription = 'Применяется для действий, требующих мелкой моторики.',
    handsExample = 'Карманная кража, взлом замков.',
    athletics = 'Атлетика',
    athleticsDescription = 'Используется для проверок силового взаимодействия персонажа и окружения.',
    athleticsExample = 'Удержать крупный камень, залезть на выступ.',
    observation = 'Внимательность',
    observationDescription = 'Применяется для проверок, основанных на умении отмечать мелкие детали.';
    observationExample = 'Обнаружить тайный рычаг, спрятанный предмет.',
    knowledge = 'Знание',
    knowledgeDescription = 'Применяется для проверок знания о мире, существах или истории.',
    knowledgeExample = 'Опознать существо, прочесть древний текст.',
    controll = 'Самоконтроль',
    controllDescription = 'Применяется для противодействию ментальному и псих. воздействиям.',
    controllExample = 'Сопротивление испугу, очарованию.',
    judgment = 'Суждение',
    judgmentDescription = 'Применяется для формирования корректных выводов на основе имеющейся информации.',
    judgmentExample = 'Распознать истинные намерения собеседника.',
    acrobats = 'Акробатика',
    acrobatsDescription = 'Используется для проверок ловких взаимодействий игрока с миром.',
    acrobatsExample = 'Баланс на узком уступе, прыжок в длину.',
    stealth = 'Скрытность',
    stealthDescription = 'Применяется для действий, которые требуется совершить незаметно.',
    stealthExample = 'Красться, Прятаться от противника.',
    power = 'Мощь',
    powerDescription = 'Облегчает проверки ближнего боя и атлетики.',
    accuracy = 'Точность',
    accuracyDescription = 'Облегчает проверки дальнего боя и внимательности.',
    wisdom = 'Мудрость',
    wisdomDescription = 'Облегчает проверки чародейства и знания.',
    morale = 'Мораль',
    moraleDescription = 'Облегчает проверки веры и самоконтроля.',
    empathy = 'Эмпатия',
    empathyDescription = 'Облегчает проверки выступления и суждения.',
    mobility = 'Подвижность',
    mobilityDescription = 'Облегчает проверки избегания и акробатики.',
    precision = 'Аккуратность',
    precisionDescription = 'Облегчает проверки ловкости рук и скрытности.',
    light = 'Легкое',
    lightDescription = 'Повседневная одежда, ряса, и другое сопоставимое.',
    lightBonus = 'Не дает очков защиты',
    lightPenalty = 'Не накладывает штрафов',
    lightPenaltyList = '',
    medium = 'Стандартное',
    mediumDescription = 'Кожаная, кольчужная, броня из легких металлов и другое сопоставимое.',
    mediumBonus = 'Добавляет 1 ОБ за 2 ОЗ',
    mediumPenalty = 'Небольшой штраф на',
    mediumPenaltyList = 'Чародейство, избегание, ловкость рук, акробатика, скрытность',
    heavy = 'Тяжёлое',
    heavyDescription = 'Все варианты латных и других сопоставимых видов брони.',
    heavyPenalty = 'Большой штраф на',
    heavyBonus = 'Добавляет 1 ОБ за 1.5 ОЗ',
    heavyPenaltyList = 'Дальний бой, чарод-во, избегание, ловкость рук, внимательность, акробатика, скрытность',
    example = 'Пример',
};

SS_Locale = function(word)
    return SS_TEXT[word] or 'NO LOCALE FOR \''..word..'\'';
end;