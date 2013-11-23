local L = LibStub("AceLocale-3.0", true):NewLocale("RaidTracker", "esMX", false)
if not L then return end

-- *** functional strings (must match the game strings exactly) ***

--L.LeftRaid = "([^%s]+) se ha marchado de la banda."
--L.LeftParty = "([^%s]+) se ha marchado del grupo de banda."
--L.ReceivesLoot1 = "([^%s]+) recibe el bot\195\173n: "..RT_ITEMREG.."."
--L.ReceivesLoot2 = "Recibes bot\195\173n: "..RT_ITEMREG.."."
--L.ReceivesLoot3 = "([^%s]+) recibe el bot\195\173n: "..RT_ITEMREG_MULTI.."."
--L.ReceivesLoot4 = "Recibes bot\195\173n: "..RT_ITEMREG_MULTI.."."

-- naxx
L.Yell_Steelbreaker = "Habeis derrotado a la Asamblea de Hierro y desbloqueado el Archivum! Bien hecho, chicos!"
-- ulduar
L.Yell_Freya =	"Su control sobre mi se ha terminado. Puedo ver claramente una vez ms. Gracias, heroes."
L.Yell_Thorim = "Detener vuestras manos! Yo cedo!"
L.Yell_Hodir = "Yo...Yo he sido liberado de su alcance! Finalmente!"
L.Yell_Mimiron = " Parece que he cometido un leve error de clculo. He permitido que mi mente se corrompiera demonio en la preision, sobrescribiendo mi directiva principal. Todos mis sistemas parecen funcionar de nuevo. Evidente."
L["Yell_Yogg-Saron"] = "Tu destino est sellado. El final de los das finalmente ha llegado sobre ti y todos los que habitan esta miserable tierra!"
L.Yell_Kologarn = "Maestro, ya vienen..."
-- toc
L.Yell_TwinValkyr = "El Azote no puede ser detenido..."
L.Yell_Anubarak = "Te he fallado, maestro..."
L.Yell_Ignis = "He...fallado"
-- icecrown

-- zones
L["Hyjal Summit"] = "La Cima Hyjal"

-- *** non-functional (do not have to match game strings) ***

-- lib karma (menu)

-- addon messages
L["Added %s to the selected raid."] = "Añadido %s seleccionado a la incursión."

-- command menu

-- UI_Options
L["Wipes"] = "Wipes"

-- UI_Templates
L["Title"] = "Título"
