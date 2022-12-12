/// <reference path="Config.ts"/>

type MpOverlayExtended = mp.OSDOverlay & { hidden: boolean }

function WrapLine(line: string, text: string): string {
	return `${text}${line}${text}`
}

function WrapFont(line: string, font: string): string {
	return WrapLine(line, `{\\fn${font}}`)
}

class Overlay {
	private overlay: MpOverlayExtended
	private options: Config

    constructor(options: Config) {
		this.overlay = mp.create_osd_overlay('ass-events') as MpOverlayExtended
		this.options = options
    }

    remove() {
        this.overlay.remove()
    }

    hide() {
        this.overlay.hidden = true
		this.overlay.update()
    }

    reveal() {
        this.overlay.hidden = false
		this.overlay.update()
	}
	
	setTranslation(primary: string, original: string) {
		this.overlay.data = ''

		if(this.options.primaryOriginal)
			[primary, original] = [original, primary]

		if(!this.options.translatedOnly)
			this.overlay.data = `{\\fscx50\\fscy50}${original}\n`

		this.overlay.data = WrapFont(WrapLine(`${this.overlay.data}${primary}`, '{\\a2}'), this.options.osdFont)
		this.overlay.update()
	}
}
