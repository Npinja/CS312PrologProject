% Videogame Recommender
% CPSC 312 2021 Prolog Project
% Authors: Alan Yan, Richard Li

% WE ARE MAKING A GAME RECOMMENDER
% Takes a list of games u play, recommends game you might want to try
% TYPE -> MMORPG, FPS, SANDBOX, ACTION-ADVENTURE, SPORTS, PUZZLES, BATTLE-ROYALE, FIGHTER
% COMPANY -> RIOT ACTIVISION BLIZZARD
% PLATFORM -> [macOS, PC, Mobile, Console]

% recommendGames(GamesAlreadyPlayed, LockPlatform, MaxResults, RecommendedGames).

recommendgames([], _, _, RecommendedGames) :- allgames(RecommendedGames).
recommendgames(GamesAlreadyPlayed, LockPlatform, MaxResults, RecommendedGames) :- findall(Name, is_valid_game(GamesAlreadyPlayed, LockPlatform, Name), PotentialGames)
    , build_recommended_games(GamesAlreadyPlayed, PotentialGames, MaxResults, RecommendedGames).

is_valid_game(GamesAlreadyPlayed, 0, GameName) :- game(GameName, _,_,_), doesnt_contain(GamesAlreadyPlayed, GameName).
is_valid_game(GamesAlreadyPlayed, 1, GameName) :- 
    game(GameName, _,_,_), doesnt_contain(GamesAlreadyPlayed, GameName), is_valid_platform(GamesAlreadyPlayed, GameName).

build_recommended_games(GP, PG, MR, FinalList) :- include(all_three_matching(GP), PG, X)
    , exclude(all_three_matching(GP), PG, R1), include(platform_type_matching(GP), R1, Y)
    , exclude(platform_type_matching(GP), R1, R2), include(platform_company_matching(GP), R2, Z)
    , exclude(platform_company_matching(GP), R2, R3), include(platform(GP), R3, V)
    , exclude(platform(GP), R3, R4), include(type_company_matching(GP), R4, B)
    , append(X, Y, Q), append(Q, Z, U), append(U, V, C), append(C,B, G), take(G, MR, FinalList).

all_three_matching(GamesAlreadyPlayed, GameName) :- is_valid_platform(GamesAlreadyPlayed, GameName), is_valid_game_type(GamesAlreadyPlayed, GameName), is_valid_company(GamesAlreadyPlayed, GameName).
platform_type_matching(GamesAlreadyPlayed, GameName) :- is_valid_platform(GamesAlreadyPlayed, GameName), is_valid_game_type(GamesAlreadyPlayed, GameName).
platform_company_matching(GamesAlreadyPlayed, GameName) :- is_valid_platform(GamesAlreadyPlayed, GameName), is_valid_company(GamesAlreadyPlayed, GameName).
platform(GamesAlreadyPlayed, GameName) :- is_valid_platform(GamesAlreadyPlayed, GameName).
type_company_matching(GamesAlreadyPlayed, GameName) :- is_valid_company(GamesAlreadyPlayed, GameName), is_valid_game_type(GamesAlreadyPlayed, GameName).
%just type
%just company

take(Src,N,L) :- findall(E, (nth1(I,Src,E), I =< N), L).
allgames(R) :- findall(Q, game(Q, _, _, _), R).

doesnt_contain([],_).
doesnt_contain([H|T],C) :-
	dif(H,C),
	doesnt_contain(T,C).

doesIntersect(X,Y) :-
    intersection(X,Y,Z),
    dif(Z,[]).

%checks if the game shares a platform with a game you already play
is_valid_platform([H|T], GameName) :- game(GameName, _ , _, Platforms), game(H, _, _, CurrentPlatforms), (doesIntersect(Platforms, CurrentPlatforms); is_valid_platform(T, GameName)).
%checks if the game shares a game type with a game you already play
is_valid_game_type([H|T], GameName) :- game(GameName, _ , GameType, _), game(H, _, OtherGameType, _), (not(dif(GameType, OtherGameType)); is_valid_game_type(T, GameName)).
%checks if the game shares a company a game you already play
is_valid_company([H|T], GameName) :- game(GameName, Company , _, _), game(H, OtherCompany, _, _), (not(dif(Company, OtherCompany)); is_valid_company(T, GameName)).

% The following code contains the videogames and their descriptions that will be used for queries 
game("Valorant", "Riot", "FPS", ["PC"]).
game("League Of Legends", "MMORPG", "Riot", ["PC", "macOS"]).
game("League Of Legends: Wild Rift", "MMORPG", "Riot", ["Mobile"]).
game("Call Of Duty Mobile", "Activision", "FPS", ["Mobile"]).
game("Minecraft", "Mojang", "Sandbox", ["PC", "macOS"]).
game("Minecraft: Pocket Edition", "Mojang", "Sandbox", ["Mobile"]).
game("Minesweeper", "Microsoft", "Puzzle", ["PC"]).
game("Solitaire", "Microsoft", "Puzzle", ["PC"]).
game("Halo Series", "343 Industries", "FPS", ["Console"]).
game("Call of Duty Series", "Activision", "FPS", ["Console", "PC"]).
game("Tetris", "SEGA", "Puzzle", ["PC", "macOS", "Mobile"]).
game("Pacman", "Bandai Namco", "Maze", ["PC", "macOS", "Mobile"]).
game("World of Warcraft", "Blizzard Entertainment", "MMORPG", ["PC", "macOS"]).
game("Overwatch", "Blizzard Entertainment", "FPS", ["PC", "Console"]).
game("Among Us", "InnerSloth LLC", "Puzzle", ["PC", "macOS", "Mobile"]).
game("Fortnite", "Epic Games", "Battle-Royale", ["Console", "PC", "Mobile"]).
game("Sneaky Sasquatch", "RAC7 Games", "Sandbox", ["macOS", "Mobile"]).
game("Grand Theft Auto Series", "Rockstar Games", "Sandbox", ["PC", "Console"]).
game("The Legend of Zelda: Breath of the Wild", "Nintendo", "Action-Adventure", ["Console"]).
game("Animal Crossing: New Horizons", "Nintendo", "Sandbox", ["Console"]).
game("Super Mario 64", "Nintendo", "Action-Adventure", ["Console"]).
game("Madden NFL Series", "EA Sports", "Sports", ["PC", "Console", "Mobile"]).
game("NBA 2K Series", "2K Games", "Sports", ["PC", "Console"]).
game("NHL Series", "EA Sports", "Sports", ["Console"]).
game("FIFA Series", "EA Sports", "Sports", ["Mobile", "Console", "PC"]).
game("Cyberpunk 2077", "CD Projekt", "Sandbox", ["Console", "PC"]).
game("Pokemon Series", "Nintendo", "MMORPG", ["Console"]).
game("Pokemon Go", "Niantic", "Action-Adventure", ["Mobile"]).
game("Counter Strike: Global Offensive", "Valve", "FPS", ["PC", "macOS"]).
game("Mario Kart", "Nintendo", "Sports", ["Console", "Mobile"]).
game("Mario Party", "Nintendo", "Puzzle", ["PC", "macOS", "Console"]).
game("Overcooked Series", "Team17", "Puzzle", ["PC", "Console"]).
game("PlayerUnknown's Battlegrounds", "PUBG Corporation", "Battle-Royale", ["PC", "Console", "Mobile"]).
game("Candy Crush Saga", "King", "Puzzle", ["PC", "macOS", "Mobile"]).
game("DOTA 2", "Valve", "MMORPG", ["PC", "macOS"]).
game("Super Smash Bros. Ultimate", "Bandai Namco", "Fighter", ["Console"]).
game("Wii Sports", "Nintendo", "Sports", ["Console"]).
game("Street Fighter Series", "Capcom", "Fighter", ["PC", "Console"]).
game("Mortal Kombat Series", "NetherRealm Studios", "Fighter", ["PC", "Console"]).
game("Tekken Series", "Bandai Namco", "Fighter", ["PC", "Console"]).
game("Marvel vs. Capcom Series", "Capcom", "Fighter", ["PC", "Console"]).
game("Apex Legends", "Respawn Entertainment", "Battle-Royale", ["PC", "Console"]).
game("Call of Duty: Warzone", "Activision", "Battle-Royale", ["PC", "Console"]).
game("ZombsRoyale.io", "Yangcheng Liu", "Battle-Royale", ["PC", "Mobile"]).
game("Agar.io", "Miniclip", "Action-Adventure", ["PC", "Mobile", "macOS"]).
game("Slither.io", "Lowtech Studios", "Action-Adventure", ["PC", "Mobile"]).
game("Battlefield Series", "EA", "FPS", ["PC", "Console"]).
