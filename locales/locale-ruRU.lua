local L = LibStub("AceLocale-3.0", true):NewLocale("RaidTracker", "ruRU", false)
if not L then return end


-- *** functional strings (must match the game strings exactly) ***

--L.LeftRaid = "([^%s]+) покидает рейдовую группу"
--L.ReceivesLoot1 = "([^%s]+) получает добычу: "..RT_ITEMREG.."."
--L.ReceivesLoot2 = "Ваша добыча: "..RT_ITEMREG.."."
--L.ReceivesLoot3 = "([^%s]+) получает добычу: "..RT_ITEMREG_MULTI.."."
--L.ReceivesLoot4 = "Ваша добыча: "..RT_ITEMREG_MULTI.."."

-- naxx
L.Yell_Steelbreaker = "Невозможно..."								-- Iron Council Hardmode / Steelbreaker last
-- ulduar
L.Yell_Freya =	"Он больше не властен надо мной. Мой взор снова ясен. Благодарю вас, герои."
L.Yell_Thorim = "Придержите мечи! Я сдаюсь."
L.Yell_Hodir = "Наконец-то я... свободен от его оков…"
L.Yell_Mimiron = "Очевидно, я совершил небольшую ошибку в расчетах. Пленный злодей затуманил мой разум и заставил меня отклониться от инструкций. Сейчас все системы в норме. Конец связи."
L["Yell_Yogg-Saron"] = "Вы обречены. Ни вы, никто другой НЕ В СИЛАХ избежать близящегося конца света. Уульви ифис халас гаг эрх'онг ушшш!"
L.Yell_Kologarn = "Повелитель, они идут..."
L.Yell_XT002 = "Плохие... игрушки... очень... плохиеееее."
L.Yell_Vezax = "Какие ужасы вас ожидают..."
-- toc
L.Yell_TwinValkyr = "Плеть не остановить..."
L.Yell_Anubarak = "Я подвел тебя, господин..."
L["Yell_Faction Champions"] = "Пустая и горькая победа. После сегодняшних потерь мы стали слабее как целое. Кто ещё, кроме Короля-лича, выиграет от подобной глупости? Пали великие воины. И ради чего? Истинная опасность ещё впереди - нас ждет битва с Королем-личом."
L.Yell_Ignis = "Повелитель Горнов Игнис"
-- icecrown
L.YellH_GunshipBattle = "Альянс повержен. Вперед, к Королю-личу!"
-- siege of orgrimmar
L.Yell_Immerseus = "У вас получилось! Теперь воды снова чисты."
L["Yell_Spoils of Pandaria"] = "Второй модуль готов к перезагрузке системы."


-- *** non-functional (do not have to match game strings) ***


-- UI_Options
L["Wipes"] = "Поражения"

-- UI_Templates
L["Title"] = "Название"