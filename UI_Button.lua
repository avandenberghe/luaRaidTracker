

RT_Button = LibKarmaUI:GetInstance( RaidTracker, {
	EscapeToChar = {
		["\194\161"] = "!",	["\194\170"] = "a", ["\194\186"] = "o", ["\194\191"] = "?", ["\195\128"] = "A", ["\195\129"] = "A",
		["\195\130"] = "A", ["\195\131"] = "A", ["\195\133"] = "A", ["\195\135"] = "C", ["\195\136"] = "E", ["\195\137"] = "E",
		["\195\138"] = "E", ["\195\139"] = "E", ["\195\140"] = "I", ["\195\141"] = "I", ["\195\142"] = "I", ["\195\143"] = "I",
		["\195\144"] = "D", ["\195\145"] = "N", ["\195\146"] = "O", ["\195\147"] = "O", ["\195\148"] = "O", ["\195\149"] = "O",
		["\195\152"] = "O", ["\195\153"] = "U", ["\195\154"] = "U", ["\195\155"] = "U", ["\195\157"] = "Y", ["\195\160"] = "a",
		["\195\161"] = "a", ["\195\162"] = "a", ["\195\163"] = "a", ["\195\165"] = "a", ["\195\167"] = "c", ["\195\168"] = "e",
		["\195\169"] = "e", ["\195\170"] = "e", ["\195\171"] = "e", ["\195\172"] = "i", ["\195\173"] = "i", ["\195\174"] = "i",
		["\195\175"] = "i", ["\195\176"] = "d", ["\195\177"] = "n", ["\195\178"] = "o", ["\195\179"] = "o", ["\195\180"] = "o",
		["\195\181"] = "o", ["\195\184"] = "o", ["\195\185"] = "u", ["\195\186"] = "u", ["\195\187"] = "u", ["\195\189"] = "y",
		["\195\191"] = "y", ["\195\132"] = "Ae", ["\195\134"] = "AE", ["\195\150"] = "Oe", ["\195\156"] = "Ue", ["\195\158"] = "TH",
		["\195\159"] = "ss", ["\195\164"] = "ae", ["\195\166"] = "ae", ["\195\182"] = "oe", ["\195\188"] = "ue", ["\195\190"] = "th",
	},
	QuickLooter = { "disenchanted", "bank", },
	addItemInfo = { func = nil, value = { }, },
	funcMenuOnClick	= function( frame ) RT_Button:Menu_OnClick(frame) end,
} )

function RT_Button:AddMenu( frame, level, ...  )
	if not level then return end
	local value
	if level == 1 then
		local parent = frame.GetParent and frame:GetParent()
		if not parent then return end
		value = { }
		for i1=1,select("#",...) do
			local k = select(i1,...)
			value[k] = parent[k]
		end
	elseif level >= 2 then
		value = UIDROPDOWNMENU_MENU_VALUE
	end
	self.addItemInfo.value = value
	return value
end

function RT_Button:AddMenuItem( level, onClick, type1, what, title, text, value, checked, hasArrow )
	if onClick == nil then onClick = 1 end;
	if type(onClick)=="boolean" then onClick = (onClick == true) and 1 or nil end
	local e = type(onClick)
	value = (type(value)=="table") and value or { value = value };
	local info = self.addItemInfo
	if info.value then
		for i,v in pairs(info.value) do
			if not value[i] then value[i] = v end
		end
	end

	info.text = title .. (text and (" ("..text..")") or "")
	info.func = (e == "function") and onClick or (onClick and self.funcMenuOnClick)
	info.checked = checked and 1 or nil
	info.hasArrow = hasArrow and 1 or nil
	info.keepShownOnClick = (hasArrow and e ~= "string") and 1 or nil
	value.type = (type1) and type1 or value.type
	value.what = (what) and what or value.what
	value.title = title
	value.frameName = (e == "string") and onClick or nil

	info.value, value = value, info.value
	UIDropDownMenu_AddButton(info, level)
	info.value = value
end


-- ************** menus **************


function RT_Button:Menu_OnClick( frame )
	local v = frame.value
	if not v then return end
	local rt = RaidTracker
	local db, o, L = rt._db, rt._options, rt.L
	--RaidTracker:DebugTable("RT_Button:Menu_OnClick", frame:GetName(), v )
	if v.frameName then
		RT_Dialog:ShowPT(v.frameName, v.type, v)
	else
		if v.type == "rarity" then
			KARaidTrackerDB.SortOptions[ RaidTrackerFrame.type .. "filter" ] = frame:GetID()
			rt:FrameUpdateView( )
		else
			RT_Dialog:Edit_OnSave( v )
		end
		HideDropDownMenu(1)
	end
end


function RT_Button:DetailFrameItems_RarityDropdown_Update( )
	local id = KARaidTrackerDB.SortOptions[ RaidTrackerFrame.type .. "filter" ]
	UIDropDownMenu_SetSelectedID( RT_RarityDropdownFrame, id )
	RT_RarityDropdownFrameText:SetText( RaidTracker.L[RT_Options.desc.rarity[ id ]] )
end

function RT_DetailFrameItems_RarityDropdown_Initialize( frame, level )
	local L = RaidTracker.L
	local options = RT_Options.desc.rarity
	for i = 1, #options do
		RT_Button:AddMenuItem( nil, nil, "rarity", nil, L[options[i]] )
	end
end


function RT_Button:AddMenuZone( level, what, label, value, zone )
	local rt,checked = RaidTracker
	local db, def, o, L = rt._db, rt._store.defaults, rt._options, rt.L

	if level == 1 then
		RT_Button:AddMenuItem( level, "RT_EditNoteFrame", "zone", what, label or L["Edit Zone"], L[zone] or L["None"], nil, db.Zones[zone], true )
	elseif level == 2 then
		local games = { }
		for k, v in pairs(RaidTracker_Games) do tinsert( games, v ); end
		table.sort(games, function(a, b) return a.id > b.id; end)
		for i, v in ipairs(games) do
			checked = nil
			for k1, v1 in pairs(def.Zones) do
				if v1.rel == v.id and k1 == zone then checked = true; end
			end
			RT_Button:AddMenuItem( level, false, nil, nil, L[RaidTracker_Tags["REL"..v.id]], nil, v.id, checked, true )
		end
		UIDropDownMenu_AddButton( { disabled = 1 }, level )
		for k, v in pairs(db.Zones) do
			RT_Button:AddMenuItem( level, true, nil, nil, L[k], nil, k, zone == k )
		end
		RT_Button:AddMenuItem( level, true, nil, nil, L["None"], nil, nil, zone == nil)
	elseif level == 3 then
		if value.type == "zone" then
			local zones = { }
			for k, v in pairs(def.Zones) do
				if value.value == v.rel then tinsert( zones, v ); end
			end
			table.sort(zones, function(a, b) return a.pid > b.pid; end)
			local man = nil
			for k, v in pairs(zones) do
				local color,colorh = RaidTracker_Games[value.value].c,"|c00FF3333"
				local im,ih = v.im,v.ih
				local title = L[v.name] .. (v.ran and (color.."  ("..v.ran..")|r") or "") ..
					(im and (color.."  i"..im.."|r") or "") .. (ih and (colorh.."  i"..ih.."|r") or "")
				--local title = L[v.name] .. (v.ran and (o.Color.."  ("..v.ran..")|r") or "")
				if man and man ~= v.man then UIDropDownMenu_AddButton( { disabled = 1 }, level ); end
				man = v.man
				RT_Button:AddMenuItem(level, true, nil, nil, title, nil, v.name, zone == v.name)
			end
		end
	end
end

function RT_Button:AddMenuLooter( level, what, label, value, player, raid )
	local rt,checked = RaidTracker
	local db, def, o, L = rt._db, rt._store.defaults, rt._options, rt.L

	if level == 1 then
		RT_Button:AddMenuItem( level, "RT_EditNoteFrame", "looter", what, label or L["Edit Looter"], player, nil, nil, true )
	elseif level == 2 then
		for k, v in pairs(RT_Button.QuickLooter) do
			RT_Button:AddMenuItem( level, true, nil, nil, L[v], nil,  v, player == v )
		end
		UIDropDownMenu_AddButton( { disabled = 1 }, level )
		local g,gi,sg,chk = { },{ },{ }
		for k, v in pairs(raid.Join) do
			rt:TableAddUnique(gi, v.player)
		end
		table.sort(gi)
		for k, v in pairs(gi) do													-- hash the list by first letter
			local s = (RT_Button.EscapeToChar[v:sub(1, 2)] or v):sub(1,1):upper()	-- if a special char get that
			if not g[s] then g[s] = { } end
			tinsert(g[s], v)
			if player == v then chk = s; end
		end
		for k, v in pairs(g) do	tinsert(sg, k) end
		table.sort(sg)
		for k, v in pairs(sg) do
			RT_Button:AddMenuItem( level, false, nil, nil, v, nil, { players=g[v] }, chk==v, true )
		end
	elseif level == 3 then
		for k, v in pairs(value.players) do
			RT_Button:AddMenuItem( level, true, nil, nil, v, nil, v, player == v )
		end
	end
end

function RT_Button:AddMenuBoss( level, what, label, value, boss )
	local rt,checked = RaidTracker
	local db, def, o, L = rt._db, rt._store.defaults, rt._options, rt.L

	local zoneBosses, bossList = RaidTracker_ZoneBosses

	if level == 1 then
		RT_Button:AddMenuItem( level, "RT_EditNoteFrame", "boss", what, label or L["Edit Boss"], boss or L["None"], nil, boss, true )
	elseif level == 2 then
		local games = { }
		for k, v in pairs(RaidTracker_Games) do tinsert( games, v ); end
		table.sort(games, function(a, b) return a.id > b.id; end)
		for i,v in ipairs(games) do
			checked = nil
			if boss then
				for k1,v1 in pairs(def.Zones) do
					if v1.rel == v.id then
						bossList = zoneBosses[k1]
						if bossList then
							for k2,v2 in pairs(bossList) do
								if boss == v2 then checked = 1; break; end
							end
						end
					end
				end
			end
			RT_Button:AddMenuItem( level, false, nil, nil, L[RaidTracker_Tags["REL"..v.id]], nil, v.id, checked, true )
		end
		UIDropDownMenu_AddButton( { disabled = 1 }, level )
		for k, v in pairs(zoneBosses) do
			if type(v) ~= "table" then
				RT_Button:AddMenuItem( level, true, nil, nil, L[k], nil, k, boss == k )
			end
		end
		RT_Button:AddMenuItem( level, true, nil, nil, L["None"], nil, nil, boss == nil )

	elseif level == 3 then
		local zones = { }
		for k, v in pairs(def.Zones) do
			if value.value == v.rel then tinsert( zones, v ); end
		end
		table.sort(zones, function(a,b) return a.pid > b.pid; end)
		local man = nil
		for k, v in pairs(zones) do
			checked = nil
			if boss then
				bossList = zoneBosses[v.name]
				if bossList then
					for k1, v1 in pairs(bossList) do
						if boss == v1 then checked = 1; break; end
					end
				end
			end
			if man and man ~= v.man then UIDropDownMenu_AddButton( { disabled = 1 }, level ); end
			man = v.man
			RT_Button:AddMenuItem( level, false, nil, nil, L[v.name], nil,  v.name, checked, true )
		end
	elseif level == 4 then
		for k, v in pairs(zoneBosses[value.value]) do
			if type(v) ~= "table" then
				RT_Button:AddMenuItem( level, true, nil, nil, L[v], nil,  v, boss == v )
			else
				for k2, v2 in pairs(v) do
					RT_Button:AddMenuItem( level, true, nil, nil, L[k], L[v2],  v2, boss == v2 )
				end
			end
		end
	end
end


function RT_RaidItemTemplate_RightClickMenu_Initialize( frame, level )
	local rt = RaidTracker
	local db, o, L = rt._db, rt._options, rt.L
	local value = RT_Button:AddMenu( frame, level, "raidid" )
	local raid = value and db.Log[value.raidid]
	if not raid then return end

	if level == 1 then
		RT_Button:AddMenuItem( level, "RT_EditNoteFrame", "time", "raid", L["Edit Start"], rt:GetDisplayDate(raid.key))
		RT_Button:AddMenuItem( level, "RT_EditNoteFrame", "time", "raidend", L["Edit End"],	rt:GetDisplayDate(raid.End) or L["None"])
		RT_Button:AddMenuZone( level, "raid", nil, value, raid.zone )
		RT_Button:AddMenuItem( level, "RT_EditNoteFrame", "note", "raid", L["Edit Note"], raid.note )
		RT_Button:AddMenuItem( level, "RT_ExportFrame", "export", "raid", L["Show Export String"] )
	elseif level >= 2 then
		if value.type == "zone" then RT_Button:AddMenuZone( level, "raid", nil, value, raid.zone ) end
	end
end

function RT_ItemsLineTemplate_RightClickMenu_Initialize( frame, level )
	local rt = RaidTracker
	local db, def, o, L = rt._db, rt._store.defaults, rt._options, rt.L
	local value = RT_Button:AddMenu( frame, level, "raidid", "itemid" )
	local raid = value and db.Log[value.raidid]
	local item = raid and raid.Loot[value.itemid]
	if not item then return end
	local itemiid = RT_ItemOptions:GetItemIid(item and item.item.id or "")

	if level == 1 then
		RT_Button:AddMenuLooter( level, "item", nil, value, item.player, raid )
		RT_Button:AddMenuItem( level, "RT_EditCostFrame", "cost", "item", L["Edit Cost"], item.cost )
		RT_Button:AddMenuItem( level, "RT_EditNoteFrame", "count", "item", L["Edit Count"], ((item.item.count) and item.item.count or 1) )
		RT_Button:AddMenuItem( level, "RT_EditNoteFrame", "time", "item", L["Edit Time"], rt:GetDisplayDate(item.time) or L["None"] )
		RT_Button:AddMenuItem( level, "RT_ItemOptionsFrame", "itemopt", "item", L["Edit Item Options"], itemiid or L["None"], { itemid=item.item.id }, db.ItemOptions[itemiid] )
		RT_Button:AddMenuBoss( level, "item", L["Dropped from"]..":", value, item.boss )
	elseif level >= 2 then
		if value.type == "looter" then RT_Button:AddMenuLooter( level, "item", nil, value, item.player, raid )
		elseif value.type == "boss" then RT_Button:AddMenuBoss( level, "item", nil, value, item.boss ) end
	end
end


function RT_PlayersLineTemplate_RightClickMenu_Initialize( frame, level )
	local rt = RaidTracker
	local db, o, L = rt._db, rt._options, rt.L
	local value = RT_Button:AddMenu( frame, level, "raidid", "playerid" )
	local raid = value and db.Log[value.raidid]
	if not raid then return end

	if level == 1 then
		RT_Button:AddMenuItem( level, nil, "whisper", nil, L["Whisper"], value.playerid )
		RT_Button:AddMenuItem( level, nil, "invite", nil, L["Invite"], value.playerid )
	end
end

function RT_EventsLineTemplate_RightClickMenu_Initialize( frame, level )
	local rt = RaidTracker
	local db, o, L = rt._db, rt._options, rt.L
	local value = RT_Button:AddMenu( frame, level, "raidid", "eventid" )
	local raid = value and db.Log[value.raidid]
	local event = raid and raid.Events[value.eventid]
	if not event then return end
	--rt:Debug("level("..level..")", raidid, itemid)

	if level == 1 then
		RT_Button:AddMenuBoss( level, "event", nil, value, event.boss )
		RT_Button:AddMenuItem( level, "RT_EditNoteFrame", "time", "event",L["Edit Time"], rt:GetDisplayDate(event.time))
		RT_Button:AddMenuZone( level, "event", nil, value, event.zone )
		RT_Button:AddMenuItem( level, "RT_EditNoteFrame", "note", "event", L["Edit Note"], event.note )
	elseif level >= 2 then
		if value.type == "boss" then RT_Button:AddMenuBoss( level, "event", nil, value, event.boss )
		elseif value.type == "zone" then RT_Button:AddMenuZone( level, "event", nil, value, event.zone ) end
	end
end

-- Next Boss selection handling
function RT_EditBossFrame_Menu_Initialize( frame, level )
	if not level then return end
	local rt = RaidTracker
	local db, def, o, L = rt._db, rt._store.defaults, rt._options, rt.L
	local raidid = o.CurrentRaid
	local raid = db.Log[raidid]
	if not raid then return end
	--rt:Debug("level("..level..")", frame:GetName(), raidid);

	local i = 0
	local ii = 0

	i = RT_Boss_Add_Button( db.Bosses["DEFAULTBOSS"], i )
	ii = ii + 1

	-- no zone, just add bosses from bosses list
	if raid.zone == nil then
		for k,v in pairs(def.Bosses) do
			if v == 1 then
				ii = ii + 1
				for k2,v2 in pairs(def.Bosses) do			-- there are none marked with 1 so will never happen.. was supposed to be world boss?
					if v2 == v then
						i = RT_Boss_Add_Button(k2,i)
					end
				end
			end
		end
	else
		for k,v in pairs(RaidTracker_ZoneBosses[raid.zone] or { }) do
			local found
			for k2,v2 in pairs(raid.Events) do
				if v2.boss == v then found = true; break end
			end
			if not found then
				if type(v) == "string" then
					ii = ii + 1
					for k2,v2 in pairs(def.Bosses) do
						if v == v2 then
							i = RT_Boss_Add_Button(k2,i)
						end
					end
				elseif type(v) == "table" then
					for k2,v2 in pairs(v) do
						ii = ii + 1
						for k3,v3 in pairs(def.Bosses) do
							if v3 == v2 then
								i = RT_Boss_Add_Button(k.." - "..k3,i)
							end
						end
					end
				end
			end
		end
	end
	if ii == 2 then
		UIDropDownMenu_SetSelectedID(RT_EditBossFrameMenu, ii)
	end

end

function RT_Boss_Add_Button( k, i )
	local t = { text = k, func = RT_Boss_Update, }
	UIDropDownMenu_AddButton( t )
	if i == cur_class_id then
		UIDropDownMenu_SetSelectedID( RT_EditBossFrameMenu, i+1 )
		UIDropDownMenu_SetText( t.text, RT_EditBossFrameMenu )
	end
	return i
end

function RT_Boss_Update( frame )
	id = frame:GetID()
	UIDropDownMenu_SetSelectedID( RT_EditBossFrameMenu, id )
end

--******************

function RT_Button:OnClick( frame, button )
	local parent = frame._parent or frame:GetParent()
	local frameName

	if self._super.OnClick( self, frame, button ) then return true end

	if button == "LeftButton" then
		if frame.type == "hit" then
			RaidTracker:Select(parent, parent.type)
		elseif frame.type == "editio" then
			RT_Dialog:Show("RT_ItemOptionsFrame", "itemopt", "item", nil, parent.loot.item.id)
		elseif frame.type == "delete" then
			frameName = "RT_ConfirmDeleteFrame"
		elseif frame.type == "note" then
			frameName = "RT_EditNoteFrame"
		else
			RaidTracker:Select(parent, frame.type)
			if frame.type == "raid" then
				RaidTrackerFrame.LastPage = { }
				RaidTrackerFrameBackButton:Disable()
			end
		end
	end

	if frameName then
		RT_Dialog:Show(frameName, frame.type, parent.type, parent.raidid, parent.itemid, parent.playerid, nil, nil, parent.eventid )
	end
end

function RT_Button:OnEnter( frame )
	local parent = frame._parent or frame:GetParent()
	local title, text, f

	if frame.type == "delete" then
		title = "Click to delete"
	elseif frame.type == "note" then
		title = "Click to edit note"
		local raid = self._karma._db.Log[parent.raidid]
		if		parent.type == "item"	then item = raid.Loot[parent.itemid]
		elseif	parent.type == "player"	then item = raid.Players[parent.playerid]
		elseif	parent.type == "event"	then item = raid.Events[parent.eventid] end
		text = item and item.note or nil
	end

	self._super.OnEnter(self, frame, title, text, RaidTracker._options.ShowTooltips >= 1 )
end

function RT_Button:ShowItemTooptipCustom( frame, parent, item, sClass, sSubClass )
	local loot = frame.loot or parent.loot
	local _inst = self._karma
	local o,L = _inst._options,_inst.L
	local r,g,b = _inst:ColorToRGB(o.Color)
	local f = GameTooltip
	f:AddLine(" ")
	if loot then
		if loot.time then	f:AddLine(_inst:GetDisplayDate(loot.time), r, g, b) end
		if loot.zone then	f:AddLine(L[loot.zone], r, g, b) end
		if loot.boss then	f:AddLine(L[loot.boss], r, g, b) end
		if loot.cost then	f:AddLine(loot.cost, r, g, b) end
	end
	sClass = item.class or sClass; sSubClass = item.subclass or sSubClass
	if sClass then			f:AddLine(L[sClass], r, g, b) end
	if sSubClass and sClass ~= sSubClass then f:AddLine(L[sSubClass], r, g, b) end
end

