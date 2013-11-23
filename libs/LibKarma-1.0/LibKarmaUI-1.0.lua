if KarmaStub:isLib("LibKarmaUI", 1.1, "$Revision: 102 $") then return end

--	Simple integrated automated lightweight support for UI contructs
--
--	This emulates basic default UI functionality buried deep in the blizz
--  ui code, most of which is standard practice for the default ui.


LibKarmaUI = LibKarmaUI or {

}

-- binds a new ui instance to this lib UI base, and reference addon instance
--	allows derived ui code to belong to more than one app
function LibKarmaUI:GetInstance( _appinst, inst )
	inst = inst or { }								-- make ui inst if none
	inst._super = self;								-- set ref to ui global as super
	inst._karma = _appinst or LibKarmaUtil			-- add ref to app inst or at least util if there is none
	return setmetatable( inst, { __index = self } )	-- hook global as super class
end

function LibKarmaUI:GetL( inst )
	local _inst = inst or self._karma;
	return _inst and (_inst.L or _inst._L) or {}
end

function LibKarmaUI:Menu_Toggle( frame )
	local t = frame.rcmenu or _G[frame:GetName().."RightClickMenu"]
	if not t then return end
	t.point = "TOPLEFT"
	t.relativePoint = "BOTTOMLEFT"
	ToggleDropDownMenu(1, nil, t, "cursor", 0, 0)
	return true
end

function LibKarmaUI:OnUpdate( frame )
	if frame.hasItem and GameTooltip:IsOwned(frame) then
		self:OnEnter(frame)
	end
end

function LibKarmaUI:OnClick( frame, button )
	local parent = frame._parent or frame:GetParent()

	if frame.hasItem and self:ShowItemTooptip(frame, parent, button) then
		return true
	end

	if button == "LeftButton" then
	elseif button == "RightButton" then
		if self:Menu_Toggle(parent) then return true end
	end
end

function LibKarmaUI:OnEnter( frame, title, text, useTT )
	local parent = frame._parent or frame:GetParent()
	local parentName = parent:GetName()
	title = title or frame.title; text = text or frame.text

	local f
	f = frame.type and _G[parentName.."MouseOver_"..frame.type] or nil; if f then f:Show() end
	f = _G[parentName.."MouseOver"]; if f then f:Show() end

	if frame.hasItem then
		self:ShowItemTooptip(frame, parent)
		CursorUpdate(frame)
	elseif (frame.hasTooltip and title and useTT) or text then
		f = GameTooltip
		f:SetOwner(frame, (type(frame.hasTooltip)=="string") and frame.hasTooltip or "ANCHOR_RIGHT")
		f:ClearLines()
		f:AddLine(title)
		if text then f:AddLine(text, 0.9, 0.9, 0.9, 1) end
		f:Show()
	end
end

function LibKarmaUI:OnLeave( frame )
	local parent = frame._parent or frame:GetParent()
	local parentName = parent:GetName()

	local f = frame.type and _G[parentName.."MouseOver_"..frame.type]; if f then f:Hide() end
	if not parent.selected then
		f = _G[parentName.."MouseOver"]; if f then f:Hide() end
	end

	if frame.hasItem then
		ResetCursor()
	end
	if GameTooltip:IsOwned(frame) then
		GameTooltip:Hide()
	end
end

function LibKarmaUI:OnShow( frame )
	local parent = frame._parent or frame:GetParent()

	if parent.selected then
		local f = _G[parent:GetName() .. "MouseOver"]; if f then f:Show() end
	end
end

function LibKarmaUI:ShowItemTooptip( frame, parent, button )
	if not frame or not parent then return end
	local item = frame.item or parent.item
	if not item then return end

	local sName,sLink,_,_,_,sClass,sSubClass = GetItemInfo("item:" .. item.id)
	if button == "LeftButton" then
		if IsModifiedClick("DRESSUP") and item.id then
			if sName then DressUpItemLink(sLink) end
			return true
		end
		if IsModifiedClick("CHATLINK") and item.id then
			if sName then ChatEdit_InsertLink(sLink) end
			return true
		end
		return false
	end

	local f = GameTooltip
	f:SetOwner(frame, "ANCHOR_BOTTOMRIGHT")
	if sName or button == "RightButton" then
		f:SetHyperlink("item:" .. item.id)
	else
		f:AddLine(item.name, self._karma:ColorToRGB(item.c))
		f:AddLine("This item is not in your cache, right-click to try to retrieve the item.", 1, 1, 1, 1)
		f:AddLine("Warning: This may result in a disconnect!", 1, 0, 0)
	end
	if self.ShowItemTooptipCustom then self:ShowItemTooptipCustom( frame, parent, item, sClass, sSubClass ) end
	f:Show()
	return button == "RightButton"
end


-- native versions of UI elements

function LibKarmaUI:GenerateMiniMenu( parent, options, handler )
	parent = parent or UIParent

	if not LibKarmaUI._minimenu then
		local L = self:GetL(handler)
		LibKarmaUI._minimenu = {	-- global
			frame = CreateFrame("Frame", "LibKarmaMiniMenu", parent, "UIDropDownMenuTemplate"),
			mClose = { order = -1000, notCheckable = true, text = L and L["Cancel"] or "Cancel" },
			OnSort = function(a,b) a,b=a.order,b.order; return (a<0 and 10000-a or a) < (b<0 and 10000-b or b) end,
		}
	end
	local _menu = LibKarmaUI._minimenu

	local m = { };										-- per-instance, can change without notification
	for k,v in pairs(options.args) do
		tinsert(m, { order = v.order or 0, text = v.name, tooltipTitle = v.name, tooltipText = v.desc, tooltipWhileDisabled = true,-- tooltipOnButton = true,
			func = v.set or v.func, value = v.value, arg1 = v.pass or v.passValue, arg2 = v.pass2 or v.passValue2, checked = v.get,
			notCheckable = v.type~="toggle", keepShownOnClick = v.type=="toggle", isNotRadio = true, isTitle = v.isTitle or nil, } )
	end
	tinsert(m, _menu.mClose)
	if options.sort ~= 0 then table.sort(m, _menu.OnSort) end

	local f = _menu.frame
	if f:GetParent() ~= parent then f:SetParent(parent) end
	UIDropDownMenu_Initialize(f, self.GenerateMenuInit, "MENU", nil, m);
	ToggleDropDownMenu(1, nil, f, "cursor", 0, 0, m, nil, true);

	return m
end
function LibKarmaUI.GenerateMenuInit( frame, level, m )
	for i = 1, #m do
		local v = m[i]; v.index = i
		if v.text then UIDropDownMenu_AddButton( v, level ); end
	end
end

function LibKarmaUI:GenerateMinimapMenu( frame, handler, options )
	return self:GenerateMiniMenu( frame, options, handler )
end

function LibKarmaUI:GenerateMinimapButton( frame, handler, options )

	LibKarmaUI._minimap = LibKarmaUI._minimap or {			-- global
		OnMouseDown	= function(self) self.icon:SetTexCoord(0, 1, 0, 1) end,
		OnMouseUp	= function(self) self.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925) end,
		OnDragStart	= function(self) self._ismoving = true end,
		OnDragStop	= function(self) self.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925); self._ismoving = false end,
		OnClick		= function(self, button) local h=self._handler return h.OnClick and h.OnClick(self,button) end,
		OnEnter		= function(self, button) local g,h=GameTooltip,self._handler
			g:SetOwner(self,"ANCHOR_RIGHT"); g:ClearLines(); if h.OnTooltipShow then h.OnTooltipShow(g) end; g:Show() end,
		OnLeave		= function(self, button) GameTooltip:Hide() end,
		OnUpdate	= function(self) if self._ismoving then
				local cx, cy = GetCursorPosition()
				local x, y = Minimap:GetCenter()
				local es = Minimap:GetEffectiveScale()
				self:Reposition( math.deg(math.atan2(y*es-cy, x*es-cx))+180 )
			 end end,
		OnShow		= function(self) self._options.show = 1 end,
		OnHide		= function(self) self._options.show = 0 end,
		Reposition	= function(self, a)
				local o = self._options
				if o.show ~= true and o.show ~= 1 then self:Hide(); return end
				a = a or o.position; o.position = a
				self:Show()
				self:ClearAllPoints()
				self:SetPoint("CENTER", Minimap, "CENTER", (Minimap:GetWidth()/2+10)*cos(a), (Minimap:GetHeight()/2+10)*sin(a))
			end,
	}

	local m,_m = CreateFrame("Button", handler.nameMMI, Minimap),self._minimap
	m._ismoving = false
	m._handler = handler
	m._options = options
	m:SetToplevel(true); m:SetMovable(true);
	m:SetFrameStrata("MEDIUM"); m:SetFrameLevel(8)--m:SetFrameStrata("LOW")
	m:SetWidth(20);	m:SetHeight(20)
	m:SetPoint("RIGHT", Minimap, "LEFT", 0,0)
	local mi = m:CreateTexture("", "ARTWORK"); m.icon = mi
	mi:SetTexture(handler.icon)
	mi:SetTexCoord(0.075, 0.925, 0.075, 0.925)
	mi:SetWidth(20); mi:SetHeight(20)
	mi:SetPoint("TOPLEFT", m, "TOPLEFT", 0, 0)
	local mm = m:CreateTexture("", "OVERLAY"); m.mask = mm;
	mm:SetTexture("Interface\\Minimap\\Minimap-TrackingBorder")
	mm:SetTexCoord(0.0, 0.6, 0.0, 0.6)
	mm:SetWidth(36); mm:SetHeight(36)
	mm:SetPoint("TOPLEFT", m, "TOPLEFT", -8, 8)
	m:RegisterForClicks("LeftButtonUp","RightButtonUp")
	m:RegisterForDrag("LeftButton")
	m:SetScript("OnMouseUp", _m.OnMouseUp )
	m:SetScript("OnDragStart", _m.OnDragStart )
	m:SetScript("OnDragStop", _m.OnDragStop )
	m:SetScript("OnClick", _m.OnClick )
	m:SetScript("OnEnter", _m.OnEnter )
	m:SetScript("OnLeave", _m.OnLeave )
	m:SetScript("OnUpdate", _m.OnUpdate )
	m:SetScript("OnShow", _m.OnShow )
	m:SetScript("OnHide", _m.OnHide )
	m.Reposition = _m.Reposition

	return m
end
