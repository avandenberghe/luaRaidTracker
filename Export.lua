-- Author      : Celess
-- Create Date : 11/8/2008 8:59:19 AM

RT_Export = {

}

function RT_Export:ExportSession( r, eFormat )
	if type(r) ~= "table" then return end

	self._format = eFormat
	self._NL = self._NL or "\n"			--(IsWindowsClient() and "\n\r" or "\n")
	self._L = RaidTracker.L
	local f = eFormat
	self._displayDate = (f == 0 or f == 4 or f == 5 or f == 11 or f >= 7) and f ~= 10
	local t = {}; self._Line = function(s) table.insert(t,s) end

		if eFormat == 12 then	self:GenerateSMFbbc(r)
	elseif eFormat == 11 then	self:GenerateText(r)
	elseif eFormat == 10 or
		   eFormat == 9 then	self:GenerateDkpXML(r)
	elseif eFormat == 8 then	self:GenerateGLbbc(r)
	elseif eFormat == 7 then	self:GenerateSMFbbc(r)
	elseif eFormat == 6 then	self:GenerateEQPlus(r)
	elseif eFormat == 5 then	self:GenerateCSV(r)
	elseif eFormat == 4 then	self:GenerateText(r)
	elseif eFormat == 3 then	self:GenerateEQdkpStrictXML(r)
	elseif eFormat == 2 then	self:GenerateMLdkpXML(r)
	elseif eFormat == 1 or
		   eFormat == 0 then	self:GenerateDkpXML(r)
	end

	return table.concat(t) --, self._NL)	--	self:addLine("") --so last line will get a "new line" terminator as well
end

function RT_Export:GetDifficultyL( sType, nDiff )								--self:Debug("GetDifficultyL")
	return (_G[((sType == "party") and "DUNGEON_DIFFICULTY" or "RAID_DIFFICULTY")..nDiff]) or self._L["Unknown"]
end

-- helper functions
function RT_Export:GetTS( v, t, k )
	t = t or type(v)
	if not v then				v = ""
	elseif t == "number" then	v = self._displayDate and RaidTracker:GetDisplayDate(v) or v;
	elseif t == "itemid" then	v = select(3,v:find("(%d+):%d+"))
	elseif t == "idiff" then	v = (v.idiff and v.itype) and ((_G[((v.itype=="party") and "DUNGEON_DIFFICULTY" or "RAID_DIFFICULTY")..v.idiff]) or v.itype) or ""
	elseif t == "xmlpair" then	v = "<"..k..">"..self:GetTS(v) .. "</" .. k .. ">"
	elseif t == "quote" then	v = "\"" .. v .. "\""
	end
	return v
end

function RT_Export:GetInstXML( t )
	local s = ""
	s = s .. "<instance>"
	if t.zone then		s = s .. "<name>" .. t.zone .. "</name>" end
	if t.iid then		s = s .. "<id>" .. t.iid .. "</id>" end
	if t.itype then		s = s .. "<type>" .. t.itype .. "</type>" end
	if t.ireset then	s = s .. "<reset>" .. t.ireset .. "</reset>" end
	if t.idiff then		s = s .. "<difficulty>" .. t.idiff .. "</difficulty>" end
	s = s .. "</instance>"
	return s
end


function RT_Export:GenerateDkpXML( r )
	local eF,s = self._format,self._Line

	s("<RaidInfo>")
	if eF == 0 then
--		s("<Version>1.4</Version>")
	elseif eF == 9 or eF == 10 then
		s("<version>GL-1.0</version><mod_version>"..(eF ~= 10 and "v2.5.10" or "v2.9.2").."</mod_version>")
		s("<realm>"..self:GetTS(r.realm).."</realm><timezone>0</timezone>")
	end

	if eF == 0 then
		s("<key>"..self:GetTS(r.key).."</key>")
	end
	s("<start>"..self:GetTS(r.key).."</start>")
	if r.End then
		s("<end>"..self:GetTS(r.End).."</end>")
	end
	if r.zone then
		s("<zone>"..r.zone.."</zone>")
	end

	if eF ~= 10 and r.iid then
		s("<instanceid>"..r.iid.."</instanceid>")
	end
	if eF ~= 10 then s(self:GetInstXML( r )) end

	if r.Players then
		s("<PlayerInfos>")
		local idx = 1
		for k, v in pairs(r.Players) do
			s("<key"..idx..">")
			s("<name>"..k.."</name>")
			for k2, v2 in pairs(r.Players[k]) do
				if k2 == "note" then
					s("<"..k2.."><![CDATA["..v2.."]]></"..k2..">")
				else
					s("<"..k2..">"..v2.."</"..k2..">")
				end
			end
			s("</key"..idx..">")
			idx = idx + 1
		end
		s("</PlayerInfos>")
	end
	if r.Events then
		local i = 1
		s("<BossKills>")
		for k, v in pairs(r.Events) do
			s("<key"..i..">")
			s("<name>"..v.boss.."</name>")
			if eF == 10 then
				s("<event_source>Raid Tracker</event_source>")
				if v.note then s("<event_note><![CDATA["..v.note.."]]></event_note>"); end
			end
			s("<time>"..self:GetTS(v.time).."</time>")
			if eF ~= 10 then s(self:GetInstXML( v )) end
			if eF == 0 or ef == 10 then
				if v.attendees then
					s("<attendees>")
					for k2, v2 in pairs(v.attendees) do
						s("<key"..k2..">")
						s("<name>"..v2.."</name>")
						s("</key"..k2..">")
					end
					s("</attendees>")
				end
			end
			s("</key"..i..">")
			i = i + 1
		end
		s("</BossKills>")
	end
	-- new exports
	if r.Wipes then
		s("<Wipes>")
		for k, v in pairs(r.Wipes) do
			s("<Wipe>"..v.."</Wipe>")
		end
		s("</Wipes>")
	end
	if r.bossnext then
		s("<NextBoss>"..r.bossnext.."</NextBoss>")
	end
	--
	if eF == 0 then
		local sNote = "<note><![CDATA["
		if r.note then sNote = sNote..r.note; end
		if r.zone then sNote = sNote.." - Zone: "..r.zone; end
		sNote = sNote.."]]></note>"
		s(sNote)
	else
		if r.note then s("<note><![CDATA["..r.note.."]]></note>"); end
	end
	s("<Join>")
	for k, v in pairs(r.Join) do
		s("<key"..k..">")
		s("<player>"..v.player.."</player>")
		if eF == 0 and r.Players and r.Players[v.player] then
			local v = r.Players[v.player]
			if v.race then s("<race>"..v.race.."</race>") end
			if v.class then s("<class>"..v.class.."</class>") end
			if v.sex then s("<sex>"..v.sex.."</sex>") end
			if v.level then s("<level>"..v.level.."</level>") end
			if v.note then s("<note><![CDATA["..v.note.."]]></note>") end
		end
		s("<time>"..self:GetTS(v.time).."</time>")
		s("</key"..k..">")
	end
	s("</Join>")
	s("<Leave>")
	for k, v in pairs(r.Leave) do
		s("<key"..k..">")
		s("<player>"..v.player.."</player>")
		s("<time>"..self:GetTS(v.time).."</time>")
		s("</key"..k..">")
	end
	s("</Leave>")
	s("<Loot>")
	for k, v in pairs(r.Loot) do
		s("<key"..k..">")
		s("<ItemName>"..v.item.name.."</ItemName>")
		if eF == 10 then s("<event_source>Raid Tracker</event_source>") end
		s("<ItemID>"..v.item.id.."</ItemID>")
		if v.item.icon then s("<Icon>"..v.item.icon.."</Icon>") end
		if v.item.class then s("<Class>"..v.item.class.."</Class>") end
		if v.item.subclass then s("<SubClass>"..v.item.subclass.."</SubClass>") end
		s("<Color>"..v.item.c.."</Color>")
		s("<Count>"..(v.item.count or 1).."</Count>")
		s("<Player>"..v.player.."</Player>")
		if v.cost then
			s("<Costs>"..v.cost.."</Costs>")
		end
		s("<Time>"..self:GetTS(v.time).."</Time>")
		if v.zone then s("<Zone>"..v.zone.."</Zone>") end
		if v.boss then s("<Boss>"..v.boss.."</Boss>") end
		if eF == 0 then
			local sNote = "<Note><![CDATA["
			if v.note then sNote = sNote..v.note; end
			if v.zone then sNote = sNote.." - Zone: "..v.zone; end
			if v.boss then sNote = sNote.." - Boss: "..v.boss; end
			if v.cost then sNote = sNote.." - "..v.cost.." DKP"; end
			sNote = sNote.."]]></Note>"
			s(sNote)
		else
			if v.note then s("<Note><![CDATA["..v.note.."]]></Note>") end
		end
		s("</key"..k..">")
	end
	s("</Loot>")
	s("</RaidInfo>")
end

function RT_Export:GenerateMLdkpXML( r )
	local rt,eFormat,s = RaidTracker,self._format, self._Line
	local o = rt._options

	local race, class, level, sex

	s('<?xml version="1.0"?>')
	s('<!DOCTYPE ML_Raidtracker PUBLIC "-//MLdkp//DTD ML_Raidtracker V 1.5//EN" "http://www.mldkp.net/dtds/1.0/ML_Raidtracker.dtd">')

	s("<raidinfo>")
	s("<version>1.5</version>")

	s("<start>"..self:GetTS(r.key).."</start>")
	s("<end>"..self:GetTS(r.End).."</end>")

	if r.realm then
		s("<realm>"..r.realm.."</realm>")
	end

	if r.zone then
		s("<zone>"..r.zone.."</zone>")
	end
	if r.iid then
		s("<instanceid>"..r.iid.."</instanceid>")
	end
	s(self:GetInstXML(r))
	if r.idiff then	s("<difficulty>" .. r.idiff .. "</difficulty>") end
	s("<exporter>"..(UnitName("Player")).."</exporter>")

	if r.Players then
		s("<playerinfos>")
		for k, v in pairs(r.Players) do
			s("<player>")
			s("<name>"..k.."</name>")
			for k2, v2 in pairs(r.Players[k]) do
				if k2 == "note" then
					s("<"..k2.."><![CDATA["..v2.."]]></"..k2..">")
				elseif k2 == "class" then
					s("<"..k2..">"..rt._lookup.ClassToId[v2].."</"..k2..">")
				elseif k2 == "race" then
					s("<"..k2..">"..rt._lookup.RaceToId[v2].."</"..k2..">")
				elseif k2 == "level" then
					if o.LevelMax < v2 then
						s("<"..k2..">"..v2.."</"..k2..">")
					end
				else
					s("<"..k2..">"..v2.."</"..k2..">")
				end
			end
			s("</player>")
		end
		s("</playerinfos>")
	end
	if r.Events then
		local bosskillsindex = 1
		s("<bosskills>")
		for k, v in pairs(r.Events) do
			s("<bosskill>")
			s("<name>"..v.boss.."</name>")
			s("<time>"..self:GetTS(v.time).."</time>")
			s(self:GetInstXML( v ))
			if r.idiff then s("<difficulty>" .. r.idiff .. "</difficulty>") end
			s("</bosskill>")
		end
		s("</bosskills>")
	end
	if r.Wipes then
		s("<wipes>")
		for k, v in pairs(r.Wipes) do
			s("<wipe><time>"..v.."</time></wipe>")
		end
		s("</wipes>")
	end
	if r.bossnext then
		s("<nextboss>"..r.bossnext.."</nextboss>")
	end

	if r.note then
		s("<note><![CDATA["..r.note.."]]></note>")
	end

	s("<joins>")
	for k, v in pairs(r.Join) do
		s("<join>")
		s("<player>"..v.player.."</player>")
		s("<time>"..self:GetTS(v.time).."</time>")
		s("</join>")
	end
	s("</joins>")
	s("<leaves>")
	for k, v in pairs(r.Leave) do
		s("<leave>")
		s("<player>"..v.player.."</player>")
		s("<time>"..self:GetTS(v.time).."</time>")
		s("</leave>")
	end
	s("</leaves>")
	s("<loots>")

	for k, v in pairs(r.Loot) do
		s("<loot>")
		s("<itemname>"..v.item.name.."</itemname>")
		s("<itemid>"..v.item.id.."</itemid>")
		s("<count>"..(v.item.count or 1).."</count>")
		s("<player>"..v.player.."</player>")
		if v.cost then
			s("<costs>"..v.cost.."</costs>")
		end
		s("<time>"..self:GetTS(v.time).."</time>")
		if v.zone then
			s("<zone>"..v.zone.."</zone>")
		end
		if v.boss then
			s("<boss>"..v.boss.."</boss>")
		end
		if v.note then
			s("<note><![CDATA["..v.note.."]]></note>")
		end
		s("</loot>")
	end
	s("</loots>")
	s("</raidinfo>")

end

function RT_Export:GenerateEQdkpStrictXML( r )
	local o = RaidTracker._options
	local eFormat,s,c = self._format,self._Line

	s("<RaidInfo>")

	s("<key>"..self:GetTS(r.key).."</key>")
	s("<start>"..self:GetTS(r.key).."</start>")
	if r.End then s("<end>"..self:GetTS(r.End).."</end>") end
	s("<zone>"..(r.zone or "").."</zone>")

	s("<PlayerInfos>")
	local i = 1
	for k, v in pairs(r.Players) do
		s("<key"..i..">")
		s("<name>"..k.."</name>")
		for k1, v1 in pairs(v) do
			if k1 == "note" then v1 = "<![CDATA["..v1.."]]>" end
			s("<"..k1..">"..v1.."</"..k1..">")
		end
		s("</key"..i..">")
		i = i + 1
	end
	s("</PlayerInfos>")

	s("<BossKills>")
	for i, v in pairs(r.Events) do
		s("<key"..i..">")
		s("<name>"..v.boss.."</name>")
		s("<time>"..self:GetTS(v.time).."</time>")
		s("<attendees>")
		if v.attendees then
			for i1, v1 in pairs(v.attendees) do
				s("<key"..i1..">" .. "<name>"..v1.."</name>" .. "</key"..i1..">")
			end
		end
		s("</attendees>")
		s("</key"..i..">")
	end
	s("</BossKills>")

	s("<note>")
	if r.note or r.zone then
		s("<![CDATA[")
		if r.note then s(r.note) end
		if r.zone then s(" - Zone: "..r.zone) end
		s("]]>")
	end
	s("</note>")

	s("<Join>")
	for i,v in pairs(r.Join) do
		s("<key"..i..">")
		s("<player>"..v.player.."</player>")
		if r.Players and r.Players[v.player] then
			local v = r.Players[v.player]
			if v.race then s("<race>"..v.race.."</race>") end
			if v.class then s("<class>"..v.class.."</class>") end
			if v.sex then s("<sex>"..v.sex.."</sex>") end
			s("<level>".. ((v.level and v.level>0) and v.level or o.LevelMax) .."</level>")
			if v.note then s("<note><![CDATA["..v.note.."]]></note>") end
		end
		s("<time>"..self:GetTS(v.time).."</time>")
		s("</key"..i..">")
	end
	s("</Join>")

	s("<Leave>")
	for i, v in pairs(r.Leave) do
		s("<key"..i..">")
		s("<player>"..v.player.."</player>")
		s("<time>"..self:GetTS(v.time).."</time>")
		s("</key"..i..">")
	end
	s("</Leave>")

	s("<Loot>")
	for k, v in pairs(r.Loot) do
		c = v.item
		s("<key"..k..">")
		s("<ItemName>"..c.name.."</ItemName>")
		s("<ItemID>"..c.id.."</ItemID>")
		if c.icon then s("<Icon>"..c.icon.."</Icon>") end
		if c.class then s("<Class>"..c.class.."</Class>") end
		if c.subclass then s("<SubClass>"..c.subclass.."</SubClass>") end
		if c.c then s("<Color>"..c.c.."</Color>") end
		s("<Count>"..(c.count or 1).."</Count>")
		s("<Player>"..v.player.."</Player>")
		if v.cost then	s("<Costs>"..v.cost.."</Costs>") end
		s("<Time>"..self:GetTS(v.time).."</Time>")
		if v.zone then s("<Zone>"..v.zone.."</Zone>") end
		if v.boss then s("<Boss>"..v.boss.."</Boss>") end
		s("<Note><![CDATA[")
		if v.note then s(v.note) end
		if v.zone then s(" - Zone: "..v.zone) end
		if v.boss then s(" - Boss: "..v.boss) end
		if v.cost then s(" - "..v.cost.." DKP") end
		s("]]></Note>")
		s("</key"..k..">")
	end
	s("</Loot>")

	s("</RaidInfo>")
end


function RT_Export:GenerateText( r )
	local L,NL,eF = self._L,self._NL,self._format
	local s = self._Line

	function ts( v, t )
		t = t or type(v); if t == "string" then v = v or L["Unknown"] end
		return self:GetTS( v, t )
	end

	s(ts(L[r.zone]) .. (r.idiff and " " or "") .. ts(r,"idiff") .. " " .. ts(r.key) .. " - " .. ts(r.End)) -- .. " " .. string.upper(GetCVar("portal")) .. "-" .. GetRealmName())
	s(ts(r.note,"quote") .. NL .. NL)

	s(L["Players"] .. ":" .. NL)
	local t = { }; for k,v in pairs(r.Players) do tinsert(t,{k,v}) end; table.sort(t, function(a,b) return a[1] < b[1] end)
	for i,v in pairs(t) do
		local join,leave,v1 = nil,nil,v[2]
		for i1,v1 in pairs(r.Join) do if v[1] == v1.player then join = v1.time; break end end
		for i1,v1 in pairs(r.Leave) do if v[1] == v1.player then leave = v1.time end end
		s(i .. " " .. (v[1] or "Unknown") .. " ".. (join and self:GetTS(join) or "") .. " - " .. (leave and self:GetTS(leave) or ""))
		for k1,v1 in pairs(v[2]) do
			if k1 ~= "sex" then
				s(", " .. ((k1 == "note" and v1) and ("\""..v1.."\"") or L[v1..""]))
			end
		end
		s(NL)
	end
	s(NL)

	s(L["Events"] .. ":" .. NL)
	for i,v in pairs(r.Events) do
		s(i .. " " .. L[v.boss or "Unknown"] .. " in " .. L[v.zone or r.zone or "Unknown"])
		s(((v.idiff or r.idiff) and (" " .. ts(((v.idiff) and v or r),"idiff")) or "") .. " at " .. self:GetTS(v.time))
		if v.attendees then
			for i1,v1 in pairs(v.attendees) do
				s((((i1 % 10) == 0 or i1 == 1) and (NL.."    ") or ", ") .. v1)
			end
		end
		s(NL)
	end
	s(NL)

	s(L["Loot"] .. ":" .. NL)
	for i,v in pairs(r.Loot) do
		s(i .. " " .. (v.item.name or "Unknown") .. " (" .. (v.item.id and select(3,v.item.id:find("(%d+):%d+")) or "Unknown") .. ")")
		s(" at " .. self:GetTS(v.time) .. " from " .. L[v.boss or "Unknown"] .. " to " .. (v.player or "Unknown") ..
			(eF ~= 11 and (" (Cost: " .. (v.cost or 0) .. ") ") or "") )
		if v.note then s((NL.."    ") .. (v.note and ("\"" .. v.note .. "\"") or "")) end
		s(NL)
	end
	s(NL)

end

function RT_Export:GenerateCSV( r )
	local L,NL,eFormat = self._L,self._NL,self._format
	local s = self._Line

	function ts( v, t )
		t = t or type(v); if t == "string" then t = "quote" end
		return self:GetTS( v, t )
	end

	s(L["Session"] .. ":" .. NL)
	s("Zone,Difficulty,Start,End,Note,Portal,Realm" .. NL)
	s(ts(r.zone) .. "," .. ts(r,"idiff") .. "," .. ts(r.key) .. "," .. ts(r.End) .. "," .. ts(r.note) .. "," .. GetCVar("portal") .. "," .. GetRealmName() .. NL)
	s(NL)

	s(L["Players"] .. ":" .. NL)
	s("Index,Name,Join,Leave,Race,Class,Level,Guild,Note" .. NL)
	local t = { }; for k,v in pairs(r.Players) do tinsert(t,{k,v}) end; table.sort(t, function(a,b) return a[1] < b[1] end)
	for i,v in pairs(t) do
		local join,leave,v1 = nil,nil,v[2]
		for i1,v1 in pairs(r.Join) do if v[1] == v1.player then join = v1.time; break end end
		for i1,v1 in pairs(r.Leave) do if v[1] == v1.player then leave = v1.time end end
		s(i .. "," .. ts(v[1]) .. ",".. ts(join) .. "," .. ts(leave) .. "," .. ts(v1.race) .. ",")
		s(ts(v1.class) .. "," .. ts(v1.level,"L") .. "," .. ts(v1.guild) .. "," .. ts(v1.note))
		s(NL)
	end
	s(NL)

	s(L["Events"] .. ":" .. NL)
	s("Index,Name,Zone,Difficulty,End,Attendees" .. NL)
	for i,v in pairs(r.Events) do
		s(i .. "," .. ts(v.boss) .. "," .. ts(v.zone or r.zone) .. "," .. ts(((v.idiff) and v or r),"idiff") .. "," .. ts(v.time) .. ",")
		if v.attendees then
			local a = ""; for i1,v1 in pairs(v.attendees) do a = a .. (i1 ~= 1 and ";" or "") .. v1 end; s(ts(a))
		end
		s(NL)
	end
	s(NL)

	s(L["Loot"] .. ":" .. NL)
	s("Index,Name,ID,Time,Mob,Player,Cost,Note" .. NL)
	for i,v in pairs(r.Loot) do
		s(i .. "," .. ts(v.item.name) .. "," .. ts(v.item.id,"itemid") .. "," .. ts(v.time) .. "," )
		s(ts(v.boss) .. "," .. ts(v.player) .. "," .. ts(v.cost or 0,"L") .. "," .. ts(v.note))
		s(NL)
	end
	s(NL)

end

function RT_Export:ProcessEqDKPTimes( r ) -- author paschy
	local t = { }

	for k,v in pairs( r.Join ) do
		if not t[v.player] then	t[v.player] = { } end
		table.insert( t[v.player], { self:GetTS(v.time), "join" } )
	end
	for k,v in pairs( r.Leave ) do
		if not t[v.player] then	t[v.player] = { } end
		table.insert( t[v["player"]], { self:GetTS(v.time), "leave" } )
	end
	for k,v in pairs( t ) do
		table.sort( t[k], function (a,b) return (a[1] < b[1]) end )
	end

	local oldval, oldkey = 0, 0
	for k,v in pairs( t ) do
		local toDelete = { }
		for k1,v1 in pairs( t[k] ) do
			if v1[1] == oldval then
				table.insert( toDelete, k1 )
				table.insert( toDelete, oldkey )
			end
			oldval = v1[1]
			oldkey = k1
		end
		for k1,v1 in pairs( toDelete ) do table.remove( t[k], v1 ) end
	end

	return t
end

function RT_Export:GenerateEQPlus( r )
	local rt,L,NL,eFormat = RaidTracker,self._L,self._NL,self._format
	local s = self._Line

	s("<raidlog>")
	s("<head>");
	s("<export><name>EQdkp Plus XML</name><version>1.0</version></export>")
	s("<tracker><name>Raid Tracker</name><version>2.2.27</version></tracker>")
	s("<gameinfo><game>World of Warcraft</game><language>"..GetLocale().."</language><charactername>"..(UnitName("Player")).."</charactername></gameinfo>")
	s("</head>")

	s("<raiddata>")
	s("<zones><zone>")
	s("<enter>"..self:GetTS(r.key).."</enter>")
	s("<leave>"..self:GetTS(r.End).."</leave>")
	if r.zone then s("<name>"..r.zone.."</name>") end
	if r.idiff then s("<difficulty>"..r.idiff.."</difficulty>") end
	s("</zone></zones>")

	s("<bosskills>")
	if r.Events then
		for k, v in pairs(r.Events) do
			s("<bosskill>")
			s("<name>"..v.boss.."</name>")
			s("<time>"..self:GetTS(v.time).."</time>")
			s("</bosskill>")
		end
	end
	s("</bosskills>")

	s("<members>")
	local times = self:ProcessEqDKPTimes( r )
	for k, v in pairs( times ) do
	s("<member>")
	s("<name>"..k.."</name>")
	if r.Players[k] then
		for k2,v2 in pairs( r.Players[k] ) do
			if k2 == "note" then
				s("<note><![CDATA["..v2.."]]></note>")
			elseif k2 == "class" then
				s("<class>"..v2.."</class>")
			elseif k2 == "race" then
				s("<race>"..v2.."</race>")
			elseif k2 == "level" then
				s("<level>"..v2.."</level>")
			else
				s("<"..k2..">"..v2.."</"..k2..">")
			end
		end
	end
	s("<times>")
	for k2,v2 in pairs( v ) do
		s("<time type='"..v2[2].."'>"..v2[1].."</time>")
	end
	s("</times>")
	s("</member>")
	end
	s("</members>")

	s("<items>")
	for k, v in pairs( r.Loot ) do
		s("<item>")
		s("<name>"..v.item.name.."</name>")
	s("<time>"..self:GetTS(v.time).."</time>")
	s("<member>"..v.player.."</member>")
		s("<itemid>"..v.item.id.."</itemid>")
		if v.cost then	s("<cost>"..v.cost.."</cost>") end
		s("</item>")
	end
	s("</items>")

	s("</raiddata>")
	s("</raidlog>")

end

function RT_Export:GenerateSMFbbc( r )  -- edit by Camealion
	local L,NL,eF = self._L,self._NL,self._format
	local s = self._Line

	function ts( v, t )
	t = t or type(v); --if t == "string" then t = "quote" end
	return self:GetTS( v, t )
	end

	if eF ~= 12 then
		s("[b]"..L["Session"].."[/b]:" .. NL)
		s("[table=]" .. NL)
		s("Zone,Difficulty,Start,End,Note,Portal,Realm" .. NL)
		s(ts(r.zone) .. "," .. ts(r,"idiff") .. "," .. ts(r.key) .. "," .. ts(r.End) .. "," .. ts(r.note) .. "," .. GetCVar("portal") .. "," .. GetRealmName() .. NL)
		s("[/table]" .. NL)
	else
		s("[b][u]"..ts(r.zone).." ("..ts(r,"idiff")..")[/u][/b]" .. NL)
		s("[i]"..ts(r.key).." - "..ts(r.End).."[/i]" .. NL)
	end
	s(NL)

	s("[b]"..L["Players"].."[/b]:" .. NL)
	s((eF ~= 12 and "[table=]" or "[list]") .. NL)
	if eF ~= 12 then s("Index,Name,Join,Leave,Race,Class,Level,Guild,Note" .. NL) end
	local t = { }; for k,v in pairs(r.Players) do tinsert(t,{k,v}) end; table.sort(t, function(a,b) return a[1] < b[1] end)
	for i,v in pairs(t) do
	local join,leave,v1 = nil,nil,v[2]
	for i1,v1 in pairs(r.Join) do if v[1] == v1.player then join = v1.time; break end end
	for i1,v1 in pairs(r.Leave) do if v[1] == v1.player then leave = v1.time end end
		if eF ~= 12 then
			s(i .. "," .. ts(v[1]) .. ",".. ts(join) .. "," .. ts(leave) .. "," .. ts(v1.race) .. ",")
			s(ts(v1.class) .. "," .. ts(v1.level,"L") .. "," .. ts(v1.guild) .. "," .. ts(v1.note))
			s(NL)
		else
			s("[*]"..ts(v[1]).." [i]("..ts(v1.class)..")[/i]" .. NL)
		end
	end
	s((eF ~= 12 and "[/table]" or "[/list]") .. NL)
	s(NL)

	s("[b]"..L[eF ~= 12 and "Events" or "Boss Kills"].."[/b]:" .. NL)
	s((eF ~= 12 and "[table=]" or "[list]") .. NL)
	if eF ~= 12 then s("Index,Name,Zone,Difficulty,End,Attendees" .. NL) end
	for i,v in pairs(r.Events) do
		if eF ~= 12 then
			s(i .. "," .. ts(v.boss) .. "," .. ts(v.zone or r.zone) .. "," .. ts(((v.idiff) and v or r),"idiff") .. "," .. ts(v.time) .. ",")
			if v.attendees then
				local a = ""; for i1,v1 in pairs(v.attendees) do a = a .. (i1 ~= 1 and " " or "") .. v1 end; s(ts(a))
			end
		else
			s("[*]"..ts(v.boss).." at "..ts(v.time))
		end
		s(NL)
	end
	s((eF ~= 12 and "[/table]" or "[/list]") .. NL)
	s(NL)

	s("[b]"..L["Loot"].."[/b]:" .. NL)
	s((eF ~= 12 and "[table=]" or "[list]") .. NL)
	if eF ~= 12 then s("Index,Name,ID,Time,Mob,Player,Cost,Note" .. NL) end
	local url = nil
	for i,v in pairs(r.Loot) do
		url = "[url=http://www.wowhead.com/?item=" ..ts(v.item.id,"itemid").."]"
		if eF ~= 12 then
			s(i .. "," .. "[wow]" .. ts(v.item.name) .. "[/wow]" .. "," .. url .. ts(v.item.id,"itemid") .. "[/url]" .. "," .. ts(v.time) .. "," )
			s(ts(v.boss) .. "," .. ts(v.player) .. "," .. ts(v.cost or 0,"L") .. "," .. ts(v.note))
		else
			local c = v.item.c
			if c and string.len(c) > 1 then c = strsub(c,3) else c = nil end
			s(url .. (c and "[color=#"..c.."]" or "").."[b]"..(v.item.name or "Unknown").."[/b]"..
				(c and "[/color]" or "").."[/url] by "..ts(v.player))
		end
		s(NL)
	end
	s((eF ~= 12 and "[/table]" or "[/list]") .. NL)
end

function RT_Export:GenerateGLbbc( r )  -- edit by Sysop
	local L,NL,eFormat = self._L,self._NL,self._format
	local s = self._Line

	function ts( v, t )
	t = t or type(v); --if t == "string" then t = "quote" end
	return self:GetTS( v, t )
	end

	s(L["Session[/b]"] .. ":" )
	s("[table]")
	s("[tr][td]Zone[/td][td]Difficulty[/td][td]Start[/td][td]End[/td][td]Note[/td][td]Portal[/td][td]Realm[/td][/tr]" )
	s("[tr][td]" .. ts(r.zone) .. "[/td][td]" .. ts(r,"idiff") .. "[/td][td]" .. ts(r.key) .. "[/td][td]" .. ts(r.End) .. "[/td][td]" .. ts(r.note) .. "[/td][td]" .. GetCVar("portal") .. "[/td][td]" .. GetRealmName() .. "[/td][/tr]" )
	s("[/table]" )
	s(NL)

	s(L["Players[/b]"] .. ":" )
	s("[table]" )
	s("[tr][td]Index[/td][td]Name[/td][td]Join[/td][td]Leave[/td][td]Race[/td][td]Class[/td][td]Level[/td][td]Guild[/td][td]Note[/td][/tr]" )
	local t = { }; for k,v in pairs(r.Players) do tinsert(t,{k,v}) end; table.sort(t, function(a,b) return a[1] < b[1] end)
	for i,v in pairs(t) do
	local join,leave,v1 = nil,nil,v[2]
	for i1,v1 in pairs(r.Join) do if v[1] == v1.player then join = v1.time; break end end
	for i1,v1 in pairs(r.Leave) do if v[1] == v1.player then leave = v1.time end end
	s("[tr][td]" .. i .. "[/td][td]" .. ts(v[1]) .. "[/td][td]".. ts(join) .. "[/td][td]" .. ts(leave) .. "[/td][td]" .. ts(v1.race) .. "[/td][td]")
	s(ts(v1.class) .. "[/td][td]" .. ts(v1.level,"L") .. "[/td][td]" .. ts(v1.guild) .. "[/td][td]" .. ts(v1.note) .. "[/td][/tr]")
	end
	s("[/table]" )
	s(NL)

	s(L["Events[/b]"] .. ":" )
	s("[table]" )
	s("[tr][td]Index[/td][td]Name[/td][td]Zone[/td][td]Difficulty[/td][td]End[/td][td]Attendees[/td][/tr]" )
	for i,v in pairs(r.Events) do
	s("[tr][td]" .. i .. "[/td][td]" .. ts(v.boss) .. "[/td][td]" .. ts(v.zone or r.zone) .. "[/td][td]" .. ts(((v.idiff) and v or r),"idiff") .. "[/td][td]" .. ts(v.time) .. "[/td][td]")
	if v.attendees then
		local a = ""; for i1,v1 in pairs(v.attendees) do a = a .. (i1 ~= 1 and " " or "") .. v1 end; s(ts(a))
	end
	s("[/td][/tr]" )
	end
	s("[/table]" )
	s(NL)

	s(L["Loot[/b]"] .. ":" )
	s("[table]" )
	s("[tr][td]Index[/td][td]Name[/td][td]ID[/td][td]Time[/td][td]Mob[/td][td]Player[/td][td]Cost[/td][td]Note[/td][/tr]" )
	for i,v in pairs(r.Loot) do
	s("[tr][td]" .. i .. "[/td][td]" .. "[item]" .. ts(v.item.name) .. "[/item]" .. "[/td][td]" .. "[url=http://www.wowhead.com/?item=" .. ts(v.item.id,"itemid") .."]" .. ts(v.item.id,"itemid") .. "[/url]" .. "[/td][td]" .. ts(v.time) .. "[/td][td]" )
	s(ts(v.boss) .. "[/td][td]" .. ts(v.player) .. "[/td][td]" .. ts(v.cost or 0,"L") .. "[/td][td]" .. ts(v.note) .. "[/td][/tr]")

	end
	s("[/table]" )
end


