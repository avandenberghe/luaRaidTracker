-- General AddOn Options

RT_Options = {
	desc = {
		logGroup = { [0] = "Off", [1] = "Log", [2] = "Auto Create", [3] = "Auto Instance", [4] = "Auto Event" },
		logAttendees = { [0] = "Off", [1] = "On event", [2] = "On event (Online)", [3] = "On event (Zone)", [4] = "On event (Both)",
			[5] = "On loot", [6] = "On loot (Online)", [7] = "On loot (Zone)", [8] = "On loot (Both)", },
		logGuild = { [0] = "Off", [1] = "On event (All)",  },
		logSnapshot = { [0] = "Off", [1] = "Online", [2] = "Zone", [3] = "Both", },
		tooltips = { [0] = "Essential", [1] = "All", },
		autoEvent = { [0] = "Off", [1] = "On mouseover", [2] = "On event", [3] = "Ask Next", },
		export = { [0] = "EQdkp/ML 1.1", [1] = "EQdkp Unknown", [2] = "MLdkp 1.5", [3] = "EQdkp Strict", [4] = "Plain Text", [5] = "Text CSV", [6] = "EQdkp Plus", [7] = "SMF BBCode", [8] = "GuildLaunch Forum", [9] = "GuildLaunch DKP", [10] = "GuildLaunch DKP2", [11] = "Text No DKP", [12] = "phpBB BBCode", },
		itemopt = {	[0] = "Default", [1] = "Never", [2] = "Always",	},
		rarity = { [0] = "|c00ffffffOff|r", [1] = "|c009d9d9dPoor|r", [2] = "|c00ffffffCommon|r", [3] = "|c001eff00Uncommon|r", [4] = "|c000070ddRare|r", [5] = "|c00a335eeEpic|r", [6] = "|c00ff8000Legendary|r", [7] = "|c00e6cc80Artifact|r", [8] = "|c00e6cc80Heirloom|r", },
		ilevel = { [0] = "Off", },
		logWipe = {
			[0] = "Off", [1] = "Log", [2] = "10%", [3] = "20%", [4] = "30%", [5] = "40%",
			[6] = "50%", [7] = "60%", [8] = "70%", [9] = "80%", [10] = "90%",
		},
	},
}


function RT_Options:OnLoad( frame )
	local rt = RaidTracker
	local o,L = rt._options,rt.L
	local desc = self.desc

	RT_OptionsFrameHeaderTitle:SetText(L["Raid Tracker"].." - "..L["Options"])
--    RT_OptionsFrameHeaderText:SetText(L["Options for raids, parties, arenas, bgs, and solo."]);

	local info = {
		{ name="_Section1", title="Logging", type="Frame", class="RT_SectionTemplate", y=-24, opts = nil, desc = "Basic logging options. Logging only occurs if there is a currently open session. For group options such as Raid and Party, the 'Log' option allows per group type the logging of events, items, attendence, and other history. 'Auto Create' additionally allows a session to be automatically created if no session is already started, such as when loot is received that passes filters, or when joining a group of that type. 'Auto Instance' additionally allows a new session to be created when entering a new triggerable zone, even if a session is already started. 'Auto Event' causes a new session to be created when a new event (boss kill) occurs, even if a session is already started.", },
		{ name="AutoRaid", title="Raids", type="Slider", class="RT_SliderTemplate", opts = desc.logGroup, desc = "Options for logging when in a raid.", },
		{ name="AutoParty", title="Parties", type="Slider", class="RT_SliderTemplate", opts = desc.logGroup, desc = "Options for logging when in a party.", },
		{ name="AutoSolo", title="Solo", type="Slider", class="RT_SliderTemplate", opts = desc.logGroup, desc = "Options for logging when playing solo. For solo, the all the same rules apply, except that becoming Solo itself (not being in any group) won't trigger starting a new session if 'Auto Create' or higher is enabled.", },
		{ name="AutoBattlegroup", title="Battlegrounds", type="Slider", class="RT_SliderTemplate", opts = desc.logGroup, desc = "Options for logging when in a battlegroup.", },
		{ name="AutoArena", title="Arenas", type="Slider", class="RT_SliderTemplate", opts = desc.logGroup, desc = "Options for logging when in an arena.", },
		{ name="LogAttendees", title="Attendees", type="Slider", class="RT_SliderTemplate", y=-24, opts = desc.logAttendees, desc = "Logs attendee snapshots for use by export. 'On event' creates a snapshot on an event (boss kill), attached to the event, 'On loot' creates a snapshot when loot is received, attached to the loot item.  Can optionally filter by zone, online, or both.  'Zone' filters anyone not in the zone, 'Online' filters anyone not online, and 'Both' filters both together.", },
		{ name="LogGuild", title="Guildies", type="Slider", class="RT_SliderTemplate", opts = desc.logGuild, desc = "Adds guildies as attendees to the log session as though they were raid members. 'On event (all)' adds all guildies on an event (boss kill), or can filter as minimum guild rank to add on an event. Ex: Officer or higher or Raider or higher. Often used as a way to show who was on standby.", },
		{ name="LogWipe", title="Wipes", type="Slider", class="RT_SliderTemplate", opts = desc.logWipe, optsf = "Ask at %s", optsfs = 2, desc = "Logs a wipe if everyone is dead, or optionally pops-up a dialog box asking if this is a wipe at a certain percentage. Will only popup if you are dead. Used by some DKP systems, or useful if you have died and want to be notified and are otherwise distracted.", },
		{ name="LogSnapshot", title="Snapshot", type="Slider", class="RT_SliderTemplate", opts = desc.logSnapshot, desc = "Controls how a snapshot filters attendees added when a new session snapshot is made.", },
		{ name="_Section2", title="Item Quality", type="Frame", class="RT_SectionTemplate", opts = nil, desc = "Item quality filters. 'Minimum' means that item's rarity or higher, and 'maximum' means that item's rarity or lower.", },
		{ name="LogRarity", title="Min Rarity", type="Slider", class="RT_SliderTemplate", opts = desc.rarity, desc = "Logs only items of this rarity or higher. If an item is filtered using this setting, it will be ignored compltely and will not trigger things like 'session start on loot', items using /rt itemadd will be filtered, etc. Items can also be set individually for logging using Item Options.", },
		{ name="LogILevel", title="Min iLevel", type="Slider", class="RT_SliderTemplate", opts = desc.ilevel, desc = "Logs only items of this item level or higher. If an item is filtered using this setting, it will be ignored compltely and will not trigger things like 'session start on loot', items using /rt itemadd will be filtered, etc. Items can also be set individually for logging using Item Options.", },
		{ name="CostGet", title="Min to Get Cost", type="Slider", class="RT_SliderTemplate", opts = desc.rarity, desc = "Gets default cost for items of this rarity or higher from an external cost system, such as Hellbender DKP or ItemLevelDKP, when an item is looted and tring to get a valid cost value. If Ask Cost is enabled will pass this value to Ask Cost as the default, otherwise will set the cost value for the loot item automatically. Items can also be set individually for this option in Item Options.", },
		{ name="CostAsk", title="Min to Ask Cost", type="Slider", class="RT_SliderTemplate", opts = desc.rarity, desc = "Asks for cost using pop-up box for items of this rarity or higher when loot is received. If Get Cost is enabled then will use the value form Get Cost as default. Items can also be set individually for this option in Item Options.", },
		{ name="StackItems", title="Max to Stack", type="Slider", class="RT_SliderTemplate", opts = desc.rarity, desc = "Stacks items of this rarity or lower in the loot logs instead of them logging individualy. This helps keep account of items without the clutter when logging information per looted item isn't needed. Items can also be set individually for this option in Item Options.", },
		{ name="_Section3", title="Advanced", type="Frame", class="RT_SectionTemplate", opts = nil, desc = "Advanced user options.", },
		{ name="ShowTooltips", title="Show Tooltips", type="Slider", class="RT_SliderTemplate", opts = desc.tooltips, desc = "Whether or not to show tooltips.", },
		{ name="AutoEvent", title="Auto Event", type="Slider", class="RT_SliderTemplate", opts = desc.autoEvent, desc = "Changes how the current loot target is determined, to trigger or find the next triggerable boss or trash mob. The current loot target is the target loot set as 'received from' when items are looted. 'On mouseover' uses the current mouse-over target, 'On event' determines the target on a boss kill event. Ask Next asks you for the next boss in a popup after an event. The most stable option is 'On event', but 'On mouseover' is useful in some cases if you are having trouble keeping the intended loot target.", },
		{ name="EventCooldown", title="Event Cooldown", type="Slider", class="RT_SliderTemplate", opts = nil, desc = "How long to wait in seconds after an event (boss kill) before allowing a non-triggerable kill, or trash mob, to change the current loot target.  You can always see the loot target currently set in the status bar at top of main window, if no target then is considered a trash mob.  Loot bosses can always be set after the fact usign the right-click menus as well.", },
		{ name="LevelMax", title="Export Level", type="Slider", class="RT_SliderTemplate", opts = nil, desc = "The default player level for use by export, and for some formats is the minimum export level for a player. Does not affect or limit anything going into the database in any way.", },
		{ name="AutoZone", title="Auto Zone", type="CheckButton", class="RT_CheckBoxTemplate", opts = nil, desc = "Allow the zone to automatically be determined. If this is not enabled then the zone wil have to be set manually using the right-click menus if needed for export. Turning this off is useful for meriad of reasons for controlling how sessions are handled and segmented, as it also affects other automation.", },
		{ name="DebugMode", title="Debug Mode", type="CheckButton", class="RT_CheckBoxTemplate", opts = nil, desc = "Enables developer debug mode. Is useful getting debug messages, for curiosity, or for helping with support in some cases.", },
		{ name="ExportFormat", title="Export Format", type="Slider", class="RT_SliderTemplate", opts = desc.export, desc = "Format used for export. Session export can be found by using the right-click menu on a session.", },
	}

	RT_Templates:InitWidgets( frame, RT_Button, info )
end


function RT_Options:OnShow( frame )
	if self.OnLoad then self:OnLoad(frame); self.OnLoad = nil end
	local rt = RaidTracker
	local o,L = rt._options,rt.L

	local count = table.maxn(self.desc.logGuild)
	for i = 2, count do tremove(self.desc.logGuild, i) end
	if IsInGuild() then
		GuildRoster(); count = max(GuildControlGetNumRanks(), 1)
		for i = 2, count do	self.desc.logGuild[i] = "("..i..") "..GuildControlGetRankName(i) end
	end
	RT_OptionsFrame_LogGuild:SetMinMaxValues(0, count)

	for k,v in pairs(rt._store.defaults.Options) do
		local e,opt = _G["RT_OptionsFrame_" .. k],o[k]
		if e then
			if e.GetMinMaxValues then local _,x = e:GetMinMaxValues(); if opt > x then opt = x end end
			if e.SetChecked then e:SetChecked(opt) else e:SetValue(opt) end
		end
	end
end


function RT_Options:OnSave( frame )
	local rt = RaidTracker
	local o,L = rt._options,rt.L

	for k,v in pairs(rt._store.defaults.Options) do
		local e = _G["RT_OptionsFrame_"..k]
		if e then
			v = e.GetChecked and ((e:GetChecked() == 1) and 1 or 0) or e:GetValue()
			if o[k] ~= v then o[k] = v end
		end
	end

	rt:FrameUpdate()
	rt:FrameUpdateView()
end