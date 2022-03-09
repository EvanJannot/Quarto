%Définition des pièces (couleur,forme,taille,remplissage,positionX,positionY,état en jeu)
%BLANC
%Carrés
	%Hauts
piece(bcht). %Trou
piece(bchp). %Plein
	%Bas (Short)
piece(bcst). %Trou
piece(bcsp). %Plein
%Ronds
	%Hauts
piece(brhp). %Plein
piece(brht). %Trou
	%Bas
piece(brsp). %Plein
piece(brst). %Trou

%NOIR
%Carrés
	%Hauts
piece(ncht). %Trou
piece(nchp). %Plein
	%Bas
piece(ncst). %Trou
piece(ncsp). %Plein
%Ronds
	%Hauts
piece(nrhp). %Plein
piece(nrht). %Trou
	%Bas
piece(nrsp). %Plein
piece(nrst). %Trou

%%%   LISTES	%%%

%Liste avec tous les emplacements qui peuvent conduire à une victoire (lignes, colonnes, diagonales)
winPos([[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16],[1,5,9,13],[2,6,10,14],[3,7,11,15],[4,8,12,16],[1,6,11,16],[4,7,10,13]]).
winCon([]).
%Contient toutes les pièces du jeu
listePiece([bcht,bchp,bcst,bcsp,brhp,brht,brsp,brst,ncht,nchp,ncst,ncsp,nrhp,nrht,nrsp,nrst]).
%Contient les pièces qui ont été posées. Cette liste permet de déterminer les coups jouables ou non
piecePosee(['_01_', '_02_', '_03_','_04_', '_05_', '_06_', '_07_', '_08_', '_09_', '_10_', '_11_', '_12_', '_13_', '_14_', '_15_','_16_']).
listeLettresNJ([]).

%%% FONCTIONS DE FIN DU JEU %%%

%Affiche les instructions pour choisir une pièce
afficheID:-
    write('================================================='),
    nl,
    write('--- Explication de l\'identifiant d\'une piece: ---'),
    nl,
    write('================================================='),
    nl,
    nl,
    write('- Premiere lettre = couleur (n = noir, b = blanc)'),
    nl,
    write('- Deuxieme lettre = forme (c = carre, r = rond)'),
    nl,
    write('- Troisieme lettre = taille (h = haut, s = short (bas))'),
    nl,
    write('- Quatrieme lettre = remplissage (p = plein, t = trou)'),
    nl,
    nl,
    write('Exemple : bcht = Blanc Carre Haut Trou'),
    nl.

%Permet de détecter en fonction du numéro du tour qui a gagné la partie
finPartie(T):-
    J is mod(T,2),
    nl,
    write('La partie est finie'),
    nl,
    write('Le joueur : '),
    ( J==0 ->   %Si J modulo 2 vaut 0 on est sur un tour paire donc c'est le joueur 2 qui gagne
    J2 is J+2,
    write(J2);
    write(J)), %Sinon c'est un tour impaire donc le joueur 1 qui gagne 
    write(' a gagne.'),
    nl,
    tourJeu(_,_,1,_). %On appelle la fonction de début de jeu mais avec le paramètre 1 qui indique que 1 joueur a gagné

%Compare 4 caractères ensemble afin de savoir si une ligne, colonne ou diagonale est composée de pièces avec les mêmes caractéristiques
%On vérifie d'abord si ce n'est pas un chiffre (initialement les cases sont de la forme __nbCase__)
%Ensuite on vérifie que ce n'est pas un underscore
%Puis si ce sont les mêmes caractères on termine la partie.
compareChar(C1,C2,C3,C4,T):-
    (   (   atom_number(C1,_); atom_number(C2,_); atom_number(C3,_); atom_number(C4,_))
    -> write('');
    (   (   C1==C2, C2==C3, C3==C4)
    -> (C1=='_' ->   write('');
       finPartie(T));
    write('')
    )
    ).

%Permet de récupérer 4 caractères consécutifs de la liste des pièces sur le plateau.
%Ensuite on appelle la fonction de comparaison des caractères.
recupChar(L,I,T):-
    %On fait tourner 160 fois la fonction car il y a 10 possibilités de victoire (4 lignes, 4 colonnes, 2 diagonales)
    %Dans chaque possibilité il y a 4 cases et dans chaque case 4 caractères donc 10*4*4=160.
    (   I=< 159 -> 
    nth0(I,L,L1), %On prend un élément ...
    I1 is I+1, 
    I2 is I+2,
    I3 is I+3,
    nth0(I1,L,L2), % ... le suivant
    nth0(I2,L,L3), %... le suivant
    nth0(I3,L,L4), %... le suivant, on a donc 4 caractères consecutifs dans L1, L2, L3 et L4
    IA is I+4,
    compareChar(L1,L2,L3,L4,T), %On appelle la fonction qui compare les caractères
    recupChar(L,IA,T);   %On rappelle la fonction en utilisant comme indice de départ le premier + 4 pour comparer 4 nouvelles lettres
    write('')).

%Transforme la liste des éléments de la grille en une liste de caractères pour l'envoyer dans recupChar
isWinner(L,T,E,Lettre,ListeLettres):- 
    %L est la liste des pièces, T le tour, E l'une des éléments de la liste des conditions de victoire
    %Lettre est l'indice de la lettre de l'identifiant, ListeLettres est la liste des lettres
    (   Lettre=<3 ->  %Chaque case a 4 lettres 
      (   E=<39 ->  %L'ensemble des possibilité de victoire représente 40 éléments (10 fois 4 cases)
       	 winPos(D), %On nomme D la liste des positions de victoire
         flatten(D,W), %On utilise flatten pour transformer D qui est une liste de listes en W une liste simple
         nth0(E,W,Q), %On prend la case numéro E de la liste flatten W et on la retourne dans Q
         nth1(Q,L,X), %On prend dans la liste L qui est la liste contenant la grille, l'élément numéro Q que l'on retourne dans X
         sub_atom(X,Lettre,1,_,Char), %On récupère la lettre souhaitée de X que l'on retourne sous le nom Char 
         E1 is E+1, %On incrémente de 1
         append(ListeLettres,[Char],NewListe), %On ajoute le caractère Char dans une nouvelle liste
         isWinner(L,T,E1,Lettre,NewListe); %On rappelle la fonction de manière recursive avec la nouvelle liste et l'incrémentation
         LettreSuiv is Lettre+1, %Si on a fait les 40 possibiltiés pour une lettre, on passe à la lettre suivante
         isWinner(L,T,0,LettreSuiv,ListeLettres)); %On rappelle la fonction avec la lettre suivante
        recupChar(ListeLettres,0,T)). %Une fois la liste avec toutes les lettres du plateau terminée on appelle la fonction recupChar
		%recupChar va récupérer les lettres 4 à 4 pour les comparer et détecter la victoire

%Permet de stopper le jeu en affichant false.
stopProlog:-
    piece(1).

%%% FONCTIONS D'AFFICHAGE %%%

%Fonction gérant l'affichage de la grille dans la console
afficheGrille(Pieces):-
    write('================================'),
    nl,
    write('--- Affichage de la grille : ---'),
    nl,
    write('================================'),
    nl,
    nl,
    afficheLigne, %Affiche une ligne composée de "===="
    nl,
    affichePiece(1,Pieces), %Affiche les pièces de la première ligne contenues dans la liste
    nl,
    afficheLigne,
    nl,
    affichePiece(2,Pieces),
    nl,
    afficheLigne,
    nl,
    affichePiece(3,Pieces),
    nl,
    afficheLigne,
    nl,
    affichePiece(4,Pieces),
    nl,
    afficheLigne.

%Fonction gérant l'affichage des pièces de la liste K qui appartiennent à la ligne I 
affichePiece(I,K):-
    (I==1 ->  
    write('|'), %On affiche un | entre chaque pièce
    nth0(0,K,X1), %Récupère l'élément 0 de la liste K et le retourne dans X1
    write(X1), %On écrit X1
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
                            
%Fonction affichant une ligne de séparation des pièces
afficheLigne:-
    write('=====================').


%%% FONCTIONS POUR VERIFIER QU'UN TOUR EST JOUABLE (PIECE ET CASE VIABLES)

%Fonction qui vérifie si l'identifiant d'une case est viable 
verifID(X,T,L):- 
    % ID étant l'identifiant, X l'ID qui sera retourné si il est valable, T le tour de jeu, L la liste des pièces posées
    (   0 is mod(T,2) ->  %Changement du texte en fonction du tour de jeu
   	write('--- J1 choisi l\'identifiant d\'une piece ---'),
    nl,
    nl,
    read(ID), %On lit l'entrée du joueur
    nl,
    (   member(ID,L) -> %Si il appartient à la liste des pièces sur le plateau on le signale
    write('Cette piece a deja ete posee, prenez en une autre.'),
        nl,
        nl,
    verifID(X,T,L); %On relance la fonction 
    (piece(ID) ->  X=ID; %On vérifie si il y a une pièce qui comporte cet ID et si oui on autorise l'entrée du joueur
    write('Cette ID n\'existe pas veuillez en selectionner un autre.'), %Sinon on le previent que l'id n'est associé à aucune pièce
    nl,
        nl,
    verifID(X,T,L))); %On relance la fonction
   	write('--- J2 choisi l\'identifiant d\'une piece ---'), %Changement du texte en fonction du tour de jeu
    nl,
    nl,
    read(ID),
    nl,
    (   member(ID,L) ->
    write('Cette piece a deja ete posee, prenez en une autre.'),
         nl,
        nl,
    verifID(X,T,L);
    (piece(ID) ->  X=ID;
    write('Cette ID n\'existe pas veuillez en sélectionner un autre.'),
         nl,
        nl,
    verifID(X,T,L)))).

%Vérifie si une case est jouable 
verifCase(X,L,T):- 
    %X retournera la case si elle est validée, L la liste des lettres, ID l'id de la pièce sélectionnée précédemment, T le tour
    (   0 is mod(T,2) ->  %on change l'affichage en fonction du tour 
    write('--- J2 choisi une case ---'),
    nl,
    nl,
    read(C), %On lit l'entrée qu'on stocke dans C
    nl,
    ( C=<16, C>0 ->  %On vérifie que le numéro choisie est entre 1 et 16.
    C1 is C-1, %On enlève 1 à l'entrée car l'indice des listes commence à 0 donc il y a un décalage
    nth0(C1,L,E), %On récupère l'élément dans la case sélectionée
    (piece(E)->  %Si cet élément est une pièce
    write('Cette case est deja prise veuillez en selectionner une autre.'), %On indique qu'il y a déjà une pièce dedans
    nl,
    nl,
    verifCase(X,L,T) ; %On relance la fonction si la case est déjà occupée
    X=C);
    write('Cette case n\'existe pas veuillez en selectionner une autre.'), %On indique que la case n'existe pas
    nl,
    nl,
    verifCase(X,L,T)); %On relance la fonction si la case choisie n'existe pas 
     write('--- J1 choisi une case ---'), %On change l'affichage en fonction du tour
    nl,
    nl,
    read(C),
    nl,
    ( C=<16, C>0 ->  
    C1 is C-1,
    nth0(C1,L,E),
    (piece(E)-> 
    write('Cette case est deja prise veuillez en selectionner une autre.'),
    nl,
    nl,
    verifCase(X,L,T) ;
    X=C);
    write('Cette case n\'existe pas veuillez en selectionner une autre.'),
    nl,
    nl,
    verifCase(X,L,T))).

%%% FONCTIONS DE JEU %%%

%Fonction qui replace l'I ème élément de la liste de L par l'élément E, elle retourne le résultat dans la liste K
replace(I, L, E, K) :-
  nth1(I, L, _, R),
  nth1(I, K, E, R).

%Fonction d'un tour de jeu jusqu'à ce que le jeu s'arrête
tourJeu(L,T,WinState,J):- 
    listeLettresNJ(NewListe),
    %ID = identifiant de la pièce, C = case, L = liste des pièces sur la grille de jeu
    %T = tour, WinState = état de la partie (0=personne n'a gagné, 1=il y a un gagnant), J = liste des pièces Jouables.
    (   WinState ==0 ->  %Si personne n'a gagné
    winCon(ListeLettres), %Défini la liste WinCon comme la liste des lettres placées 
    verifID(ID2,T,L), %Demande au joueur de jouer et vérifie la pièce
    verifCase(C2,L,T), %Demande au joueur suivant de choisir une case et la vérifie
    replace(C2,L,ID2,K), %Remplace dans la liste des cases, le numéro de la case par la pièece
    afficheID, %Affiche les instructions sur l'identifiant des pièces
    nl,
    afficheGrille(K), %Affiche la grille avec la liste des pièces
    isWinner(K,T,0,0,ListeLettres), %Vérifie si les conditions de victoire sont remplies et arrête le jeu si jamais
    T2 is T+1, %Augmente de 1 le tour 
    select(ID2,J,R), %Retire la pièce choisie par le joueur de la liste J des pièces et retourne le résultat dans la liste R
    nl,
    nl,
    write('Liste des coups jouables :'),
        nl,
    write(R), %Affiche la liste R qui correspond aux pièces non jouées donc aux coups jouables
    %conseilPiece(R), Conseil une pièce au joueur parmi les pièces dispos
    evaluationPiece(R,0,NewListe,Sortie), %Récupère la liste des pièces non jouées sous forme de lettres
    compteOccurence(Sortie,b,0,0,OccurenceB),
    compteOccurence(Sortie,n,0,0,OccurenceN),
    compteOccurence(Sortie,c,0,0,OccurenceC),
    compteOccurence(Sortie,r,0,0,OccurenceR),
    compteOccurence(Sortie,h,0,0,OccurenceH),
    compteOccurence(Sortie,s,0,0,OccurenceS),
    compteOccurence(Sortie,p,0,0,OccurenceP),
    compteOccurence(Sortie,t,0,0,OccurenceT),
    plusPresente(OccurenceB,OccurenceN,OccurenceC,OccurenceR,OccurenceH,OccurenceS,OccurenceP,OccurenceT),
    nl,
    tourJeu(K,T2,WinState,R); %Relance un tour
    stopProlog). %Si quelqu'un a gagné on arrête le jeu

%Fonction pour conseiller une pièce aléatoire parmi celles restantes
conseilPiece(L):- 
    nth0(0,L,T), %On prend la première piéce que l'on retourne sous le nom T
    (   T\=''  ->  %Si il y a une pièce 
    length(L,Y), %On récupère la taille de la liste des pièces qu'on retourne dans Y
    nl,
    random(0,Y,R), %on prend un chiffre aléatoire entre 0 et Y qu'on retourne dans R
    nth0(R,L,X), %On prend l'élément R de la liste des pièces qu'on retourne dans X
    write('Coup conseille : '),
    write(X); %On conseil de jouer la pièce X qui est une pièce aléatoire de la liste des coups possible
    write('R existe pas')). %Sinon on renvoie un message d'erreur

%Recupere les lettres des pieces qui ne sont pas posées 
evaluationLettre(E,I,ListeL,NewListeF):-
    (   I<4  -> 
    sub_atom(E,I,1,_,Char1), %On récupère la première lettre
    I1 is I+1, 
    I2 is I+2,
    I3 is I+3,
    sub_atom(E,I1,1,_,Char2), % ... la suivante
    sub_atom(E,I2,1,_,Char3), %... la suivante
    sub_atom(E,I3,1,_,Char4), %... la suivante, on a donc les 4 lettres de l'id
    append(ListeL,[Char1],NewListe1),
    append(NewListe1,[Char2],NewListe2),
    append(NewListe2,[Char3],NewListe3),
    append(NewListe3,[Char4],NewListeF);
    write('')).

%Evalue la meilleure piece à proposer au joueur adverse
evaluationPiece(ListeNonJouee,I,NewListe,Sortie):-
    listeLettresNJ(L),
    length(ListeNonJouee,Y),
    (   I<Y ->  
     nth0(I,ListeNonJouee,E), %On récupère l'élément I de la liste des coups non joués
     evaluationLettre(E,0,L,X), %On appelle la fonction qui récupère ses lettres 
     append(NewListe,X,K), %On ajoute ses lettres à notre liste
     I2 is I+1,
    evaluationPiece(ListeNonJouee,I2,K,Sortie); %On continue avec l'élément suivant de la liste
    Sortie = NewListe). %Une fois la liste finie, on définie la sortie comme cette liste

%Fonction qui compte l'occurence de chaque lettre des pieces non jouées 
compteOccurence(L,E,O,Indice,Occurence):-
    length(L,Longueur),
    (   Indice < Longueur ->  
    nth0(Indice,L,Element), %On récupère la lettre I de notre liste
    (   Element == E ->  %On regarde si c'est la lettre dont on compte l'occurence
    NewO is O+1; %On incremente l'occurence de 1
    NewO is O),
    NewIndice is Indice+1,
    compteOccurence(L,E,NewO,NewIndice,Occurence); %On continue de parcourir la liste
    Occurence is O).

%Compare les occurences de toutes les caractéristiques
plusPresente(B,N,C,R,H,S,P,T):-
    L = [B,N,C,R,H,S,P,T], %On place les occurences dans une liste
    nl,
    nl,
    write('Notre IA vous conseille les caracteristiques les moins présentes parmi celles des pieces jouables'),
    nl,
    write('Choisissez une piece avec l\'une des caracteristiques suivante:'),
    nl,
    nl, %On récupère les lettres qui reviennent le plus et on les propose 
    (   B==N, N==C, C==R, R==H, H==S, S==P, P==T ->  %Si toutes les caractéristiques sont autant présente, on laisse le choix
    write('Les caracteristiques sont toutes presentes dans la meme proportion, prenez celle que vous souhaitez.'),
        nl;
    (   max_member(B, L) ->  write('Piece Blanche'),nl;write('')),
     (   max_member(N, L) ->  write('Piece Noire'),nl;write('')),
     (   max_member(C, L) ->  write('Piece Carree'),nl;write('')),
     (   max_member(R, L) ->  write('Piece Ronde'),nl;write('')),
     (   max_member(H, L) ->  write('Piece Haute'),nl;write('')),
     (   max_member(S, L) ->  write('Piece Basse'),nl;write('')),
     (   max_member(P, L) ->  write('Piece Pleine'),nl;write('')),
     (   max_member(T, L) ->  write('Piece avec un Trou'),nl;write(''))).

%Fonction du premier tour de jeu
jouer:- 
    write('################################'),
    nl,
    write('=== QUARTO by FRANCOIS & EVAN =='),
    nl,
    write('################################'),
    nl,
    nl,
    write('================================='),
    nl,
    write('--------- Regles du jeu ---------'),
    nl,
    write('================================='),
    nl,
    nl,
    write('L\'objectif du jeu est d\'aligner quatre pieces ayant au moins un point commun entre elles.'),
    nl,
    write('Mais chaque joueur ne joue pas ce qu\'il veut, c\'est son adversaire qui choisit pour lui.'),
    nl,
    write('Les seize pieces du jeu, toutes differentes, possedent chacune quatre caracteres distincts : haute ou basse, ronde ou carree, blanche ou noire, pleine ou trouee.'),
    nl,
    write('Chacun a son tour choisit et donne une piece a l\'adversaire, qui doit la jouer sur une case libre.'),
    nl,
    write('Le gagnant est celui qui, avec une piece reçue, cree un alignement de quatre pieces ayant au moins un caractere commun.'),
    nl,
    nl,
    afficheID, %Affiche les instructions pour choisir une pièce
    nl,
    piecePosee(L), %Défini piecePosee comme la liste L
    afficheGrille(L), %Affiche la grille initiale
    nl,
    nl,
    listePiece(J), %Définie listePiece comme la liste J 
    tourJeu(L,2,0,J). %Lance le corps du jeu

