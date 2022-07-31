# SubUtil
Modular script for auto translating subtitles into multiple languages.
You can extend it with you favorite translator by contributing one.
## Features
- Auto enable when `toLang` not match any subtitle stream.
- Auto correct subtitle offset for comfort watching without delays.
- Register 3 script messages what you can bind via `~~/input.conf`.
    - copy-sub-to-clipboard
    `copy original subtitle text to clipboard via powershell set-clipboard`
    - enable-sub-translator
    - disable-sub-translator
## Options
Avalible options `~~/script-opts/subutil.conf`
```
defaultDelay = -0.5
translator = "crow"
autoEnableTranslator = false
fromLang = "en"
toLang = "ru"
```
## Optional but for now required dependencies
CrowTranslate need for translate text see [crow.lua](https://github.com/EnergoStalin/subutils-mpv/blob/master/modules/translators/crow.lua)
Avalible via
```powershell
winget install --id CrowTranslate.CrowTranslate
```