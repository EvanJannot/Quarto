%Définition des pièces (couleur,forme,taille,remplissage,positionX,positionY,état en jeu)
%BLANC
%Carrés
piece(bcht,blanc,carre,haut,trou).
piece(bchp,blanc,carre,haut,plein).
piece(bcbt,blanc,carre,bas,trou).
piece(bcbp,blanc,carre,bas,plein).
%Ronds
piece(brhp,blanc,rond,haut,plein).
piece(brht,blanc,rond,haut,trou).
piece(brbp,blanc,rond,bas,plein).
piece(brbt,blanc,rond,bas,trou).


%NOIR
%Carrés
piece(ncht,noir,carre,haut,trou).
piece(nchp,noir,carre,haut,plein).
piece(ncbt,noir,carre,bas,trou).
piece(ncbp,noir,carre,bas,plein).
%Ronds
piece(nrhp,noir,rond,haut,plein).
piece(nrht,noir,rond,haut,trou).
piece(nrbp,noir,rond,bas,plein).
piece(nrbt,noir,rond,bas,trou).

afficheID():-
    write('--- Explication de l\'identifiant : ---'),
    nl,
    nl,
    write('- Première lettre = couleur (n = noir, b = blanc)'),
    nl,
    write('- Deuxième lettre = forme (c = carré, r = rond)'),
    nl,
    write('- Troisième lettre = taille (h = haut, b = bas)'),
    nl,
    write('- Quatrième lettre = remplissage (p = plein, t = trou)'),
    nl,
    nl,
    write('Exemple : bcht = Blanc Carré Haut Trou'),
    nl.

winPos([[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16],[1,5,9,13],[2,6,10,14],[3,7,11,15],[4,8,12,16],[1,6,11,16],[4,7,10,13]]).
winCon([]).

finPartie(T):-
    J is mod(T,2),
    nl,
    write('La partie est terminée'),
    nl,
    write('Le joueur : '),
    ( J==0 ->   
    J2 is J+2,
    write(J2);
    write(J)),
    write(' a gagné.'),
    nl,
    choixPiece(_,_,_,_,1,_).

compareChar(C1,C2,C3,C4,T):-
    (   (   atom_number(C1,_); atom_number(C2,_); atom_number(C3,_); atom_number(C4,_))
    -> write('');
    (   (   C1==C2, C2==C3, C3==C4)
    -> (C1=='_' ->   write('');
       finPartie(T));
    write('')
    )
    ).

recupChar(L,I,T):-
    (   I=< 120 -> 
    nth0(I,L,L1),
    I1 is I+1,
    I2 is I+2,
    I3 is I+3,
    nth0(I1,L,L2),
    nth0(I2,L,L3),
    nth0(I3,L,L4),
    IA is I+4,
    compareChar(L1,L2,L3,L4,T),
    recupChar(L,IA,T);   
    write('')).

isWinner(L,T,E,Case,ListeLettres):- 
    (   Case=<3 ->  
      (   E=<39 ->  
       	 winPos(D),
         flatten(D,W),
         nth0(E,W,Q),
         nth1(Q,L,X),
         sub_atom(X,Case,1,_,Char),
         E1 is E+1,
         append(ListeLettres,[Char],NewListe),
         isWinner(L,T,E1,Case,NewListe);
         CaseBis is Case+1,
         isWinner(L,T,0,CaseBis,ListeLettres));
        recupChar(ListeLettres,0,T)).

afficheGrille(K):-
    write('--- Affichage de la grille : ---'),
    nl,
    nl,
    afficheLigne(),
    nl,
    affichePiece(1,K),
    nl,
    afficheLigne(),
    nl,
    affichePiece(2,K),
    nl,
    afficheLigne(),
    nl,
    affichePiece(3,K),
    nl,
    afficheLigne(),
    nl,
    affichePiece(4,K),
    nl,
    afficheLigne().

listePiece([bcht,bchp,bcbt,bcbp,brhp,brht,brbp,brbt,ncht,nchp,ncbt,ncbp,nrhp,nrht,nrbp,nrbt]).
piecePosee(['__01_', '__02_', '__03_','__04_', '__05_', '__06_', '__07_', '__08_', '__09_', '__10_', '__11_', '__12_', '__13_', '__14_', '__15_','__16_']).
affichePiece(I,K):-
    (I==1 ->  
    write('|'),
    nth0(0,K,X1),
    write(X1),
    write('|'),
    nth0(1,K,X2),
    write(X2),
    write('|'),
    nth0(2,K,X3),
    write(X3),
    write('|'),
    nth0(3,K,X4),
    write(X4),
    write('|');
    
    I ==2 ->  
    write('|'),
    nth0(4,K,X5),
    write(X5),
    write('|'),
    nth0(5,K,X6),
    write(X6),
    write('|'),
    nth0(6,K,X7),
    write(X7),
    write('|'),
    nth0(7,K,X8),
    write(X8),
    write('|');
    
    I==3 ->  
    write('|'),
    nth0(8,K,X9),
    write(X9),
    write('|'),
    nth0(9,K,X10),
    write(X10),
    write('|'),
    nth0(10,K,X11),
    write(X11),
    write('|'),
    nth0(11,K,X12),
    write(X12),
    write('|');
    
    I==4 ->  
    write('|'),
    nth0(12,K,X13),
    write(X13),
    write('|'),
    nth0(13,K,X14),
    write(X14),
    write('|'),
    nth0(14,K,X15),
    write(X15),
    write('|'),
    nth0(15,K,X16),
    write(X16),
    write('|')
    ).
                                                                        
afficheLigne():-
    write('=======================').

verifID(ID,X,T,L):- 
    nl,
    nl,
    (   0 is mod(T,2) ->  
   	write('--- J1 choisi un identifiant ---'),
    nl,
    nl,
    read(ID),
    nl,
    (   member(ID,L) ->
    write('Cette pièce a déjà été posée, prenez en une autre.'),
    verifID(_,X,T,L);
    (piece(ID,_,_,_,_) ->  X=ID;
    write('Cette ID n\'existe pas veuillez en sélectionner un autre.'),
    verifID(_,X,T,L)));
   	write('--- J2 choisi un identifiant ---'),
    nl,
    nl,
    read(ID),
    nl,
    (   member(ID,L) ->
    write('Cette pièce a déjà été posée, prenez en une autre.'),
    verifID(_,X,T,L);
    (piece(ID,_,_,_,_) ->  X=ID;
    write('Cette ID n\'existe pas veuillez en sélectionner un autre.'),
    verifID(_,X,T,L)))).

verifCase(C,X,L,ID,T):-
    (   0 is mod(T,2) ->  
    write('--- J2 choisi une case ---'),
    nl,
    nl,
    read(C),
    nl,
    ( C=<16 ->  
    C1 is C-1,
    nth0(C1,L,E),
    (piece(E,_,_,_,_)-> 
    write('Cette case est déjà prise veuillez en sélectionner une autre.'),
    nl,
    nl,
    verifCase(_,X,L,ID,T) ;
    X=C);
    write('Cette case n\'existe pas veuillez en sélectionner une autre.'),
    nl,
    nl,
    verifCase(_,X,L,ID,T));
     write('--- J1 choisi une case ---'),
    nl,
    nl,
    read(C),
    nl,
    ( C=<16 ->  
    C1 is C-1,
    nth0(C1,L,E),
    (piece(E,_,_,_,_)-> 
    write('Cette case est déjà prise veuillez en sélectionner une autre.'),
    nl,
    nl,
    verifCase(_,X,L,ID,T) ;
    X=C);
    write('Cette case n\'existe pas veuillez en sélectionner une autre.'),
    nl,
    nl,
    verifCase(_,X,L,ID,T))).

replace(I, L, E, K) :-
  nth1(I, L, _, R),
  nth1(I, K, E, R).

stopProlog(I):-
    piece(I,_,_,_,_).

choixPiece(ID,C,L,T,WinState,J):-
    (   WinState ==0 ->  
    winCon(ListeLettres),
    verifID(ID,ID2,T,L),
    verifCase(C,C2,L,ID2,T),
    replace(C2,L,ID2,K),
    afficheID(),
    nl,
    afficheGrille(K),
    isWinner(K,T,0,0,ListeLettres),
    T2 is T+1,
    select(ID2,J,R),
    nl,
    write('Liste des coups jouables :'),
    write(R),
    conseilPiece(R),
    choixPiece(_,_,K,T2,WinState,R);
    stopProlog(0)).

affichePiece(I):-
    (   piece(I,_,_,_,_) ->  write('');
    write(piece(_,_,_,_,_))).
    
choixPiece(ID,X):- 
    write('=== QUARTO by FRANCIS & ETHAN =='),
    nl,
    nl,
    afficheID(),
    nl,
    piecePosee(L),
    afficheGrille(L),
    listePiece(J),
    choixPiece(ID,X,L,2,0,J).

conseilPiece(L):- 
    nth0(0,L,T),
    (   T\=''  ->  
    length(L,Y),
    nl,
    random(0,Y,R),
    nth0(R,L,X),
    write('Coup conseillé : '),
    write(X);
    write('R existe pas')).

jouer():-
    choixPiece(_,_).

