namespace Core.Translator {
    export abstract class Type {
        constructor(private fromLang: string, private toLang: string) {}
        abstract translate(value: string): string
    }
}
