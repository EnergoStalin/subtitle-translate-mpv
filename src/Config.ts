import 'mp';

export interface Config {
    defaultDelay: number,
    translator: string,
    autoEnableTranslator: boolean,
    translatedOnly: boolean,
    primaryOriginal: boolean,
    fromLang: string,
    toLang: string,
    osdFont: string
}

const config: Config = {
    defaultDelay: -0.5,
    translator: 'crow',
    autoEnableTranslator: false,
    translatedOnly: false,
    primaryOriginal: false,
    fromLang: 'en',
    toLang: 'ru',
    osdFont: 'Arial'
}

export function readConfig(name: string): Config {
    mp.options.read_options(config as any, name)

    return config
}
