local L = LibStub("AceLocale-3.0", true):NewLocale("RaidTracker", "enUS", true, true)
if not L then return end


do		-- to release temp vars, this do/end, and any local or static vars should not be copied to non-english locale scripts

-- |cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0:80:0|h[Broken Fang]|h|r
local REGITEM =		"(|c%x+|Hitem:%d+:%d+:%d+:%d+:%d+:%d+:(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+)|h%[.-%]|h|r)"
local REGUSER, REGCOUNT, REGEND = "([^%s]+)", "(%d+)", "%"
RT_ITEMREG =		REGITEM..REGEND					--(|c%x+|Hitem:%d+:%d+:%d+:%d+:%d+:%d+:(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+)|h%[.-%]|h|r)%
RT_ITEMREG_MULTI =	REGITEM.."x"..REGCOUNT..REGEND	--(|c%x+|Hitem:%d+:%d+:%d+:%d+:%d+:%d+:(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+)|h%[.-%]|h|r)x(%d+)%


-- *** functional strings (must match the game strings exactly) ***

local _LEFTRAID = ERR_RAID_MEMBER_REMOVED_S and ERR_RAID_MEMBER_REMOVED or "%s has left the raid group."
local _LEFTPARTY = LEFT_PARTY and LEFT_PARTY or "%s leaves the party."
local _GROUPDISBAND = ERR_GROUP_DISBANDED and ERR_GROUP_DISBANDED or "Your group has been disbanded."
local _RECITEM = ERR_QUEST_REWARD_ITEM_S and ERR_QUEST_REWARD_ITEM_S or "Received item: %s."
local _RECLOOT = LOOT_ITEM and LOOT_ITEM or "%s receives loot: %s."
local _RECLOOTMULT = LOOT_ITEM_MULTIPLE and LOOT_ITEM_MULTIPLE:gsub("%%d", "%s") or "%s receives loot: %sx%s."
local _RECLOOTYOU = LOOT_ITEM_SELF and LOOT_ITEM_SELF or "You receive loot: %s."
local _RECLOOTYOUMULT = LOOT_ITEM_SELF_MULTIPLE and LOOT_ITEM_SELF_MULTIPLE:gsub("%%d", "%s") or "You receive loot: %sx%s."

L.LeftRaid = _LEFTRAID:format(REGUSER)		--"([^%s]+) has left the raid group."
L.LeftParty = _LEFTPARTY:format(REGUSER)	--"([^%s]+) leaves the party."
--L.LeftParty2 = _GROUPDISBAND				--"Your group has been disbanded."
L.ReceivedItem1 = _RECITEM:format(REGITEM..REGEND) --"Received item: "..RT_ITEMREG.."."
L.ReceivesLoot1 = _RECLOOT:format(REGUSER, REGITEM..REGEND) --"([^%s]+) receives loot: "..RT_ITEMREG.."."
L.ReceivesLoot2 = _RECLOOTYOU:format(REGITEM..REGEND) --"You receive loot: "..RT_ITEMREG.."."
L.ReceivesLoot3 = _RECLOOTMULT:format(REGUSER, REGITEM, REGCOUNT..REGEND) --"([^%s]+) receives loot: "..RT_ITEMREG_MULTI.."."
L.ReceivesLoot4 = _RECLOOTYOUMULT:format(REGITEM, REGCOUNT..REGEND) --"You receive loot: "..RT_ITEMREG_MULTI.."."
--L.ReceivesLootYou = "You receive loot: "..RT_ITEMREG_MULTI.."."

L.Yell_Majordomo = "Impossible! Stay your attack, mortals... I submit! I submit!"
L["Yell_Chess Event"] = "Karazhan - Chess, Victory Controller"
L.Yell_Julianne = "O happy dagger! This is thy sheath; there rust, and let me die!"
L.Yell_Sathrovarr = "I'm... never on... the losing... side..."
-- naxx
L.Yell_Steelbreaker = "Impossible..."								-- Iron Council Hardmode / Steelbreaker last
L.Yell_Brundir = "You rush headlong into the maw of madness!"		-- Iron Council Normalmode / Brundir last
L.Yell_Molgeim = "What have you gained from my defeat? You are no less doomed, mortals!"	-- Iron Council Semimode / Molgeim last
-- ulduar
L.Yell_Freya = "His hold on me dissipates. I can see clearly once more. Thank you, heroes."
L.Yell_Thorim = "Stay your arms! I yield!"
L.Yell_Hodir = "I... I am released from his grasp... at last."
L.Yell_Mimiron = "It would appear that I've made a slight miscalculation. I allowed my mind to be corrupted by the fiend in the prison, overriding my primary directive. All systems seem to be functional now. Clear."
L["Yell_Yogg-Saron"] = "Your fate is sealed. The end of days is finally upon you and ALL who inhabit this miserable little seedling! Uulwi ifis halahs gag erh'ongg w'ssh."
-- toc
L.Yell_TwinValkyr = "The Scourge cannot be stopped..."
L.Yell_Anubarak   = "I have failed you, master..."
L["Yell_Faction Champions"] = "A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death."
L.Yell_Ignis = "I...have...failed..."
-- icecrown
L.YellA_GunshipBattle = "Don't say I didn't warn ye scoundrels. Onwards, brothers and sisters!"
L.YellH_GunshipBattle = "The Alliance falter. Onward to the Lich King!"
-- firelands
L.Yell1_Ragnaros = "Too soon! ... You have come too soon..."
L.Yell2_Ragnaros = "No, nooooo... this was to be my hour of triumph..."
-- dragon soul
L["Yell_Warlord Zon'ozz"] = "Uovssh thyzz... qwaz..."
L["Yell_Yor'sahj the Unsleeping"] = "Ez, Shuul'wah! Sk'woth'gl yu'gaz yoh'ghyl iilth!"
L.Yell_Deathwing = "It is time. I will expend everything to bind every thread here, now, around the Dragon Soul. What comes to pass will NEVER be undone."
-- ms vaults
L["Yell_The Spirit Kings"] = "A secret passage has opened beneath the platform, this way!"
-- siege of orgrimmar
L.Yell_Immerseus = "Ah, you have done it!  The waters are pure once more."
L["Yell_Spoils of Pandaria"] = "Module 2's all prepared for system reset."

-- zones
--L["Hyjal Summit"] = true
--L["World Boss"] = true
for _k,t in pairs({RaidTracker_Tags,RaidTracker_Zones}) do
	for k,v in pairs(t) do
		if type(v)=="table" and v.mid and v.mid ~=0 then
			local s,n = GetMapNameByID(v.mid),v.mame or v.name
			if s and s ~= n then L[n] = s end
		end
	end
end

-- games
L["Classic"] = EXPANSION_NAME0 or true;				-- parking this here until sure there are no functional ties
L["The Burning Crusade"] = EXPANSION_NAME1 or true;
L["Wrath of the Lich King"] = EXPANSION_NAME2 or true;
L["Cataclysm"] = EXPANSION_NAME3 or true ;
L["Mists of Pandaria"] = EXPANSION_NAME4 or true;


-- *** non-functional (do not have to match game strings) ***

local isSC, isOR, isAS, _SP = LibKarmaAce:GetLexFlags(GetLocale())
local _GrabVerb = function(s,d) return s and (isSC and s:sub(1,6) or select(isOR and 1 or -1, strsplit(' ', s))) or d end
local _GrabNoun = function(s,d) return s and (isSC and s:sub(-6,-1) or select(isOR and -1 or 1, strsplit(' ', s))) or d end
local _VIEW = _GrabVerb(CALENDAR_VIEW_EVENT, "View")
local _SHOW = _GrabVerb(SHOW_MAP, "Show")
local _EDIT = _GrabVerb(CALENDAR_EDIT_ANNOUNCEMENT, "Edit")
local _DELETE = _GrabVerb(BROWSER_DELETE_COOKIES, "Delete")
local _COST = COSTS_LABEL and COSTS_LABEL:sub(1,-2) or "Cost"
local _TIME = SLASH_TIME1 and SLASH_TIME1:sub(2) or "Time"; if not isAS then _TIME = _TIME:gsub("^%l", string.upper) end
local _EVENT = _GrabNoun(CALENDAR_VIEW_EVENT, "Event")
local _PLAYERS,_BOTH,_ITEM = TUTORIAL_TITLE19, CONVERSATION_MODE_POPOUT_AND_INLINE, HELPFRAME_ITEM_TITLE --fixme: unstable
--local s = ERROR_SLASH_EQUIP_TO_SLOT; s = s and s:match('%[(.*)%]'); _ITEM_NAME = s and (not isAS and s:gsub("^%l", string.upper) or s) or "Item name"

-- lib karma (menu)
--L["Cancel"] = true --localized in LibKarma
--L["Close"] = true --localized in LibKarma
--L["Help"] = true --localized in LibKarma
--L["Item Options"] = true
--L["Main Window"] = true
--L["Options"] = true --localized in LibKarma
--L["Show Help"] = isOR and SHOW.._SP..GAMEMENU_HELP or GAMEMENU_HELP.._SP..SHOW
--L["Show Item Options"] = true
--L["Show Main Window"] = true
--L["Show Options"] = isOR and SHOW.._SP..MAIN_MENU or MAIN_MENU.._SP..SHOW
--L.ADDON_TOOLTIP = "|cffeda55fClick|r to open main window. |cffeda55fShift-click|r to open options."
--L.ADDON_TOOLTIP_RC = "|cffeda55fRight-click|r to show menu."

-- addon messages
--L["Added %s to the selected raid."] = true
--L["%s: Could not add %s"] = true
--L["%s: Must be a current open raid."] = true
--L["%s: Must supply an item link and a player name."] = true
--L["%s: There is no raid selected"] = true

-- command menu
--L["additem"] = true
--L["/rt - Shows the main window."] = true
--L["/rt options|o - Shows Options window"] = true
--L["/rt io - Shows the ItemOptions window"] = true
--L["/rt io [ITEMLINK|ITEMID]... - Adds items to ItemOptions window"] = true
--L["/rt additem [ITEMLINK] [PLAYER] - Adds a loot item to the selected raid"] = true
--L["/rt join [PLAYER] - Add a player to the selected raid"] = true
--L["/rt leave [PLAYER] - Removes a player from the selected raid"] = true
--L["/rt deleteall - Deletes all raids"] = true
--L["/rt debug 1|0 - Enables/Disables debug mode"] = true
--L["/rt addwipe - Adds a Wipe with the current timestamp"] = true

-- RaidTracker Frame
L._BACK = BACK	--"Back" ambiguous with libbabbleinventory "Back" backside
L["Boss"] = BOSS
L["Delete"] = DELETE
L["End"] = KEY_END
--L["First join"] = true
--L["Item name"] = _ITEM_NAME
L["Items"] = ITEMS
--L["Kill date"] = true
--L["Last leave"] = true
L["Loot"] = LOOT
L["Looter"] = LOOTER
L["New"] = NEW
--L["Participants"] = true
L["Player name"] = CALENDAR_PLAYER_NAME
--L["Raid date"] = true
L["Raids"] = RAIDS
L["Rarity"] = RARITY
--L["Raid Tracker"] = true
--L["Snapshot"] = true
--L["Time looted"] = true
L["View Events"] = isOR and _VIEW.._SP..EVENTS_LABEL or EVENTS_LABEL.._SP.._VIEW
L["View Items"] = isOR and _VIEW.._SP..ITEMS or ITEMS.._SP.._VIEW
L["View Loot"] = isOR and _VIEW.._SP..LOOT or LOOT.._SP.._VIEW
L["View Players"] = isOR and _VIEW.._SP.._PLAYERS or _PLAYERS.._SP.._VIEW
L["View Raid"] = isOR and _VIEW.._SP..RAID or RAID.._SP.._VIEW
L["View Raids"] = isOR and _VIEW.._SP..RAIDS or RAIDS.._SP.._VIEW

-- Raid Log
--L["10"] = true
--L["25"] = true
L["Heroic"] = "|cffff0000"..PLAYER_DIFFICULTY2.."|r"
L["Poor"] = ITEM_QUALITY0_DESC
L["Common"] = ITEM_QUALITY1_DESC
L["Uncommon"] = ITEM_QUALITY2_DESC
L["Rare"] = ITEM_QUALITY3_DESC
L["Epic"] = ITEM_QUALITY4_DESC
L["Legendary"] = ITEM_QUALITY5_DESC
L["Artifact"] = ITEM_QUALITY6_DESC
L["Heirloom"] = ITEM_QUALITY7_DESC

-- UI_Options
L["Advanced"] = ADVANCED_LABEL
--L["Arenas"] = true
--L["Attendees"] = true
--L["Auto Event"] = true
--L["Auto Zone"] = true
L["Battlegrounds"] = BATTLEFIELDS
--L["Battlegroups"] = true			--(unused)
--L["Debug Mode"] = true
--L["Event Cooldown"] = true
--L["Export Level"] = true
--L["Export Format"] = true
--L["Guildies"] = true
--L["Item Quality"] = true
--L["Logging"] = true
--L["Max to Stack"] = true
--L["Min iLevel"] = true
--L["Min Rarity"] = true
--L["Min to Ask Cost"] = true
--L["Min to Get Cost"] = true
--L["Parties"] = true
--L["Show Tooltips"] = isOR and _SHOW.._SP.."Tooltips" or "Tooltips".._SP.._SHOW
L["Solo"] = SOLO
--L["Wipes"] = true

-- UI_Options options
L["All"] = ALL
L["Always"] = ALWAYS
--L["Ask at %s"] = true
--L["Ask Next"] = true
--L["Auto Create"] = true
--L["Auto Instance"] = true
L["Both"] = _BOTH
L["Default"] = DEFAULT
--L["Essential"] = true
L["Never"] = NEVER
L["Off"] = OFF
--L["On event"] = true
L["On event (All)"] = "On event ("..ALL..")"		--fixme: these
L["On event (Both)"] = "On event (".._BOTH..")"
L["On event (Online)"] = "On event ("..FRIENDS_LIST_ONLINE..")"
L["On event (Zone)"] = "On event ("..ZONE..")"
--L["On loot"] = true
L["On loot (Both)"] = "On loot (".._BOTH..")"
L["On loot (Online)"] = "On loot ("..FRIENDS_LIST_ONLINE..")"
L["On loot (Zone)"] = "On loot ("..ZONE..")"
--L["On mouseover"] = true
L["Online"] = FRIENDS_LIST_ONLINE
--L["Plain Text"] = true
--L["Unsaved"] = true
L["Zone"] = ZONE

-- UI_ItemOptions
--L["Ask Cost"] = true
--L["Get Cost"] = true
--L["Item ID: "] = true
L["Log"] = GUILD_EVENT_LOG
--L["Stack"] = true
L["Unknown"] = UNKNOWN
--L["Unknown (ID: "] = true			--(unused)

-- UI_Dialog
--L["Bank"] = true
L["Delete Item"] = isOR and _DELETE.._SP.._ITEM or _ITEM.._SP.._DELETE
L["Delete Raid"] = isOR and _DELETE.._SP..RAID or RAID.._SP.._DELETE
L["Delete Player"] = isOR and _DELETE.._SP..PLAYER or PLAYER.._SP.._DELETE
L["Delete Event"] = isOR and _DELETE.._SP.._EVENT or _EVENT.._SP.._DELETE
--L["Export String"] = true
L["Join"] = JOIN
L["Leave"] = CHAT_LEAVE
--L["Maybe"] = true
L["Name"] = NAME
L["No"] = NO
L["Raid"] = RAID
L["Yes"] = YES

-- UI_Button
L["Disenchant"] = ROLL_DISENCHANT
--L["Dropped from"] = true
L["Edit Cost"] = isOR and _EDIT.._SP.._COST or _COST.._SP.._EDIT
L["Edit Count"] = isOR and _EDIT.._SP.."Count" or "Count".._SP.._EDIT
L["Edit End"] = isOR and _EDIT.._SP..KEY_END or KEY_END.._SP.._EDIT
--L["Edit Item Options"] = true
L["Edit Looter"] = isOR and _EDIT.._SP..LOOTER or LOOTER.._SP.._EDIT
L["Edit Note"] = isOR and _EDIT.._SP..LABEL_NOTE or LABEL_NOTE.._SP.._EDIT
L["Edit Start"] = isOR and _EDIT.._SP..START or START.._SP.._EDIT
L["Edit Time"] = isOR and _EDIT.._SP.._TIME or _TIME.._SP.._EDIT
L["Edit Zone"] = isOR and _EDIT.._SP..ZONE or ZONE.._SP.._EDIT
L["Invite"] = INVITE
L["None"] = NONE
--L["Show Export String"] = true
L["Whisper"] = WHISPER

-- UI_Templates
--L["Button"] = true
L["Done"] = DONE
L["Save"] = SAVE
--L["Title"] = true

end -- to release temp vars