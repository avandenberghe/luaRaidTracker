-- Raid Item Maintainance Dialog


RT_ItemOptions = {
	sortName = function(a, b) return (a.name or "") < (b.name or "") end,
	sortId = function(a, b) return (a.id or 0) < (b.id or 0) end,
}

function RT_ItemOptions:GetItemIid( id )
	if id and type(id)=="string" then
		_,_,id = string.find(id,"(%d+)")
	end
	return id and tonumber(id)
end

function RT_ItemOptions:GetDispName( item, isTitle )
	if not item then return "" end
	local frame = RT_ItemOptionsFrame
	local rt = RaidTracker
	local db,o,L = rt._db,rt._options,rt.L

	local tag = rawget(frame.items, item.id) and "Unsaved" or (not rawget(db.ItemOptions, item.id) and "Default")

	if not item.name or not item.quality then
		local name, _, quality = GetItemInfo(item.id)
		if name and not item.name then item.name = name end
		if quality and not item.quality then item.quality = quality end
	end
	if not item.c then
		local color
		if item.quality then
			_, _, _, color = GetItemQualityColor(item.quality)
		end
		if color then item.c = strsub(color,3) end
	end
	local t
	if item.name then
		t = (item.c) and ("|cFF"..item.c..item.name.."|r") or item.name
		--rt:Debug("io table",item.c,item.name)
	else
		t = L["Unknown"] .. " (ID: "..item.id..")"
	end
	if tag and (isTitle or tag~="Default") then
		t = t .. " ("..L[tag]..")"
	end
	-- ("("..item.id..")  " ..

	return t, tag
end


function RT_ItemOptions:OnLoad( frame )
	local L = RaidTracker.L
	local desc = RT_Options.desc

	RT_ItemOptionsFrameHeaderTitle:SetText(L["Raid Tracker"].." - "..L["Item Options"])
	RT_ItemOptionsFrameHeaderText:SetText("")

	local info = {
		{ name="Log", title="Log", type="Slider", class="RT_SliderTemplate", opts = desc.itemopt, desc = "Log this item. Default uses the default options.", },
		{ name="Stack", title="Stack", type="Slider", class="RT_SliderTemplate", opts = desc.itemopt, desc = "Stack this item rather than log individualy.  Default uses the default options.", },
		{ name="CostGet", title="Get Cost", type="Slider", class="RT_SliderTemplate", opts = desc.itemopt, desc = "Get cost for this item from an external cost system, such as Hellbender DKP or ItemLevelDKP. Default uses the default options.", },
		{ name="CostAsk", title="Ask Cost", type="Slider", class="RT_SliderTemplate", opts = desc.itemopt, desc = "Ask for cost using a popup box as loot is received. Get Cost always happens before Ask Cost. Default uses the default options.", },
	}

	RT_Templates:InitWidgets( RT_ItemOptionsFrameEdit, RT_Button, info )
end


function RT_ItemOptions:OnShow( frame )
	if self.OnLoad then self:OnLoad(frame); self.OnLoad = nil end
	RT_ItemOptions:Update()
end


function RT_ItemOptions:Update( )
	local frame = RT_ItemOptionsFrame
	local rt = RaidTracker
	local db,o,L = rt._db,rt._options,rt.L
	frame.itemid = self:GetItemIid(frame.itemid)
	frame.items = frame.items or setmetatable( {}, { __index = db.ItemOptions} )

	-- get items, allow for called edit or add through interface
	if frame.itemid and not frame.items[frame.itemid] then
		frame.items[frame.itemid] = { id = frame.itemid, Log = 0, Stack = 1, CostGet = 0, CostAsk = 0, }
	end
	frame.list = RaidTracker:TableGetValues(frame.items, self.sortName )
	if frame.itemid then								-- requesting to edit or add a specific one
		for i,v in pairs(frame.list) do
			if v.id == frame.itemid then o.ItemOptionsSelected = i break end
		end
		frame.itemid = nil
	end
	RT_ItemOptions_ScrollBar_Update()

	local f = RT_ItemOptionsFrameEdit
	if not o.ItemOptionsSelected then
		f:Hide()
		return
	elseif o.ItemOptionsSelected > #frame.list then
		o.ItemOptionsSelected = #frame.list
	end
	local item = frame.list[o.ItemOptionsSelected]
	local title, tag = self:GetDispName(item, true)
	f:Hide()
	f.id = o.ItemOptionsSelected
	f.item = item
	RT_ItemOptionsFrameEditTitle:SetText( title )
	RT_ItemOptionsFrameEditLinkID:SetText( "Item ID: " .. item.id )
	RT_ItemOptionsFrameEdit_Log:SetValue( item.Log and (item.Log + 1) or 0 );
	RT_ItemOptionsFrameEdit_Stack:SetValue( item.Stack and (item.Stack + 1) or 0 );
	RT_ItemOptionsFrameEdit_CostGet:SetValue( item.CostGet and (item.CostGet + 1) or 0 );
	RT_ItemOptionsFrameEdit_CostAsk:SetValue( item.CostAsk and (item.CostAsk + 1) or 0 )
	if tag == "Default" then
		RT_ItemOptionsFrameEdit_DeleteButton:Disable()
	else
		RT_ItemOptionsFrameEdit_DeleteButton:Enable()
	end
	f:Show()
end


function RT_ItemOptions:Edit_Save( frame )
	local rt = RaidTracker;	local db = rt._db
	-- propagate default values or add new item to database
	local item = rt:TableSet(db.ItemOptions, frame.item.id, frame.item, true)
	frame:GetParent().items[item.id] = nil

	i = RT_ItemOptionsFrameEdit_Log:GetValue(); item.Log = (i ~= 0) and i-1 or nil
	i = RT_ItemOptionsFrameEdit_Stack:GetValue(); item.Stack = (i ~= 0) and i-1 or nil
	i = RT_ItemOptionsFrameEdit_CostGet:GetValue(); item.CostGet = (i ~= 0) and i-1 or nil
	i = RT_ItemOptionsFrameEdit_CostAsk:GetValue(); item.CostAsk = (i ~= 0) and i-1 or nil;

	RT_ItemOptions:Update()
end


function RT_ItemOptions:Delete( frame )
	local rt = RaidTracker;	local db = rt._db
	local itemId = frame.item.id
	db.ItemOptions[itemId] = nil;
	frame:GetParent().items[itemId] = nil;
	RT_ItemOptions:Update()
end


function RT_ItemOptions_ScrollBar_Update( )
	local frame = RT_ItemOptionsFrameListScroll
	local rt = RaidTracker;	local db,o = rt._db,rt._options

	local data = RT_ItemOptionsFrame.list
	local maxlines = #data
	FauxScrollFrame_Update(frame, maxlines, 21, 16)
	for i = 1, 21 do
		local id = i + FauxScrollFrame_GetOffset(frame)
		local sline = "RT_ItemOptionsFrameListScrollLine"..i
		local line = _G[sline];
		if id > maxlines then
			line:Hide()
		else
			local item = data[id]
			local title, tag = RT_ItemOptions:GetDispName(item)
		line.id = id
		line.item = item
		line.selected = (o.ItemOptionsSelected == id) and 1 or nil
			line:SetText(title)
			if tag == "Unsaved" then
				line:GetFontString():SetTextColor(0.85,0.75,0.10,1)
				line:SetNormalFontObject("GameFontNormal")
			elseif tag == "Default" then
				line:GetFontString():SetTextColor(0.85,0.75,0.10,0.70)
				line:SetNormalFontObject("GameFontNormalSmall")
			else
				line:GetFontString():SetTextColor(0.85,0.75,0.10,1)
				line:SetNormalFontObject("GameFontNormal")
			end
			if line.selected then
				_G[sline.."MouseOver"]:Show()
				line:SetNormalFontObject("GameFontNormal")
			else
				_G[sline.."MouseOver"]:Hide()
			end
			line:Show()
		end
	end
	frame:Show()
end


