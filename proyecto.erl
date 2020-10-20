%-------------------------------------------------------------
%	Alumnos:
%		Erick Blanco Fonseca
%		Josué Gerardo Gutiérrez Mora
%		Miguel Sánchez Sánchez

%	Lenguajes de programación (IC-4700) Grupo 20.
%	Tecnológico de Costa Rica.

%-------------------------------------------------------------

-module(proyecto).


% Se exportan las funciones de FUNCION DE APTITUD
-export([funcion_aptitud/2, 
		 funcion_aptitudAux/5, 
		 getAptitud/5]).


% Se exportan las funciones de CRUCE
-export([crear/2,
		 rellenando/3,
		 getNuevaGeneracion/2,
		 mutarLista/7,
		 cruce/4]).


% Se exportan las funciones de NUCLEO
-export([generarPoblacion/1,
		 generarPoblacionAux/3,
		 hacerLista/1,
		 hacerListaAux/2,
		 geneticosNReinas/1,
		 geneticos/5,
		 geneticosAux/6,
		 geneticosAux2/7]).



% Se exportan las funciones de APOYO
-export([shuffle/1,
		 insertar/3,
		 obtener/2,
		 rellenarConVacias/2,
		 elementoRandom/1,
		 swap/3,
		 swapAux/6,
		 random/1,
		 unir/2,
		 pertenece/2,
		 eliminaIguales/1,
		 indice/2,
		 indiceElementoAux/3,
		 minimo/1,
		 indiceDelMinimo/1,
		 mitadUP/1,
		 mitadAux/3,
		 esZero/1]).


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FUNCION DE APTITUD>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% Se encarga de ir formando la lista con la mejor aptitud de cada lista de la población
% Recibe una lista de números y el tamaño de esta.
funcion_aptitud(L, _N) when L == [] -> [];
funcion_aptitud([H|T], N) -> 
	[funcion_aptitudAux(H, 0, 0, 0, N) | funcion_aptitud(T, N)].

% Lista auxiliar, hace el recorrido dentro de los elementos de cada sublista
% Retorna el mejor elemento de la lista que se le lanza
% Recibe una lista, un indice mayor I, un indice J que se anida en I, la lista de aptitud, y el tamaño N de la lista
funcion_aptitudAux(_L, I, _J, Aptitud, N) when I == (N) -> Aptitud;
funcion_aptitudAux(L, I, J, Aptitud, N) when J == (N) -> funcion_aptitudAux(L, I+1, 0, Aptitud, N);
funcion_aptitudAux(L, I, J, Aptitud, N) -> 
	funcion_aptitudAux(L, I, J+1, getAptitud(I, J, obtener(I+1,L), obtener(J+1,L), Aptitud), N).

% Dados los resultados de los cálculos, se verifica si la aptitud aumenta o no
% Recibe índice I, subíndice J, Elemento índice (X) y J(Y) de la lista en evaluacion, y por último el elemento
% de la aptitud que tiene lleva la lista hasta el momento
getAptitud(I,J,X,Y, Aptitud) when ((I=/=J) and ( abs((I+1)-(J+1)) == abs(X-Y))) ->
	Aptitud+1;
getAptitud(_I,_J,_X,_Y,Aptitud) -> Aptitud.


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FUNCION DE CRUCE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%---------------------------------------------------------------------------------------------
% Esta parte se encarga de generar la Nueva_generacion
% Se crea una lista del tamaño de la poblacion, la primera lista es la Elite
% El resto se rellena con listas vacías.
% Las listas vacías se van rellenando según dicta el algoritmo genético


% Toma 2 listas, de la primera saca la mitad para arriba
% de la segunda se toman los elementos que no están en lo que quedó de la primera
% y se le agregan a la lista a formar
% Devuelve una lista nueva basada en las funciones mencionadas anteriormente.
crear(L1, L2) -> unir(mitadUP(L1), L2).


% Va rellenando una a una las listas vacias de la nueva generacion
% Retorna la Nueva generación ya con las listas cargadas
% Recibe una matriz que solo posee una lista Elite y el resto son listas vacias
% recibe la matriz poblacion y un contador
rellenando(Nueva_generacion, _Poblacion, C) when C == (length(Nueva_generacion)+1) -> Nueva_generacion;
rellenando(Nueva_generacion, Poblacion, C) ->
	rellenando(insertar(C,crear(elementoRandom(Poblacion), elementoRandom(Poblacion)), Nueva_generacion), Poblacion, C+1).
	

% Hace el llamado inicial para obtener la nueva generacion
% retorna oficialmente la nueva generación
% Recibe la lista
getNuevaGeneracion(Poblacion, Elite) ->
	rellenando(rellenarConVacias(Elite, length(Poblacion)), Poblacion,2).

%---------------------------------------------------------------------------------------------


% Nueva_generacion
% Mutacion que siempre empieza siendo 0
% Mutaciones : la cantidad de mutaciones a realizar
% Ram : Número random para seleccionar una lista de Nueva_generacion
% Ran1: Número random para seleccionar de la lista obtenida anteriormente
% Ran2: Número random selecciona de la lista, junto con el anterior para intercambiarlos
% N   : Tamaño de cada lista 

% Regresa la matriz Nueva generación con sus listas ya mutadas
mutarLista(Nueva_generacion, Mutacion, Mutaciones, _Ram, _Ran1, _Ran2, _N)
	when Mutacion >= Mutaciones -> Nueva_generacion;

mutarLista(Nueva_generacion, Mutacion, Mutaciones, Ram, Ran1, Ran2, N) ->
	mutarLista(insertar(Ram, 
						swap(obtener(Ram, Nueva_generacion), Ran1,Ran2), 
						Nueva_generacion),
			  Mutacion+1,
			  Mutaciones,
			  random(N),
			  random(N),
			  random(N),
			  N).


% Funcion inicial de cruce que invoca todo lo demás para 
% hacer el cruce según se le pida. Retorna de forma oficial la matriz Nueva Generación
% Se le inserta la matriz población, Una lista elite, El tamaño N de cada lista en Poblacion y 
% el tamaño de la matriz Población
cruce(Poblacion, Elite, N, Cant_poblacion) ->
	mutarLista(getNuevaGeneracion(Poblacion,Elite), 
			   0,
			   round(Cant_poblacion * 0.05),
			   random(N),
			   random(N),
			   random(N),
			   N).


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%<<<<<<<<<<<<<<<<<<<<<<<<<FUNCIONES NUCLEO, SE ENCARGAN DE CONECTAR TODO>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


%----------------------------------------------------------------------------------------
%	Estas dos se encargan de generar la poblacion
%----------------------------------------------------------------------------------------


% Funcion encargada de generar la poblacion según el número de Reinas
% Recibe un entero con el número de reinas
generarPoblacion(N) -> generarPoblacionAux(N, N*4, 1).
%Recibe el tamaño de cada sublista, el tamaño de la poblacion y un contador
%devuelve una lista con sublistas
generarPoblacionAux(_Tam, N, C) when C == N+1 -> [];
generarPoblacionAux(Tam, N, C) -> [hacerLista(Tam) | generarPoblacionAux(Tam, N, C+1)].

% Funcion que se encarga de devolver una lista aleatoria de nums entre 1 y N
% recibe un entero
hacerLista(N) -> hacerListaAux(N, 1).
%recibe el tamaño de la lista y un contador, retorna una lista desordenada de manera random
hacerListaAux(N, C) when C == N+1 -> [];
hacerListaAux(N, C) -> shuffle([C | hacerListaAux(N,C+1)]).

%----------------------------------------------------------------------------------------

geneticosNReinas(N) when N =< 3 -> 'ERROR, INSERTE UN VALOR ENTERO MAYOR A 3';
geneticosNReinas(N) -> geneticos(N, 0, 400, generarPoblacion(N), N*4).

% io:format("~p ~n", [C])

geneticos(N, Cruces, TotalCruces, Poblacion, Cant_poblacion) ->
	geneticosAux(N, Cruces, TotalCruces, Poblacion, Cant_poblacion, funcion_aptitud(Poblacion, N)).


geneticosAux(N, Cruces, TotalCruces, Poblacion, Cant_poblacion, Elite) ->
	geneticosAux2(N, Cruces, TotalCruces, Poblacion, Cant_poblacion, Elite, esZero(minimo(Elite))).


geneticosAux2(_N, _Cruces, _TotalCruces, Poblacion, _Cant_poblacion, Elite, Minimo)
	when Minimo == true -> obtener(indiceDelMinimo(Elite),Poblacion);

geneticosAux2(_N, Cruces, TotalCruces, Poblacion, _Cant_poblacion, Elite, _Minimo)
	when Cruces == TotalCruces+1 -> obtener(indiceDelMinimo(Elite),Poblacion);

geneticosAux2(N, Cruces, TotalCruces, Poblacion, Cant_poblacion, Elite, _Minimo) -> io:format("~p ~n", [obtener(indiceDelMinimo(Elite),Poblacion)]),
	geneticosAux2(N, Cruces+1, TotalCruces, cruce(Poblacion, Elite, N, Cant_poblacion), Cant_poblacion, funcion_aptitud(Poblacion,N), esZero(minimo(funcion_aptitud(Poblacion,N)))).



%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FUNCIONES DE APOYO>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


%Recibe una lista y la devuelve desordenada aleatoriamente
shuffle(L) -> [Y||{_,Y} <- lists:sort([ {rand:uniform(), N} || N <- L])].

% Devuelve la lista de nueva generacion con la Elite en frente
% y el resto de la lista en puras listas vacias 
% (Es del tamaño del elemento Poblacion)
% Se le insertan una lista Elite y un entero con la cantidad de Poblacion
rellenarConVacias(_Elite, Cant_poblacion) when Cant_poblacion == 0 -> [];
rellenarConVacias(Elite, Cant_poblacion) when Elite == [] -> [Elite | rellenarConVacias([], Cant_poblacion-1)];
rellenarConVacias(Elite, Cant_poblacion) ->
		[Elite | rellenarConVacias([], Cant_poblacion-1)].


% Devuelve un elemento RANDOM de una lista
% recibe una lista
elementoRandom(L) -> lists:nth(rand:uniform(length(L)), L).


% Intercambia dos elementos de una lista
% Recibe una lista y los dos indices de los elementos a cambiar
swap(L,P1,P2) -> swapAux(L, P1, P2,obtener(P1, L), obtener(P2, L), 2).
swapAux(L, _P1, _P2, _E1, _E2, C) when C == 0 -> L;
swapAux(L, P1, P2, E1, E2, C) -> swapAux(insertar(P1, E2, L), P2, P1, E2, E1, C-1).


% Devuelve un elemento de una lista dado su indice
% recibe un índice y una lista
obtener(I, L) -> lists:nth(I, L).


% Devuelve un número random entre 1 y N
% Recibe un número entero
random(N) -> rand:uniform(N).


% Unir a la lista otra lista que no tiene los elementos de la primera
% Recibe 2 listas.
unir(L1,L2) -> L1 ++ eliminaIguales([X||X<-L2, pertenece(X,L1)]).
pertenece(X,L) -> not lists:member(X, L).
eliminaIguales([]) -> [];
eliminaIguales([H|T]) -> [H | [X || X <- eliminaIguales(T), X /= H]].


% Regresa el índice de un elemento (Si es que este se encuentra ahí)
% Recibe el valor del elemento y la lista donde se supone está
indice(E, L) -> indiceElementoAux(E, L, 1).
indiceElementoAux(_E, [], _I)  -> false;
indiceElementoAux(E, [H|_T], I) when H == E -> I;
indiceElementoAux(E, [H|T], I) when H =/= E -> indiceElementoAux(E, T, I+1).


% Retorna el valor más bajo de de una lista
% Recibe una lista
minimo(L) -> lists:min(L).


% Indice del elemento de más bajo valor
% Recibe una lista
indiceDelMinimo(L) -> indice(minimo(L), L).


% Devuelve de la mitad para arriba de una lista
% Recibe una lista
mitadUP(L) -> mitadAux(L, floor(length(L)/2), 0).
mitadAux(L, _I, _C) when L == [] -> [];
mitadAux(L, I, C) when C == I -> mitadAux(L, I, C+1);
mitadAux([_H|T], I, C) when C =< I -> mitadAux(T, I, C+1);
mitadAux([H|T], I, C) -> [H| mitadAux(T,I,C)].


esZero(E) when E == 0 -> true;
esZero(E) when E =/= 0 -> false. 

% Insertar en una lista
% Recibe la posición donde insertar, el elemento a insertar y la lista donde se hace
insertar(Pos,E,L) -> lists:sublist(L,Pos-1)++[E]++lists:nthtail(Pos,L).
