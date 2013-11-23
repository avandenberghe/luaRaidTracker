local L = LibStub("AceLocale-3.0", true):NewLocale("RaidTracker", "frFR", false)
if not L then return end

-- *** functional strings (must match the game strings exactly) ***

--L.LeftRaid = "([^%s]+) a quitt\195\169 le groupe de raid"
--L.ReceivesLoot1 = "([^%s]+) re\195\167oit le butin.+: "..RT_ITEMREG.."."
--L.ReceivesLoot2 = "Vous recevez le butin.+: "..RT_ITEMREG.."."
--L.ReceivesLoot3 = "([^%s]+) re\195\167oit le butin.+: "..RT_ITEMREG_MULTI.."."
--L.ReceivesLoot4 = "Vous recevez le butin.+: "..RT_ITEMREG_MULTI.."."

L.Yell_Majordomo = "Impossible ! Arr\195\170tez votre attaque, mortels... Je me rends ! Je me rends !"
L["Yell_Chess Event"] = "Les salles de Karazhan tremblent, tandis qu'est lev\195\169e la mal\195\169diction qui scellait les portes du hall du Flambeur."
L.Yell_Julianne = "O willkommener Dolch! Dies werde deine Scheide. Roste da und lass mich sterben!"; -- need english translation
-- naxx
-- ulduar
L.Yell_Freya =	"Son emprise sur moi se dissipe. J'y vois \195\160 nouveau clair. Merci, H\195\169ros."
-- toc
-- icecrown

-- zones

-- *** non-functional (do not have to match game strings) ***

-- lib karma (menu)

-- addon messages

-- command menu

-- UI_Options
L["Wipes"] = "Échecs"

-- UI_Templates
L["Title"] = "Titre"
