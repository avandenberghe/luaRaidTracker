--local L =  LibStub("AceLocale-3.0"):GetLocale("RaidTracker", true)

 --Conventions: Tags [TAQ], Real Name [Ahn'Qiraj], Display Name [Ahn'Qiraj Temple]
 --  tags         - for having a unique identifier for a zone reguardles of anything else, like changes in game, locale or whatever
 --  real name    - for mapping when GetRealZoneName is called in an instance, is the locale specific real instance name
 --  display name - the map name which is also locale specific for a zone

RaidTracker_Games = {
	[0] = { id=0, c="", r=1, g=1, b=1, c2="", r2=1, g2=1, b2=1, },
	[1] = { id=1, c="|c00ffd657", r=217, g=141, b=7,   c1="", r1=1, g1=1, b1=1,   c2="", r2=1, g2=1, b2=1, },
	[2] = { id=2, c="|c00d1ff11", r=171, g=209, b=79,  c1="", r1=1, g1=1, b1=1,   c2="", r2=1, g2=1, b2=1, },
	[3] = { id=3, c="|c0076dfff", r=118, g=223, b=255, c1="", r1=1, g1=1, b1=1,   c2="", r2=1, g2=1, b2=1, },
	[4] = { id=4, c="|c00f4aa16", r=217, g=141, b=7,   c1="", r1=1, g1=1, b1=1,   c2="", r2=1, g2=1, b2=1, },
	[5] = { id=5, c="|c006af52a", r=106, g=245, b=42,  c1="", r1=1, g1=1, b1=1,   c2="", r2=1, g2=1, b2=1, },
};

RaidTracker_Tags = {
	-- releases
	["REL0"]	= "World Event",
	["REL1"]	= "Classic",
	["REL2"]	= "The Burning Crusade",
	["REL3"]	= "Wrath of the Lich King",
	["REL4"]	= "Cataclysm",
	["REL5"]	= "Mists of Pandaria",
	-- zones
	["WB"]=		{ id=1,  mid=0,   name="World Boss", },
	["KM"]=		{ id=2,  mid=0,   name="Kalimdor", },
	["KM:DWM"]=	{ id=3,  mid=907, name="Dustwallow Marsh", },
	["KM:SIL"]=	{ id=4,  mid=261, name="Silithus", },
	["KM:TAN"]=	{ id=5,  mid=161, name="Tanaris", },
	["KM:DTR"]=	{ id=6,  mid=4,   name="Durotar", },
	["KM:NBR"]=	{ id=7,  mid=11,  name="Northern Barrens", },
	["KM:AVL"]=	{ id=8,  mid=43,  name="Ashenvale", },
	["KM:ORG"]=	{ id=52, mid=0,   name="Orgrimmar", },
	["EK"]=		{ id=9,  mid=0,   name="Eastern Kingdoms", },
	["EK:BRM"]=	{ id=10, mid=0,   name="Blackrock Mountain", },
	["EK:STV"]=	{ id=11, mid=689, name="Stranglethorn Vale", },
	["EK:DWP"]=	{ id=12, mid=32,  name="Deadwind Pass", },
	["EK:EPL"]=	{ id=13, mid=0,   name="Easterm Plaguelands", },
	["EK:STW"]=	{ id=14, mid=0,   name="Stormwind", },
	["EK:AHL"]=	{ id=15, mid=16,  name="Arathi Highlands", },
	["OL"]=		{ id=16, mid=0,   name="Outlands", },
	["OL:BEM"]=	{ id=17, mid=475, name="Blade's Edge Mountains", },
	["NR"]=		{ id=18, mid=0,   name="Northrend", },
	["NR:BRT"]=	{ id=19, mid=486, name="Borean Tundra", },
	["NR:CLD"]=	{ id=20, mid=0,   name="Coldarra", },
	["NR:NEX"]=	{ id=21, mid=803, name="The Nexus", },
	["NR:UTG"]=	{ id=22, mid=523, name="Utgarde Keep", },
	["NR:PON"]=	{ id=23, mid=0,   name="Pit of Narjun", },
	["NR:DAL"]=	{ id=24, mid=924, name="Dalaran", },
	["NR:UDR"]=	{ id=25, mid=529, name="Ulduar", },
	["NR:ZDK"]=	{ id=26, mid=496, name="Zul'Drak", },
	["NR:WRT"]=	{ id=27, mid=0,   name="Wyrmrest Temple", },
	["NR:WGK"]=	{ id=28, mid=0,   name="Wintergrasp Fortress", },
	["NR:ICR"]=	{ id=29, mid=492, name="Icecrown", },
	["NR:ATG"]=	{ id=30, mid=0,   name="Argent Tournament Grounds", },
	["NR:ICG"]=	{ id=31, mid=0,   name="Icecrown Glacier", },
	["KM:MTH"]=	{ id=32, mid=683, name="Mount Hyjal", },
	["EK:VAI"]=	{ id=33, mid=613, name="Vashj'ir", },
	["EK:WTF"]=	{ id=34, mid=39,  name="Westfall", },
	["EK:SPF"]=	{ id=35, mid=21,  name="Silverpine Forest", },
	["TM"]=		{ id=36, mid=751, name="The Maelstrom", },
	["TM:DEH"]=	{ id=37, mid=640, name="Deepholm", },
	["KM:ULD"]=	{ id=38, mid=748, name="Uldum", },
	["EK:TWH"]=	{ id=39, mid=770, name="Twilight Highlands", },
	["EK:TOB"]=	{ id=40, mid=708, name="Tol Barad", },
	["EK:TSG"]=	{ id=41, mid=20,  name="Tirisfal Glades", },
	["EK:WPL"]=	{ id=42, mid=22,  name="Western Plaguelands", },
	["PD"]=		{ id=43, mid=0,   name="Pandaria", },
	["PD:TJF"]=	{ id=44, mid=880, name="The Jade Forest", },
	["PD:VFW"]=	{ id=45, mid=807, name="Valley of the Four Winds", },
	["PD:KLS"]=	{ id=46, mid=879, name="Kun-Lai Summit", },
	["PD:VEB"]=	{ id=47, mid=937, name="Vale of Eternal Blossoms", },
	["PD:TLS"]=	{ id=48, mid=810, name="Townlong Steppes", },
	["PD:DRW"]=	{ id=49, mid=858, name="Dread Wastes", },
	["PD:TVS"]=	{ id=50, mid=873, name="The Veiled Stair", },
	["PD:IOT"]=	{ id=51, mid=933, name="Isle of Thunder", },
}

-- instName, ordinal, progress, game, instID, mapID, location, type, man, level, range, mapName
RaidTracker_Zones = {
	-- ALL
	["World Boss"]					= { id=0,  pid=0,  rel=0, iid=0,  mid=0,   loc="WB",     type="Raid",  man=40, min=0,  ran="60",	name="World Boss", },
	["Teldrassil"]					= { id=0,  pid=0,  rel=1, iid=0,  mid=41,  loc="KM",     type="Raid",  man=40, min=58, ran="1-12",	name="Teldrassil", },
	-- BG
	["Warsong Gulch"] 				= { id=78, pid=1,  rel=1, iid=0,  mid=443, loc="KM:AVL", type="Raid",  man=10, min=5, ran="5-90",	name="Warsong Gulch", },
	["Arathi Basin"]				= { id=79, pid=1,  rel=1, iid=0,  mid=461, loc="EK:AHL", type="Raid",  man=15, min=5, ran="5-90",	name="Arathi Basin", },
	-- CLASSIC
	["Ragefire Chasm"]				= { id=1,  pid=2,  rel=1, iid=389,mid=680, loc="KM:DTR", type="Party", man=5,  min=10, ran="15-16",	name="Ragefire Chasm", },
	["Wailing Caverns"]				= { id=2,  pid=3,  rel=1, iid=43, mid=749, loc="KM:NBR", type="Party", man=5,  min=10, ran="15-25",	name="Wailing Caverns", },
	["Blackfathom Deeps"]			= { id=4,  pid=5,  rel=1, iid=48, mid=688, loc="KM:AVL", type="Party", man=5,  min=15, ran="20-30",	name="Blackfathom Deeps", },
	["Stormwind Stockade"]			= { id=3,  pid=6,  rel=1, iid=34, mid=690, loc="EK:STW", type="Party", man=5,  min=15, ran="20-30",	name="Stormwind Stockade", mame="The Stockade", },
	["Molten Core"]					= { id=5,  pid=13, rel=1, iid=0,  mid=696, loc="EK:BRM", type="Raid",  man=40, min=58, ran="60+",	name="Molten Core", },
	["Blackwing Lair"]				= { id=6,  pid=15, rel=1, iid=0,  mid=755, loc="EK:BRM", type="Raid",  man=40, min=60, ran="60++",	name="Blackwing Lair", },
	["Onyxia's Lair1"]				= { id=7,  pid=14, rel=1, iid=0,  mid=0,   loc="KM:DWM", type="Raid",  man=40, min=58, ran="60+",	name="Onyxia's Lair", },
	["Zul'Gurub1"]					= { id=8,  pid=10, rel=1, iid=0,  mid=0,   loc="EK:STV", type="Raid",  man=20, min=56, ran="60",	name="Zul'Gurub", },
	["Ruins of Ahn'Qiraj"]			= { id=9,  pid=11, rel=1, iid=0,  mid=717, loc="KM:TAN", type="Raid",  man=20, min=58, ran="60",	name="Ruins of Ahn'Qiraj", },
	["Ahn'Qiraj"]					= { id=10, pid=12, rel=1, iid=0,  mid=766, loc="KM:TAN", type="Raid",  man=40, min=60, ran="60+",	name="Ahn'Qiraj", },
	["Naxxramas1"]					= { id=11, pid=16, rel=1, iid=0,  mid=0,   loc="EK:STV", type="Raid",  man=40, min=60, ran="60+++",	name="Naxxramas", },
	-- TBC
	["Karazhan"]					= { id=12, pid=17, rel=2, iid=0, mid=799, loc="EK:DWP", type="Raid",  man=10, min=68, ran="70+",	name="Karazhan", },
	["Gruul's Lair"]				= { id=13, pid=18, rel=2, iid=0, mid=776, loc="OL:BEM", type="Raid",  man=25, min=68, ran="70+",	name="Gruul's Lair", },
	["Magtheridon's Lair"]			= { id=14, pid=19, rel=2, iid=0, mid=779, loc="OL:BEM", type="Raid",  man=25, min=68, ran="70+",	name="Magtheridon's Lair", },
	["Serpentshrine Cavern"]		= { id=15, pid=21, rel=2, iid=0, mid=780, loc="OL:BEM", type="Raid",  man=25, min=70, ran="70++",	name="Serpentshrine Cavern", },
	["Tempest Keep"]				= { id=16, pid=22, rel=2, iid=0, mid=782, loc="OL:BEM", type="Raid",  man=25, min=70, ran="70++",	name="Tempest Keep", },
	["Hyjal Summit"]				= { id=17, pid=23, rel=2, iid=0, mid=775, loc="OL:BEM", type="Raid",  man=25, min=70, ran="70+++",	name="Hyjal Summit", },
	["Black Temple"]				= { id=18, pid=24, rel=2, iid=0, mid=919, loc="OL:BEM", type="Raid",  man=25, min=70, ran="70+++",	name="Black Temple", },
	["Zul'Aman1"]					= { id=19, pid=20, rel=2, iid=0, mid=0,   loc="OL:BEM", type="Raid",  man=10, min=70, ran="70++",	name="Zul'Aman", },
	["Sunwell Plateau"]				= { id=20, pid=25, rel=2, iid=0, mid=789, loc="OL:BEM", type="Raid",  man=25, min=70, ran="70+++",	name="Sunwell Plateau", },
	["Utgarde Keep"]				= { id=21, pid=26, rel=3, iid=0, mid=523, loc="NR:UTG", type="Party", man=5,  min=65, ran="70-72",	name="Utgarde Keep", },
	["The Nexus"]					= { id=22, pid=27, rel=3, iid=0, mid=803, loc="NR:NEX", type="Party", man=5,  min=66, ran="71-73",	name="The Nexus", },
	["Azjol-Nerub"]					= { id=23, pid=28, rel=3, iid=0, mid=533, loc="NR:PON", type="Party", man=5,  min=67, ran="72-74",	name="Azjol-Nerub", },
	["Ahn'kahet: The Old Kingdom"]	= { id=24, pid=29, rel=3, iid=0, mid=522, loc="NR:PON", type="Party", man=5,  min=68, ran="73-75",	name="Ahn'kahet: The Old Kingdom", },
	["Drak'Tharon Keep"]			= { id=25, pid=30, rel=3, iid=0, mid=534, loc="NR:ZDK", type="Party", man=5,  min=69, ran="74-76",	name="Drak'Tharon Keep", },
	["The Violet Hold"]				= { id=26, pid=31, rel=3, iid=0, mid=536, loc="NR:DAL", type="Party", man=5,  min=70, ran="75-77",	name="The Violet Hold", },
	["Gundrak"]						= { id=27, pid=32, rel=3, iid=0, mid=530, loc="NR:ZDK", type="Party", man=5,  min=71, ran="76-78",	name="Gundrak", },
	["Halls of Stone"]				= { id=28, pid=33, rel=3, iid=0, mid=526, loc="NR:UDR", type="Party", man=5,  min=72, ran="77-79",	name="Halls of Stone", },
	["The Oculus"]					= { id=29, pid=34, rel=3, iid=0, mid=528, loc="NR:NEX", type="Party", man=5,  min=75, ran="80",		name="The Oculus", },
	["Utgarde Pinnacle"]			= { id=30, pid=35, rel=3, iid=0, mid=524, loc="NR:UTG", type="Party", man=5,  min=75, ran="80",		name="Utgarde Pinnacle", },
	["The Culling of Stratholme"]	= { id=31, pid=36, rel=3, iid=0, mid=521, loc="KM:TAN", type="Party", man=5,  min=75, ran="80",		name="The Culling of Stratholme", },
	["Halls of Lightning"]			= { id=32, pid=37, rel=3, iid=0, mid=525, loc="NR:UDR", type="Party", man=5,  min=75, ran="80",		name="Halls of Lightning", },
	["Naxxramas"]					= { id=33, pid=42, rel=3, iid=0, mid=535, loc="NR:NEX", type="Raid",  man=10, min=78, ran="80+",	name="Naxxramas", },
	["The Obsidian Sanctum"]		= { id=34, pid=43, rel=3, iid=0, mid=531, loc="NR:WRT", type="Raid",  man=10, min=78, ran="80+",	name="The Obsidian Sanctum", },
	["Vault of Archavon"]			= { id=35, pid=44, rel=3, iid=0, mid=532, loc="NR:WGK", type="Raid",  man=10, min=78, ran="80+",	name="Vault of Archavon", },
	["The Eye of Eternity"]			= { id=36, pid=45, rel=3, iid=0, mid=527, loc="NR:NEX", type="Raid",  man=10, min=80, ran="80++",	name="The Eye of Eternity", },
	["Ulduar"]						= { id=37, pid=46, rel=3, iid=0, mid=529, loc="NR:UDR", type="Raid",  man=10, min=80, ran="80++",	name="Ulduar", },
	["Trial of the Champion"]		= { id=38, pid=38, rel=3, iid=0, mid=542, loc="NR:ICR", type="Party", man=5,  min=80, ran="80+",	name="Trial of the Champion", },
	["Trial of the Crusader"]		= { id=39, pid=47, rel=3, iid=0, mid=543, loc="NR:ICR", type="Raid",  man=10, min=80, ran="80+++",	name="Trial of the Crusader", },
	["Onyxia's Lair"]				= { id=40, pid=48, rel=3, iid=0, mid=718, loc="KM:DWM", type="Raid",  man=10, min=80, ran="80+++",	name="Onyxia's Lair", },
	["The Forge of Souls"]			= { id=41, pid=39, rel=3, iid=0, mid=601, loc="NR:ICG", type="Party", man=5,  min=80, ran="80++",	name="The Forge of Souls", },
	["Pit of Saron"]				= { id=42, pid=40, rel=3, iid=0, mid=602, loc="NR:ICG", type="Party", man=5,  min=80, ran="80++",	name="Pit of Saron", },
	["Halls of Reflection"]			= { id=43, pid=41, rel=3, iid=0, mid=603, loc="NR:ICG", type="Party", man=5,  min=80, ran="80++",	name="Halls of Reflection", },
	["Icecrown Citadel"]			= { id=44, pid=49, rel=3, iid=0, mid=604, loc="NR:ICG", type="Raid",  man=10, min=80, ran="80++++",	name="Icecrown Citadel", },
	-- CATACLYSM
	["Deadmines"]					= { id=45, pid=1,  rel=4, iid=36, mid=756, loc="EK:WTF", type="Party", man=5,  min=10, ran="15-16", im="226", ih="329",	name="Deadmines", mame="The Deadmines", },
	["Shadowfang Keep"]				= { id=46, pid=4,  rel=4, iid=0,  mid=764, loc="EK:SPF", type="Party", man=5,  min=11, ran="18-21", im="226", ih="329",	name="Shadowfang Keep", },
	["Blackrock Caverns"]			= { id=47, pid=50, rel=4, iid=0,  mid=753, loc="EK:BRM", type="Party", man=5,  min=80, ran="80-82", im="226", ih="329",	name="Blackrock Caverns", },
	["Throne of the Tides"]			= { id=48, pid=51, rel=4, iid=0,  mid=767, loc="EK:VAI", type="Party", man=5,  min=80, ran="80-82", im="226", ih="329",	name="Throne of the Tides", },
	["The Vortex Pinnacle"]			= { id=49, pid=52, rel=4, iid=0,  mid=769, loc="KM:ULD", type="Party", man=5,  min=81, ran="82-84", im="272", ih="329",	name="The Vortex Pinnacle", },
	["The Stonecore"]				= { id=50, pid=53, rel=4, iid=0,  mid=768, loc="TM:DEH", type="Party", man=5,  min=81, ran="82-84", im="272", ih="329",	name="The Stonecore", },
	["Lost City of the Tol'vir"]	= { id=51, pid=54, rel=4, iid=0,  mid=747, loc="KM:ULD", type="Party", man=5,  min=84, ran="84-85", im="305", ih="329",	name="Lost City of the Tol'vir", },
	["Halls of Origination"]		= { id=52, pid=55, rel=4, iid=0,  mid=759, loc="KM:ULD", type="Party", man=5,  min=85, ran="85", im="305", ih="329",	name="Halls of Origination", },
	["Grim Batol"]					= { id=53, pid=56, rel=4, iid=0,  mid=757, loc="EK:TWH", type="Party", man=5,  min=85, ran="85", im="205", ih="329",	name="Grim Batol", },
	["Zul'Aman"]					= { id=54, pid=57, rel=4, iid=0,  mid=781, loc="EK:EPL", type="Party", man=5,  min=85, ran="85+", im="346", dn="353",	name="Zul'Aman", },
	["Zul'Gurub"]					= { id=55, pid=58, rel=4, iid=0,  mid=793, loc="EK:STV", type="Party", man=5,  min=85, ran="85+", im="346", dn="353",	name="Zul'Gurub", },
	["End Time"]					= { id=56, pid=59, rel=4, iid=0,  mid=820, loc="KM:TAN", type="Party", man=5,  min=85, ran="85+", im="353", dn="378",	name="End Time", },
	["Well of Eternity"]			= { id=57, pid=60, rel=4, iid=0,  mid=816, loc="KM:TAN", type="Party", man=5,  min=85, ran="85+", im="353", dn="378",	name="Well of Eternity", },
	["Hour of Twilight"]			= { id=58, pid=61, rel=4, iid=0,  mid=819, loc="KM:TAN", type="Party", man=5,  min=85, ran="85+", im="353", dn="378",	name="Hour of Twilight", },
	["Blackwing Descent"]			= { id=59, pid=62, rel=4, iid=0,  mid=754, loc="EK:BRM", type="Raid",  man=10, min=85, ran="85+", im="372",		name="Blackwing Descent", },
	["Baradin Hold"]				= { id=60, pid=63, rel=4, iid=0,  mid=752, loc="EK:TOB", type="Raid",  man=10, min=85, ran="85+", im="372",		name="Baradin Hold", },
	["Throne of the Four Winds"]	= { id=61, pid=64, rel=4, iid=0,  mid=773, loc="KM:ULD", type="Raid",  man=10, min=85, ran="85+", im="372",		name="Throne of the Four Winds", },
	["The Bastion of Twilight"]		= { id=62, pid=65, rel=4, iid=0,  mid=758, loc="EK:TWH", type="Raid",  man=10, min=85, ran="85+", im="372",		name="The Bastion of Twilight", },
	["Firelands"]					= { id=63, pid=66, rel=4, iid=0,  mid=800, loc="KM:TAN", type="Raid",  man=10, min=85, ran="85++", im="372",	name="Firelands", },
	["Dragon Soul"]					= { id=64, pid=67, rel=4, iid=0,  mid=824, loc="KM:TAN", type="Raid",  man=10, min=85, ran="85+++", im="372",	name="Dragon Soul", },
	-- PANDARIA
	["Scarlet Halls"]				= { id=65, pid=7,  rel=5, iid=0,  mid=871, loc="EK:TSG", type="Party", man=5,  min=21, ran="26-36", ih="440", dh="463",	name="Scarlet Halls", },
	["Scarlet Monastery"]			= { id=66, pid=8,  rel=5, iid=0,  mid=874, loc="EK:TSG", type="Party", man=5,  min=23, ran="28-38", ih="440", dh="463",	name="Scarlet Monastery", },
	["Scholomance"]					= { id=67, pid=9,  rel=5, iid=0,  mid=898, loc="EK:WPL", type="Party", man=5,  min=33, ran="38-48", ih="440", dh="463",	name="Scholomance", },
	["Temple of the Jade Serpent"]	= { id=68, pid=68, rel=5, iid=0,  mid=867, loc="PD:TJF", type="Party", man=5,  min=85, ran="85-87", im="358", dn="400", ih="440", dh="463",	name="Temple of the Jade Serpent", },
	["Stormstout Brewery"]			= { id=69, pid=69, rel=5, iid=0,  mid=876, loc="PD:VFW", type="Party", man=5,  min=85, ran="85-87", im="358", dn="410", ih="440", dh="463",	name="Stormstout Brewery", },
	["Shado-Pan Monastery"]			= { id=70, pid=70, rel=5, iid=0,  mid=877, loc="PD:KLS", type="Party", man=5,  min=87, ran="87-89", im="393", dn="420", ih="440", dh="463",	name="Shado-Pan Monastery", },
	["Mogu'shan Palace"]			= { id=71, pid=71, rel=5, iid=0,  mid=885, loc="PD:VEB", type="Party", man=5,  min=87, ran="87-89", im="393", dn="430", ih="440", dh="463",	name="Mogu'shan Palace", },
	["Siege of Niuzao Temple"]		= { id=72, pid=72, rel=5, iid=0,  mid=887, loc="PD:TLS", type="Party", man=5,  min=89, ran="90", im="440", dn="463",	name="Siege of Niuzao Temple", },
	["Gate of the Setting Sun"]		= { id=73, pid=73, rel=5, iid=0,  mid=875, loc="PD:TLS", type="Party", man=5,  min=89, ran="90", im="440", dn="463",	name="Gate of the Setting Sun", },
	["Mogu'shan Vaults"]			= { id=74, pid=74, rel=5, iid=0,  mid=896, loc="PD:KLS", type="Raid",  man=10, min=89, ran="90+", im="440", dn="489",	name="Mogu'shan Vaults", },
	["Heart of Fear"]				= { id=75, pid=75, rel=5, iid=0,  mid=897, loc="PD:DRW", type="Raid",  man=10, min=89, ran="90+", im="440", dn="489",	name="Heart of Fear", },
	["Terrace of Endless Spring"]	= { id=76, pid=76, rel=5, iid=0,  mid=886, loc="PD:TVS", type="Raid",  man=10, min=89, ran="90+", im="440", dn="489",	name="Terrace of Endless Spring", },
	["Throne of Thunder"]			= { id=77, pid=77, rel=5, iid=0,  mid=930, loc="PD:IOT", type="Raid",  man=10, min=89, ran="90++", im="440", dn="489",	name="Throne of Thunder", },
	["Siege of Orgrimmar"]			= { id=78, pid=78, rel=5, iid=0,  mid=953, loc="KM:ORG", type="Raid",  man=10, min=89, ran="90+++", im="440", dn="489",	name="Siege of Orgrimmar", },
}

-- is realy just a lookup drop down list atm
--   realy nice if to not just waste on dropdowns
RaidTracker_ZoneBosses = {
	["Trash mob"] = 1,
	["World Boss"] = {
		"Lord Kazzak", "Azuregos",													-- raid, tainted scar in blasted lands, Southeast Azshara
		"Emeriss", "Lethon", "Ysondre", "Taerar",									-- raid, emarlad dragons Duskwood (Twilight Grove), the Hinterlands (Seradane), Feralas (Dream Bough), and Ashenvale (Bough Shadow).
		"Lord Skwol", "Baron Kazum", "High Marshal Whirlaxis", "Prince Skaldrenox", -- raid, silithus
		"Avalanchion", "Baron Charr", "Princess Tempestria", "The Windreaver",		-- party, elemental, azshara, unguro, Ruins of Kel'Theril in Winterspring, silithus
		-- tbc
		"Highlord Kruul", "Doom Lord Kazzak", "Doomwalker",
		-- panda
		"Salyis's Warband", "Galleon", "Sha of Anger",
	},
	-- Classic
	["Teldrassil"] = { "Nightsaber Stalker", },
	["Ragefire Chasm"] = { "Adarogg","Dark Shaman Koranthal","Slagmaw","Lava Guard Gordoth", },
	["Wailing Caverns"] = { "Lady Anacondra","Lord Pythas","Lord Cobrahn","Kresh","Skum","Lord Serpentis","Verdan the Everliving","Mutanus the Devourer", },
	["Stormwind Stockade"] = { "Hogger","Lord Overheat","Randolph Moloch", },
	["Blackfathom Deeps"] = { "Ghamoo-Ra","Lady Sarevess","Gelihast","Old Serra'kis","Twilight Lord Kelris","Aku'mai", },
	["Molten Core"] = { "Lucifron","Magmadar","Gehennas","Garr","Baron Geddon","Shazzrah","Sulfuron Harbinger","Golemagg the Incinerator","Majordomo Executus","Ragnaros", },
	["Blackwing Lair"] = { "Razorgore the Untamed","Vaelastrasz the Corrupt","Broodlord Lashlayer","Firemaw","Ebonroc","Flamegor","Chromaggus","Nefarian", },
	["Zul'Gurub1"] = { "High Priestess Jeklik","High Priest Venoxis","High Priestess Mar'li","High Priest Thekal","High Priestess Arlokk","Hakkar","Bloodlord Mandokir","Jin'do the Hexxer","Gahz'ranka","Hazza'rah","Gri'lek","Renataki","Wushoolay", },
	["Ahn'Qiraj"] = { "The Prophet Skeram","Fankriss the Unyielding","Battleguard Sartura","Princess Huhuran","Twin Emperors","C'Thun","Vem","Princess Yauj","Lord Kri","Viscidus","Ouro", },
	["Ruins of Ahn'Qiraj"] = { "Kurinnaxx","General Rajaxx","Ayamiss the Hunter","Moam","Buru the Gorger","Ossirian the Unscarred", },
	-- TBC
	["Karazhan"] = { "Attumen the Huntsman","Moroes","Maiden of Virtue",
		["Theater Event"] = { "Unknown","The Crone","The Big Bad Wolf","Romulo and Julianne", },
		"The Curator","Terestian Illhoof","Shade of Aran","Chess Event","Prince Malchezaar","Netherspite","Nightbane",
		"Rokad the Ravager","Hyakiss the Lurker","Shadikith the Glider","Echo of Medivh","Image of Medivh",	},
	["Gruul's Lair"] = { "High King Maulgar","Gruul the Dragonkiller", },
	["Magtheridon's Lair"] = { "Magtheridon", },
	["Serpentshrine Cavern"] = { "Hydross the Unstable","The Lurker Below","Leotheras the Blind","Fathom-Lord Karathress","Morogrim Tidewalker","Lady Vashj", },
	["Caverns Of Time"] = { "Unknown", },
	["Black Temple"] = { "High Warlord Naj'entus","Supremus","Gurtogg Bloodboil","Teron Gorefiend","Shade of Akama","Reliquary of Souls","Mother Shahraz","Illidari Council","Illidan Stormrage", },
	["Tempest Keep"] = { "Al'ar","High Astromancer Solarian","Void Reaver","Kael'thas Sunstrider", },
	["Hyjal Summit"] = { "Rage Winterchill","Anetheron","Kaz'rogal","Azgalor","Archimonde", },
	["Zul'Aman1"] = { "Nalorakk","Akil'zon","Jan'alai","Halazzi","Witch Doctor","Hex Lord Malacrass","Zul'jin", },
	["Sunwell Plateau"] = { "Kalecgos","Sathrovarr the Corruptor","Brutallus","Felmyst","Eredar Twins","Entropius","Kil'jaeden", },
	-- WOTLK
	["Utgarde Keep"] = { "Dalronn the Controller","Skarvald the Constructor","Constructor & Controller","Ingvar the Plunderer","Prince Keleseth", },  -- "Constructor & Controller", --these are one encounter, so we do as an encounter name
	["The Nexus"] = { "Anomalus","Commander Stoutbeard","Grand Magus Telestra","Keristrasza","Ormorok the Tree-Shaper", },
	["Azjol-Nerub"] = { "Anub'arak","Hadronox","Krik'thir the Gatewatcher", },
	["Ahn'kahet: The Old Kingdom"]	= { "Amanitar","Elder Nadox","Herald Volazj","Jedoga Shadowseeker","Prince Taldaram", },
	["Drak'Tharon Keep"] = { "King Dred","Novos the Summoner","The Prophet Tharon'ja","Trollgore", },
	["The Violet Hold"] = { "Cyanigosa","Erekem","Ichoron","Lavanthor","Moragg","Xevozz","Zuramat the Obliterator", },
	["Gundrak"] = { "Eck the Ferocious","Drakkari Colossus","Gal'darah","Moorabi","Slad'ran", },
	["Halls of Stone"] = { "Krystallus","Maiden of Grief","Sjonnir The Ironshaper","The Tribunal of Ages", },
	["The Oculus"] = { "Drakos the Interrogator","Ley-Guardian Eregos","Mage-Lord Urom","Varos Cloudstrider", },
	["Utgarde Pinnacle"] = { "Skadi the Ruthless","King Ymiron","Svala Sorrowgrave","Gortok Palehoof", },
	["The Culling of Stratholme"] = { "Meathook","Chrono-Lord Epoch","Mal'Ganis","Salramm the Fleshcrafter", },
	["Halls of Lightning"] = { "General Bjarngrim","Ionar","Loken","Volkhan", },
	["Naxxramas"] = { "Patchwerk","Grobbulus","Gluth","Thaddius","Instructor Razuvious","Gothik the Harvester","Highlord Mograine",
		"Baron Rivendare","Thane Korth'azz","Lady Blaumeux","Sir Zeliek","The Four Horsemen","Noth the Plaguebringer",
		"Heigan the Unclean","Loatheb","Anub'Rekhan","Grand Widow Faerlina","Maexxna","Sapphiron","Kel'Thuzad", },
	["The Obsidian Sanctum"] = { "Sartharion","Shadron","Tenebron","Vesperon", },
	["Vault of Archavon"] = { "Archavon the Stone Watcher","Emalon the Storm Watcher","Koralon the Flame Watcher","Toravon the Ice Watcher", },
	["The Eye of Eternity"] = { "Malygos", },
	["Ulduar"] = { "Flame Leviathan","Ignis the Furnace Master","Razorscale","XT-002 Deconstructor","The Iron Council","Steelbreaker","Runemaster Molgeim",
		"Stormcaller Brundir","Kologarn","Auriaya","Mimiron","Freya","Thorim","Hodir","General Vezax","Yogg-Saron","Algalon the Observer", },
	["Trial of the Champion"] = { "Deathstalker Visceri","Eressea Dawnsinger","Mokra the Skullcrusher","Runok Wildmane","Zul'tore","Ambrose Boltspark",
		"Colosos","Jacob Alerius","Jaelyne Evensong","Lana Stouthammer","Argent Confessor Paletress","Eadric the Pure","The Black Knight", },
	["Trial of the Crusader"] = { "Anub'arak","Faction Champions","Lord Jaraxxus","The Beasts of Northrend","The Twin Val'kyr", },
	["Onyxia's Lair"] = { "Onyxia", },
	["The Forge of Souls"] = { "Bronjahm","Devourer of Souls", },
	["Pit of Saron"] = { "Forgemaster Garfrost","Smelting wife's father Garfrost","Krick and Ick","Krick","Ick","Scourgelord Tyrannus", },
	["Halls of Reflection"]	= { "Falric","Marwyn","The Lich King", },
	["Icecrown Citadel"] = { "Lord Marrowgar","Lady Deathwhisper","Icecrown Gunship Battle","Deathbringer Saurfang","Festergut","Rotface",
		"Professor Putricide","Blood Princes","Blood-Queen Lana'thel","Valithria Dreamwalker","Sindragosa","The Lich King", },
	-- Cataclysm
	["Deadmines"] = { "Glubtok","Helix Gearbreaker","Foe Reaper 5000","Admiral Ripsnarl","\"Captain\" Cookie","Vanessa VanCleef", },
	["Shadowfang Keep"] = { "Baron Ashbury","Baron Silverlaine","Commander Springvale","Lord Walden","Lord Godfrey", },
	["Blackrock Caverns"] = { "Rom'ogg Bonecrusher","Corla, Herald of Twilight","Karsh Steelbender","Beauty","Ascendant Lord Obsidius", },
	["Throne of the Tides"] = { "Lady Naz'jar","Commander Ulthok","Erunak Stonespeaker","Mindbender Ghur'sha","Ozumat", },
	["The Vortex Pinnacle"] = { "Grand Vizier Ertan","Altairus","Asaad", },
	["The Stonecore"] = { "Corborus","Slabhide","Ozruk","High Priestess Azil", },
	["Lost City of the Tol'vir"] = { "General Husam","High Prophet Barim","Lockmaw","Augh","Siamat", },
	["Halls of Origination"] = { "Temple Guardian Anhuur","Earthrager Ptah","Anraphet","Isiset","Ammunae","Setesh","Rajh", },
	["Grim Batol"] = { "General Umbriss","Forgemaster Throngus","Drahga Shadowburner","Drahga Shodowburner","Erudax", },
	["Zul'Gurub"] = { "High Priest Venoxis","Bloodlord Mandokir","Gri'lek","Hazza'rah","Renataki","Wushoolay",
		"High Priestess Kilnara","Zanzil","Jin'do the Godbreaker", },
	["Zul'Aman"] = { "Nalorakk","Akil'zon","Jan'alai","Halazzi","Hex Lord Malacrass","Daakara", },
	["End Time"] = { "Echo of Baine","Echo of Jaina","Echo of Sylvanas","Echo of Tyrande","Murozond", },
	["Well of Eternity"] = { "Peroth'arn","Queen Azshara","Mannoroth and Varo'then","Mannoroth","Varo'then", },
	["Hour of Twilight"] = { "Arcurion","Asira Dawnslayer","Archbishop Benedictus", },
	--Cata Raids
	["Blackwing Descent"] = { "Omnotron Defense System","Magmaw","Maloriak","Atramedes","Chimaeron","Nefarian", },
	["Baradin Hold"] = { "Argaloth","Occu'thar","Alizabal", "Pit Lord Argaloth", },
	["Throne of the Four Winds"] = { "Conclave of Wind","Al'Akir", },
	["The Bastion of Twilight"] = { "Halfus Wyrmbreaker","Valiona and Theralion","Ascendant Council","Cho'gall","Sinestra", },
	["Firelands"] = { "Beth'tilac","Lord Rhyolith","Alysrazor","Shannox","Baleroc","Majordomo Staghelm","Ragnaros","Occu'thar", },
	["Dragon Soul"] = { "Morchok","Warlord Zon'ozz","Yor'sahj the Unsleeping","Hagara the Stormbinder","Ultraxion",
		"Warmaster Blackhorn","Spine of Deathwing","Madness of Deathwing", },
	-- Pandaria
	["Scarlet Halls"] = { "Houndmaster Braun","Armsmaster Harlan","Flameweaver Koegler", },
	["Scarlet Monastery"] = { "Thalnos the Soulrender","Brother Korloff","High Inquisitor Whitemane", },
	["Scholomance"] = { "Instructor Chillheart","Jandice Barov","Rattlegore","Lilian Voss","Darkmaster Gandling", },
	["Temple of the Jade Serpent"] = { "Wise Mari","Lorewalker Stonestep","Liu Flameheart","Sha of Doubt", },
	["Stormstout Brewery"] = { "Ook-Ook","Hoptallus","Yan-Zhu the Uncasked", },
	["Mogu'shan Palace"] = { "Trial of the King","Ming the Cunning","Kuai the Brute","Haiyan the Unstoppable",
		"Gekkan","Xin the Weaponmaster", },
	["Shado-Pan Monastery"] = { "Gu Cloudstrike","Master Snowdrift","Sha of Violence","Taran Zhu", },
	["Siege of Niuzao Temple"] = { "Vizier Jin'bak", "Commander Vo'jak", "General Pa'valak", "Wing Leader Ner'onok",  },
	["Gate of the Setting Sun"] = { "Saboteur Kip'tilak","Striker Ga'dok","Commander Ri'mok","Raigonn", },
	--Panda Raids
	["Mogu'shan Vaults"] = { "The Stone Guard","Feng the Accursed","Gara'jal the Spiritbinder","The Spirit Kings",
		"Elegon","Will of the Emperor", },
	["Heart of Fear"] = { "Imperial Vizier Zor'lok","Blade Lord Ta'yak","Garalon","Wind Lord Mel'jarak",
		"Amber-Shaper Un'sok","Grand Empress Shek'zeer", },
	["Terrace of Endless Spring"] = { "Protectors of the Endless","Protector Kaolan","Tsulong","Lei Shi","Sha of Fear", },
	["Throne of Thunder"] = { "Jin'rokh the Breaker","Horridon","Council of Elders","Sul the Sandcrawler","Frost King Malakk",
		"High Priestess Mar'li","Tortos","Megaera","Ji-Kun","Durumu the Forgotten","Primordius","Dark Animus","Iron Qon",
		"Twin Consorts","Lu'lin","Suen","Lei Shen","Ra-den", },
	["Siege of Orgrimmar"] = { "Immerseus", "The Fallen Protectors", "Rook Stonetoe", "He Softfoot", "Sun Tenderheart",
		"Norushen", "Amalgam of Corruption", "Sha of Pride", "Galakras", "Iron Juggernaut", "Kor'kron Dark Shaman", "Earthbreaker Haromm", "Wavebinder Kardris",
		"General Nazgrim", "Malkorok", "Spoils of Pandaria", "Secured Stockpile of Pandaren Spoils", "Thok the Bloodthirsty", "Siegecrafter Blackfuse",
		"Paragons of the Klaxxi", "Kil'ruk the Wind-Reaver", "Xaril the Poisoned Mind", "Kaz'tik the Manipulator",
		"Korven the Prime", "Rik'kal the Dissector", "Iyyokuk the Lucid", "Ka'roz the Locust", "Skeer the Bloodseeker", "Hisek the Swarmkeeper",
		"Garrosh Hellscream", },
}

RaidTracker_Bosses = {
	DEFAULTBOSS = "Trash mob",
	-- MC
	Majordomo = "Majordomo Executus",					-- yell temp hack
	-- BWL
	["Lord Victor Nefarius"] = "Nefarian",
	-- AQ
	["Emperor Vek'lor"] = "Twin Emperors",
	["Emperor Vek'nilash"] = "Twin Emperors",
	-- Naxx
	["Baron Rivendare"] = "The Four Horsemen",
	["Lady Blaumeux"] = "The Four Horsemen",
	["Sir Zeliek"] = "The Four Horsemen",
	["Thane Korth'azz"] = "The Four Horsemen",
	--Karazhan
	["Rokad the Ravager"] = "Rokad the Ravager",		-- animal boss, make it event
	["Hyakiss the Lurker"] = "Hyakiss the Lurker",		-- animal boss, make it event
	["Shadikith the Glider"] = "Shadikith the Glider",	-- animal boss, make it event
	["The Big Bad Wolf"] = "The Big Bad Wolf",
	["The Crone"] = "The Crone",
	["Julianne"] = "Romulo and Julianne",
	["Chess Event"] = "Chess Event",
	["Echo of Medivh"] = "Echo of Medivh",				-- leave as possible mouse-over trigger for chess
	["Image of Medivh"] = "Image of Medivh",			-- leave as possible mouse-over trigger for nightbane
	--Black Temple
	["Essence of Anger"] = "Reliquary of Souls",
	["Gathios the Shatterer"] = "Illidari Council",
	["High Nethermancer Zerevor"] = "Illidari Council",
	["Lady Malande"] = "Illidari Council",
	["Veras Darkshadow"] = "Illidari Council",
	--Sunwell Plateau
	["Kalecgos"] =  "IGNORE", -- Kalecgos
	["Sathrovarr the Corruptor"] = "Kalecgos",
	Sathrovarr = "Kalecgos",							-- temp yell hack
	["Lady Sacrolash"] = "Eredar Twins",
	["Grand Warlock Alythess"] = "Eredar Twins",
	-- Ulduar
	["Steelbreaker"] = "The Iron Council",
	["Runemaster Molgeim"] = "The Iron Council",
	["Stormcaller Brundir"] = "The Iron Council",
	Molgeim = "The Iron Council",
	Brundir = "The Iron Council",						-- temp to patch the yell
	Ignis = "Ignis the Furnace Master",
	-- Trial of the Crusader
	["Gormok the Impaler"] = "The Beasts of Northrend",
	["Acidmaw"] = "The Beasts of Northrend",
	["Dreadscale"] = "The Beasts of Northrend",
	["Icehowl"] = "The Beasts of Northrend",
	["Eydis Darkbane"] = "The Twin Val'kyr",
	["Fjola Lightbane"] = "The Twin Val'kyr",
	TwinValkyr = "The Twin Val'kyr",
	Anubarak = "Anub'arak",
	["Gorgrim Shadowcleave"] = "Faction Champions",
	["Birana Stormhoof"] = "Faction Champions",
	["Erin Misthoof"] = "Faction Champions",
	["Ruj'kah"] = "Faction Champions",
	["Ginselle Blightslinger"] = "Faction Champions",
	["Liandra Suncaller"] = "Faction Champions",
	["Malithas Brightblade"] = "Faction Champions",
	["Caiphus the Stern"] = "Faction Champions",
	["Vivienne Blackwhisper"] = "Faction Champions",
	["Maz'dinah"] = "Faction Champions",
	["Thrakgar"] = "Faction Champions",
	["Broln Stouthorn"] = "Faction Champions",
	["Harkzog"] = "Faction Champions",
	["Narrhok Steelbreaker"] = "Faction Champions",
	["Krick"] = "Krick and Ick",
	["Ick"] = "Krick and Ick",
	-- Icecrown Citadel
	["Valanar"] = "Blood Princes",
	["Keleseth"] = "Blood Princes",
	["Taldaram"] = "Blood Princes",
	GunshipBattle = "Icecrown Gunship Battle",
	Valithria = "Valithria Dreamwalker",
	-- Grim Batol
	["Drahga Shodowburner"] = "Drahga Shadowburner",	-- is it shodowburner or shadowbunrer...
	--Cataclysm
	["Electron"] = "Omnotron Defense System",
	["Toxitron"] = "Omnotron Defense System",
	["Magmatron"] = "Omnotron Defense System",
	["Arcanotron"] = "Omnotron Defense System",
	["Nezir"] = "Conclave of Wind",
	["Anshal"] = "Conclave of Wind",
	["Rohash"] = "Conclave of Wind",
	["Valiona"] = "Valiona and Theralion",
	["Theralion"] = "Valiona and Theralion",
	["Feludius"] = "Ascendant Council",
	["Ignacious"] = "Ascendant Council",
	["Arion"] = "Ascendant Council",
	["Terrastra"] = "Ascendant Council",
	["Elementium Monstrosity"] = "Ascendant Council",
	["Deathwing"] = "Spine of Deathwing",
	--Pandaria
	["Ming the Cunning"] = "Trial of the King",
	["Kuai the Brute"] = "Trial of the King",
	["Haiyan the Unstoppable"] = "Trial of the King",
	["Galleon"] = "Salyis's Warband",
	["Amethyst Guardian"] = "The Stone Guard",
	["Sul the Sandcrawler"] = "Council of Elders",
	["Frost King Malakk"] = "Council of Elders",
	["High Priestess Mar'li"] = "Council of Elders",
	["Lu'lin"] = "Twin Consorts",
	["Suen"] = "Twin Consorts",
	["Rook Stonetoe"] = "The Fallen Protectors",
	["He Softfoot"] = "The Fallen Protectors",
	["Sun Tenderheart"] = "The Fallen Protectors",
	-- soo
	["Earthbreaker Haromm"] = "Kor'kron Dark Shaman",
	["Wavebinder Kardris"] = "Kor'kron Dark Shaman",
	["Secured Stockpile of Pandaren Spoils"] = "Spoils of Pandaria",
	["Kil'ruk the Wind-Reaver"] = "Paragons of the Klaxxi",
	["Xaril the Poisoned Mind"] = "Paragons of the Klaxxi",
	["Kaz'tik the Manipulator"] = "Paragons of the Klaxxi",
	["Korven the Prime"] = "Paragons of the Klaxxi",
	["Rik'kal the Dissector"] = "Paragons of the Klaxxi",
	["Iyyokuk the Lucid"] = "Paragons of the Klaxxi",
	["Ka'roz the Locust"] = "Paragons of the Klaxxi",
	["Skeer the Bloodseeker"] = "Paragons of the Klaxxi",
	["Hisek the Swarmkeeper"] = "Paragons of the Klaxxi",
}

-- merge
do
	local t = RaidTracker_Bosses
	for k,v in pairs(RaidTracker_ZoneBosses) do
		if type(v) == "table" then
			for k1,v1 in pairs(v) do
				if type(v1) ~= "table" then
					if not t[v1] then t[v1] = v1 end
				end
			end
		end
	end
end

