if not RaidTracker then return end

function RaidTracker:OnLoadCustom( frame )
	UIPanelWindows[frame:GetName()] = { area = "left", pushable = 1, whileDead = 1 }

	-- Register events
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("GROUP_ROSTER_UPDATE")
	frame:RegisterEvent("CHAT_MSG_LOOT")
	frame:RegisterEvent("CHAT_MSG_SYSTEM")
	frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	frame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	frame:RegisterEvent("CHAT_MSG_MONSTER_WHISPER")
	frame:RegisterEvent("UNIT_HEALTH")
	frame:RegisterEvent("UNIT_CONNECTION")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:RegisterEvent("ZONE_CHANGED")
	frame:RegisterEvent("ZONE_CHANGED_INDOORS")
	frame:RegisterEvent("UPDATE_INSTANCE_INFO")
end

function RaidTracker:OnPlayerLogin( frame )
	local _inst,o = self._acelib,self._options
	self.L = _inst.L

	o.EventLast = GetTime()

	if _inst and _inst.menu then
		local args = _inst.menu.args
		local main = args.main; main.type = "toggle"; main.set = main.func;
			main.get = function() return RaidTrackerFrame:IsVisible() end
		local opts = args.options; opts.type = "toggle"; opts.set = opts.func;
			opts.get = function() return RT_OptionsFrame:IsVisible() end
		args.itemoptions = {
			type = "toggle", order = 14, name = _inst.L["Item Options"], desc = _inst.L["Show Item Options"],
			passValue = "io", set = _inst.menufunc, get = function() return RT_ItemOptionsFrame:IsVisible() end,
		}
		args.interactive = {
			type = "toggle", order = 13, name = _inst.L["Interactive"], desc = _inst.L["Make Window Interactive"],
			passValue = "interactive", set = _inst.menufunc, get = function() return RaidTracker._options.Interactive==1 end,
		}
		args.transparent = {
			type = "toggle", order = 12, name = _inst.L["Transparent"], desc = _inst.L["Make Window Transparent"],
			passValue = "transparent", set = _inst.menufunc, get = function() return RaidTracker._options.Transparent==1 end,
		}
	end

	self:FrameInit() -- init translations for frame labels
	local game,frameName,selfMeta = RaidTracker_Games[4], frame:GetName(), self._meta;
	_G[frameName.."HeaderIcon"]:SetTexture( selfMeta.icon )
	_G[frameName.."HeaderTime"]:SetText( "" )
	_G[frameName.."HeaderTitle"]:SetText( selfMeta.title )
	_G[frameName.."HeaderVersion"]:SetText( game.c .. " v" .. selfMeta.version .. "|r" )  -- .. " "..selfMeta.locale.."|r" )
	--_G[frameName.."HeaderVersion"]:SetTextColor( o.Color )  -- .. " "..selfMeta.locale.."|r" )

	RT_Dialog:TransparentToggle(RaidTrackerFrame, o.Transparent==1)
end

function RaidTracker:UpdateFrame_OnUpdate()
	local frame = RaidTrackerFrame
	if not frame:IsVisible() then return end

	_G[frame:GetName().."HeaderTime"]:SetText( self:GetRealmDisplayTime("%H:%M:%S") )
end

function RaidTracker:OnCommandCustom( msg, cmd, args )
	local frame = RaidTrackerFrame
	local db,o,L = self._db,self._options,self.L
	local lsCommand = L[cmd]

	if cmd == "debug" then
		if args=="1" then
			o.DebugMode = 1
		elseif args=="0" then
			o.DebugMode = 0
		end
		self:Print(L:F("Debug Mode: %s", L[o.DebugMode == 1 and "Enabled" or "Disabled"]))
	elseif cmd == "addwipe" then
		self:AddWipeDB()
	elseif cmd == "deleteall" then
		self:Print(L:F("Deleting %d sessions", #db.Log))
		self:TruncateSessionDB()
		self:FrameUpdate()
		self:FrameUpdateView()
	elseif cmd == "additem" then
		local linkMatch = "|c%x+|Hitem:[-%d:]+|h%[.-%]|h|r"
		local _, _, item, player = string.find(args or "", "("..linkMatch..")%s+(%S+)")
		if not item or not player then
			self:Print(L:F("%s: Must supply an item link and a player name.", lsCommand))
		elseif not frame.selected then
			self:Print(L:F("%s: There is no raid selected", lsCommand))
		else
			if self:AddLootItemDB(frame.selected, item, player) then
				self:Print(L:F("Added %s to the selected raid.", item))
			else
				self:Print(L:F("%s: Could not add %s", lsCommand, item))
			end
		end
		self:FrameUpdate()
		self:FrameUpdateView()
	elseif cmd == "join" or cmd == "leave" then
		if not frame.selected then
			self:Print(L:F("%s: There is no raid selected", lsCommand)); return
		end
		if args and args ~= "" then
			RT_JoinLeaveFrameNameEB:SetText(args)
		end
		RT_Dialog:Show("RT_JoinLeaveFrame", cmd, "raid", frame.selected)
	elseif cmd == "bossnext" then
		if not o.CurrentRaid then
			self:Print(L:F("%s: Must be a current open raid.", lsCommand)); return
		end
		RT_Dialog:Show("RT_EditBossFrame", "boss", "next", o.CurrentRaid)
	elseif cmd == "io" then
--		local checks = { "item:(%d+):","(%d+)%s?" }
		local checks = { "item:(%d+):" }
		for i,match in pairs(checks) do
			for itemid in string.gmatch(args or "",match) do
				itemid = tonumber(itemid)
				if db.ItemOptions[itemid] then
					self:Print(L:F("Item %d is already in the Item Options list.", itemid))
				else
--					db.ItemOptions[itemid] = {id = itemid}
					RT_ItemOptionsFrame.itemid = itemid
					RT_ItemOptions:Update()
					self:Print(L:F("Added %d to the Item Options list.", itemid))
				end
			end
		end
		if not args then
			RT_Dialog:ShowToggle(RT_ItemOptionsFrame)
		end
	elseif cmd == "transparent" or cmd == "interactive" then
		local opt,v = cmd == "transparent" and "Transparent" or "Interactive"
		if not args then		v = o[opt] == 1 and 0 or 1
		elseif args=="1" then	v = 1
		elseif args=="0" then	v = 0
		else self:Print(L:F("%s: Invalid toggle value.", lsCommand)); return true end
		o[opt]=v;
		self:Print(L:F(opt.." Mode: %s", L[v == 1 and "Enabled" or "Disabled"]))
		if opt == "Interactive" then
			self:FrameUpdate()	--buttons or whatnot get configed here
			self:FrameUpdateView()
		else
			RT_Dialog:TransparentToggle(RaidTrackerFrame, v == 1)
		end
	elseif cmd == "time" then
		local st,mt = self:GetGameTime(),self:GetSysTime()
		local stf,mtf = self:GetTimePartFmt(st),self:GetTimePartFmt(mt)
		local ofs,atd = st - mt,self._update.timediff
		local atf = self:GetDate(self:GetTime(nil, atd))
		self:Print(L:F("Server time: %s (%d)\nMy time: %s (%d)\nOffset: %d (simple)\nTimeDiff: %d (to realm)\nAdjusted: %s (universal realm time)", stf, st, mtf, mt, ofs, atd, atf))
	elseif cmd == "instanceinfo" or cmd == "o" then
		self:Print(L:F("InstanceInfo:")); self:SysMsg(GetInstanceInfo())
		self:Print(L:F("ZoneInfo:")); self:SysMsg(GetRealZoneText(), ", ", GetZoneText())
		local mapId = GetCurrentMapAreaID()
		self:Print(L:F("MapInfo:")); self:SysMsg(GetMapNameByID(mapId), mapId)
	elseif cmd == "options" or cmd == "o" then
		RT_Dialog:ShowToggle(RT_OptionsFrame)
	elseif not cmd then
		if frame:IsVisible() then
			HideUIPanel(frame)
		else
			ShowUIPanel(frame)
		end
	elseif cmd == "help" then
		self:Print(L["/rt - Shows the main window."])
		self:Print(L["/rt options|o - Shows Options window"])
		self:Print(L["/rt io - Shows the ItemOptions window"])
		self:Print(L["/rt io [ITEMLINK|ITEMID]... - Adds items to ItemOptions window"])
		self:Print(L["/rt additem [ITEMLINK] [PLAYER] - Adds a loot item to the selected raid"])
		self:Print(L["/rt join [PLAYER] - Add a player to the selected raid"])
		self:Print(L["/rt leave [PLAYER] - Removes a player from the selected raid"])
		self:Print(L["/rt deleteall - Deletes all raids"])
		self:Print(L["/rt transparent 1|0 - Enables/Disables transparent mode"])
		self:Print(L["/rt interactive 1|0 - Enables/Disables interactive mode"])
		self:Print(L["/rt debug 1|0 - Enables/Disables debug mode"])
		self:Print(L["/rt addwipe - Adds a Wipe with the current timestamp"])
		return
	else
		return
	end
	return true
end

function RaidTracker:OnEventCustom( frame, event, ... )
	local db,o,L = self._db,self._options,self.L
	local ar1, ar2, ar3, ar4, ar5, ar6 = select(1, ...)

	if event == "GROUP_ROSTER_UPDATE" then							--self:Debug(event, ar1, ar2, ar3, ar4)
		if o.CurrentRaid and self:GetAttendeeCount() <= 1 then		--self:Debug(o.CurrentRaid, self:GetAttendeeCount(), self:CanAutoCreateLog())
			self:EndSessionDB();									-- if a session and no peoples, den mark them all lefted
		elseif not o.CurrentRaid and IsInGroup() and self:CanAutoCreateLog() then
			self:CreateSessionDB();									-- if not a session and peoples der and is okies to make session by self, den makes a session
		elseif o.CurrentRaid then
			self:UpdateSessionDB()
		else
			return
		end
		self:FrameUpdate()
		self:FrameUpdateView()

	elseif event == "CHAT_MSG_LOOT" then
		if not o.CurrentRaid and self:CanAutoCreateLog() then
			self:CreateSessionDB();									-- if not a raid and peoples der and is okies to make raid by self, den makes a raid
		end
		if o.CurrentRaid then
			local msg = select(1,...)
			local sPlayer, sLink, iCount, bFilter;					-- job here is to get player, link, item count, and if to engage item filters
			if		string.find(msg, L.ReceivesLoot1) then	_, _, sPlayer, sLink = string.find(msg, L.ReceivesLoot1)
			elseif	string.find(msg, L.ReceivesLoot2) then	_, _, sLink = string.find(msg, L.ReceivesLoot2)
				sPlayer = YOU
			elseif	string.find(msg, L.ReceivesLoot3) then	_, _, sPlayer, sLink, iCount = string.find(msg, L.ReceivesLoot3)
			elseif	string.find(msg, L.ReceivesLoot4) then	_, _, sLink, iCount = string.find(msg, L.ReceivesLoot4)
				sPlayer = YOU
			end
			if sPlayer and sPlayer == YOU then
				sPlayer = (UnitName("player"))
			end
			self:Debug("CHAT_MSG_LOOT", "msg",msg, "results",sPlayer,sLink,iCount)
			if not sLink or not sPlayer then return end

			self:AddLootItemDB( o.CurrentRaid, sLink, sPlayer, iCount )
		end
		self:FrameUpdate()
		self:FrameUpdateView()

	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		if o.AutoEvent == 1 and not UnitIsFriend("mouseover", "player") and not UnitInRaid("mouseover") and not UnitInParty("mouseover") then
			self:Debug("possible mouseover unit update", unit)
			if not self:UpdateLootTargetDB(L.R[(UnitName("mouseover"))]) then return end
		else
			return
		end
		self:FrameUpdate()
		self:FrameUpdateView()

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "CHAT_MSG_MONSTER_YELL" or event == "CHAT_MSG_MONSTER_EMOTE" or event == "CHAT_MSG_MONSTER_WHISPER" then
		local filter = COMBATLOG_OBJECT_TYPE_NPC + COMBATLOG_OBJECT_REACTION_HOSTILE
		local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, srcFlags2, destGUID, destName, destFlags = select(1, ...)
		--self:Debug(event, timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags)

		local unit
		if event == "CHAT_MSG_MONSTER_YELL" or event == "CHAT_MSG_MONSTER_EMOTE" or event == "CHAT_MSG_MONSTER_WHISPER" then
			unit = L.R[timestamp]
			if not unit then return end
			destName,unit = strsplit("_", unit)
			if not destName or destName:sub(1,4) ~= "Yell" then return end
			if unit == "Julianne" then
				julianne_died = true
			end
		elseif type~="UNIT_DIED" or bit.band(destFlags, filter) ~= filter then
			return
		else
			unit = L.R[destName]
		end

		-- here we have a dead hostile mob
		local boss,update = db.Bosses[unit]
		self:Debug(event,"unit",destName,unit,boss)
		if o.AutoEvent == 2 and self:UpdateLootTargetDB(unit,boss) then
			update = true
		end

		-- Romulo and Julianne Hack
		if boss == "Romulo and Julianne" then
			if julianne_died == false then boss = nil end
		end

		if boss and boss ~= "IGNORE" then
			if (not o.CurrentRaid and self:CanAutoCreateLog()) or self:CanAutoCreateLog("event") then
				self:Print(L["Creating new session due to boss kill."])
				self:CreateSessionDB()
				update = true
			end
			local raid = db.Log[o.CurrentRaid]
			if raid then
				local found
				for k, v in pairs(raid.Events) do
					if v.boss == boss then found = true; break; end
				end
				if not found then
					update = true
					if o.LogGuild >= 1 then
						RaidTracker:AddGuildDB()
					end
					self:AddEventDB(raid, boss)
					if o.AutoEvent == 3 then
						RT_Dialog:Show("RT_EditBossFrame", "boss", "next", o.CurrentRaid)
					end
				end
			end
		end
		if update then
			self:FrameUpdate()
			self:FrameUpdateView()
		end

	elseif event == "ZONE_CHANGED_NEW_AREA" or event == "UPDATE_INSTANCE_INFO"
		 or event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" then			--self:Debug(event, ar1, ar2, ar3, ar4)
		self:UpdateZoneDB()
		self:FrameUpdate()
		self:FrameUpdateView()
	end

	-- end of events that dont require current raid
	if not o or not o.CurrentRaid then
		return

	elseif event == "PLAYER_ENTERING_WORLD" or event == "UNIT_CONNECTION" then	--self:Debug(event, ar1, ar2, ar3, ar4)
		self:UpdateSessionDB()
		self:FrameUpdateView()
		self:FrameUpdate()

	elseif event == "CHAT_MSG_SYSTEM" then									--self:Debug(event, ar1, ar2, ar3)
		local msg = select(1,...)
		local name = (UnitName("player"))
		if not name or name == UKNOWNBEING or name == UNKNOWN then return end

		local tsDate, sPlayer = self:GetTimestamp()
		_, _, sPlayer = string.find(msg, L.LeftRaid)	-- wrong name for non-home players
		if not sPlayer then
			_, _, sPlayer = string.find(msg, L.LeftParty)
		end																	--;self:Debug("party", event, sPlayer, msg)--, UnitName(sPlayer), msg)
		if not sPlayer or sPlayer == name or
			sPlayer == UKNOWNBEING or sPlayer == UNKNOWN then return end

		local dbOnline = db.Online
		if not dbOnline[sPlayer] then				--hack: because wow is returning the short name atm (10/10/2012)
			local s = "^"..sPlayer.."-"
			sPlayer = nil
			for k,v in pairs(dbOnline) do
				if k and k:find(s) then sPlayer = k; break end
			end
			if not sPlayer then return end
		end

		tinsert(db.Log[o.CurrentRaid].Leave, { player = sPlayer, time = tsDate, } )
		dbOnline[sPlayer] = nil										;self:Debug(sPlayer, "LEFT", self:GetDisplayDate(tsDate))

		self:FrameUpdateView()
		self:FrameUpdate()

	elseif event == "UNIT_HEALTH" then
		if InCombatLockdown() or self:GetAttendeesType()~="Raid" or GetTime() < (o.WipeLast + o.WipeCooldown) then return end

		if o.LogWipe > 1 then
			local dead,count = 0, self:GetAttendeeCount()
			for i = 1, count, 1 do
				if UnitIsDeadOrGhost(self:GetAttendeeUnitId(i)) then
					dead = dead + 1
				end
			end
			if dead == count then
				self:AddWipeDB()
				RT_AcceptWipeFrame:Hide()
			elseif (dead / count) > (o.LogWipe-1)*0.01 then
				RT_AcceptWipeFrame.type = "wipe"
				RT_AcceptWipeFrame:Show()
			end
		end
	end

end

-- types: 0 solo, 2 raid, 2 party, 3 bg, 4 arena
-- types: 0 off, 1 log, 2 create, 3 create instance, 4 cerate event
-- unifies attendees info lookup and raid/party/bgs/arenas
function RaidTracker:CanAutoCreateLog( eType )									--self:Debug("CanAutoCreateLog", eType)
	local nGroup = GetNumGroupMembers()
	local o, t, c, m  = self._options, self:GetAttendeesType(nGroup), self:GetAttendeeCount(nGroup), 2
	if eType=="event" then m=4 elseif eType=="zone" then m=3 end
	return ( (t=="Raid" and o.AutoRaid>=m and c>0) or (t=="Battleground" and o.AutoBattlegroup>=m and c>0) or
		   (t=="Party" and o.AutoParty>=m and c>1) or (t=="Arena" and o.AutoArena>=m and c>1) or (o.AutoSolo>=m and c==1) )
		   and c or nil
end

function RaidTracker:GetAttendeesType( nGroup )							--self:Debug("GetAttendeesType", nGroup)
	local _, sType = IsInInstance()
	if sType == "arena" then return "Arena" end
	if sType == "pvp" then return "Battleground" end
	nGroup = nGroup or GetNumGroupMembers()
	if nGroup > 0 and IsInRaid() then return "Raid" end
	if nGroup > 0 then return "Party" end
	return "Solo"
end

function RaidTracker:GetAttendeeCount( nGroup )							--self:Debug("GetAttendeeCount", nGroup)
	nGroup = nGroup or GetNumGroupMembers()
	local _, sType = IsInInstance()
	local o = self._options
	if nGroup > 0 and IsInRaid() then
		return (o.AutoRaid >= 1 or (sType == "pvp" and o.AutoBattlegroup >= 1)) and nGroup or 0
	end
	if nGroup > 0 then	-- if party logging is off then will return 0 if on a party
		return (o.AutoParty >= 1 or	(sType == "arena" and o.AutoArena >= 1)) and nGroup or 0
	end
	return (o.AutoSolo >= 1) and 1 or 0
end

function RaidTracker:GetAttendeeUnitId( i, nGroup )						--self:Debug("GetAttendeeUnitId", i, nGroup)
	if tonumber(i)==nil then return i end
	nGroup = nGroup or GetNumGroupMembers()
	if nGroup > 0 and IsInRaid() then return "raid"..i end
	return ((i+1) > nGroup) and "player" or ("party"..i)	--??
end

function RaidTracker:GetAttendeeZone( unit )							--self:Debug("GetAttendeeZone", nGroup)
	local zone = self:UnitOtherZone(unit)
	return zone or ((IsInInstance()) and (GetInstanceInfo()) or (GetRealZoneText()))
end

function RaidTracker:GetAttendeeInfo( i, isExtended, nGroup )			--self:Debug("GetAttendeeInfo", i, isExtended, nGroup)
	local unit = self:GetAttendeeUnitId( i, nGroup )
	local name, online, zone, level, class
	if IsInRaid() and type(i) == "number" then
		name,_,_,level,_,class,zone,online = GetRaidRosterInfo(i);		-- name, rank, subgroup, level, class, fileName, zone, online = GetRaidRosterInfo(i)
	else
		name,online,zone = (UnitName(unit)),(UnitIsConnected(unit)),self:GetAttendeeZone(unit)
	end
	if not isExtended then
		return name, online, zone
	end
	return name, online, zone, (level or (UnitLevel(unit))), (class or (select(2,UnitClass(unit)))), (UnitSex(unit)), (GetGuildInfo(unit)), (select(2,UnitRace(unit)))
end

function RaidTracker:GetAttendees( c, chkOnline, chkZone, nGroup )	-- just needs to be fast, its a bit convoluted, but fast and small
	nGroup = nGroup or GetNumGroupMembers();
	local t = (type(c)~="number") and { } or nil; 			-- okies, can pass count to make faster, else get count, if not number then is "type"
	local n = self:_GetAttendees( chkOnline, chkZone, ((not t) and c or self:GetAttendeeCount(nGroup)), t, t and c~="names", nGroup )
	return t or n
end

function RaidTracker:_GetAttendees( chkOnline, chkZone, count, t, ids, nGroup )	--self:Debug("_GetAttendees", i, isExtended, nGroup)
	if count == 0 then return 0 end
	local n,sZone = 0,((chkZone) and (self:GetAttendeeZone()) or nil)	-- use us as relative. should be current instance
	--local n,sZone = 0,((chkZone) and (GetRealZoneText()) or nil)			--FIXME: should be comparing to session zone, not ours?
	for i = 1, count do
		local name, online, zone = self:GetAttendeeInfo(i, false, nGroup)		--;self:Debug("_GetAttendees", i, count, name, online, zone, isExtended, nGroup)
		if (name and name ~= UKNOWNBEING and name ~= UNKNOWN) and 		-- check name and identity
			(not chkZone or not zone or zone==sZone) and				-- should check, haz a zone, zone matches
			(not chkOnline or online) then  							-- should check, is online
				n = n + 1
				if t then t[n] = (ids and i or name) end
		--else
		--	if not (name and name ~= UKNOWNBEING and name ~= UNKNOWN) then
		--		self:Debug("fname", i, n, name, "ids",ids, "ng",nGroup)
		--	elseif not (not chkZone or not zone or zone==sZone) then
		--		self:Debug("fzone", i, n, name, "ids",ids, zone,sZone)
		--	elseif not (not chkOnline or online) then
		--		self:Debug("fol", i, n, name, "ids",ids, "co",online, "ng",nGroup)
		--	else
		--		self:Debug("fail", i, n, name, "ids",ids, "cz",zone,sZone, "co",online, "ng",nGroup)
		--	end
		end
	end
	return n
end

function RaidTracker:UpdateSessionDB( isNew, isFast )
	local db,o = self._db,self._options
	if not o.CurrentRaid then return end
	local raid = db.Log[o.CurrentRaid]
	if not raid then self:EndSessionDB(); return end

	-- update player info, join and leave times
	local tAttend, tsDate = self:GetAttendees(), self:GetTimestamp()
	--self:DebugTable(tAttend)
	if not raid.Players then raid.Players = { } end
	for i, v in pairs(tAttend) do
		local name, online, zone, level, class, sex, guild, race = self:GetAttendeeInfo(v, true);
		if not name then return end -- someting went wrong, possibly event firing too soon after reload

		if not raid.Players[name] then
			raid.Players[name] = { }
		end
		if o.PlayerDetail == 1 then
			local ti = raid.Players[name]
			if race then		ti.race = race; end
			if class then		ti.class = class; end
			if sex then			ti.sex = sex; end
			if level > 0 then	ti.level = level; end
			if guild then		ti.guild = guild; end
		end

		if isNew or online ~= db.Online[name] then						-- will change status for existing player
			if isNew or online then
				tinsert( raid.Join,  { player = name, time = tsDate } )
			end
			if not online then
				tinsert( raid.Leave, { player = name, time = tsDate } )
			end
		end

		db.Online[name] = online
	end

	self:UpdateZoneDB(raid)
end

function RaidTracker:UpdateLootTargetDB( unit, boss )	--self:Debug("ltDB",unit,boss)
	local db,o,L = self._db,self._options,self.L
	boss = boss or db.Bosses[unit]

	if boss then
		if boss == "IGNORE" then
			boss = nil
		else
			o.EventLast = GetTime()						--self:Debug("event last update")
		end
	elseif db.Bosses["DEFAULTBOSS"] then				self:Debug("trash", GetTime(), o.EventLast, o.EventCooldown, o.EventLast + o.EventCooldown)
		if (GetTime() > (o.EventLast + o.EventCooldown)) then
			boss = db.Bosses["DEFAULTBOSS"]
		end
	end
	if boss and o.BossName ~= boss then
		o.BossName = boss
		self:Print(L:F("AutoEvent boss update \"%s\".", boss))
		return boss
	end
end


function RaidTracker:AddEventDB( r, event )
	local o,L = self._options,self.L
	local tsDate, c = self:GetTimestamp(), o.LogAttendees
	local t = {
		boss = event,
		time = tsDate,
		zone = L.R[self:GetAttendeeZone()],
		note = nil,
		attendees = (c>=1 or c<=4) and self:GetAttendees("names", c==2 or c==4, c==3 or c==4) or nil,
	}
	t.id = #r.Events + 1;
	tinsert(r.Events, t.id, t)
	self:UpdateInstanceDB(t)
	self:Print(L:F("Adding event for \"%s\" at %s.", L[event], self:GetDisplayDate(tsDate)))
end


function RaidTracker:UpdateInstanceDB( t )
	local isInst, sType = IsInInstance()
	if t.zone and isInst then
		local _, _, nDiff, _ = GetInstanceInfo()
		t.idiff = nDiff
		t.itype = sType
	end
	if t.zone and t.idiff then
		for i=1, GetNumSavedInstances() do
			local name, id, reset, diff = GetSavedInstanceInfo(i)
			if name == t.zone and diff == t.idiff then
				t.iid = id; t.ireset = reset; break
			end
		end
	end
end

function RaidTracker:UpdateZoneDB( r )
	local db,o,L = self._db,self._options,self.L	--;self:Debug("UpdateZoneDB", o.AutoZone, o.CurrentRaid)
	if o.AutoZone == 0 or not o.CurrentRaid then return end
	r = r or db.Log[o.CurrentRaid]
	local sZone, _, nDiff, sDiffName = GetInstanceInfo()
--	local sZone = GetRealZoneText()
--	local qZone = GetRealZoneText()
	local zone = self.L.R[sZone]					--;self:Debug("UpdateZoneDB", sZone, qZone, zone, r.zone, nDiff, sDiffName)
													--;self:Debug("UpdateZoneDB", GetInstanceInfo())


	if zone and db.Zones[zone] then																-- is a trigger
		if not r.zone then
			r.zone = zone
			self:Print(L:F("Setting current session zone to %s %s.", sZone, sDiffName))
		elseif (zone ~= r.zone or (r.idiff and nDiff and nDiff ~= r.idiff))						--FIXME: is bugged for 25 man, it temporary marked as 10 man after death
				and self:CanAutoCreateLog("zone") then											-- has one already
			self:Print(L["Creating new session due to zone change."])
			self:CreateSessionDB()																-- will get called again on create new session, so bail
			return
		end
	end

	self:UpdateInstanceDB( r )
end


function RaidTracker:AddWipeDB()
	local db,o = self._db,self._options
	if not o.CurrentRaid then return end
	local raid = db.Log[o.CurrentRaid]					--self:Debug("RaidTracker:AddWipeDB")

	o.WipeLast = GetTime()
	if not raid.Wipes then
		raid.Wipes = { }
	end
	tinsert( raid.Wipes, self:GetTimeStamp() )
	self:Print(self.L["Wipe has been recorded."])
end

function RaidTracker:AddGuildDB()
	local db,o = self._db,self._options
	if not o.CurrentRaid then return end				--self:Debug("RaidTracker:AddGuildDB")
	local raid = db.Log[o.CurrentRaid]
	local nDate = self:GetTimestamp()

	GuildRoster()
	local showOL = GetGuildRosterShowOffline(); SetGuildRosterShowOffline(false)
	for i = 1, GetNumGuildMembers() do
		local name, rank, irank, level, _, zone, group, note, _, online = GetGuildRosterInfo(i)
		if o.LogGuild == 1 or irank <= o.LogGuild and online ~= db.Online[name] then
			if online then
				tinsert( raid.Join, { player = name, time = nDate } )
				db.Online[name] = online
			elseif not online and db.Online[name] then
				tinsert( raid.Leave, { player = name, time = nDate } )
				db.Online[name] = online
			end
		end
	end
	SetGuildRosterShowOffline(showOL)
end


function RaidTracker:CreateSessionDB( )
	local db,o = self._db,self._options
	local tsDate,sRealm = self:GetTimestamp(),GetRealmName()

	-- start new raid
	self:EndSessionDB()
	o.CurrentRaid = 1
	tinsert( db.Log, o.CurrentRaid, {
		Players = { },
		Join = { },
		Leave = { },
		Events = { },
		Loot = { },
		Wipes = nil,
		key = tsDate,
		End = nil,
		zone = nil,
		realm = sRealm,
		note = nil,
		bossnext = nil,
		iid = nil, itype = nil, idiff = nil, ireset = nil,
	} )
	self:Print(self.L:F("Joining new raid at %s.", self:GetDisplayDate(tsDate)))
	self:UpdateSessionDB( true );					-- setup player info, join and leave times
end

function RaidTracker:EndSessionDB( )
	local db,o = self._db,self._options

	if o.CurrentRaid then
		local tsTime = self:GetTimestamp()
		local raid = db.Log[o.CurrentRaid]
		self:Print(self.L:F("Ending current raid at %s.", self:GetDisplayDate(tsTime)))
		if raid then
			for k, v in pairs(db.Online) do
				tinsert( raid.Leave, { player = k, time = tsTime, } )
			end
			if not raid.End then
				raid.End = tsTime
			end
		end
		o.CurrentRaid = nil
	end

	db.Online = { }
end

function RaidTracker:DeleteSessionDB( raidid )
	local frame = RaidTrackerFrame
	local db,o = self._db,self._options

	if frame.selected == raidid then			-- unhook frame if selected raid
		if frame.selected > 1 then
			 frame.selected = frame.selected - 1
		end
		frame.type = "players"
	end
	if o.CurrentRaid == raidid then		-- unhook db if current raid
		o.CurrentRaid = nil
		db.Online = { }
	end

	table.remove(db.Log, raidid)
end

function RaidTracker:TruncateSessionDB( )
	local db,o = self._db,self._options
	db.Log = { }
	db.Online = { }
	o.CurrentRaid = nil
end

function RaidTracker:SnapshotSessionDB( )
	local db,o = self._db,self._options
	if not o.CurrentRaid then return end

	self:Print(self.L["Snapshotting current raid."])
	local r = db.Log[o.CurrentRaid]
	local tsDate = self:GetTimestamp()

	local t = {
		key = tsDate,
		End = tsDate,
		zone = r.zone,
	}
	for k,v in pairs(r) do
		if type(v) == "table" then t[k] = { } end
	end

	-- ther reason for not using getAttendees is that it will only examine the raid
	local ols = o.LogSnapshot;
	if ols == 1 then					-- just use the traditional method for online only
		for k,v in pairs(db.Online) do	t.Players[k] = { } end
	else
		local chkOnline,chkZone = (ols==2 or ols==3),(ols==1 or ols==3)
		for k,v in pairs(r.Players) do
			local name, online, zone = self:GetAttendeeInfo(k)
			if (not chkZone or zone==t.zone) and (not chkOnline or online) then
				t.Players[k] = { }
			end
		end
	end
	for k, v in pairs(t.Players) do		-- add times for each player
		tinsert(t.Join, { player = k, time = tsDate } )
		tinsert(t.Leave, { player = k, time = tsDate } )
	end

	tinsert(db.Log, 2, t)
end

function RaidTracker:CreateLootItemDB( frame, sLink, sPlayer, iCount, ioCostGet )
	iCount = tonumber(iCount)
	local o,L = self._options,self.L
	local sColor, sItem, sName = self:GetLinkMeta(sLink)
	if not sItem then return end
	local sNote, sCost

	if ioCostGet then
		local _, _, s0, s1, s2, s3 = string.find(sItem, "^(%d+):(%d+):(%d+):(%d+)")
		if (not sCost or sCost<=0) and ilvlDKP then
			_, sCost = self:SafeCall(ilvlDKP, "item:"..sItem ); sCost = tonumber(sCost);					--self:Debug("ItemLevelDKP", sCost)
		end
		if (not sCost or sCost<=0) and HDKP_GetDKP then
			sCost = self:SafeCall(HDKP_GetDKP, s0, s1, s2, s3); sCost = tonumber(sCost);					--self:Debug("HoB_DKP", sCost)
		end
		if (not sCost or sCost<=0) and Hellbender and Hellbender.GimmieDKP then
			sCost = self:SafeCall(Hellbender.GimmieDKP, Hellbender, "item:"..sItem); sCost = tonumber(sCost);--self:Debug("Hellbender", sCost)
		end
		if (not sCost or sCost<=0) and EasyDKP and EasyDKP.GetValue then
			sCost = self:SafeCall(EasyDKP.GetValue, EasyDKP, tonumber(s0) or 0); sCost = tonumber(sCost);	--self:Debug("EasyDKP", sCost)
		end
		if (not sCost or sCost<=0) and type(DKPValues) == "table" then
			sCost = tonumber(DKPValues[tostring(s0)]);														--self:Debug("AdvancedItemTooltip", sCost)
		end
		if (not sCost or sCost<=0) and CheeseSLS and CheeseSLS.getCTRTprice then
			sCost = self:SafeCall(CheeseSLS.getCTRTprice, CheeseSLS, sPlayer, sItem); sCost = tonumber(sCost);
		end
		if (not sCost or sCost<=0) and ML_RaidTracker_Custom_Price then
			sCost = self:SafeCall(ML_RaidTracker_Custom_Price, sItem); sCost = tonumber(sCost);
		end
	end

	local tsDate, c = self:GetTimestamp(), o.LogAttendees
	local name, link, quality, iLevel, minLevel, class, subclass, maxStack, invtype, icon = GetItemInfo("item:"..sItem)
	if icon then
		_, _, icon = string.find(icon, "^.*\\(.*)$")
	end
	local t = {
		player = sPlayer,
		item = {
			c = sColor,
			id = sItem,
			tooltip = (o.SaveTooltips == 1) and self:GetItemTooltip(sItem) or nil,
			name = sName,
			icon = icon,
			count = (iCount and iCount > 1) and iCount or nil,
			class = class,
			subclass = subclass,
			ilevel = iLevel,
		},
		cost = (tonumber(sCost) and tonumber(sCost) > 0) and tonumber(sCost) or nil,
		boss = (o.AutoEvent >= 1) and o.BossName or nil,
		note = sNote,
		zone = L.R[self:GetAttendeeZone()],	-- should be neutral L[]?
		time = tsDate,
		attendees = (c>=5 and c<=8) and self:GetAttendees("names", c==6 or c==8, c==7 or c==8) or nil,
	}
	return t
end

function RaidTracker:AddLootItemDB( raidid, sLink, sPlayer, iCount )
	if not raidid then return end
	iCount = tonumber(iCount)
	local frame,db,o = RaidTrackerFrame,self._db,self._options
	self:Debug("AddLootItemDB","rid",raidid,"link",sLink,"player",sPlayer)

	-- check via Options
	local sColor, sItem, sName = self:GetLinkMeta(sLink)
	if not sItem then return end
	local rarity = self._lookup.ColorToRarity[sColor]
	local _, _, _, ilevel = GetItemInfo(sLink);
	local _, _, itemid = string.find(sItem, "^(%d+):%d+:%d+:%d+")
	local io = db.ItemOptions[tonumber(itemid)]
	local ioStack, ioCostAsk, ioCostGet
	if (io and io.Log==0) or ( (not io or not io.Log) and not
		((rarity >= o.LogRarity) and (ilevel >= o.LogILevel)) ) then return; end
	ioStack = (io and io.Stack==1) or ((not io or not io.Stack) and
		(o.StackItems~=0 and rarity <= o.StackItems) )
	ioCostGet = (io and io.CostGet==1) or ((not io or not io.CostGet) and
		(o.CostGet~=0 and rarity >= o.CostGet) )
	ioCostAsk = (io and io.CostAsk==1) or ((not io or not io.CostAsk) and
		(o.CostAsk~=0 and rarity >= o.CostAsk) )

	-- add loot item
	local loot,t = db.Log[raidid].Loot,nil
	if ioStack then
		for k, v in pairs(loot) do
			if v.item.name == sName and v.player == sPlayer then
				t = v.item; t.count = (t.count or 1) + ((iCount and iCount>0) and iCount or 1); break
			end
		end
	end
	if not t then
		t = self:CreateLootItemDB(frame, sLink, sPlayer, iCount, ioCostGet)
		if t then
			t.id = #loot + 1;
			tinsert(loot, t.id, t)
			if ioCostAsk then
				RT_Dialog:Show("RT_EditCostFrame", "cost", "item", raidid, t.id)
			end
		end
	end
	return t
end

function RaidTracker:GetLinkMeta( sLink )
	if not sLink then return end
	local _, _, sColor, sItemStr, sName = string.find(sLink, "|c(%x+)|Hitem:([-%d:]+)|h%[(.-)%]|h|r")
	return sColor, sItemStr, sName
end

function RaidTracker:GetLink( sItem )
	if not sItem then return end
	local _,sLink = GetItemInfo("item:" .. sItem)
	return sLink
end

function RaidTracker:GetDisplayDate( t, fmt )
	return t and self:GetDate(t, self._options.Timezone, fmt) or nil
end

function RaidTracker:GetTimestamp( s, ts )
	return self:GetTime(s, ts or self._update.timediff)
end

function RaidTracker:GetRealmDisplayTime( fmt )
	return self:GetDisplayDate(self:GetTimestamp(), fmt or "%H:%M:%S")
end

function RaidTracker:GetRaidTitle( raidid, isid, isdate, iszone, color )
	local db,L = self._db,self.L
	local raid = db.Log[raidid]
	if not raid then return "Title" end

	local s = ""
	if isid then
		s = s .. (#db.Log - raidid + 1)
	end
	if isdate and raid.key then
		if		isdate=="default" then	isdate = nil
		elseif	isdate==true then		isdate = "%b %d'%y %H:%M"
		elseif	isdate=="short" then	isdate = "%m.%d %H:%M" end
		s = s .. (s=="" and "" or ") ") .. (self:GetDisplayDate(raid.key, isdate) or "")
	end
	if iszone and raid.zone then
		s = s .. (s=="" and "" or " ") .. (color and "|c00ffffff" or "") .. L[raid.zone] .. (color and "|r" or "")
		local id = raid.idiff
		if raid.zone and id then
			if color then s = s .. self._options.Color end
			local z = db.Zones[raid.zone]
			if z then
				if z.rel >= 3 and z.type == "Raid" then
					s = s .. " " .. ((id == 1 or id == 3) and L["10"] or L["25"])
					s = s .. " " .. ((id > 2) and L["Heroic"] or "")
				elseif z.type == "Party" and id > 1 then
					s = s .. " " .. L["Heroic"]
				end
			end
			if color then s = s .. "|r" end
		end
	end
	return s
end

function RaidTracker:GetStatusText( frame )
	local db, o, L = self._db, self._options, self.L
	local raid = o.CurrentRaid and db.Log[o.CurrentRaid]

	-- build status text
	local c = self:GetAttendeeCount()
	local rzt, szt = (GetRealZoneText()) or "", (GetSubZoneText()) or ""		-- localized
	local cOL, cZ = self:GetAttendees(c, true), self:GetAttendees(c, true, true)
	local sc =  c>0 and (" (" .. cOL .. ((cOL~=c) and ("/" .. c) or "") .. ")") or ""
	local sz = rzt .. (szt~="" and (": "..szt) or "")
	local szc =  (cZ>0 and cZ~=cOL) and (" ("..cZ..")") or ""
	local boss = (o.BossName and o.BossName~="Trash mob") and (" ["..L[o.BossName].."]") or ""
	return L[self:GetAttendeesType()] .. sc .. " - " .. sz .. szc .. boss
end


--[[ *****************************************************************************************************
	******************************************************************************************************
	******************************************************************************************************
	****************************************************************************************************** ]]

-- set localizations, is better than creating OnLoad for each element, maybe... :)
function RaidTracker:FrameInit()
	local L,init = self.L, RT_Templates.InitButtonTextL

	UIDropDownMenu_Initialize(RT_RarityDropdownFrame, RT_DetailFrameItems_RarityDropdown_Initialize)
	UIDropDownMenu_SetSelectedID(RT_RarityDropdownFrame, 1)
	UIDropDownMenu_SetWidth(RT_RarityDropdownFrame, 92)

	init(L, RaidTrackerFrameButtonNew)
	init(L, RaidTrackerFrameBackButton)
	init(L, RaidTrackerFrameEndRaidButton)
	init(L, RaidTrackerFrameSnapshotButton)
	init(L, RaidTrackerFrameDeleteButton)
	init(L, RaidTrackerFrameViewButton)

	init(L, RT_DetailFramePlayersTab1)
	init(L, RT_DetailFramePlayersTab2)
	init(L, RT_DetailFramePlayersTab3)
	init(L, RT_DetailFrameItemsTab1)
	init(L, RT_DetailFrameItemsTab2)
	init(L, RT_DetailFrameItemsTab3)
	init(L, RT_DetailFrameItemsTab4)
	init(L, RT_DetailFrameRaidsTab1)
	init(L, RT_DetailFrameRaidsTabLooter)
	init(L, RT_DetailFrameEventsTab1)
	init(L, RT_DetailFrameEventsTabBoss)

	init(L, RT_ConfirmDeleteFrameDeleteButton)
	init(L, RT_ConfirmDeleteFrameCancelButton)

	init(L, RT_ExportFrameDoneButton)
	init(L, RT_EditCostFrameBankButton)
	init(L, RT_EditCostFrameDisenchantButton)
	init(L, RT_AcceptWipeFrameMaybeButton)
	init(L, RT_AcceptWipeFrameNoButton)
	init(L, RT_AcceptWipeFrameYesButton)
	init(L, RT_EditNoteFrameSaveButton)
	init(L, RT_EditNoteFrameCancelButton)
end

function RaidTracker:FrameUpdate(frame)
	local frame = RaidTrackerFrame
	local db = KARaidTrackerDB
	local o, L = db.Options, self.L
	local dbLog = db.Log

	local isInteractive,isVisible = o.Interactive == 1, frame:IsVisible()
	frame.type = frame.type or "players"

	if isVisible then
		RT_Dialog:InteractiveToggle(RaidTrackerFrame, isInteractive)
	end

	-- main frame top buttons
	if o.CurrentRaid --[[and o.Interactive==1]] then
		RaidTrackerFrameEndRaidButton:Enable()
		RaidTrackerFrameSnapshotButton:Enable()
	else
		RaidTrackerFrameEndRaidButton:Disable()
		RaidTrackerFrameSnapshotButton:Disable()
	end
	if isVisible then
		RT_Dialog:InteractiveToggle(RaidTrackerFrameEndRaidButton, isInteractive)
		RT_Dialog:InteractiveToggle(RaidTrackerFrameSnapshotButton, isInteractive)
	end

	if RaidTracker:GetAttendeeCount() > 0 then
		RaidTrackerFrameButtonNew:Enable()
	else
		RaidTrackerFrameButtonNew:Disable()
	end
	if isVisible then
		RT_Dialog:InteractiveToggle(RaidTrackerFrameButtonNew, isInteractive)
	end

	if frame.LastPage and #frame.LastPage > 0 then
		RaidTrackerFrameBackButton:Enable()
	else
		RaidTrackerFrameBackButton:Disable()
	end

	-- process
	local maxitems = #dbLog
	if maxitems > 0 then
		RaidTrackerFrameDeleteButton:Enable()
	else
		RaidTrackerFrameDeleteButton:Disable()
	end
	if isVisible then
		RT_Dialog:InteractiveToggle(RT_LogFrame, isInteractive)
		RT_Dialog:InteractiveToggle(RT_DetailFramePlayers, isInteractive)
		RT_Dialog:InteractiveToggle(RT_DetailFrameItems, isInteractive)
		RT_Dialog:InteractiveToggle(RT_DetailFrameRaids, isInteractive)
		RT_Dialog:InteractiveToggle(RT_DetailFrameEvents, isInteractive)
		RT_Dialog:InteractiveToggle(RaidTrackerFrameDeleteButton, isInteractive)
	end

	if maxitems <= 0 then
		frame.type = "players"
		frame.selected = nil
		RT_DetailFramePlayers:Hide()
		RT_DetailFrameItems:Hide()
		RT_DetailFrameRaids:Hide()
		RT_DetailFrameEvents:Hide()
		RaidTrackerFrameViewButton:Disable()
	else
		local type = frame.type
		if type == "players" or type == "items" then
			frame.selected = frame.selected or 1
			if not dbLog[frame.selected] then
				frame.selected = maxitems
			end
			if #dbLog[frame.selected].Loot == 0 then
				RaidTrackerFrameViewButton:Disable()
			else
				RaidTrackerFrameViewButton:Enable()
			end
			RaidTrackerFrameViewButton:SetText( (type == "players" and L["View Items"]) or L["View Players"])
		elseif type == "playerraids" or type == "playeritems" then
			local _playerid,hasItem = frame.playerid
			for k, v in pairs(dbLog) do
				for k1, v1 in pairs(v.Loot) do
					if v1.player == _playerid then hasItem = 1; break end
				end
				if hasItem then	break end
			end
			if not hasItem then
				if type == "playeritems" then
					frame.type = "playerraids"
					self:FrameUpdate()
					self:FrameUpdateView()
					return
				end
				RaidTrackerFrameViewButton:Disable()
			else
				RaidTrackerFrameViewButton:Enable()
			end
			RaidTrackerFrameDeleteButton:Disable()
			RaidTrackerFrameViewButton:SetText((type == "playerraids" and L["View Loot"]) or L["View Raids"] )
		elseif type == "itemhistory" or type == "events" then
			RaidTrackerFrameViewButton:Disable()
			RaidTrackerFrameDeleteButton:Disable()
		end
	end

	-- ScrollFrame update
	RT_ScrollFrameRaids_Update()
	RaidTrackerFrameHeaderText:SetText(RaidTracker:GetStatusText(frame))
end



function RaidTracker.CompareItems(a, b)
	local so = KARaidTrackerDB.SortOptions
	local lookup = RaidTracker._lookup
	local _type = RaidTrackerFrame.type

	local filter, method, way = so[_type.."filter"], so[_type.."method"], so[_type.."way"]
	local r1,r2,c1,c2 = lookup.ColorToRarity[a.item.c], lookup.ColorToRarity[b.item.c]

	if r1 < filter then
		return false
	elseif r2 < filter then
		return true
	end

	if method == "name" then
		c1, c2 = a.item.name, b.item.name
		if c1 == c2 then
			c1, c2 = a.player, b.player
		end
	elseif method == "looter" then
		c1, c2 = a.player, b.player
		if c1 == c2 then
			c1, c2 = r2, r1
			if c1 == c2 then
				c1, c2 = a.item.name, b.item.name
			end
		end
	elseif method == "looted" then
		c1, c2 = a.time, b.time
	else										-- rarity
		c1, c2 = r1, r2
		if c1 == c2 then
			c1, c2 = a.item.name, b.item.name
			if c1 == c2 then
				c1, c2 = a.player, b.player
			else
				way = "asc"
			end
		end
	end
	if way == "asc" then
		return c1 < c2
	else
		return c1 > c2
	end
end

function RaidTracker:FrameUpdateView( )
	local frame,self = RaidTrackerFrame, RaidTracker
	local db, o, L = self._db, self._options, self.L
	local so,dbLog = db.SortOptions, db.Log
	local lookup = self._lookup

	frame.type = frame.type or "players"

	local raidid = frame.selected
	local raid = raidid and dbLog[raidid]
	local viewButton = RaidTrackerFrameView2Button
	if frame.type == "events" then
		viewButton:SetText(L["View Raid"])
	else
		viewButton:SetText(L["View Events"])
		if not raidid or (not raid.Events or #raid.Events==0) then
			viewButton:Disable()
		else
			viewButton:Enable()
		end
	end
	if #dbLog <= 0 then return end

	if frame.type == "players" or not frame.type then
		RT_DetailFramePlayers:Show()
		RT_DetailFrameItems:Hide()
		RT_DetailFrameRaids:Hide()
		RT_DetailFrameEvents:Hide()
	elseif frame.type == "items" or frame.type == "playeritems" then
		RT_DetailFramePlayers:Hide()
		RT_DetailFrameItems:Show()
		RT_DetailFrameRaids:Hide()
		RT_DetailFrameEvents:Hide()
	elseif frame.type == "playerraids" or frame.type == "itemhistory" then
		RT_DetailFramePlayers:Hide()
		RT_DetailFrameItems:Hide()
		RT_DetailFrameRaids:Show()
		RT_DetailFrameEvents:Hide()
	elseif frame.type == "events" then
		RT_DetailFramePlayers:Hide()
		RT_DetailFrameItems:Hide()
		RT_DetailFrameRaids:Hide()
		RT_DetailFrameEvents:Show()
	end

	if frame.type == "players" or not frame.type then
		local players = { }
		if raid then
			local index = { }
			for k, v in pairs(raid.Join) do
				if v.player then
					local id = index[v.player]
					if not id or v.time < players[id].join then
						local t = { join = v.time, name = v.player }
						if index[v.player] then
							players[id] = t
						else
							tinsert( players, t )
							index[v.player] = #players
						end
					end
					id = index[v.player]
					local player = players[id]
					if not player.lastjoin or player.lastjoin < v.time then
						player.lastjoin = v.time
					end
				end
			end
			for k, v in pairs(raid.Leave) do
				local id = index[v.player]
				if id then
					local player = players[id]
					if (not player.leave or v.time > player.leave) and v.time >= player.lastjoin then
						player.leave = v.time
					end
				end
			end
			for k, v in pairs(players) do
				if not v.leave then
					players[k].leave = 99999999999;			-- Very ugly hack, I know :(
				end
			end

			local method, way = so.playersmethod, so.playersway
			table.sort(	players,
				function(a, b)
					if way == "asc" then
						return (a[method] < b[method])
					else
						return (a[method] > b[method])
					end
				end
			)
		end
		RT_DetailFramePlayers.raidid = raidid
		RT_DetailFramePlayers.players = players
		RT_DetailScrollFramePlayers_Update()
		RT_DetailFramePlayersText:SetText(L["Participants"] .. " (" .. #players .. ")")

	elseif frame.type == "items" then
		local nitems, nhidden = 0, 0

		if raid then
			local loot = { }
			for k,v in pairs(raid.Loot) do
				if v.item and lookup.ColorToRarity[v.item.c] >= so.itemsfilter then		--FIXME: v.item is null for one user, not getign set somewher or bommed out
					tinsert(loot, v)
					nitems = nitems + 1
				else
					nhidden = nhidden + 1
				end
			end
			table.sort( loot, self.CompareItems )

			RT_DetailFrameItems.raidid = raidid
			RT_DetailFrameItems.data = loot
			RT_DetailFrameItems.type = frame.type
			RT_DetailScrollFrameItems_Update()
			RT_DetailFrameItems:Show()
		end
		RT_Button:DetailFrameItems_RarityDropdown_Update()
		RT_DetailFrameItemsText:SetText(L["Items"].." ("..nitems.. ((nhidden~=0) and ("/"..(nhidden + nitems)) or "") .."):")

	elseif frame.type == "playerraids" then
		RT_DetailFrameRaidsTabLooter:Hide()
		RT_DetailFrameRaidsTab1:SetWidth(300)
		RT_DetailFrameRaidsTab1Middle:SetWidth(290)
		local name = frame.playerid

		local raids = { }
		for k, v in pairs(dbLog) do
			for k1, v1 in pairs(v.Join) do
				if v1.player == name then
					tinsert(raids, { k, v })
					break
				end
			end
		end

		local way = so.playerraidsway
		table.sort( raids, function(a, b)
				if way == "asc" then
					return a[2].key < b[2].key
				else
					return a[2].key > b[2].key
				end
			end
		)
		RT_DetailFrameRaids.name = name
		RT_DetailFrameRaids.data = raids
		RT_DetailScrollFramePlayer_Update()
		RT_DetailFrameRaidsText:SetText(name .. "'s " .. L["Raids"] .. " (" .. #raids .. "):")

	elseif frame.type == "itemhistory" then
		RT_DetailFrameRaidsTabLooter:Show()
		RT_DetailFrameRaidsTab1:SetWidth(163)
		RT_DetailFrameRaidsTab1Middle:SetWidth(155)

		local itemname, totalItems = frame.itemname, 0
		local loot = { }
		for k,v in pairs(dbLog) do
			for k1,v1 in pairs(v.Loot) do
				if v1.item.name == itemname then
					tinsert( loot, { k, v, v1 } )
					totalItems = totalItems + (v1.item.count or 1)
				end
			end
		end

		local method, way = so[frame.type.."method"], so[frame.type.."way"]
		table.sort( loot, function(a, b)
			if method == "looter" then
				if way == "asc" then
					return a[3].player < b[3].player
				else
					return a[3].player > b[3].player
				end
			else
				if way == "asc" then
					return a[2].key < b[2].key
				else
					return a[2].key > b[2].key
				end
			end
		end	)

		RT_DetailFrameRaids.data = loot
		RT_DetailFrameRaids.name = itemname
		RT_DetailScrollFramePlayer_Update()
		RT_DetailFrameRaidsText:SetText(itemname .. " (" .. #loot .. "/" .. totalItems .. "):")

	elseif frame.type == "playeritems" then
		local name = frame.playerid
		local nitems, nhidden = 0, 0

		local loot = { }
		for k, v in pairs(dbLog) do
			for k1, v1 in pairs(v.Loot) do
				if v1.player == name then
					if lookup.ColorToRarity[v1.item.c] >= so.playeritemsfilter then
						nitems = nitems + 1
						tinsert( loot, {
								note = v1.note,
								player = v1.player,
								time = v1.time,
								item = v1.item,
								id = v1.id,
								raidid = k,	} )
					else
						nhidden = nhidden + 1
					end
				end
			end
		end
		table.sort( loot, self.CompareItems )

		RT_DetailFrameItems.raidid = raidid
		RT_DetailFrameItems.data = loot
		RT_DetailFrameItems.type = frame.type
		RT_DetailScrollFrameItems_Update()
		RT_DetailFrameItemsText:SetText(name .. "'s " .. L["Loot"] .. "(" .. nitems .. ((nhidden~=0) and ("/"..(nhidden+nitems)) or "") .. "):")
		RT_Button:DetailFrameItems_RarityDropdown_Update()

	elseif frame.type == "events" then
		RT_DetailFrameEventsTabBoss:Show()
		RT_DetailFrameEventsTab1:SetWidth(163)
		RT_DetailFrameEventsTab1Middle:SetWidth(155)

		local events = { }
		if raid and raid.Events then
			for k, v in pairs(raid.Events) do
				tinsert(events, v)
			end
		end

		RT_DetailFrameEvents.raidid = raidid
		RT_DetailFrameEvents.data = events
		RT_DetailFrameItems.type = frame.type
		RT_DetailScrollFrameEvents_Update()
		RT_DetailFrameEventsText:SetText(self:GetRaidTitle(raidid, false, true, true))
	end
end


function RT_ScrollFrameRaids_Update( )
	local frame,self = RT_LogFrame, RaidTracker
	local dbLog = self._db.Log

	local selected = RaidTrackerFrame.selected
	local maxitems = #dbLog
	FauxScrollFrame_Update(frame, maxitems, 22, 15)
	for i=1, 22 do
		local id = i + FauxScrollFrame_GetOffset(frame)
		local sline = "RT_LogFrameLine" .. i
		local line = _G[sline]

		if id > maxitems then
			line.selected = nil
			line.raidid = nil
			line:Hide()
		else
			line.type = "raid"
			line.raidid = id
			line.selected = (selected == id) and 1 or nil

			local raidTitle = self:GetRaidTitle(id, true, "short", true, true)
			local raidTag = dbLog[id].note
			line:SetText( raidTitle .. (raidTag and (" ("..raidTag..")") or "") )
			if line.selected then
				_G[sline.."MouseOver"]:Show()
			else
				_G[sline.."MouseOver"]:Hide()
			end
			line:Show()
		end
	end
	frame:Show()
end

function RT_DetailScrollFramePlayers_Update()
	local frame,self = RT_DetailFramePlayers, RaidTracker
	local db,o,L = self._db, self._options, self.L
	local dbLog = db.Log

	local raidid = frame.raidid
	local raid = raidid and dbLog[raidid]
	local maxlines = #frame.players
	FauxScrollFrame_Update(frame, maxlines, 14, 18)
	for i = 1, 14 do
		local sline = "RT_DetailFramePlayersLine"..i
		local line = _G[sline]
		local id = i + FauxScrollFrame_GetOffset(frame)
		if id > maxlines then
			line:Hide()
		else
			local player = frame.players[id]
			line.type = "player"
			line.raidid = raidid
			line.playerid = player.name
			line.raidtitle = self:GetRaidTitle(raidid, false, true)
			_G[sline.."Name"]:SetText(player.name)
			_G[sline.."Number"]:SetText( (id < 10) and ("  "..id) or id )
			_G[sline.."Join"]:SetText( self:GetDisplayDate(player.join, (o.TimeFormat==1) and "%H:%M" or "%I:%M%p") )
			_G[sline .. "Leave"]:SetText("")
			if player.leave ~= 99999999999 then
				_G[sline.."Leave"]:SetText( self:GetDisplayDate(player.leave, (o.TimeFormat==1) and "%H:%M" or "%I:%M%p") )
			end
			local c = raid.Players[player.name];  c = (c and c.note) and 1 or 0.5
			_G[sline.."NoteButtonNormalTexture"]:SetVertexColor(c, c, c)
			line:Show()
		end
	end
	frame:Show()
end

function RT_DetailScrollFrameItems_Update()
	local frame = RT_DetailFrameItems
	local self = RaidTracker
	local db, o, L = self._db, self._options, self.L

	local raid = db.Log[frame.raidid]
	local maxlines = #frame.data
	FauxScrollFrame_Update(frame, maxlines, 7, 41)
	for i=1, 7 do
		local sline = "RT_DetailFrameItemsLine" .. i
		local line = _G[sline]
		local id = i + FauxScrollFrame_GetOffset(frame)
		if id > maxlines then
			line:Hide()
		else
			local loot = frame.data[id]
			local count = loot.item.count
			line.type = "item"
			line.loot = loot
			line.item = loot.item
			line.itemid = loot.id
			line.itemname = loot.item.name
			_G[sline.."Count"]:SetText((count and count > 1) and count or "")
			_G[sline.."IconTexture"]:SetTexture("Interface\\Icons\\" .. (loot.item.icon or o.ItemIcon))
			local c = loot.item.c
			_G[sline.."Description"]:SetText("|c" .. ((c == "ff1eff00") and "ff005F00" or c) .. loot.item.name);	-- tone down the green
			c = loot.note and 1 or 0.5
			_G[sline.."NoteButtonNormalTexture"]:SetVertexColor(c, c, c)
			if frame.type == "items" then
				line.raidid = frame.raidid
				_G[sline.."Looted"]:SetText(L:F("Looted by: %s", self:ToStr(nil,40,loot.player)))
			elseif frame.type == "playeritems" then
				line.raidid = loot.raidid
				_G[sline .. "Looted"]:SetText(L:F("Looted %s", self:GetRaidTitle(line.raidid, false, true)))
			end
			line:Show()
		end
	end
	frame:Show()
end

function RT_DetailScrollFramePlayer_Update()
	local frame = RT_DetailFrameRaids
	local self = RaidTracker
	local db, o, L = self._db, self._options, self.L
	local dbLog = db.Log

	local name = frame.name
	local data = frame.data
	local maxlines = #data
	FauxScrollFrame_Update(frame, maxlines, 14, 18)
	for i=1, 14 do
		local sline = "RT_DetailFrameRaidsLine" .. i
		local line = _G[sline]
		local id = i + FauxScrollFrame_GetOffset(frame)
		if id > maxlines then
			line:Hide()
		else
			local data = data[id]
			local iNumber = #dbLog - data[1] + 1

			line.type = "raid"
			line.raidid = data[1]
			line.raidtitle = self:GetRaidTitle(line.raidid, false, true)
			_G[sline.."Number"]:SetText((iNumber < 10) and ("  " .. iNumber) or iNumber)
			_G[sline.."Name"]:SetText(line.raidtitle)
			if RaidTrackerFrame.type == "playerraids" then
				line.playerid = name
				_G[sline.."NoteButton"]:Show()
				local playersName = data[2].Players[name]
				local c = (playersName and playersName.note) and 1 or 0.5
				_G[sline.."NoteButtonNormalTexture"]:SetVertexColor(c, c, c)
				_G[sline.."DeleteButton"]:Show()
				_G[sline.."Note"]:Hide()
				_G[sline.."HitAreaRight"]:Hide()
				_G[sline.."Name"]:SetWidth(232)
			elseif RaidTrackerFrame.type == "itemhistory" then
				line.playerid = data[3].player
				_G[sline.."NoteButton"]:Hide()
				_G[sline.."DeleteButton"]:Hide()
				_G[sline.."Note"]:Show()
				_G[sline.."Name"]:SetWidth(130)
				_G[sline.."Note"]:SetText(line.playerid)
				_G[sline.."HitAreaRight"]:Show()
			end
			line:Show()
		end
	end
	frame:Show()
end

function RT_DetailScrollFrameEvents_Update()
	local frame = RT_DetailFrameEvents
	local self = RaidTracker
	local db, o, L = self._db, self._options, self.L

	local maxlines = #frame.data
	FauxScrollFrame_Update(frame, maxlines, 14, 18)
	for i=1, 14 do
		local sline = "RT_DetailFrameEventsLine" .. i
		local line = _G[sline]
		local id = i + FauxScrollFrame_GetOffset(frame)
		if id > maxlines then
			line:Hide()
		else
			local event = frame.data[id]
			line.raidid = frame.raidid
			line.type = "event"
			line.event = event
			line.eventid = event.id
			_G[sline.."MouseOver"]:Hide()
			_G[sline.."HitArea"]:Show()
			_G[sline.."Boss"]:SetText(L[event.boss])
			_G[sline.."Time"]:SetText(self:GetDisplayDate(event.time,"%m/%d %H:%M"))
			c = event.note and 1 or 0.5
			_G[sline.."NoteButtonNormalTexture"]:SetVertexColor(c, c, c)
			line:Show()
		end
	end
	frame:Show()
end


function RaidTracker:SortToggle( frame )
	self.SortToggle_t = self.SortToggle_t or {
		itemhistory = { "name", "looter" },
		playerraids = { "name", "looter" },
		playeritems = { "name", "looted", "looter", "rarity" },
		items		= { "name", "looted", "looter", "rarity" },
		players		= { "name", "join", "leave" },
	}

	local so,id,type = self._db.SortOptions, frame:GetID(), RaidTrackerFrame.type or "players"
	local table,method,way = self.SortToggle_t[type], type.."method", type.."way"
	if not table then return end

	if so[method] == table[id] then
		so[way] = (so[way] == "asc") and "desc" or "asc"
	else
		so[way] = (table[id] ~= "leave") and "asc" or "desc"
		so[method] = table[id]
	end

	PlaySound("igMainMenuOptionCheckBoxOn")
	self:FrameUpdateView()
end

function RaidTracker:Select( frame, type )
	local selected, copy
	if type == "raid" then
		type = "players"
		selected = frame.raidid
	elseif type == "player" then
		type = "playerraids"
		copy = "playerid"
	elseif type == "item" then
		type = "itemhistory"
		copy = "itemname"
	else return	end

	self:GetPage()
	local rtf = RaidTrackerFrame
	rtf.type = type
	if copy then rtf[copy] = frame[copy] end
	rtf.selected = selected
	self:FrameUpdate()
	self:FrameUpdateView()
end

function RaidTracker:GetPage()
	local frame = RaidTrackerFrame
	if frame.type or frame.itemname or frame.selected or frame.playerid then
		tinsert( frame.LastPage, {
				type = frame.type,
				itemname = frame.itemname,
				selected = frame.selected,
				player = frame.playerid,
			} )
	end
	if #frame.LastPage > 0 then
		RaidTrackerFrameBackButton:Enable()
	else
		RaidTrackerFrameBackButton:Disable()
	end
end

function RaidTracker:GoBack()
	local frame = RaidTrackerFrame
	local t = tremove( frame.LastPage )
	if t then
		frame.type = t.type
		frame.itemname = t.itemname
		frame.selected = t.selected
		frame.playerid = t.player
		self:FrameUpdate()
		self:FrameUpdateView()
	end
	if #frame.LastPage > 0 then
		RaidTrackerFrameBackButton:Enable()
	else
		RaidTrackerFrameBackButton:Disable()
	end
end

