윈도우os의 win+숫자키 기능 대체입니다.

첫 번째 파라미터는 바인딩할 키 이며
두 번째 파라미터는 실행할 앱 이름 입니다.  
App 이름으로 실행할 프로그램을 못찾는 케이스는 실행 프로그램명을 세번째 인자로 받습니다.

```
local OptionKey = require('libs.optionKey.index')
OptionKey.register('1', 'RustRover')
OptionKey.register('2', 'NAVER Whale', 'Whale.app')
```

두 번째 파라미터에 앱 배열을 넣으면 `Hyper+key`는 선택된 앱을 실행하고,
`Hyper+shift+key`는 실행할 앱을 고르는 팝업을 띄웁니다. 저장된 선택이 없으면 첫 번째 앱이 기본값입니다.

```
OptionKey.register('1', {
    { appName = 'PyCharm', launchName = 'PyCharm.app' },
    { appName = 'PhpStorm', launchName = 'PhpStorm.app' },
})
```
