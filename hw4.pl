:- dynamic derived/1.
:- dynamic asked/1.

:- op(800, xfx, <==).
:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(200, xfy, and).

:- retractall(derived(_)), retractall(asked(_)).

% rules

% 1 заложен нос и слизь - насморк
if
    i_have_a_stuffy_nose and i_have_mucus_from_my_nose
then
    i_have_a_runny_nose.

% 2 насморк и чихание и зуд - аллергия
if
    i_have_a_runny_nose and i_am_sneezing and i_have_an_itch
then
    i_have_allergies.

% 3 сыпь на коже и зуд - часотка
if
    i_have_an_itch and i_have_a_rus_on_my_skin
then
    i_have_scabies.

% 4 на коже пустулы или фликтены и часотка -- пиодермия
% пустулы и фликтены особые воспаления кожи. пиодермия осложнение часотки.
if
    i_have_scabies and i_have_pustules_or_flickens_on_my_skin
then
    i_have_pyoderma.

% 5 насморк и чихание и усталость и температура - орви
if
    i_have_a_runny_nose and i_am_sneezing and i_have_fatigue and i_have_a_fever
then
    i_have_ARVI.

% 6 симпоты ОРВИ и гной в горле - тонзиллит
if
    i_have_pus_in_my_throat and i_have_ARVI
then
    i_have_tonsillitis.

% 7 усталость и нету аппетита и кашель и потеря веса - рак легких
if
    i_have_fatigue and i_have_no_appetite and i_have_cought and i_have_weight_loss
then
    i_have_lung_cancer.

% 8 синдромы орви + нету запахов или вкусов - ковид
if
    i_have_ARVI and (i_cant_smell or i_cant_taste_the_food)
then
    i_have_a_caronovirus.

% 9 усталость + температура + озноб + интоксикация - грипп
if
    i_have_fatigue and i_have_a_fever and i_have_chills and i_am_intoxicated
then
    i_have_the_flu.

% 10 все симпотмы грипа и болят суставы и кашель без крови - бронхит
if
    i_have_the_flu and my_joints_hurt and i_have_a_cough_without_blood
then
    i_have_bronchitis.

% 11 отдышка и кашель и сдавленность в груди - астма
if
    i_am_short_of_breath and i_have_cought and i_feel_pressure_in_my_chest
then
    i_have_asthma.

% 12 астма + приступы удушья - тяжелая бронхиальная астма
if
    i_have_asthma and i_have_constant_attacks_of_suffocation
then
    i_have_severe_bronchial_asthma.

% 13 головные боли + повышенная чувствительность к свету - мигрень
if
    i_have_a_headache and i_have_an_increased_sensitivity_to_light
then
    i_have_a_migraine.

% 14 болят суставы или жжение в области суставов или утренняя скованноть - артрит
if
    my_joints_hurt or i_have_a_burning_sensation_in_my_joints or i_have_morning_stiffness
then
    i_have_arthritis.

% 15 боль в глазах + головные боли + гало вокрух света - глаукома
if
    i_have_pain_in_my_eyes and i_have_a_headache and i_have_a_halo_around_the_light_sources
then
    i_have_glaucoma.


% rules

askable(i_have_cought).                            % есть кашель
askable(i_have_a_stuffy_nose).                     % заложен нос
askable(i_have_mucus_from_my_nose).                % выделяется слизь из носа
askable(i_am_sneezing).                            % я постоянно чихаю
askable(i_have_an_itch).                           % зуд
askable(i_have_a_rus_on_my_skin).                  % сыпь на коже
askable(i_have_pustules_or_flickens_on_my_skin).   % на коже пустулы или фликтены
askable(i_have_fatigue).                           % усталость
askable(i_have_a_fever).                           % температура
askable(i_have_pus_in_my_throat).                  % гной в горле
askable(i_have_no_appetite).                       % нет аппетита
askable(i_have_weight_loss).                       % потеря веса
askable(i_cant_smell).                             % я не чувствую запахи
askable(i_cant_taste_the_food).                    % я не чувствую вкус пищи
askable(i_have_chills).                            % озноб
askable(i_am_intoxicated).                         % интоксикация
askable(my_joints_hurt).                           % болять суставы
askable(i_have_a_cough_without_blood).             % мой кашель без крови
askable(i_am_short_of_breath).                     % отдышка
askable(i_feel_pressure_in_my_chest).              % я чувствую давление в груди
askable(i_have_constant_attacks_of_suffocation).   % постоянные приступы удушья
askable(i_have_a_headache).                        % головная боль
askable(i_have_an_increased_sensitivity_to_light). % повышенная чувствительность к свету
askable(i_have_a_burning_sensation_in_my_joints).  % чувство жжения в суставах
askable(i_have_morning_stiffness).                 % утренняя скованность
askable(i_have_pain_in_my_eyes).                   % боль в глазах.
askable(i_have_a_halo_around_the_light_sources).   % гало вокруг источников света


true(Statement, Proof) :-
    retractall(derived(_)),
    retractall(asked(_)),
    true(Statement, Proof, []).

true(Statement, Statement, _) :- derived(Statement).

true(S1 and S2, P1 and P2, Trace) :-
    true(S1, P1, Trace),
    true(S2, P2, Trace).

true(S1 or S2, P, Trace) :-
    true(S1, P, Trace) ; true(S2, P, Trace).

true(Conclusion, Conclusion <== ConditionProof, Trace) :-
    if Condition then Conclusion,
    true(Condition, ConditionProof, [if Condition then Conclusion | Trace]).

true(Statement, Proof, Trace) :-
    askable(Statement),
    \+ derived(Statement),
    \+ asked(Statement),
    ask(Statement, Proof, Trace).


ask(Statement, Proof, Trace) :-
    format('\nIs it true that ~w ? Please answer \'yes\', \'no\' or \'why\'.\n',[Statement]),
    read_string(user_input, "\n", "\r\t", _, Answer),
    response(Answer, Statement, Proof, Trace).


response("yes", S, S <== was_told, _) :- !,
    asserta(derived(S)),
    asserta(asked(S)).

response("no", S, _, _) :- !,
    asserta(asked(S)),
    fail.

response("why", Statement, Proof, Trace) :- !,
    print_reasoning_chain(Trace, 0), nl,
    ask(Statement, Proof, Trace).

response(_, Statement, Proof, Trace) :-
    write('Please answer only \'yes\', \'no\' or \'why\'!\n'),
    read_string(user_input, "\n", "\r\t", _, Answer),
    response(Answer, Statement, Proof, Trace).


print_reasoning_chain([], _).
print_reasoning_chain([if Cond then Concl | Rules], _) :-
    format('\n   To infer ~w, using rule\n\t   (if ~w then ~w)',
           [Concl, Cond, Concl]), print_reasoning_chain(Rules, _).

demo() :-
    true(i_have_allergies, St),
    format('\n ~w', [St]).
