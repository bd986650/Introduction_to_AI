reactor(adtina).
reactor(comati).
reactor(dynotis).
reactor(tamura).

principle(tp).
principle(dd).
principle(fusor).
principle(poly).

month(jan).
month(feb).
month(mar).
month(apr).

country(ecuador).
country(france).
country(qatar).
country(zambia).

% 1.
% The reactor launching in March is either the direct drive reactor or the reactor in France.
% Реактор, запущенный в Марте - это либо DD реактор, либо реактор, построенный во Франции.
first(P, M, C) :- (principle(P), month(M), country(C)), 
    (M = mar, ((P = dd, C \= france) ; (P \= dd, C = france)) ; (M \= mar ->  true)).

% 2.
% The Comati DX5 will not launch in January.
% Реактор Comati DX5 был запущен НЕ в Январе.
second(R, M) :- (reactor(R), month(M)), ((R = comati, M \= jan) ; (R \= comati ->  true)).

% 3.
% Реактор, запущенный в Марте, TP реактор и реактор в Замбии - это три разных реактора.
% The facility launching in March, the theta pinch facility, and the facility in Zambia are three different reactors.
third(P, M, C) :- (principle(P), month(M), country(C)),
    (((M = mar, P \= tp, C \= zambia); (M \= mar, P = tp, C \= zambia); (M \= mar, P \= tp, C = zambia)) ; ((M \= mar, P \= tp, C \= zambia) ->  true)).

% 4.
% Реактор, запущенный в Январе - это либо TP реактор, либо реактор из Катара.
% The reactor launching in January is either the theta pinch facility or the reactor in Qatar.
fourth(P, M, C) :- (principle(P), month(M), country(C)) , ((M = jan, ((P = tp, C \= qatar);(P \= tp, C = qatar))) ; ((M \= jan) ->  true)).

% 5.
% Из двух реакторов, TP реактор и реактор, запущенный в Феврале, один - это Comati DX5, а другой из Эквадора.
% Of the reactor launching in February and the theta pinch reactor, one is the Comati DX5 and the other is in Ecuador.
fifth(R, P, M, C) :- (reactor(R), principle(P), month(M), country(C)),
    (((P = tp, M \= feb, ((R = comati, C \= ecuador) ; (R \= comati, C = ecuador))) ; (P \= tp, M = feb, ((R = comati, C \= ecuador) ; (R \= comati, C = ecuador))));
    ((P \= tp, M \= feb) ->  true)).

% 6.
% The Tamura BX12 is in Zambia.
% Реактор Tamura BX12 построен в Замбии.
sixth(R, C) :- (R \= tamura -> true ; (R = tamura, C = zambia)).

% 7.
% The facility launching in April, the Adtina V, and the fusor facility are three different reactors.
% Реактор, запущенный в Апреле, Adtina V и fusor-реактор - это три разных реактора.
seventh(R, M, P) :- (reactor(R), month(M), principle(P)),
    (((M = apr, R \= adtina, P \= fusor) ; (M \= apr, R = adtina, P \= fusor) ; (M \= apr, R \= adtina, P = fusor)) ;
    ((M \= apr, R \= adtina, P \= fusor) ->  true)).

% 8.
% The facility in Qatar is either the facility launching in March or the Dynotis X1.
% Реактор из Катара - это либо реактор, запущенный в Марте, либо Dynotis X1.
eighth(R, M, C) :- (reactor(R), month(M), country(C)),
    ((C = qatar, ((M = mar, R \= dynotis) ; (M \= mar, R = dynotis))) ; C \= qatar ->  true).

sol(Solution) :-
    Solution = [jan-R1-P1-С1, feb-R2-P2-C2, mar-R3-P3-C3, apr-R4-P4-C4],

    permutation([comati, dynotis, adtina, tamura], [R1, R2, R3, R4]),
    (R1 \= R2, R1 \= R3, R1 \= R4), (R2 \= R3, R2 \= R4), (R3 \= R4),

    permutation([fusor, tp, dd, poly], [P1, P2, P3, P4]),
    (P1 \= P2, P1 \= P3, P1 \= P4), (P2 \= P3, P2 \= P4), (P3 \= P4),

    permutation([ecuador, qatar, zambia, france], [С1, C2, C3, C4]),
    (С1 \= C2, С1 \= C3, С1 \= C4), (C2 \= C3, C2 \= C4), (C3 \= C4),

    % Januray
    first(P1, jan, С1),
    second(R1, jan),
    third(P1, jan, С1),
    fourth(P1, jan, С1),
    fifth(R1, P1, jan, С1),
    sixth(R1, С1),
    seventh(R1, jan, P1),
    eighth(R1, jan, С1),

    % February
    first(P2, feb, C2),
    second(R2, feb),
    third(P2, feb, C2),
    fourth(P2, feb, C2),
    fifth(R2, P2, feb, C2),
    sixth(R2, C2),
    seventh(R2, feb, P2),
    eighth(R2, feb, C2),

    % March
    first(P3, mar, C3),
    second(R3, mar),
    third(P3, mar, C3),
    fourth(P3, mar, C3),
    fifth(R3, P3, mar, C3),
    sixth(R3, C3),
    seventh(R3, mar, P3),
    eighth(R3, mar, C3),

    % April
    first(P4, apr, C4),
    second(R4, apr),
    third(P4, apr, C4),
    fourth(P4, apr, C4),
    fifth(R4, P4, apr, C4),
    sixth(R4, C4),
    seventh(R4, apr, P4),
    eighth(R4, apr, C4).
