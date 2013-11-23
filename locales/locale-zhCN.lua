local L = LibStub("AceLocale-3.0", true):NewLocale("RaidTracker", "zhCN")
if not L then return end

-- *** functional strings (must match the game strings exactly) ***

--L.LeftRaid = "([^%s]+)离开了团队。"
--L.LeftParty = "([^%s]+)离开了队伍。"
----L.LeftParty2 = "你的队伍已经被解散了。"
--L.ReceivesLoot1 = "([^%s]+)获得了物品："..RT_ITEMREG.."。"
--L.ReceivesLoot2 = "你获得了物品："..RT_ITEMREG.."。"
--L.ReceivesLoot3 = "([^%s]+)得到了物品："..RT_ITEMREG_MULTI.."。"
--L.ReceivesLoot4 = "你得到了物品："..RT_ITEMREG_MULTI.."。"

L.Yell_Majordomo = "不……不可能！等一下……我投降！我投降！"
L["Yell_Chess Event"] = "象棋"
L.Yell_Julianne = "啊，好刀子！这就是你的鞘子；你插了进去，让我死了吧。"
-- naxx
-- ulduar
-- toc
-- icecrown
-- siege of orgrimmar
L.Yell_Immerseus = "啊，你成功了。泉水再一次变得纯净了！"
L["Yell_Spoils of Pandaria"] = "系统重置中。请勿关闭电源，否则将发生爆炸。"

-- zones
L["Hyjal Summit"] = "海加尔峰"
L["World Boss"] = "世界首领"

-- *** non-functional (do not have to match game strings) ***

-- lib karma (menu)
L["Item Options"] = "物品选项"
L["Show Item Options"] = "显示物品选项"
-- addon messages
L["Added %s to the selected raid."] = "将 %s 添加到选中的Raid中。"

L["%s: Could not add %s"] = "%s：不能添加 %s"
L["%s: Must be a current open raid."] = "%s：必须是正在进行中的Raid。"
L["%s: Must supply an item link and a player name."] = "%s：必须填写一个物品链接和玩家名称。"
L["%s: There is no raid selected"] = "%s：没有选择需要添加物品的Raid"

-- command menu
L["additem"] = "添加物品"
L["/rt - Shows the main window."] = "/rt - 打开主窗口。"
L["/rt options|o - Shows Options window"] = "/rt options|o - 打开选项窗口。"
L["/rt io - Shows the ItemOptions window"] = "/rt io - 打开物品选项窗口。"
L["/rt io [ITEMLINK|ITEMID]... - Adds items to ItemOptions window"] = "/rt io 物品链接|物品ID - 添加物品到物品选项窗口。"
L["/rt additem [ITEMLINK] [PLAYER] - Adds a loot item to the selected raid"] = "/rt additem 物品链接 玩家名称 - 添加一个拾取记录到选中的Raid。"
L["/rt join [PLAYER] - Add a player to the selected raid"] = "/rt join 玩家名称 - 添加玩家到选中的Raid。"
L["/rt leave [PLAYER] - Removes a player from the selected raid"] = "/rt leave 玩家名称 - 从选中的Raid中移除玩家。"
L["/rt deleteall - Deletes all raids"] = "/rt deleteall - 删除所有Raid记录。"
L["/rt debug 1|0 - Enables/Disables debug mode"] = "/rt debug 1|0 - 打开/关闭 调试模式"
L["/rt addwipe - Adds a Wipe with the current timestamp"] = "/rt addwipe - 为当前时间点添加一个Wipe"


-- UI_Options
L["Wipes"] =  "失败"

-- UI_Templates
L["Title"] = "标题"