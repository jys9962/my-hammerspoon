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
`Hyper+shift+key`는 실행할 앱을 고르는 팝업을 띄웁니다. 저장된 선택이 없으면 첫 번째 앱이 기본값입니다.

```
OptionKey.register('1', {
    'com.jetbrains.pycharm',
    'com.jetbrains.PhpStorm',
})
```
