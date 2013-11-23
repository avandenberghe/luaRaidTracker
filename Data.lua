--[[
	Persistent Data for RaidTracker, Saved Variables

	Aribrary definitions to keep things clear on identifiers:
		Group   - the set of 5 or less members in a party, raid or BG, or any set of members in any type of group
		Party   - group of 5 or less that is not in a raid and is using the Party UI
		Raid    - a set of one or more groups that has formed into a raid and is using the Raid UI
		BG      - a raid that is a pvp raid or party and is using the PvP UI (BattleGroup/Battleground)

		Rarity - the quality or rarity of an item, quality and rarity are used interchangably
			[RarityID]  1:poor, 2:common, 3:uncommon, 4:rare, 5:epic, 6:legendary, 7:artifact 8:Heirloom
]]


RaidTracker = LibKarma:GetInstance( "RaidTracker", {

} )

RaidTracker:RegisterDB( "KARaidTrackerDB", {
	Options = {
		AutoRaid = 3,                   -- [0:off|1:log|2:create]  logging raid if a raid
		AutoParty = 2,					-- [0:off|1:log|2:create]  logging raid if a party
		AutoSolo = 1,					-- [0:off|1:log|2:create]  logging raid if solo
		AutoBattlegroup = 0,			-- [0:off|1:log|2:create]  logging raid if a battelgroup
		AutoArena = 0,					-- [0:off|1:log|2:create]  logging raid if a battelgroup
		AutoEvent = 2,                  -- [0:off|1:onMouseover|2:onBossKill]  when to check for auto boss
		AutoZone = 1,                   -- [0|1]  automatically determine zone
		CostAsk = 0,                    -- [0:off|RarityID]  minimum item rarity to ask for dkp cost for items (ask user)
		CostGet = 0,                	-- [0:off|RarityID]  minimum item rarity to get for dkp cost for items (get from plugin)
		DebugMode = 0,                  -- [0|1]  Debug mode for development
		EventCooldown = 120,			-- [seconds]  how long should trash mob's ignored after a boss kill
		ExportFormat = 0,               -- [0:MLdkp1.1/EQdkp|1:EQdkpUnknown|2:MLdkp1.5|3:EQdkpStrict]  Export format for dkp
		Interactive = 1,				-- [0:off|1:on]  make window interctive or not
		ShowTooltips = 1,               -- [0:Essential|1:All]  show tooltips
		StackItems = 3,                 -- [0:off|RarityID]  maximum item rarity to group items by count instead of log individualy
		LogAttendees = 3,               -- [0:off|1:onEvent(2:o|3:z|4:b)|5:onLoot(6:o|7:z|8:b)]  log attendees in database on specified event
		LogSnapshot = 1,                -- [0:off|1:o|2:z|3:b]  log attendee filter in snapshot on creating new session snapshot
		LogGuild = 0,                   -- [0:off|1:All:2:rank...]  adds guildroster on event to session attendees, or by rank filter
		LogWipe	= 0,					-- [0:off|1:always|2..9:onAsk(10-80%)] ask if the group dies if it is a wipe, if all are dead it will not ask
		LevelMax = 90,                  -- if player level is maxlevel it will not be exported to mldkp
		LogRarity = 2,                  -- [0:off|RarityID]  minimum rarity to log
		LogILevel = 0,                  -- [0:off|iLevel]  minimum item level to log
		TimeFormat = 0,                 -- [0|1] - Use 24h time format for display
		Timezone = 0,					-- players timezone offset used in DB
		Transparent = 0,				-- [0:off|1:on]  make window see through or not
		-- Internal flags
		Color = "|c00d98d07",			-- optional text accent color
		--Color = "|c0076dfff",			-- optional text accent color
		ItemIcon = "INV_Misc_Gear_08",	-- default item icon, used if none exists
		ItemOptionsSelected = nil,      -- last selected item option
		CurrentRaid = nil,				-- raid id of raid currently beign logged (basically 1 or nil)
		BossName = "Trash mob",         -- just the name of the boss
		PlayerDetail = 1,				-- [0|1]  save race, class and level
		SaveTooltips = 0,               -- [0|1]  save tooltips of items for debugging
		ServerTime = 0,					-- servertime offset in seconds
		EventLast = 0,					-- timer to not initiate a new event
		WipeLast = 0,					-- timer to not bug if was a wipe again
		WipeCooldown = 150,             -- how long should death be ignored after a wipe count (seconds)
		VersionCopy = 0,                -- [0|1]  Is imported CT_RaidTracker, one time thing very first load only
		VersionFix = 38,                -- [0...]  Current database version level
	},
	SortOptions = {
		playersmethod = "name",
		playersway = "asc",
		itemsmethod = "looted",
		itemsway = "asc",
		itemsfilter = 1,
		playeritemsmethod = "name",
		playeritemsway = "asc",
		playeritemsfilter = 1,
		playerraidsmethod = "name",
		playerraidsway = "desc",
		itemhistorymethod = "name",
		itemhistoryway = "asc",
	},
	ItemOptions = {
		[20725] = { id = 20725, name = "Nexus Crystal",           Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 4, },
		-- BC
		[29434] = { id = 29434, name = "Badge of Justice",        Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 4, },
		[22450] = { id = 22450, name = "Void Crystal",            Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 4, },
		--  TK - Kael'thas
		[30311] = { id = 30311, name = "Warp Slicer",             Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[30312] = { id = 30312, name = "Infinity Blade",          Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[30313] = { id = 30313, name = "Staff of Disintegration", Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[30314] = { id = 30314, name = "Phaseshift Bulwark",      Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[30316] = { id = 30316, name = "Devastation",			  Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[30317] = { id = 30317, name = "Cosmic Infuser",          Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[30318] = { id = 30318, name = "Netherstrand Longbow",    Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[30319] = { id = 30319, name = "Nether Spike",            Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 0, },
		[30320] = { id = 30320, name = "Bundle of Nether Spikes", Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		--  BT - Naj'entus
		[32408] = { id = 32408, name = "Naj'entus Spine",         Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 1, },
		-- WotLK
		[40752] = { id = 40752, name = "Emblem of Heroism",       Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 4, },
		[40753] = { id = 40753, name = "Emblem of Valor",         Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 4, },
		[45624] = { id = 45624, name = "Emblem of Conquest",      Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 4, },
		[47241] = { id = 47241, name = "Emblem of Triumph",       Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 4, },
		[49426] = { id = 49426, name = "Emblem of Frost",         Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 4, },
		[34057] = { id = 34057, name = "Abyss Crystal",           Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 4, },
		[43228] = { id = 43228, name = "Stonekeeper's Shard", 	  Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 3, },
		[44990] = { id = 44990, name = "Champion's Seal",         Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 1, },
		-- Cata
		-- Panda
		[87208] = { id = 87208, name = "Sigil of Power",          Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[87209] = { id = 87209, name = "Sigil of Wisdom",         Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[87210] = { id = 87210, name = "Chimera of Fear",         Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[94222] = { id = 94222, name = "Key to the Palace of Lei Shen",Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 4, },
		[94593] = { id = 94593, name = "Secrets of the Empire",   Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[94594] = { id = 94594, name = "Titan Runestones",        Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
		[94867] = { id = 94867, name = "Heart of the Thunder King",Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, quality = 5, },
	},
	Zones = RaidTracker_Zones,
	Bosses = RaidTracker_Bosses,
	Online = { },
	Log = { },
} )


function RaidTracker:RunVersionFix( frame )
	local store = self._store
	local db,o,def = store.db,self._options,store.defaults
	local log = db.Log

	if o.VersionCopy == 0 and CT_RaidTracker_RaidLog then
		self:Print("Importing CT_RaidTracker database.")
		if not rawget(o, "VersionFix") then self:ImportToDB( nil, _G, "CT_RaidTracker_", true, false, { "Options", "SortOptions", "Online", } ) end
		if not rawget(o, "VersionFix") then self:ImportToDB( o, _G, "CT_RaidTracker_", true, false, { "VersionFix", CurrentRaid="GetCurrentRaid", } ) end
		self:ImportToDB( nil, _G, "CT_RaidTracker_", true, false, { "ItemOptions", "CustomZoneTriggers", "RaidLog", } )
		o.VersionCopy = 1
	end
	o.VersionFix = o.VersionFix											-- force database to store the default value
	if db.RaidLog then o.VersionFix = min(o.VersionFix, 23) end			-- fix for orphaned RaidLog in the log

	-- 1 - 27 roll-up
	if o.VersionFix >= 0 and o.VersionFix <= 26 then			self:Debug("VersionFix", 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27)
		local tv,c,c1,c2,c3 = { ["Akil'Zon"]="Akil'zon", ["Jan'Alai"]="Jan'alai", ["Ayamiss The Hunter"]="Ayamiss the Hunter", ["Buru The Gorger"]="Buru the Gorger",
			["Ossirian The Unscarred"]="Ossirian the Unscarred", ["Noth The Plaguebringer"]="Noth the Plaguebringer", ["disenchanted"]="disenchant",
			["Tempest Keep: The Eye"]="Tempest Keep",[""]="_NIL", }
		self:ImportRenameDB( _G, { RaidTrackerAceDB="KARaidTrackerAceDB", } )
		self:ImportToDB( nil, nil, nil, true, true, { Log="RaidLog", ZoneTriggers="CustomZoneTriggers", } )
		self:ImportToDB( nil, nil, nil, true, true, { Zones="ZoneTriggers", } )
		if o.MLdkp or o.OldFormat then o.ExportFormat = (o.MLdkp == 1) and 2 or (o.OldFormat == 1 and 0 or 1) end
		if o.AutoGroup == 1 then o.LogGroup = nil end
		if o.AutoRaidCreation == 1 then o.AutoRaidCreation = nil end
		if o.LogBattlefield == 1 and not rawget(o, AutoArena) then o.AutoArena = 1 end
		if o.VersionFix < 24 and o.NewRaidOnNewZone == 1 then o.LogRaid = 3 end
		if o.VersionFix < 27 then c = o.LogAttendees; o.LogAttendees = (c==1 and 2 or (c==2 and 6 or (c==3 and 4 or c))) end
		if o.VersionFix < 27 and o.ShowTooltips >= 2 then o.ShowTooltips = 1 end
		self:ImportRenameDB( o, { PlayerDetail={"SaveExtPlayer","SavePlayerDetail","SaveExtendedPlayerInfo"}, CostGet={"DkpValue","GetDkpValue"}, CostAsk="AskCosts",
			EventCooldown={"BossCooldown","AutoBossChangeMinTime"}, WipeAsk="Wipe", WipeCooldown="WipeCoolDown", AutoParty="LogGroup", AutoRaid="AutoRaidCreation",
			BossName="AutoBossBoss", LogGuild="GuildSnapshot", LogItems="MinQuality", AutoBattlegroup="LogBattlefield", CurrentRaid="GetCurrentRaid",
			"DebugMode", "DebugFlag", "MaxLevel", "24hFormat", "AutoGroup", "TimeOffsetStatus", "TimeSync", "BossAsk", "NextBoss",	"TimeFormat", "AutoEvent",
			"AutoBoss", "NewRaidOnNewZone", "MLdkp", "OldFormat", [tv]="BossName", } )
		if o.WipePercent and o.LogWipe > 0 then o.LogWipe = min(floor(o.WipePercent*10+2),9); o.WipePercent = nil end
		if o.VersionFix < 23 and o.LogGuild > 1 then o.LogGuild = 1 end
		self:ImportRenameDB( db.SortOptions, { playersway="way", playersmethod="method", itemsfilter="itemfilter", itemsmethod="itemmethod", itemsway="itemway", playeritemsfilter="playeritemfilter",
			playeritemsmethod="playeritemmethod", playeritemsway="playeritemway", playerraidsway="playerraidway", playerraidsmethod="playerraidmethod", } )
		local t = { Log={"Track","status"}, CostAsk="askcosts", CostGet="costsgrabbing", Stack={"Group","group"}, }
		c,db.ItemOptions = db.ItemOptions,{ }
		for k,v in pairs(c) do
			if type(v) == "table" then
				self:ImportRenameDB( v, t )
				db.ItemOptions[v.id] = v
			end
		end
		for k, v in pairs(db.Zones) do
			if def.Zones[k] then db.Zones[k] = nil
			elseif type(v) == "string" then db.Zones[k] = { id=0, pid=0, rel=0, name=v } end
		end

		local t = { bossnext="nextboss", Events="BossKills", End="raidEnd", Wipes="wipes", Players="PlayerInfos", realm="Realm", key="Key",
			zone={"Zone","name"}, iid={"id","instanceid"}, ireset="reset", [tv]={"Zone", "zone", "name", "bosslast", "note"}, "Inst", }
		local tI = { zone="name", iid="id", ireset="reset", idiff="difficulty", }
		local tL = { [tv] = {"boss","player","zone","note"}, "thisitemid", "Inst", cost="costs",}
		for k,v in pairs(log) do
			if v.Inst then self:ImportRenameDB( v, tI, v.Inst ) end
			self:ImportRenameDB( v, t )
			if not v.Players then v.Players = { } end
			if not v.Events then v.Events = { } end
			c = v.key; if c and type(c)~="number" then v.key = self:GetTimestamp(c) end
			c = v.End; if c and type(c)~="number" then v.End = self:GetTimestamp(c) end
			if v.Notes then
				for k1,v1 in pairs(v.Notes) do
					c = v.Players[k1]
					if not c then c = { }; v.Players[k1] = c end
					if not c.note then c.note = v1; end
				end
				v.Notes = nil
			end
			for k1,v1 in pairs(v.Join) do
				if not v1 then tremove(v.Join, k1) end
				c = v1.time; if c and type(c)~="number" then v1.time = self:GetTimestamp(c) end
			end
			for k1,v1 in pairs(v.Leave) do
				if not v1 then tremove(v.Leave, k1) end
				c = v1.time; if c and type(c)~="number" then v1.time = self:GetTimestamp(c) end
			end

			if o.VersionFix < 25 then  -- fawk, first db inconsistancy issue ever, was due to legacy CT code
				c = v.Events; c1,c2 = c[1],c[2]
				if c1 and c2 and c1.iid ~= c2.iid then c1.iid,c1.idiff,c1.ireset=c2.iid,c2.idiff,c2.ireset; v.iid,v.idiff,v.ireset=c2.iid,c2.idiff,c2.ireset end
				c1 = 0; for k1,v1 in pairs(v.Players) do c1 = c1 + 1 end
				c = db.Zones[v.zone]; if c and v.iid and c.type=="Raid" and c.man==10 and v.idiff==2 and c1 < 20 then v.idiff = 1 end
			end
			for k1,v1 in pairs(v.Events) do
				if v1 and type(v1) ~= "table" then
					v.Events[k1] = nil
					v1 = { boss = k1, time = v1, }; tinsert( v.Events, v1 )
				end
				if type(v1.time) == "table" then
					v1.boss = v1.time.boss
					v1.attendees = v1.time.attendees
					v1.time = v1.time.time
				end
				if v1.Inst then self:ImportRenameDB( v1, tI, v1.Inst ) end
				self:ImportRenameDB( v1, tL )
				c = v1.time; if c and type(c)~="number" then v1.time = self:GetTimestamp(c) end
				c = v1.attendees; if c and (type(c)~="table" or type(c[1])~="string") then v1.attendees = nil end
				if o.VersionFix < 25 and v1.iid ~= v.iid then v1.iid,v1.idiff,v1.ireset=v.iid,v.idiff,v.ireset end
			end

			for k1,v1 in pairs(v.Loot) do
				if not v1 or not v1.item then tremove(v.Loot, k1) end
			end
			for k1,v1 in pairs(v.Loot) do
				if v1.id ~= k1 then v1.id = k1 end
				self:ImportRenameDB( v1, tL )
				if v1.item.tooltip then v1.item.tooltip = nil end
				c = v1.item.count; if c then c = tonumber(c); v1.item.count = (c and c > 2) and c or nil end
				c = v1.cost; if c then c = tonumber(c); v1.cost = (c and c > 0) and c or nil end
				c = v1.time; if c and type(c)~="number" then v1.time = self:GetTimestamp(c) end
				c = v1.attendees; if c and (type(c)~="table" or type(c[1])~="string") then v1.attendees = nil end
			end
		end
		o.VersionFix = 27
	end

	if o.VersionFix >= 35 and o.VersionFix <= 35 then			--self:Debug("VersionFix", 35)
		if o.LevelMax == 80 then o.LevelMax = 85 end
		o.VersionFix = 36
	end

	if o.VersionFix >= 36 and o.VersionFix <= 36 then			--self:Debug("VersionFix", 36)
		if o.LevelMax == 85 then o.LevelMax = 90 end
	end

	if o.VersionFix >= 27 and o.VersionFix <= 38 then			self:Debug("VersionFix", 28, 29, 30, 31, 32, 33, 34 ,35, 36, 37, 38, 39)
		local tv,c,c1,c2,c3 = { ["Ulduar Raid"]="Ulduar", ["Trial of the Grand Crusader"]="Trial of the Crusader",
			["Twin Val'kyr"]="The Twin Val'kyr", ["Northrend Beasts"]="The Beasts of Northrend",
			["Mogu'Shan Palace"]="Mogu'shan Palace", ["Shado-pan Monastery"] = "Shado-Pan Monastery",
			["The Stockade"] = "Stormwind Stockade", ["The Deadmines"] = "Deadmines",
			["disenchant"]="disenchanted", [""]="_NIL", }
		self:ImportRenameDB( o, { LogRarity={"LogItems","MinQuality"}, "Timezone", [tv]="BossName", } )
		self:ImportRenameDB( db.Zones, { Ulduar = "Ulduar Raid", ["Trial of the Crusader"]="Trial of the Grand Crusader",
			["Mogu'shan Palace"] = "Mogu'Shan Palace", ["Shado-Pan Monastery"] = "Shado-pan Monastery",
			["Stormwind Stockade"] = "The Stockade", ["Deadmines"] = "The Deadmines", } )
		local t = { [tv]={"zone", "name", }, }
		for k,v in pairs(db.Zones) do
			self:ImportRenameDB( v, t )
			if def.Zones[k] then db.Zones[k] = nil;
			elseif type(v) == "string" then db.Zones[k] = { id=0, pid=0, rel=0, name=v } end
		end
		local t = { [tv]={"Zone","zone","name","bosslast","note"}, }
		local tL = { [tv] = {"boss","player","zone","note"}, cost="costs", }
		for k,v in pairs(log) do
			self:ImportRenameDB( v, t )
			c = v.zone; if c and not db.Zones[c] then db.Zones[c] = { id=0, pid=0, rel=0, name=c } end
			if not v.Players then v.Players = { } end
			if not v.Events then v.Events = { } end
			for k1,v1 in pairs(v.Join) do
				if not v1 then tremove(v.Join, k1) end
			end
			for k1,v1 in pairs(v.Leave) do
				if not v1 then tremove(v.Leave, k1) end
			end
			for k1,v1 in pairs(v.Events) do
				if v1.id ~= k1 then v1.id = k1 end
				self:ImportRenameDB( v1, tL )
				c = v1.attendees; if c and (type(c)~="table" or type(c[1])~="string") then v1.attendees = nil end
			end
			for k1,v1 in pairs(v.Loot) do
				if not v1 or not v1.item then tremove(v.Loot, k1) end
			end
			for k1,v1 in pairs(v.Loot) do
				if v1.id ~= k1 then v1.id = k1 end
				self:ImportRenameDB( v1, tL )
				if v1.item.tooltip then v1.item.tooltip = nil end
				c = v1.item.count; if c then c = tonumber(c); v1.item.count = (c and c > 2) and c or nil end
				c = v1.cost; if c then c = tonumber(c); v1.cost = (c and c > 0) and c or nil end
				c = v1.attendees; if c and (type(c)~="table" or type(c[1])~="string") then v1.attendees = nil end
			end
		end
		o.VersionFix = 39
	end

end
