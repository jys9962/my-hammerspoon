윈도우os의 win+숫자키 기능 대체입니다.

첫 번째 파라미터는 바인딩할 키 이며
두 번째 파라미터는 실행할 앱의 **bundleID** 입니다.
bundleID는 대상 앱을 포커스한 상태에서 `option+cmd+i`를 눌러 콘솔에서 확인할 수 있습니다.

```
local OptionKey = require('libs.optionKey.index')
OptionKey.register('1', 'com.jetbrains.rustrover')
OptionKey.register('2', 'com.naver.Whale')
```

두 번째 파라미터에 bundleID 배열을 넣으면 `Hyper+key`는 선택된 앱을 실행하고,
`Hyper+shift+key`는 실행할 앱을 고르는 alert를 띄웁니다. 키를 누른 채 같은 키를 반복하면
다음 앱으로 이동하고, 모든 modifier를 놓는 순간 선택이 저장됩니다. alert의 선택은 항상 목록의 첫 번째 앱에서 시작합니다.

```
OptionKey.register('1', {
    'com.jetbrains.pycharm',
    'com.jetbrains.PhpStorm',
})
```
