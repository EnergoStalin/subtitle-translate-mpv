/// <reference path="Config.ts"/>
/// <reference path="modules/Average.ts"/>
/// <reference path="modules/Translator.ts"/>
/// <reference path="Overlay.ts"/>

namespace UI {
    export class SubtitleView {
        private average: Core.Utility.Average.Type
        constructor(private overlay: Overlay, private translator: Core.Translator.Type, private config: Core.Config.Type) {
            this.average = new Core.Utility.Average.Type(-0.5, mp.get_time)
        }
        
        onSubChanged() {
            let value = mp.get_property('sub-text-ass')
    
            if (value === null || value === '') {
                this.overlay.hide()
                return
            }
    
            value = value!.replace(/\\([nN])/, '\\$1')
            let data: string
    
            try {
                data = this.translator.translate(value)
            } catch (ex) {
                dump(ex)
                return
            }
    
            this.average.tick()
            this.overlay.setTranslation(data, value)
    
            mp.set_property_number('sub-delay', this.config.defaultDelay - this.average.tick())
    
            this.overlay.reveal()
        }
    }
}
