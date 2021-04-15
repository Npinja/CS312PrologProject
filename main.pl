% Videogame Recommender
% CPSC 312 2021 Prolog Project
% Authors: Alan Yan, Richard Li

% WE ARE MAKING A GAME RECOMMENDER
% Takes a list of games u play, recommends game you might want to try
% TYPE -> MOBA, FPS, SANDBOX, RTS, RPG, SPORTS, PUZZLES
% COMPANY -> RIOT ACTIVISION BLIZZARD
% PLATFORM -> [macOS, PC, Mobile, Console]

% DISTANCE FORMULA: SAME GAME TYPE (3) (1) PLATFORM (100)

% recommendGames(GamesAlreadyPlayed, LockPlatform, MaxResults, RecommendedGames).

recommendgames([], _, _, RecommendedGames) :- allgames(RecommendedGames).
recommendgames(GamesAlreadyPlayed, LockPlatform, MaxResults, RecommendedGames) :- findall(Name, is_valid_game(GamesAlreadyPlayed, LockPlatform, MaxResults, Name), RecommendedGames).

is_valid_game(GamesAlreadyPlayed, LockPlatform, MaxResults, GameName) :- 
    game(GameName, _,_,_), doesnt_contain(GamesAlreadyPlayed, GameName), filter_platform(GamesAlreadyPlayed, GameName).

allgames(R) :- findall(Q, game(Q, _, _, _), R).

doesnt_contain([],_).
doesnt_contain([H|T],C) :-
	dif(H,C),
	doesnt_contain(T,C).

doesIntersect(X,Y) :-
    intersection(X,Y,Z),
    dif(Z,[]).

filter_platform([H|T], GameName) :- game(GameName, _ , _, Platforms), game(H, _, _, CurrentPlatforms), (doesIntersect(Platforms, CurrentPlatforms); filter_platform(T, GameName)).


% The following code contains the videogames their descriptions that will be used for queries 
game("Valorant", "Riot", "FPS", ["PC"]).
game("League Of Legends", "MOBA", "Riot", ["PC", "macOS"]).
game("League Of Legends: Wild Rift", "MOBA", "Riot", ["Mobile"]).
game("Call Of Duty Mobile", "Activision", "FPS", ["Mobile"]).
game("Minecraft", "Mojang", "Sandbox", ["PC", "macOS"]).
game("Minecraft: Pocket Edition", "Mojang", "Sandbox", ["Mobile"]).
game("Minesweeper", "Microsoft", "Puzzle", ["PC"])
game("Solitaire", "Microsoft", "Puzzle", ["PC"])
game("Halo Series", "343 Industries", "FPS", ["Console", "PC"])
game("Call of Duty Series", "Activision", ["Console", "PC"])
game("Tetris", "Microsoft", "Puzzle", ["PC"])


