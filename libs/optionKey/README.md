윈도우os의 win+숫자키 기능 대체입니다.

첫 번째 파라미터는 바인딩할 키 이며
두 번째 파라미터는 실행할 앱 이름 입니다.  
App 이름으로 실행할 프로그램을 못찾는 케이스는 실행 프로그램명을 세번째 인자로 받습니다.

```
local OptionKey = require('libs.optionKey.index')
OptionKey.register('1', 'RustRover')
OptionKey.register('2', 'NAVER Whale', 'Whale.app')
```
