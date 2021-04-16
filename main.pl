% Videogame Recommender
% CPSC 312 2021 Prolog Project
% Authors: Alan Yan, Richard Li

% WE ARE MAKING A GAME RECOMMENDER
% Takes a list of games u play, recommends game you might want to try
% TYPE -> MASSIVE-MULTIPLAYER-ONLINE-ROLE-PLAYING-GAME (MMORPG), FIRST-PERSON-SHOOTER (FPS), SANDBOX, ACTION-ADVENTURE, SPORTS, PUZZLE, BATTLE-ROYALE, FIGHTER, REAL-TIME-STRATEGY (RTS)
% COMPANY -> RIOT ACTIVISION BLIZZARD etc.
% PLATFORM -> [macOS, PC, Mobile, Console]


start :- 
    write("---- Video Game Recommender ---- \n\n"),
    write("Type recommend to get started").

recommend :-
	write("What games have you played before (ex. [\"Valorant\", \"Pokemon Series\"])\n"), 
	read(PG),
	write("Would you only like games that are on platforms you've played on before? (0 for no 1 for yes) \n"),
	read(LockPlatform),
	write("What are the maximum number of games would you like?\n"),
	read(MR),
	recommendgames(PG, LockPlatform, MR, Games),
    write("\n Here Are Your Results: \n\n"),
    writeList(Games).

writeList([]).
writeList([H|T]) :- game(H, Company, Type, Platforms),
    write("Name: "),
    write(H),
    write("\n"),
    write("Created By: "),
    write(Company),
    write("\n"),
    write("Game Type: "),
    write(Type),
    write("\n"),
    write("Platforms: "),
    write(Platforms),
    write("\n\n"),
    writeList(T).


% recommendgames is the main entry point of the program
% GamesAlreadyPlayed is a LIST of game names that the user has already played before.
% LockPlatform is 0 if the user wants to see games that are outside their platform and 1 if they only want to see games on platforms they already play on.
% MaxResults is the maximum number of recommendations the user wants from the recommender.
% RecommendedGames is the list of names of games the user might want to try out.
recommendgames([], _, _, RecommendedGames) :- allgames(RecommendedGames).
recommendgames(GamesAlreadyPlayed, LockPlatform, MaxResults, RecommendedGames) :- findall(Name, is_valid_game(GamesAlreadyPlayed, LockPlatform, Name), PotentialGames)
    , build_recommended_games(GamesAlreadyPlayed, PotentialGames, MaxResults, RecommendedGames).

% Determines whether a game should be a potential recommendation (havent been played before and shares a platform with a game you already play)
is_valid_game(GamesAlreadyPlayed, 0, GameName) :- game(GameName, _,_,_), doesnt_contain(GamesAlreadyPlayed, GameName).
is_valid_game(GamesAlreadyPlayed, 1, GameName) :- 
    game(GameName, _,_,_), doesnt_contain(GamesAlreadyPlayed, GameName), is_valid_platform(GamesAlreadyPlayed, GameName).

% Builds the list of recommended games by a tier order that we decided was best
% 1) Type, Company and Platform
% 2) Type, Platform
% 3) Company, Platform
% 4) Platform
% 5) Type, Company
% 6) Type
build_recommended_games(GP, PG, MR, FinalList) :- include(all_three_matching(GP), PG, X)
    , exclude(all_three_matching(GP), PG, R1), include(platform_type_matching(GP), R1, Y)
    , exclude(platform_type_matching(GP), R1, R2), include(platform_company_matching(GP), R2, Z)
    , exclude(platform_company_matching(GP), R2, R3), include(platform(GP), R3, V)
    , exclude(platform(GP), R3, R4), include(type_company_matching(GP), R4, B)
    , exclude(platform(GP), R4, R5), include(is_valid_game_type(GP), R5,K)
    , append(X, Y, Q), append(Q, Z, U), append(U, V, C), append(C,B, G), append(G, K, T), take(T, MR, FinalList).

all_three_matching(GamesAlreadyPlayed, GameName) :- is_valid_platform(GamesAlreadyPlayed, GameName), is_valid_game_type(GamesAlreadyPlayed, GameName), is_valid_company(GamesAlreadyPlayed, GameName).
platform_type_matching(GamesAlreadyPlayed, GameName) :- is_valid_platform(GamesAlreadyPlayed, GameName), is_valid_game_type(GamesAlreadyPlayed, GameName).
platform_company_matching(GamesAlreadyPlayed, GameName) :- is_valid_platform(GamesAlreadyPlayed, GameName), is_valid_company(GamesAlreadyPlayed, GameName).
platform(GamesAlreadyPlayed, GameName) :- is_valid_platform(GamesAlreadyPlayed, GameName).
type_company_matching(GamesAlreadyPlayed, GameName) :- is_valid_company(GamesAlreadyPlayed, GameName), is_valid_game_type(GamesAlreadyPlayed, GameName).

%Takes the first N results from the Src
take(Src,N,L) :- findall(E, (nth1(I,Src,E), I =< N), L).
allgames(R) :- findall(Q, game(Q, _, _, _), R).

doesnt_contain([],_).
doesnt_contain([H|T],C) :-
	dif(H,C),
	doesnt_contain(T,C).

doesIntersect(X,Y) :-
    intersection(X,Y,Z),
    dif(Z,[]).

% checks if the game shares a platform with a game you already play
is_valid_platform([H|T], GameName) :- game(GameName, _ , _, Platforms), game(H, _, _, CurrentPlatforms), (doesIntersect(Platforms, CurrentPlatforms); is_valid_platform(T, GameName)).
% checks if the game shares a game type with a game you already play
is_valid_game_type([H|T], GameName) :- game(GameName, _ , GameType, _), game(H, _, OtherGameType, _), (not(dif(GameType, OtherGameType)); is_valid_game_type(T, GameName)).
% checks if the game shares a company a game you already play
is_valid_company([H|T], GameName) :- game(GameName, Company , _, _), game(H, OtherCompany, _, _), (not(dif(Company, OtherCompany)); is_valid_company(T, GameName)).

% The following code contains the videogames and their descriptions that will be used for queries 
game("Valorant", "Riot", "FPS", ["PC"]).
game("League Of Legends", "Riot", "MMORPG", ["PC", "macOS"]).
game("League Of Legends: Wild Rift", "Riot", "MMORPG", ["Mobile"]).
game("Call Of Duty Mobile", "Activision", "FPS", ["Mobile"]).
game("Minecraft", "Mojang", "Sandbox", ["PC", "macOS", "Console"]).
game("Minecraft: Pocket Edition", "Mojang", "Sandbox", ["Mobile"]).
game("Minesweeper", "Microsoft", "Puzzle", ["PC"]).
game("Solitaire", "Microsoft", "Puzzle", ["PC"]).
game("Halo Series", "343 Industries", "FPS", ["Console"]).
game("Call of Duty Series", "Activision", "FPS", ["Console", "PC"]).
game("Tetris", "SEGA", "Puzzle", ["PC", "macOS", "Mobile"]).
game("Pacman", "Bandai Namco", "Puzzle", ["PC", "macOS", "Mobile"]).
game("World of Warcraft", "Blizzard Entertainment", "MMORPG", ["PC", "macOS"]).
game("Overwatch", "Blizzard Entertainment", "FPS", ["PC", "Console"]).
game("Among Us", "InnerSloth LLC", "Puzzle", ["PC", "macOS", "Mobile"]).
game("Fortnite", "Epic Games", "Battle-Royale", ["Console", "PC", "Mobile"]).
game("Sneaky Sasquatch", "RAC7 Games", "Sandbox", ["macOS"]).
game("LEGO Brawls", "Red Games Co.", "Fighter", ["macOS"]).
game("LEGO Star Wars Series", "Warner Bros. Interactive Entertainment", "Action-Adventure", ["PC", "macOS", "Console"]).
game("Grand Theft Auto Series", "Rockstar Games", "Sandbox", ["PC", "Console"]).
game("The Legend of Zelda Series", "Nintendo", "Action-Adventure", ["Console"]).    
game("Animal Crossing: New Horizons", "Nintendo", "Sandbox", ["Console"]).
game("Super Mario 64", "Nintendo", "Action-Adventure", ["Console"]).
game("Madden NFL Series", "EA Sports", "Sports", ["PC", "Console", "Mobile"]).
game("NBA 2K Series", "2K Games", "Sports", ["PC", "Console"]).
game("NHL Series", "EA Sports", "Sports", ["Console"]).
game("FIFA Series", "EA Sports", "Sports", ["Mobile", "Console", "PC"]).
game("Cyberpunk 2077", "CD Projekt", "Sandbox", ["Console", "PC"]).
game("Pokemon Series", "Nintendo", "Action-Adventure", ["Console"]).
game("Pokemon Go", "Niantic", "Action-Adventure", ["Mobile"]).
game("Counter Strike: Global Offensive", "Valve", "FPS", ["PC", "macOS"]).
game("Mario Kart Series", "Nintendo", "Sports", ["Console", "Mobile"]).
game("Mario Party", "Nintendo", "Action-Adventure", ["PC", "macOS", "Console"]).
game("Overcooked Series", "Team17", "Action-Adventure", ["PC", "Console"]).
game("PlayerUnknown's Battlegrounds", "PUBG Corporation", "Battle-Royale", ["PC", "Console", "Mobile"]).
game("Candy Crush Saga", "King", "Puzzle", ["PC", "macOS", "Mobile"]).
game("DOTA 2", "Valve", "MMORPG", ["PC", "macOS"]).
game("Super Smash Bros. Ultimate", "Nintendo", "Fighter", ["Console"]).
game("Wii Sports", "Nintendo", "Sports", ["Console"]).
game("Wii Sports Resort", "Nintendo", "Sports", ["Console"]).
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
game("Tomb Raider", "Crystal Dynamics", "Action-Adventure", ["PC", "macOS", "Console"]).
game("The Elder Scrolls Series", "Bethesda", "Action-Adventure", ["PC", "Console"]).
game("Assasins Creed Series", "Ubisoft", "Action-Adventure", ["PC", "Console", "macOS"]).
game("Marvel's Avengers", "Square Enix", "Action-Adventure", ["PC", "Console"]).
game("Marvel's Spider-Man: Miles Morales", "Insomniac Games", "Action-Adventure", ["Console"]).
game("Monument Valley", "ustwogames", "Puzzle", ["Mobile"]).
game("2048", "Solebon LLC", "Puzzle", ["Mobile"]).
game("Portal 2", "Valve", "Puzzle", ["PC", "macOS", "Console"]).
game("Star Wars Jedi: Fallen Order", "Respawn Entertainment", "Action-Adventure", ["PC", "Console"]).
game("Rocket League", "Psyonix", "Sports", ["PC", "macOS", "Console"]).
game("PGA Tour Series", "2K Games", "Sports", ["PC", "Console"]).
game("Pong", "Atari", "Sports", ["PC", "macOS", "Mobile"]).
game("Runescape", "Jagex", "MMORPG", ["PC", "macOS"]).
game("Genshin Impact", "miHoYo", "Action-Adventure", ["PC", "Mobile", "Console"]).
game("Roblox", "Roblox Corporation", "MMORPG", ["PC", "macOS", "Console"]).
game("Terraria", "Re-Logic", "Sandbox", ["PC", "macOS", "Console"]).
game("Garry's Mod", "Facepunch Studios Ltd", "Sandbox", ["PC", "macOS"]).
game("Half-Life Series", "Valve", "FPS", ["PC", "Console"]).
game("Team Fortress 2", "Valve", "FPS", ["PC", "macOS", "Console"]).
game("Tom Clancy's Rainbow Six Siege", "Ubisoft", "FPS", ["PC", "Console"]).
game("Destiny 2", "Bungie Inc", "FPS", ["PC", "Console"]).
game("DOOM Eternal", "Bethesda", "FPS", ["PC", "Console"]).
game("Far Cry Series", "Ubisoft", "FPS", ["PC", "Console"]).
game("Titanfall 2", "Respawn Entertainment", "FPS", ["PC", "Console"]).
game("BioShock Series", "Irrational Games", "FPS", ["PC", "macOS", "Console"]).
game("Metro Exodus", "4A Games", "FPS", ["PC", "macOS", "Console"]).
game("Borderlands Series", "Gearbox Software", "FPS", ["PC", "macOS", "Console"]).
game("Wolfenstein Series", "MachineGames", "FPS", ["PC", "Console"]).
game("Crysis Series", "Crytek", "FPS", ["PC", "Console"]).
game("Clash of Clans", "Supercell", "RTS", ["Mobile"]).
game("Clash Royale", "Supercell", "RTS", ["Mobile"]).
game("Brawl Stars", "Supercell", "MMORPG", ["Mobile"]).
game("Diablo Series", "Blizzard", "MMORPG", ["PC", "Console"]).
game("Firewatch", "Panic", "Action-Adventure", ["PC", "macOS", "Console"]).
game("Hearthstone", "Blizzard", "RTS", ["PC", "macOS", "Mobile"]).
game("Civilization Series", "Sid Meier", "Puzzle", ["PC", "macOS", "Console"]).
game("SimCity Series", "EA", "Sandbox", ["PC", "macOS"]).
game("The Sims Series", "EA", "Sandbox", ["PC", "macOS", "Console"]).
game("Resident Evil Series", "Capcom", "Action-Adventure", ["PC", "Console"]).
game("Age of Empires Series", "Relic Entertainment", "RTS", ["PC", "macOS"]).
game("Total War Series", "Creative Assembly", "RTS", ["PC", "macOS"]).
game("StarCraft Series", "Blizzard", "RTS", ["PC", "macOS"]).
game("Boom Beach", "Supercell", "RTS", ["Mobile"]).
game("Pummel Party", "Rebuilt Games", "Action-Adventure", ["PC"]).
