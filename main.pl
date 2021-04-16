% Videogame Recommender
% CPSC 312 2021 Prolog Project
% Authors: Alan Yan, Richard Li

% WE ARE MAKING A GAME RECOMMENDER
% Takes a list of games u play, recommends game you might want to try
% TYPE -> MASSIVE-MULTIPLAYER-ONLINE-ROLE-PLAYING-GAME (MMORPG), FIRST-PERSON-SHOOTER (FPS), SANDBOX, ACTION-ADVENTURE, SPORTS, PUZZLE, BATTLE-ROYALE, FIGHTER, REAL-TIME-STRATEGY (RTS)
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

% The following code contains the videogames and their descriptions that will be used for queries 
game("Valorant", "Riot", "FPS", ["PC"]).
game("League Of Legends", "Riot", "MMORPG", ["PC", "macOS"]).
game("League Of Legends: Wild Rift", "Riot", "MMORPG", ["Mobile"]).
game("Call Of Duty Mobile", "Activision", "FPS", ["Mobile"]).
game("Minecraft", "Mojang", "Sandbox", ["PC", "macOS", "Console"]).
game("Minecraft: Pocket Edition", "Mojang", "Sandbox", ["Mobile"]).
game("Minesweeper", "Microsoft", "Puzzle", ["PC"]).
game("Solitaire", "Microsoft", "Puzzle", ["PC"]).
game("Halo Series", "343 Industries", "FPS", ["Console", "PC"]).
game("Call of Duty Series", "Activision", "FPS", ["Console", "PC"]).
game("Tetris", "SEGA", "Puzzle", ["PC", "macOS", "Mobile"]).
game("Pacman", "Bandai Namco", "Puzzle", ["PC", "macOS", "Mobile"]).
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
game("Pokemon Series", "Nintendo", "Action-Adventure", ["Console"]).
game("Pokemon Go", "Niantic", "Action-Adventure", ["Mobile"]).
game("Counter Strike: Global Offensive", "Valve", "FPS", ["PC", "macOS"]).
game("Mario Kart", "Nintendo", "Sports", ["Console", "Mobile"]).
game("Mario Party", "Nintendo", "Action-Adventure", ["PC", "macOS", "Console"]).
game("Overcooked Series", "Team17", "Action-Adventure", ["PC", "Console"]).
game("PlayerUnknown's Battlegrounds", "PUBG Corporation", "Battle-Royale", ["PC", "Console", "Mobile"]).
game("Candy Crush Saga", "King", "Puzzle", ["PC", "macOS", "Mobile"]).
game("DOTA 2", "Valve", "MMORPG", ["PC", "macOS"]).
game("Super Smash Bros. Ultimate", "Bandai Namco", "Fighter", ["Console"]).
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
