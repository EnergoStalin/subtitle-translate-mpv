# SubtitleTranslateMPV
[![wakatime](https://wakatime.com/badge/user/e95ece5f-54ed-4ef2-9ff3-b88a5a8bfc5c/project/018c75c5-8ed3-419b-bcee-46019d97f66a.svg)](https://wakatime.com/badge/user/e95ece5f-54ed-4ef2-9ff3-b88a5a8bfc5c/project/018c75c5-8ed3-419b-bcee-46019d97f66a)

![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)

> :memo:
> `~~` reffering to [mpv config folder](https://mpv.io/manual/stable/#script-location)

> :memo: You can benchmark defaultDelay by executing benchmark-sub-translator script message [see](#receiptrecommended-inputconf)

Modular script for auto translating subtitles on the fly into multiple languages.
You can extend it with you favorite translator by contributing one.
## :herb:Features
- Auto enable when `toLang` not match any subtitle stream.
- Auto correct subtitle offset for comfort watching without delays.
- Register 4 script messages what you can bind via `~~/input.conf`.
    - Toggle messages
        - sub-translated-only
        - sub-primary-original
    - enable-sub-translator
    - disable-sub-translator
    - benchmark-sub-translator

## :bug:Known issues
- Encoding in some languages with crow provider under windows [#2](https://github.com/EnergoStalin/subtitle-translate-mpv/issues/2)
- Subtitle rendering in `translatedOnly=no` mode can go slightly out of screen

## :arrow_down:Install
- Clone repository into `~~/scripts` folder
```
git clone --depth 1 https://github.com/EnergoStalin/subtitle-translate-mpv.git
```
- Setup default settings for mpv and script itself described below
- Install dependencies described below and make sure them accessible from path

## :gear:Options
Avalible options `~~/script-opts/<cloned_folder_name>.conf`([see mp.get_script_name()](https://mpv.io/manual/stable/#lua-scripting-mp-get-script-name())) with default values
```conf
# Initial subtitle delay for translator
defaultDelay=-0.5
# Which script to use as translator(see translators folder in repository)
translator=crow
# Show only primary text
translatedOnly=yes
# Use original text as primary
primaryOriginal=no
# Used in translator
fromLang=en
toLang=ru
# Full font name for showed text defaults to osd-font mpv property and can be omitted
osdFont=Anime Ace v3
# defaults to osd-font-size
osdFontSize=36
# Override all subtitle fonts to osdFont
overrideFonts=yes
# When any subitle stream language don't match toLang
# (match performed by lua string.find())
# Or there any external subtitle with unknown language
autoEnableTranslator=yes
# How fast delay adjusts default is 8 translate requests(ticks)
sensitivity=8
```
## :receipt:Recommended input.conf
```conf
CTRL+t script-message enable-sub-translator
CTRL+T script-message disable-sub-translator
ALT+t script-message sub-translated-only
ALT+o script-message sub-primary-original

# Will run benchmark to determine optimal defaultDelay for current translator
# Check console for output
ALT+b script-message benchmark-sub-translator
```
## :warning:Optional but for now required dependencies
CrowTranslate for translation text see [crow.lua](https://github.com/EnergoStalin/subutils-mpv/blob/master/modules/translators/crow.lua)
> :warning::warning::warning: Crow may decide to encode your language not into utf-8 then **script will not work**(fixed for russian by tricking [encoding](https://github.com/EnergoStalin/subtitle-translate-mpv/blob/master/modules/translators/encodings/auto.lua)) should work for major languages tho

Avalible via winget
```powershell
winget install --id CrowTranslate.CrowTranslate
```
