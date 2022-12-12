/// <reference path="modules/Translator.ts"/>
/// <reference path="Config.ts"/>
/// <reference path="SubtitleView.ts"/>

class TranslatorImpl extends Core.Translator.Type {
    translate(value: string): string {
        return `ABOBA ${value}`
    }

}

(function () {
    const aboba = Core.Config.read('subutils-js')
    const overlay = new UI.Overlay(aboba)
    overlay.setTranslation(new TranslatorImpl('en', 'ru').translate('aboba'), 'aboba')
    
    dump(aboba)
})()
