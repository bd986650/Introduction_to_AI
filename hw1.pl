/*
 * Logical puzzle.
 *
 * Butsie is a brown cat, Cornie is a black cat, Mac is a red cat.
 * Flash, Rover and Spot are dogs. Flash is a spotted dog, Rover
 * is a red dog and Spot is a white dog. Fluffy is a black dog.
 *
 * Tom owns any Pet that is either brown or black. Kate owns all
 * non-white dogs, not belonging to Tom.
 *
 * All pets Kate or Tom owns are pedigree animals.
 *
 * Alan owns Mac if Kate does not own Butsie and Spot is not a pedigree
 * animal.
 *
 * Write a Prolog program that answers, which animals do not have an owner.
*/

cat(butsie).
cat(cornie).
cat(mac).

dog(flash).
dog(rover).
dog(spot).
dog(fluffy).

color(butsie, brown).
color(cornie, black).
color(mac, red).

color(flash, spotted).
color(rover, red).
color(spot, white).
color(fluffy, black).

has(tom, Pet) :- (color(Pet, brown); color(Pet, black)).

has(kate, Pet) :- dog(Pet), (color(Pet, red); color(Pet, spotted)), \+ has(tom, Pet).

has(alan, mac) :- \+ has(kate, butsie), \+ pedigree(spot).

pedigree(Pet) :- (has(tom, Pet); has(kate, Pet)).

res(Pet) :- (cat(Pet); dog(Pet)), \+ has(tom, Pet), \+ has(kate, Pet), \+ has(alan, Pet).  
