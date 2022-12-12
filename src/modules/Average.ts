type MeasureFunc = () => number
type MeasureFuncNull = MeasureFunc | null

/**
 * Class handles average value generation
 */
class Average {
    private count: number = 1
    private last: number = 0

    constructor(private avg: number, private measure: MeasureFuncNull) { }

    /**
     * Resets class state with given values
     * @param avg new initial average
     * @param measure measure function
     */
    reset(avg: number, measure: MeasureFuncNull) {
        this.count = 1
        this.avg = avg
        this.measure = measure || this.measure
    }

    /**
     * Performs tick with measure function
     * @returns current average
     */
    tick(): number {
        if (this.measure === null) return 0
        
        if (this.last === 0) {
            this.avg += this.last - this.measure()
            this.last = 0
            this.count++
        } else {
            this.last = this.measure()
        }


        return this.avg / this.count
    }
}
