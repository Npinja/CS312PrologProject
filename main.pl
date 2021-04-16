% Videogame Recommender
% CPSC 312 2021 Prolog Project
% Authors: Alan Yan, Richard Li

% WE ARE MAKING A GAME RECOMMENDER
% Takes a list of games u play, recommends game you might want to try
% TYPE -> MMORPG, FPS, SANDBOX, ACTION-ADVENTURE, SPORTS, PUZZLES
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
game("League Of Legends", "MMORPG", "Riot", ["PC", "macOS"]).
game("League Of Legends: Wild Rift", "MMORPG", "Riot", ["Mobile"]).
game("Call Of Duty Mobile", "Activision", "FPS", ["Mobile"]).
game("Minecraft", "Mojang", "Sandbox", ["PC", "macOS"]).
game("Minecraft: Pocket Edition", "Mojang", "Sandbox", ["Mobile"]).
game("Minesweeper", "Microsoft", "Puzzle", ["PC"]).
game("Solitaire", "Microsoft", "Puzzle", ["PC"]).
game("Halo Series", "343 Industries", "FPS", ["Console", "PC"]).
game("Call of Duty Series", "Activision", "FPS" ["Console", "PC"]).
game("Tetris", "SEGA", "Puzzle", ["PC", "macOS", "Mobile"]).
game("Pacman", "Bandai Namco", "Maze", ["PC", "macOS", "Mobile"]).
game("World of Warcraft", "Blizzard Entertainment", "MMORPG", ["PC", "macOS"]).
game("Overwatch", "Blizzard Entertainment", "FPS", ["PC", "Console"]).
game("Among Us", "InnerSloth LLC", "Puzzle", ["PC", "macOS", "Mobile"]).
game("Fortnite", "Epic Games", "Battle Royale", ["Console", "PC", "Mobile"]).
game("Sneaky Sasquatch", "RAC7 Games", "Sandbox", ["macOS", "Mobile"]).
game("Grand Theft Auto Series", "Rockstar Games", "Sandbox", ["PC", "Console"]).
game("The Legend of Zelda: Breath of the Wild", "Nintendo", "Action-Adventure", ["Console"]).
game("Minecraft", "Mojang", "Sandbox", ["PC", "macOS"]).
game("Animal Crossing: New Horizons", "Nintendo", "Sandbox", ["Console"]).
game("Super Mario 64", "Nintendo", "Action-Adventure", ["Console"]).
game("Madden NFL Series", "EA Sports", "Sports", ["PC", "Console", "Mobile"]).
game("NBA 2K Series", "2K Games", "Sports", ["PC", "Console"]).
game("NHL Series", "EA Sports", "Sports", ["Console"]).
game("FIFA Series", "EA Sports", "Sports", ["Mobile", "Console", "PC"]).
game("Cyberpunk", "CD Projekt", "Sandbox, ["Console", "PC"]).
game("Pokemon Series", "Nintendo", "MMORPG", ["Console"]).
game("Pokemon Go", "Niantic", "Action-Adventure", ["Mobile"]).
game("Counter Strike: Global Offensive", "Valve", "FPS", ["PC", "macOS"]).
game("Mario Kart", "Nintendo", "Sports", ["Console", "Mobile"]).
game("Mario Party", "Nintendo", "Puzzle", ["PC", "macOS", "Console"]).