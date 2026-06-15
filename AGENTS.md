# AGENTS.md

이 저장소는 개인 macOS 자동화 도구인 **Hammerspoon** 설정입니다. Lua로 작성되며, 앱 전환 단축키와 윈도우 관리 단축키를 제공합니다.

## 실행 / 리로드

빌드·테스트 도구는 없습니다. Hammerspoon 런타임이 직접 `init.lua`를 로드합니다.

- 설정 리로드: Hammerspoon이 실행 중이면 `option+cmd+r` (init.lua의 `initForHammerspoonConsole`에서 바인딩). 또는 메뉴바 Hammerspoon 아이콘 → Reload Config.
- 디버깅: `option+cmd+c`로 Hammerspoon 콘솔에 포커스. 콘솔에서 `print(...)` 출력 확인. `option+cmd+i`로 현재 포커스된 앱/윈도우 이름 출력.
- 변경 검증: 코드 수정 → 리로드 → 해당 단축키를 실제로 눌러 동작 확인. 단위 테스트가 없으므로 런타임 확인이 유일한 검증 수단입니다.

## 모듈 구조

`init.lua`가 진입점이며, 하단의 `init*()` 함수들을 순차 호출해 단축키를 바인딩합니다. 새 기능을 추가할 때는 `libs/`에 모듈을 만들고 `init.lua`에서 `require` 후 초기화합니다.

각 기능 모듈(`libs/<feature>/`)은 다음 두 파일 패턴을 따릅니다:
- `index.lua` — `hs.hotkey.bind`로 키를 바인딩하고 `init`/`register` 같은 진입 함수를 export. **부수효과(바인딩)는 여기서만.**
- `Controller.lua` — 키가 눌렸을 때의 실제 로직. 순수하게 동작만 담당하고 키 바인딩은 모름.

`libs/util/`는 모든 모듈이 공유하는 유틸리티입니다.

## 핵심 아키텍처: 탭 방식 윈도우 전환

`optionKey`(앱별 단축키)와 `commandBacktick`(같은 앱 내 윈도우 순환)은 동일한 메커니즘을 공유합니다. 여러 파일이 맞물려 동작하므로 함께 이해해야 합니다:

- **`libs/util/TabAlert.lua`** — 전환 UI의 **상태를 가진 싱글톤**. `data` 테이블에 현재 탭 이름·윈도우 목록·선택 인덱스를 보관합니다. `startTab`으로 오버레이를 띄우고, `nextTab`/`beforeTab`이 인덱스를 순환시키며 `hs.alert`로 후보 목록을 다시 그립니다. **선택은 즉시 확정되지 않습니다** — 화면에 표시만 됩니다.
- **`libs/util/EventWatcher.lua`** — `flagsChanged` 이벤트를 감시해, **모든 모디파이어(alt/cmd/ctrl)가 떼어지는 순간** 등록된 콜백을 실행합니다. TabAlert는 여기에 콜백을 등록해, 사용자가 키를 놓으면 그때 `focusCurrentIndex()`로 선택된 윈도우에 실제 포커스를 주고 상태를 초기화합니다. → 이것이 "modifier 누른 채 숫자/백틱 연타 → 떼면 확정"이라는 OS 표준 앱 전환 UX의 구현 방식입니다.
- **`libs/util/Window.lua`** — 앱별 윈도우 목록을 `_window_map`에 **캐싱**해 순서를 안정적으로 유지합니다. `getList` 호출마다 기존 목록에서 닫힌 창을 제거하고 새 창을 뒤에 추가하므로, 연타 시 윈도우 순서가 흔들리지 않습니다. `isMaximizable()`로 유효 창만 필터링합니다.

즉 흐름은: Controller가 `Window.getList`로 후보를 얻어 `TabAlert.startTab` 호출 → 같은 단축키 재입력 시 `nextTab` → EventWatcher가 모디파이어 해제를 감지해 최종 포커스. 새로운 탭형 전환 기능을 만든다면 이 세 유틸을 그대로 재사용하세요.

## 함수형 유틸

`libs/util/Fp.lua`는 커링된 `map/filter/sort/reduce/concat/tap`과 `pipe`를 제공합니다. 모든 컬렉션 변환은 `Fp.pipe(tbl, Fp.filter(...), Fp.concat(...))` 형태로 작성하는 것이 이 저장소의 관례입니다(예: `Window.lua`의 윈도우 목록 갱신). `libs/util/ArrayUtil.lua`(some/every/findIndex), `libs/util/StringUtil.lua`(utf8Len/truncateString/repeatStr — 한글 폭 계산을 위해 UTF-8 길이를 직접 셈)도 함께 사용합니다.

## 주의사항

- `TabAlert.lua`에는 `getMessage`가 두 번 정의되어 있으며, Lua 특성상 **뒤(L84)의 정의가 실제로 사용**됩니다. 메시지 포맷을 바꿀 때 위쪽 정의는 무시됩니다.
- `init.lua`의 앱 등록 목록(`initOptionKey`)은 개인 환경에 맞춰진 하드코딩이며, 일부는 주석 처리되어 있습니다. 앱을 추가/변경할 때 `OptionKey.register(key, 앱이름, [실행파일명])` 형식을 따르고, App 이름으로 실행이 안 되는 경우에만 세 번째 인자(`*.app`)를 줍니다.
- 키 바인딩은 `option` 단독, `option+shift`(역방향), `option+cmd+ctrl`(Hyper) 조합을 사용합니다. 신규 단축키 추가 시 기존 바인딩과 충돌하지 않는지 `init.lua` 전체를 확인하세요.
