local L = LibStub("AceLocale-3.0", true):NewLocale("RaidTracker", "zhTW")
if not L then return end
-- Author      : lecod

-- *** functional strings (must match the game strings exactly) ***

--L.LeftRaid = "([^%s]+)離開了團隊。"
--L.LeftParty = "([^%s]+)離開了隊伍。"
----L.LeftParty2 = "你的隊伍已經解散。"
--L.ReceivesLoot1 = "([^%s]+)拾取了物品:"..RT_ITEMREG.."。"
--L.ReceivesLoot2 = "你拾取了物品:"..RT_ITEMREG.."。"
--L.ReceivesLoot3 = "([^%s]+)獲得戰利品:"..RT_ITEMREG_MULTI.."。"
--L.ReceivesLoot4 = "你獲得戰利品:"..RT_ITEMREG_MULTI.."。"
----L.ReceivesLootYou = "你得到了物品:"..RT_ITEMREG_MULTI.."。"

-- naxx
L.Yell_Steelbreaker = "不可能......"                                -- Iron Council Hardmode / Steelbreaker last
L.Yell_Brundir = "你魯莽地闖入了瘋狂的禁地!"                    -- Iron Council Normalmode / Brundir last
L.Yell_Molgeim = "擊敗我對你有什麼益處?你早已注定要滅亡，凡人。"    -- Iron Council Semimode / Molgeim last
L.Yell_Four_Horsemen = "這場遊戲已經讓我覺得無聊了。繼續吧，到我這裏來，我會親自毀滅你們的靈魂!"
-- ulduar
L.Yell_Freya =    "他對我的操控已然退散。我已再次恢復神智了。感激不盡，英雄們。"
L.Yell_Thorim = "住手!我認輸了!"
L.Yell_Hodir = "我…我終於從他的掌控中…解脫了。"
L.Yell_Mimiron = "看來我還是產生了些許計算錯誤。任由我的心智受到囚牢中魔鬼的腐化，棄我的首要職責於不顧。所有的系統看起來都正常運作。報告完畢。"
L["Yell_Yogg-Saron"] = "你們的命運已經注定。末日到來，所有居住在這可悲幼苗上的生物將無一倖免。(古神語)寄宿在我屍體上的陰影將永世侵擾這片大地。"
-- toc
L.Yell_TwinValkyr = "誰也阻擋不了天譴軍團……"
L.Yell_Anubarak = "我讓你失望了，主人……"
L["Yell_Faction Champions"] = "膚淺而悲痛的勝利。今天痛失的生命反而令我們更加的頹弱。除了巫妖王之外，誰還能從中獲利?偉大的戰士失去了寶貴生命。為了什麼?真正的威脅就在前方 - 巫妖王在死亡的領域中等著我們。"
-- icecrown
-- siege of orgrimmar
L.Yell_Immerseus = "啊，你成功了!水又再次純淨了。"
L["Yell_Spoils of Pandaria"] = "模組二號已準備好系統重置。"

-- zones
L["Hyjal Summit"] = "海加爾山"
L["World Boss"] = "世界首領"

-- *** non-functional (do not have to match game strings) ***

-- lib karma (menu)
L["Item Options"] = "物品選項"
L["Show Item Options"] = "顯示物品選項"

-- addon messages
L["Added %s to the selected raid."] = "將 %s 增加到選中的Raid中。"

L["%s: Could not add %s"] = "%s：不能增加 %s"
L["%s: Must be a current open raid."] = "%s：必須是正在進行中的Raid。"
L["%s: Must supply an item link and a player name."] = "%s：必須填寫一個物品鏈接和玩家名稱。"
L["%s: There is no raid selected"] = "%s：沒有選擇需要增加物品的Raid"

-- command menu
L["additem"] = "增加物品"
L["/rt - Shows the main window."] = "/rt - 打開主窗口。"
L["/rt options|o - Shows Options window"] = "/rt options|o - 打開選項窗口。"
L["/rt io - Shows the ItemOptions window"] = "/rt io - 打開物品選項窗口。"
L["/rt io [ITEMLINK|ITEMID]... - Adds items to ItemOptions window"] = "/rt io 物品鏈接|物品ID - 增加物品到物品選項窗口。"
L["/rt additem [ITEMLINK] [PLAYER] - Adds a loot item to the selected raid"] = "/rt additem 物品鏈接 玩家名稱 - 增加一個拾取記錄到選中的Raid。"
L["/rt join [PLAYER] - Add a player to the selected raid"] = "/rt join 玩家名稱 - 增加玩家到選中的Raid。"
L["/rt leave [PLAYER] - Removes a player from the selected raid"] = "/rt leave 玩家名稱 - 從選中的Raid中移除玩家。"
L["/rt deleteall - Deletes all raids"] = "/rt deleteall - 刪除所有Raid記錄。"
L["/rt debug 1|0 - Enables/Disables debug mode"] = "/rt debug 1|0 - 打開/關閉 調試模式"
L["/rt addwipe - Adds a Wipe with the current timestamp"] = "/rt addwipe - 為當前時間點增加一個Wipe"

-- RaidTracker Frame

-- Raid Log

-- UI_Options
L["Wipes"] = "失敗"

-- UI_Options options

-- UI_Templates
L["Title"] = "標題"