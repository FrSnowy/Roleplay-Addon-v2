local SS_TEXT = {
    melee = 'Ближний бой',
    range = 'Дальний бой',
    magic = 'Чародейство',
    religion = 'Вера',
    perfomance = 'Выступление',
    hands = 'Ловкость рук',
    stealth = 'Скрытность',
    observation = 'Суждение',
    controll = 'Самоконтроль',
    knowledge = 'Знание',
    athletics = 'Атлетика',
    acrobats = 'Акробатика',
};

function SS_Locale(word)
    return SS_TEXT[word] or 'NO LOCALE';
end;