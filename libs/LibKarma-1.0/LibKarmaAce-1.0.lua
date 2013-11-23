if KarmaStub:isLib("LibKarmaAce", 1.1, "$Revision: 102 $") then return end

--	Simple integrated automated lightweight support for other basic desparate libraries and systems

--	This file is primarily a way to hobble together rock, ace2, ace3, minimap, fubar, ldb, titan, and
--	others in a	way where the addon can be blissfully unaware. Either rely on any or none of these
--	facilities being available and get at worst case a native minimap icon with a native right-click
--	menu. This is really a lot of functionality in a pretty small space...

--  Direct Fu support was removed after 5.3 release as loading the api still embeded in some mods causes
--  performance degredation, and fu generated menus and icons have serious issues now.

LibKarmaAce = LibKarmaAce or  {

}

function LibKarmaAce:GetLexFlags(loc)
	local isSC,isOR = loc == "zhCN" or loc == "zhTW", loc ~= "koKR" and loc ~= "deDE"	-- single char, verb order
	local isAS,_SP = isSC or loc == "koKR", isSC and "" or " "							-- non-latin, delimiter
	return isSC, isOR, isAS, _SP
end
--function LibKarmaAce:GetLexTools()		-- used file load time. only supports current loc.
--	local t = self["_lextools"]
--	if not t then
--		local isSC, isOR, isAS, _SP = self:GetLexFlags(GetLocale())
--		t = {
--		GrabVerb = function(s,d) return s and (isSC and s:sub(1,6) or select(isOR and 1 or -1, strsplit(' ', s))) or d end,
--		GrabNoun = function(s,d) return s and (isSC and s:sub(-6,-1) or select(isOR and -1 or 1, strsplit(' ', s))) or d end,
--		CapCase = function(s) return (not isAS and s) and s:gsub("^%l", strupper) or s end,
--		UncapCase = function(s) return (not isAS and s) and s:gsub("^%u", strlower) or s end,
--		isSC = isSC, isOR = isOR, isAS = isAS, _SP = _SP, loc = loc,
--		}
--		self["_lextools"] = t 
--	end
--	return t
--end
function LibKarmaAce:LoadLocales( frame, inst, locale, L )

	L["Show Help"] = true --isOR and SHOW.._SP..GAMEMENU_HELP or GAMEMENU_HELP.._SP..SHOW
	L["Main Window"] = true
	L["Show Main Window"] = true
	L["Show Options"] = true --isOR and SHOW.._SP..MAIN_MENU or MAIN_MENU.._SP..SHOW
	L.ADDON_TOOLTIP = "|cffeda55fClick|r to open main window. |cffeda55fShift-click|r to open options."
	L.ADDON_TOOLTIP_RC = "|cffeda55fRight-click|r to show menu."

	-- already localized
	L["Help"] = GAMEMENU_HELP or true
	L["Options"] = GAMEOPTIONS_MENU or true
	L["Cancel"] = CANCEL or true
	L["Close"] = CLOSE or true

	--if locale == "esMX" then L["Help"] = "Spanish" end
	-- inst:DebugTable("LibKarmaAce:LoadLocales", locale, L:GetLocale(Name,true))
end

function LibKarmaAce:OnAddonLoaded( frame, inst )

	-- global
	self._acelib = self._acelib or {
		locale = {
			mt = {	__newindex = function( t, k, v ) if t[1] then t[1][k] = v end; end,
					__index = function( t, k ) if not k then return end
						local _,_,c,s,r,f = string.find(k, "^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
						if c then k,s = s,k end
						for i, v in pairs(t) do
							v = (v and type(i) == "number") and v[k]; f = f or v
							if v and (i==1 or v~=k) then return c and (c..v..r) or v end
						end
						if not f and t[1] then t[1][k] = k end;			-- store capture
						return c and s or (f or k);						-- return cross checked value or defaults
					end, },
			proxy	= {	__newindex = function( t, k, v ) rawset(t[1],k,v==true and k or v) end,	__index = function( t, k ) return rawget(t[1],k); end, },
			proxyr	= { __newindex = function( t, k, v ) end, __index = function( t, k ) for i, v in pairs(t[1]) do if v==k then return i end end end, },
			format  = function( t, s, ... ) return s and string.format(t[s], ...) end,
			tcase  = function( t, s ) return s and t[s:gsub("^%l", string.upper)] end,
		},
		defaults = {
			profile = { minimap = { show = 1, position = 225, }, },
			global = { LCapture = { [inst._meta.locale]={} }, LCaptureR = { [inst._meta.locale]={} }, },
		}
	}

	-- instance
	local name = inst._instance.name
	inst._acelib = {
		name	= name.."Ace",
		nameDB	= name.."AceDB",
		nameLDB = name.."AceLDB",
		nameMMI = name.."AceMMI",
		locale	= { },
	}
	setmetatable( inst._acelib, { __index = self._acelib } )
end

do
	LoadAddOn("LibStub")
	LoadAddOn("Ace3")
	LoadAddOn("Dewdrop-2.0")
	--LoadAddOn("Dewdrop")
	--LoadAddOn("LibRock-1.0")
	LoadAddOn("LibBabble-Zone-3.0")
	LoadAddOn("LibBabble-Boss-3.0")
	LoadAddOn("LibBabble-Inventory-3.0")
	LoadAddOn("LibBabble-CreatureType-3.0")
	--LoadAddOn("LibFuBarPlugin-3.0")
	LoadAddOn("LibDataBroker-1.1")
end

function LibKarmaAce:OnPlayerLogin( frame, inst )
	local _instG, _inst = self._acelib, inst._acelib

	-- --------- relies on old variables_loaded ----------

	-- global (get lib references)
	local LibStub = LibStub
	if not _instG.lib then
		_instG.lib = {
			L	= LibStub and LibStub("AceLocale-3.0", true),
			LZ	= LibStub and LibStub("LibBabble-Zone-3.0", true),
			LB	= LibStub and LibStub("LibBabble-Boss-3.0", true),
			LI	= LibStub and LibStub("LibBabble-Inventory-3.0", true),
			LT	= LibStub and LibStub("LibBabble-CreatureType-3.0", true),
			--fu	= LibStub and LibStub("LibFuBarPlugin-3.0", true),
			al	= AceLibrary,
			aao	= LibStub and LibStub("AceAddon-3.0", true),
			ac	= LibStub and LibStub("AceConsole-3.0", true),
			db	= LibStub and LibStub("AceDB-3.0", true),
			ldb	= LibStub and LibStub("LibDataBroker-1.1", true),
			aaoembed = { },
		}
		if _instG.lib.ac then tinsert(_instG.lib.aaoembed, "AceConsole-3.0") end
	end
	local _LG, _lib = _instG.locale, _instG.lib

	-- global (get instances)
	if not _LG.base then
		_LG.base	= setmetatable({ {}, }, _LG.proxy)
		_LG.zone	= _lib.LZ	and inst:SafeCall(_lib.LZ.GetUnstrictLookupTable, _lib.LZ)
		_LG.boss	= _lib.LB	and inst:SafeCall(_lib.LB.GetUnstrictLookupTable, _lib.LB)
		_LG.class	= LOCALIZED_CLASS_NAMES_MALE
		_LG.inv		= _lib.LI	and inst:SafeCall(_lib.LI.GetUnstrictLookupTable, _lib.LI)
		_LG.ctype	= _lib.LT	and inst:SafeCall(_lib.LT.GetUnstrictLookupTable, _lib.LT)
		_LG.baseR	= setmetatable({ _LG.base[1], }, _LG.proxyr)
		_LG.zoneR	= _lib.LZ	and inst:SafeCall(_lib.LZ.GetReverseLookupTable, _lib.LZ)
		_LG.bossR	= _lib.LB	and inst:SafeCall(_lib.LB.GetReverseLookupTable, _lib.LB)
		_LG.classR	= setmetatable({ LOCALIZED_CLASS_NAMES_MALE, }, _LG.proxyr)
		_LG.invR	= _lib.LI	and inst:SafeCall(_lib.LI.GetReverseLookupTable, _lib.LI)
		_LG.ctypeR	= _lib.LT	and inst:SafeCall(_lib.LT.GetReverseLookupTable, _lib.LT)
	end
	_lib.dd			= _lib.al	and (_lib.al:HasInstance("Dewdrop-2.0") and _lib.al("Dewdrop-2.0"))

	-- instance (get db and loc instances)
	local _L = _inst.locale
	_inst.db	= _lib.db and _lib.db:New(_inst.nameDB, _inst.defaults) or inst:_GetDB(nil, _inst.nameDB, _inst.defaults, true)
	_L.capture	= inst._meta.lcapture and _inst.db.global.LCapture[inst._meta.locale] or { }
	_L.captureR	= inst._meta.lcapture and _inst.db.global.LCaptureR[inst._meta.locale] or { }
	_L.inst		= setmetatable({_lib.L and _lib.L:GetLocale(inst._instance.name, true) or {}}, _LG.proxy)
	_L.instR	= setmetatable({_L.inst[1]}, _LG.proxyr)
	_inst.LR	= setmetatable({_L.captureR,_LG.zoneR,_LG.bossR,_LG.classR,_LG.invR,_LG.ctypeR,_L.instR,_LG.baseR, F=_LG.format,}, _LG.mt)
	_inst.L		= setmetatable({_L.capture,_LG.zone,_LG.boss,_LG.class,_LG.inv,_LG.ctype,_L.inst,_LG.base, S=_L.inst, F=_LG.format, T=_LG.tcase, R=_inst.LR,}, _LG.mt)

	-- instance (load LK locale strings)
	self:LoadLocales( frame, inst, inst._meta.locale, _LG.base )


	-- --------- relies on player_login ----------

	-- instance...
	local L = _inst.L
	_inst.instance	= _lib.aao and _lib.aao:NewAddon(_inst.name, unpack(_lib.aaoembed)) or { }
	_inst.menufunc	= function(v1,v2) _inst.instance:ExecChatCommandAce(v1,v2) end
	_inst.menu  = { handler = _inst.instance, type = "group", args = {
			main	= {	type = "execute", order = 10, name = L["Main Window"], desc = L["Show Main Window"],
						passValue = "", func = _inst.menufunc,														},
			options	= {	type = "execute", order = 20, name = L["Options"], desc = L["Show Options"],
						passValue = "options", func = _inst.menufunc,												},
			help	= {	type = "execute", order = 30, name = L["Help"], desc = L["Show Help"],
						passValue = "help", func = _inst.menufunc,													},
			hide	= {	type = "toggle",  order = -3,  name = L["Hide minimap icon"], desc = L["Hide Icon"],
						get = function() return _inst.db.profile.minimap.show ~= 1 end,
						passValue = "hide", set = _inst.menufunc, }, }, }

	local _a = _inst.instance
	if _a then									-- ace
		_a._karma				= inst
		_a._L					= _inst.L
		_a.db					= _inst.db
		_a.icon					= inst._meta.icon
		_a.title				= inst._meta.title
		_a.lable				= inst._meta.title
		_a.version				= inst._meta.version
		_a.ExecChatCommandAce	= LibKarmaAce.ExecChatCommandAce
		_a.ExecMenuCommandAce	= LibKarmaAce.ExecMenuCommandAce
		_a.OnShowMenuAce		= LibKarmaAce.OnShowMenuAce
		_a.OnMenuRequest		= _inst.menu
		_a.OnCommandAce			= LibKarmaAce.OnCommandAce
		_a.OnInitialize			= LibKarmaAce.OnInitialize
		_a.OnUpdateFuBarTooltip	= LibKarmaAce.OnUpdateFuBarTooltip
		_a.OnUpdateTooltip		= LibKarmaAce.OnUpdateTooltip
		_a.OnFuBarClick			= LibKarmaAce.OnFuBarClick
		_a.OnTooltipShow		= function(frame) _inst.instance:OnUpdateTooltip(frame) end
		_a.OnClick				= function(frame,button) LibKarmaAce.OnClick(_inst.instance, frame, button) end
	end
	if _lib.ldb then						-- libdatabroker
		_a.type					= "launcher"
		_G[_inst.nameLDB]		= _lib.ldb:NewDataObject(_a.title, _a)
	end

	if not _lib.fu then						-- app icon
		_a.Hide = LibKarmaAce.Hide
		_a.Show = LibKarmaAce.Show
		_a.nameMMI = _inst.nameMMI
		_inst.minimap = LibKarmaUI:GenerateMinimapButton( frame, _a, _inst.db.profile.minimap )
		if MinimapButtonFrame then				-- mbf/sexymap profile issues leaving a frame hidden
			_inst.db.profile.minimap.show = 1
		end
		_inst.minimap:Reposition()
	end
	if not _lib.aao and _a.OnInitialize then _a:OnInitialize()	end
	if CT_RegisterMod then					-- ct mod and related
		CT_RegisterMod(inst._meta.title, "Display window", 5, self._meta.icon,
			self._meta.desc, "switch", _a, function(self) self:ExecChatCommandAce() end )
	end
end


function LibKarmaAce:ExecMenuCommandAce( t )
	local _args = self._karma._acelib.menu.args
	t = ((type(t) == "string") and _args[t] or t) or _args.main
	if not t or type(t) ~= "table" then return end
	if t.type == "execute" or t.type == "toggle" then
		return self._karma:SafeCall(t.func or t.set, t.passValue)
	end
end

function LibKarmaAce:ExecChatCommandAce( frame, cmd )
	local func = SlashCmdList[strupper(self._karma._instance.name)]
	if type(frame) ~= "table" then cmd = frame end
	if func then self._karma:SafeCall(func, cmd or "") end
end

function LibKarmaAce:OnCommandAce( msg, cmd, args )
	local _inst = self._karma._acelib
	if cmd == "hide" then
		local isShown = _inst.minimap and _inst.minimap:IsVisible()
		--local isShown = ((_inst.lib.fu and _inst.lib.aao) and self:GetFrame():IsShown()) or (_inst.minimap and _inst.minimap:IsVisible())
		if not isShown then	self:Show()	else self:Hide() end
		return true
	elseif cmd == "help" then
		self._karma:Print((self._karma._meta.slash or ("/" .. self._karma._meta.short)) .. " hide - Hides the icon.")
	end
end

function LibKarmaAce:OnShowMenuAce( frame )
	local _lib,_menu = self._karma._acelib.lib,self.OnMenuRequest
	if not _menu then return end
	if type(_menu) == "table" then
		if _lib.dd then
			_lib.dd:Open(frame, "children", function() _lib.dd:FeedAceOptionsTable(_menu) end)
		else
			LibKarmaUI:GenerateMinimapMenu( nil, self, _menu )
		end
	elseif type(_menu) == "function" then
		self._karma:SafeCall(_menu)
	end
end

function LibKarmaAce:Hide()
	local _inst = self._karma._acelib
	_inst.minimap:Hide()
end

function LibKarmaAce:Show()
	local _inst = self._karma._acelib
	_inst.minimap:Show()
end

function LibKarmaAce:OnUpdateFuBarTooltip(f)
	f = f or GameTooltip
	f:AddLine(self._L[self.title]);
	f:AddLine(self._L["ADDON_TOOLTIP"], 0.2, 1, 0.2, 1);
end
function LibKarmaAce:OnUpdateTooltip(f)
	self:OnUpdateFuBarTooltip(f)
	f = f or GameTooltip
	f:AddLine(self._L["ADDON_TOOLTIP_RC"], 0.2, 1, 0.2, 1);
end

function LibKarmaAce:OnFuBarClick(button)
	if button == "LeftButton" then self:ExecMenuCommandAce( IsShiftKeyDown() and "options" ) end
end
function LibKarmaAce:OnClick(frame,button)
	if button == "RightButton" then	self:OnShowMenuAce(frame) end
	self:OnFuBarClick(button)
end

function LibKarmaAce:OnInitialize( )
	-- below only works with Fu3.0
	--local _inst = self._karma._acelib
	--local _lib = _inst.lib
	--if _inst.menu and _lib.fu and _lib.aao and _lib.dd then		-- only if has dd, else own menu
	--	self._karma:ArgsToTable(_inst.menu.args, _lib.fu:GetEmbedRockConfigOptions(_inst.instance))
	--	for i, v in pairs (_inst.menu.args) do
	--		if v.type == "boolean" then v.type = "toggle" end
	--		if v.type == "choice" then v.type = "text" end
	--		if v.choices then v.validate = v.choices end
	--		if i == "hide" then v.name = "Hide" end
	--	end
	--end
end
