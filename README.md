# SubUtil
[![wakatime](https://wakatime.com/badge/user/e95ece5f-54ed-4ef2-9ff3-b88a5a8bfc5c/project/ff0b8a46-c4f1-4805-a7a2-096874f3ed18.svg)](https://wakatime.com/badge/user/e95ece5f-54ed-4ef2-9ff3-b88a5a8bfc5c/project/ff0b8a46-c4f1-4805-a7a2-096874f3ed18)

Modular script for auto translating subtitles into multiple languages.
You can extend it with you favorite translator by contributing one.
## Features
- Auto enable when `toLang` not match any subtitle stream.
- Auto correct subtitle offset for comfort watching without delays.
- Register 3 script messages what you can bind via `~~/input.conf`.
    - Toggle messages
        - sub-translated-only
        - sub-primary-original
    - enable-sub-translator
    - disable-sub-translator
    - sub-to-clipboard
    `Copy original subtitle text to clipboard via powershell set-clipboard`
## Options
Avalible options `~~/script-opts/subutil.conf` with default values
```conf
defaultDelay = -0.5
translator = "crow" # Which script to use as translator(see translators folder in repository)
translatedOnly = yes # Show only primary text
primaryOriginal = yes # Use original text as primary
fromLang = "en"
toLang = "ru"
autoEnableTranslator = yes
```
## Recommended input.conf
```conf
CTRL+S script-message sub-to-clipboard
CTRL+t script-message enable-sub-translator
CTRL+T script-message disable-sub-translator
ALT+t script-message sub-translated-only
ALT+o script-message sub-primary-original
```
## Optional but for now required dependencies
CrowTranslate for translation text see [crow.lua](https://github.com/EnergoStalin/subutils-mpv/blob/master/modules/translators/crow.lua)
Avalible via windows
```powershell
winget install --id CrowTranslate.CrowTranslate
```