:- use_module(library(clpfd)).
:- use_module(cost).
:- use_module(utils).
:- use_module(small_data).
:- use_module(print).

% Главный предикат программы
main :-
    clean, 											% Очистка текущих данных
    findall(E, exam(E, _), Exams),				    % Получение списка всех экзаменов
    prepare_env(Exams), 							% Подготовка среды для расписания
    length(Exams, LenExam),						    % Вычисление количества экзаменов
    ucs_traverse(node([], 0, 0), LenExam, Events),  % Построение расписания
    cost(schedule(Events), Cost), 					% Расчет итоговой стоимости расписания
    format("~nSCHEDULE:~n"),						% Вывод заголовка расписания
    pretty_print(schedule(Events)), 				% Печать расписания
    format("~nTotal penalty: ~f~n", Cost), 			% Вывод итоговой стоимости
    !.

% Определение соседей текущего узла
neighbors(node(State, Length, _), node([event(ExamID, RoomID, Day, Hour) | State], NewLength, NewCost)) :-
    % Определение диапазона доступных дней
    ex_season_starts(FirstDay),
    ex_season_ends(LastDay),
    between(FirstDay, LastDay, Day),
	% =============
    NewLength #= Length + 1, 													% Увеличение длины состояния
    exam(ExamID, _), 															% Выбор экзамена
    \+ member(event(ExamID, _, _, _), State),									% Проверка, что экзамен ещё не запланирован
    exam_duration(ExamID, Duration), 											% Получение продолжительности экзамена
    classroom_available(RoomID, Day, From, Till), 								% Проверка доступности аудитории
    Dur #= Till - Duration,
    between(From, Dur, Hour), 													% Определение времени начала экзамена
    st_group(ExamID, Students), 												% Получение списка студентов на экзамене
    length(Students, LenSt), 													% Количество студентов
    classroom_capacity(RoomID, CapRoom), 										% Вместимость аудитории
    LenSt #=< CapRoom, 															% Проверка соответствия вместимости аудитории
    not_intersected(ExamID, RoomID, Day, Hour, Duration, State), 				% Проверка на пересечение
    cost(schedule([event(ExamID, RoomID, Day, Hour) | State]), NewCost). 		% Расчет стоимости для нового состояния

% Проверка на пересечение экзаменов
not_intersected(_, _, _, _, _, _). 									% Условие отсутствия пересечений по умолчанию
not_intersected(ExamID, RoomID, Day, Hour, Duration, State) :-
    member(event(OtherExamID, OtherRoomID, Day, OtherHour), State), % Проверка экзаменов в тот же день
    exam_duration(OtherExamID, OtherDuration),
    OtherHour #< Hour + Duration, 									% Проверка времени пересечения
    Hour #< OtherHour + OtherDuration,
    (   															% Проверка условий пересечения
        OtherRoomID = RoomID;
        teacher_teaches_both_classes(ExamID, OtherExamID);
        student_follows_both_classes(ExamID, OtherExamID)
    ),
    !, fail. 														% Пересечение найдено — возвращаем провал

% Алгоритм обхода с использованием UCS
ucs_traverse(node(_, NeededLength, _), NeededLength, _) :- !. 							% Базовый случай: достигнута нужная длина
ucs_traverse(node(State, Length, Cost), NeededLength, [NewEvent | Events]) :-
    findall(																			% Генерация всех соседей текущего узла
        node(NState, NLength, NCost),
        limit(1000, neighbors(node(State, Length, Cost), node(NState, NLength, NCost))),
        Neighbors 																	
    ),
    sort(3, @<, Neighbors, [node([NewEvent | Rest], NewLen, NewCost) | _]), 			% Сортировка соседей по стоимости
    ucs_traverse(node([NewEvent | Rest], NewLen, NewCost), NeededLength, Events). 		% Рекурсивный вызов для следующего узла
