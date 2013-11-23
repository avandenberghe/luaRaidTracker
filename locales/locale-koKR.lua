local L = LibStub("AceLocale-3.0", true):NewLocale("RaidTracker", "koKR", false)
if not L then return end
-- Author      : bisonai

-- *** functional strings (must match the game strings exactly) ***

--L.LeftRaid = "([^%s]+) 님이 공격대를 떠났습니다."
--L.LeftParty = "([^%s]+) 님이 파티를 떠났습니다."
----L.LeftParty2 = "파티가 해체되었습니다."
--L.ReceivesLoot1 = "([^%s]+) 님이 아이템을 획득했습니다: "..RT_ITEMREG..".*"
--L.ReceivesLoot2 = "아이템을 획득했습니다: "..RT_ITEMREG..".*"
--L.ReceivesLoot3 = "([^%s]+) 님이 아이템을 획득했습니다: "..RT_ITEMREG_MULTI..".*"
--L.ReceivesLoot4 = "아이템을 획득했습니다: "..RT_ITEMREG_MULTI..".*"

-- naxx
-- ulduar
L.Yell_Freya = "내게서 그의 지배력이 걷혔다. 다시 온전한 정신을 찾았도다. 영웅들이여, 고맙다."
L.Yell_Thorim = "무기를 거둬라! 내가 졌다!"
L.Yell_Hodir = "드디어... 드디어 그의 손아귀를... 벗어나는구나."
-- toc
L.Yell_Anubarak = "실명시켜 드렸군요, 주인님..."
L.Yell_Krick = "잠간! 멈취! 제발, 죽이지마!"
-- icecrown
L.Yell_The_Lich_King = "도망갈 곳은 없다... 너는 이제 나의 것이다!"
-- siege of orgrimmar
L.Yell_Immerseus = "아, 역시 해냈군! 골짜기의 물이 다시 깨끗해졌네."
L["Yell_Spoils of Pandaria"] = "제2 모듈, 시스템 초기화 준비 완료."

-- zones
L["Hyjal Summit"] = "하이잘 정상"
L["World Boss"] = "월드 보스"
L["Smelting wife's father Garfrost"] = "제련장인 가프로스트"
L["Krick"] = "크리스"
L["Ick"] = "이크"



-- *** non-functional (do not have to match game strings) ***

-- lib karma (menu)
L["Cancel"] = "취소"
L["Item Options"] = "아이템 옵션"
L["Options"] = "옵션"
L["Show Item Options"] = "아이템 옵션 보기"

-- addon messages
L["Added %s to the selected raid."] = "선택한 공격대에 %s 추가합니다."
L["Added %d to the Item Options list."] = "아이템 옵션 리스트에 아이템(%d)을 추가합니다."
L["Adding event for \"%s\" at %s."] = "\"%s\"(%s) 이벤트를 추가하다."
L["AutoEvent boss update \"%s\"."] = "자동 보스 업데이트 \"%s\"."
L["Creating new session due to boss kill."] = "보스킬로 인해 새로운 섹션에 추가합니다."
L["Creating new session due to zone change."] = "지역 변경으로 새로운 세션을 만듭니다."
L["Deleting %d sessions"] = "%d개의 로그를 모두 삭제했습니다"
L["Ending current raid at %s."] = "현재 %s 공격대가 끝났습니다."
--L["event last update"] = "이벤트 마지막 업데이트"
L["Item %d is already in the Item Options list."] = "아이템 옵션의 리스트에 아이템(%d)은 있습니다."
L["Joining new raid at %s."] = "새로운 %s 공격대에 참가했습니다."
L["Looted by: %s"] = "획득자 : %s"
--L["Looted by: %s%s"] = "획득자 : %s%s"
L["Looted %s"] = "획득자 %s"
--L["Selected sections have been copied."] = "선택된 섹션을 복사되었습니다."
L["Snapshotting current raid."] = "현재 레이드의 간단한 정보를 복사합니다."
L["Setting current session zone to %s %s."] = "%s %s 새로운 세션 지역으로 설정합니다."
L["Wipe has been recorded."] = "닦음(?)은 기록되었다."

L["%s: Could not add %s"] = "%s: %s 추가 하지 못했습니다."
L["%s: Must be a current open raid."] = "%s: 현재 공격대를 열어야 합니다."
L["%s: Must supply an item link and a player name."] = "%s: 아이템 링크 및 플레이어 이름을 제공합니다."
L["%s: There is no raid selected"] = "%s: 공격대가 선택되지 않았습니다."

-- command menu
L["additem"] = "아이템 추가"
L["/rt - Shows the main window."] = "/루팅(rt) - 메인 창을 표시합니다."
L["/rt options|o - Shows Options window"] = "/루팅(rt) 옵션(o) - 설정창을 표시합니다."
L["/rt io - Shows the ItemOptions window"] = "/루팅(rt) 아이템옵션(io) - 아이템 설정창을 표시합니다."
L["/rt io [ITEMLINK|ITEMID]... - Adds items to ItemOptions window"] = "/루팅(rt) 아이템옵션(io) [ITEMLINK|ITEMID]... - 아이템 옵션창에 아이템을 추가합니다."
L["/rt additem [ITEMLINK] [PLAYER] - Adds a loot item to the selected raid"] = "/루팅(rt) 아이템추가(추가,additem,ai) [ITEMLINK] [PLAYER] - 선택한 공격대에 전리품 아이템을 추가합니다."
L["/rt join [PLAYER] - Add a player to the selected raid"] = "/루팅(rt) 입장(join) [PLAYER] - 선택한 공격대에 플레이어를 추가합니다."
L["/rt leave [PLAYER] - Removes a player from the selected raid"] = "/루팅(rt) 나감(leave) [PLAYER] - 선택한 공격대에서 플레이어를 삭제합니다."
L["/rt deleteall - Deletes all raids"] = "/루팅(rt) 삭제(deleteall) - 모든 공격대를 삭제합니다."
L["/rt debug 1|0 - Enables/Disables debug mode"] = "/루팅(rt) 디버그(debug) 1|0 - 디버그 모드를 활성화/비활성화 합니다."
L["/rt addwipe - Adds a Wipe with the current timestamp"] = "/루팅(rt) 추가와이프(addwipe) - 현재 타임 스탬프와 함께 추가합니다."

-- RaidTracker Frame
L["Back"] = "뒤로"
L["Boss"] = "보스"
L["Delete"] = "삭제"
L["End"] = "종료"
L["First join"] = "참가 시간"
L["Item name"] = "아이템 이름"
L["Items"] = "아이템"
L["Kill date"] = "처치 날짜"
L["Last leave"] = "떠난 시간"
L["Loot"] = " 루팅"
L["Looter"] = "획득자"
L["New"] = "신규"
L["Participants"] = "참가자"
L["Player name"] = "플레이어 이름"
L["Raid date"] = "레이드 날짜"
L["Raids"] = " 공격대"
L["Rarity"] = "품질"
--L["Raid Tracker"] = "RaidTracker"
L["Snapshot"] = "스냅샷"
L["Time looted"] = "획득 시간"
L["View Events"] = "보스킬 보기"
L["View Items"] = "아이템 보기"
L["View Loot"] = "루팅 보기"
L["View Players"] = "플레이어 보기"
L["View Raid"] = "공격대 보기"
L["View Raids"] = "공격대 보기"

-- Raid Log
L["10"] = "10인"
L["25"] = "25인"
L["Heroic"] = "|cffff0000영웅|r"

-- UI_Options
L["Advanced"] = "고급 설정"
L["Arenas"] = "투기장"
L["Attendees"] = "참석자"
L["Auto Event"] = "자동 보스킬"
L["Auto Zone"] = "자동 지역"
L["Battlegroups"] = "전장"
L["Debug Mode"] = "디버그 모드"
L["Event Cooldown"] = "보스킬 간격"
L["Export Level"] = "최대 레벨"
L["Export Format"] = "형식 내보내기"
L["Guildies"] = "길드"
L["Item Quality"] = "아이템 품질"
L["Logging"] = "기록 설정"
L["Max to Stack"] = "중첩하는 최대 아이템"
L["Min iLevel"] = "최소 레벨"
L["Min Rarity"] = "최소 품질"
L["Min to Ask Cost"] = "최소 포인트 묻기"
L["Min to Get Cost"] = "포인트 획득 최소 묻기"
L["Parties"] = "파티"
L["Show Tooltips"] = "툴팁 표시"
L["Solo"] = "솔로잉"
L["Wipes"] = "wipe 요구 백분율"

-- UI_Options options
L["All"] = "모두"
L["Ask at %s"] = "%s에 묻기"
L["Ask Next"] = "다음 묻기"
L["Auto Create"] = "신규시 자동"
L["Auto Instance"] = "인던시 자동"
L["Both"] = "둘다"
L["Default"] = "기본값"
L["Essential"] = "중요정보만"
L["Never"] = "하지않음"
L["Off"] = "끄기"
L["On event"] = "보스킬"
L["On event (All)"] = "보스킬(모두)"
L["On event (Both)"] = "보스킬(둘다)"
L["On event (Online)"] = "보스킬(접속중)"
L["On event (Zone)"] = "보스킬(같은지역)"
L["On loot"] = "루팅"
L["On loot (Both)"] = "루팅(둘다)"
L["On loot (Online)"] = "루팅(접속중)"
L["On loot (Zone)"] = "루팅(같은지역)"
L["On mouseover"] = "마우스오버"
L["Online"] = "온라인"
L["Plain Text"] = "일반 텍스트"
L["Unsaved"] = "저장안함"
L["Zone"] = "지역"

-- UI_ItemOptions
L["Ask Cost"] = "포인트 묻기"
L["Get Cost"] = "획득 포인트 묻기"
L["Item ID: "] = "아이템 ID: "
L["Log"] = "기록"
L["Stack"] = "중첩"
L["Unknown"] = "알수 없음"
L["Unknown (ID: "] = "알수없음 (ID: "

-- UI_Dialog
L["Bank"] = "은행"
L["Export String"] = "형식(문자열) 내보내기"
L["Join"] = "참여"
L["Leave"] = "나감"
L["Maybe"] = true
L["Name"] = "이름"
L["No"] = "아니오"
L["Yes"] = "예"

-- UI_Button
L["Disenchant"] = "마력추출"
L["Dropped from"] = "획득 지역(보스)"
L["Edit Cost"] = "포인트 수정"
L["Edit Count"] = "획득수 수정"
L["Edit End"] = "종료 수정"
L["Edit Item Options"] = "아이템 옵션 수정"
L["Edit Looter"] = "획득자 수정"
L["Edit Note"] = "메모 수정"
L["Edit Start"] = "시작 수정"
L["Edit Time"] = "시간 수정"
L["Edit Zone"] = "지역 수정"
L["None"] = "없음"
L["Show Export String"] = "형식 내보내기 보기"

-- UI_Templates
--L["Button"] = "버튼"
L["Done"] = "확인"
L["Save"] = "저장"
L["Title"] = "제목"

