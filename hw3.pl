:- prolog_load_context(directory, Dir), 
    atom_concat(Dir, '/wordnet', WNDB_),
    absolute_file_name(WNDB_, WNDB), 
    asserta(user:file_search_path(wndb, WNDB)).
:- use_module('desktop/projects/nsu/prolog/wnload/prolog/wn').
:- use_module(library(clpfd)).

search_relation(A, B, Relation) :- ((wn_hyp(A, B); wn_hyp(B, A)), Relation = hyp);
                            ((wn_mm(A, B); wn_mm(B, A)), Relation = mm);
                            ((wn_mp(A, B); wn_mp(B, A)), Relation = mp).

move([S|Tail], [New, Relation, S|Tail]) :-
   search_relation(S, New, Relation), \+member(New, Tail).

dfs([Finish|Tail], Finish, [Finish|Tail], 0).
dfs(CurrentWay, Finish, Way, N) :- 
    N > 0, 
    move(CurrentWay, NewWay),
    N1 is N - 1, 
    dfs(NewWay, Finish, Way, N1).

print_relation([_], Acc, Acc).  
print_relation([Syn1, Relation, Syn2|Tail], Acc, Con) :-
    wn_s(Syn1, _, W1, P1, Sen1, _),
    wn_s(Syn2, _, W2, P2, Sen2, _),
    New = r(W1/P1/Sen1, Relation, W2/P2/Sen2),
    print_relation([Syn2|Tail], [New|Acc], Con).

nums(1).
nums(N) :- nums(M), N is M + 1.

related_words(Word1/PoS1/Sense1/Syn1, Word2/PoS2/Sense2/Syn2, MaxDist, Connection) :-
wn_s(Syn1, _, Word1, PoS1, Sense1, _),
wn_s(Syn2, _, Word2, PoS2, Sense2, _),
nums(L), (L > MaxDist, !, fail; dfs([Syn1], Syn2, Con, L)),     
print_relation(Con, [], Connection).
