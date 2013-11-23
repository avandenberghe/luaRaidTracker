if KarmaStub:isLib("LibKarma", 1.1, "$Revision: 90 $") then return end

--
--	Simple ligthweight AddOn framework
--

LibKarma = LibKarma or {

}


function LibKarma:GetInstance( name, inst )
	inst = inst or { }

	-- global
	self._update = self._update or {
		onupdate = function(f, elapsed) f._handler:_OnUpdate(f, elapsed) end,
	}

	-- instance...
	inst._instance = {
		name = name,
		instance = inst,
		libUtility = LibKarmaUtil,
		libLibrary = LibKarma,
		libLocale = LibKarmaLocale,
		libAce = LibKarmaAce,
	}

	inst._meta = {
		title = GetAddOnMetadata( name, "Title" ),
		version = GetAddOnMetadata( name, "Version" ),
		author = GetAddOnMetadata( name, "Author" ),
		desc = GetAddOnMetadata( name, "Description" ),
		short = strlower(GetAddOnMetadata( name, "X-ShortName" ) or inst._instance.name),
		slash = nil,
		icon = GetAddOnMetadata( name, "X-Icon" ),
		lcapture = GetAddOnMetadata( name, "X-LCapture" ) == "1" and 1 or nil,
		locale = GetLocale() == "enGB" and "enUS" or GetLocale(),
	}

	inst._update = {
		frame = CreateFrame( "Frame", nil, UIParent ),
		time = 0,
		count = 0,
		next = 0,
		interval = 0.25,
		delay = 4,
		events = { },
		gtime = 0,
		timediff = inst._instance.libUtility:GetTimeDiff(),
	}
	inst._update.frame._handler = inst
	inst._update.frame:SetScript("OnUpdate", self._update.onupdate )

	inst._store = {
		db = nil,
		name = nil,
		defaults = { Options = { DebugMode = 1 } },
	}
	inst._options = inst._store.defaults.Options

	local _inst = inst._instance
	setmetatable( _inst.libLibrary, { __index = _inst.libUtility } )
	return setmetatable( inst, { __index = _inst.libLibrary } )
end

-- i hate having to add so much code, but too many addons now, too many conflicts
function LibKarma:AddSlashCommand( sinst, s, force )
	if not s then return end
	s = "/"..strlower(s)
	local s1,s2
	if not force then
		for k,v in pairs(SlashCmdList) do
			if k then
				s1 = "SLASH_"..strupper(k)
				for i = 1,10 do
					s2 = _G[s1..i]
					if not s2 then break end
					if strlower(s2) == s then return end
				end
			end
		end
	end
	s1 = "SLASH_"..strupper(self._instance.name..((sinst)and sinst or ""))
	for i = 1,10 do
		if not _G[s1..i] then
			_G[s1..i] = s; if not sinst then self._meta.cslash = s end; return s
		end
	end
end

function LibKarma:OnLoad( frame, ... )
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("VARIABLES_LOADED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")

	local s = strupper(self._instance.name)
	SlashCmdList[s] = function(msg) self:OnCommand(msg) end
	self:AddSlashCommand( nil, s, true )

	if self.OnLoadCustom then self:OnLoadCustom(frame,...) end
end

function LibKarma:OnCommand( msg, ... )
	local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
	if cmd then	cmd = cmd:lower(); if cmd == "" then cmd = nil end end
	if args then args = args:trim(); if args == "" then args = nil end end

	if self.OnCommandCustom then if self:OnCommandCustom(msg,cmd,args,...) then return end end
	local _inst = self._acelib and self._acelib.instance or nil
	if _inst and _inst.OnCommandAce then if _inst:OnCommandAce(msg,cmd,args,...) then return end end
	if cmd ~= "help" then self:OnCommand("help") end
end

function LibKarma:OnEvent( frame, event, ... )
	local ar1 = select(1, ...)
	if event == "ADDON_LOADED" then
		if ar1 == self._instance.name then
			self:_HookDB()
			if LibKarmaAce and LibKarmaAce.OnAddonLoaded then LibKarmaAce:OnAddonLoaded(frame,self) end
		end
		if self.OnAddonLoaded then self:OnAddonLoaded(frame,...) end
	elseif event == "PLAYER_LOGIN" then
		frame:UnregisterEvent("PLAYER_LOGIN")
		self:AddSlashCommand( nil, self._meta.short )
		if LibKarmaAce and LibKarmaAce.OnPlayerLogin then LibKarmaAce:OnPlayerLogin(frame,self) end
		if self.RunVersionFix then self:RunVersionFix(frame); self.RunVersionFix = nil end
		if self.OnPlayerLogin then self:OnPlayerLogin(frame,...) end
		self._update.delay = 0;
	elseif event == "VARIABLES_LOADED" then
		if self.OnVariablesLoaded then self:OnVariablesLoaded(frame); end
--	elseif event == "PLAYER_ENTERING_WORLD" then
--		if self.OnPlayerEnteringWorld then self:OnPlayerEnteringWorld(frame,...); end
	elseif self._update.events then
		tinsert( self._update.events, {frame, event, ...} );		--self:Debug("Queueing", self._update.time, frame and frame:GetName(), event, ...)
		return
	end
	if self.OnEventCustom then self:OnEventCustom(frame,event,...) end
end


function LibKarma:_OnUpdate( frame, elapsed, ... )
	local u = self._update
	u.time = u.time + elapsed;
	if u.time < u.next then	return end
	u.next = u.time + u.interval; u.count = u.count + 1;

	if u.events and u.time > u.delay then
		for k, v in pairs(u.events) do								--self:Debug("Running", u.time, unpack(v))
			if self.OnEventCustom then self:OnEventCustom(unpack(v)) end
		end
		u.events = nil
	end
	u.gtime = self:GetGameTime()
	if u.glast ~= u.gtime then
		u.glast = u.gtime
		u.timediff = self:GetTimeDiff(u.gtime)						--self:Debug("Updating", u.timediff)
	end
	if self.UpdateFrame_OnUpdate then self:UpdateFrame_OnUpdate(frame, elapsed, ...) end
end

function LibKarma:_HookTablesDB( db, defaults, recurse )
	for i,v in pairs(defaults) do
		if type(v) == "table"  then
			if not rawget(db, i) then rawset(db, i, { }) end
			if recurse then self:_HookTablesDB( db[i], defaults[i], recurse ) end
			setmetatable(rawget(db, i), {__index = rawget(defaults, i)})
		end
	end
	return db
end

function LibKarma:_GetDB( db, name, defaults, recurse )
	db = name and _G[name] or db or { }
	if name then _G[name] = db end
	self:_HookTablesDB( db, defaults, recurse )
	return setmetatable(db, {__index = defaults})
end

function LibKarma:_HookDB( )
	local s = self._store;
	s.db = self:_GetDB( s.db, s.name, s.defaults )
	self._options = s.db.Options
	self._db = s.db
end

function LibKarma:RegisterDB( name, defaults )
	local s = self._store
	s.name = name
	s.defaults = defaults or s.defaults or { };
	self:_HookDB( )
end

function LibKarma:ImportValueDB( t, s, i, ... )
	for i1=1,select("#",...) do
		local k = select(i1,...)
		local v = rawget(s, k)
		if v then
			if type(i) == "table" then
				v = i[v]
				if v then t[k] = (v ~= "_NIL") and v or nil end
			else
				if type(i) == "string" and not rawget(t,i) then	t[i] = v end
				t[k] = nil
			end
		end
	end
end

function LibKarma:ImportRenameDB( t, names, s )
	s = s or t
	for i,v in pairs(names) do
		if type(v) == "table" then
			self:ImportValueDB(t,s,i,unpack(v))
		else
			self:ImportValueDB(t,s,i,v)
		end
	end
end

function LibKarma:ImportToDB( dst, src, prefix, isMerge, isDelete, names  )
	if not names then return end
	dst = dst or self._store.db
	src = src or dst
	for i,v in pairs(names) do
		if type(i) == "number" then i = v end
		local s = (prefix or "")..v
		if src[s] then
			if isMerge then
				dst[i] = self:TableMerge( dst[i], src[s], isDelete )
			elseif not rawget(dst,i) then
				dst[i] = self:TableCopy( src[s] )
			end
			if isDelete then src[s] = nil end
		end
	end
end
