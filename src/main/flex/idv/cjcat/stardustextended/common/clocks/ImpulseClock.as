package idv.cjcat.stardustextended.common.clocks {
import idv.cjcat.stardustextended.cjsignals.Signal;
import idv.cjcat.stardustextended.common.xml.XMLBuilder;

/**
	 * The impulse clock causes the emitter to create a single burst of particles right after the <code>impulse()</code> method is called.
	 */
	public class ImpulseClock extends Clock {

		public static const DEFAULT_BURST_INTERVAL : Number = 33;

		private const DISCHARGE_COMPLETE: Signal = new Signal();

		/**
		 * The time between bursts. You have to implement this functionality, Stardust is not using this property.
		 */
		private var _burstInterval:Number;
		private var _nextBurstTime:Number;

		/**
		 * How many particles to burst out after each <code>impulse()</code> call.
		 */
		public var impulseCount:int;
		private var _repeatCount:int;
		private var _dischargeCount:int;
		private var _discharged:Boolean;
		private var _dischargeLimit: int;
		private var _cumulativeDischarges: uint;

		
		public function ImpulseClock(impulseCount:int = 0, repeatCount:int = 1) {
			this.impulseCount = impulseCount;
			this.repeatCount = repeatCount;
			this.burstInterval = DEFAULT_BURST_INTERVAL;

			_discharged = true;
			_dischargeLimit = -1;
			_cumulativeDischarges = 0;
		}

		/**
		 * The repetition count of bursting.
		 * 
		 * <p>
		 * For instance, if set to 2, after the <code>impulse()</code> method is called, 
		 * the following successive two <code>getTicks()</code> call would both return a value equal to the <code>impulseCount</code> property. 
		 * After that, the <code>getTicks()</code> method simply returns zero before the next <code>impulse()</code> method call.
		 * </p>
		 */
		public function get repeatCount():int { return _repeatCount; }
		public function set repeatCount(value:int):void {
			if (value < 1) value = 1;
			_repeatCount = value;
		}

		public function get burstInterval() : int {
			return _burstInterval;
		}

		public function set burstInterval(value : int) : void
		{
			_burstInterval = value;
			_nextBurstTime = 0;
		}

		public function get nextBurstTime() : Number {
			return _nextBurstTime;
		}

		public function get dischargeComplete() : Signal
		{
			return DISCHARGE_COMPLETE;
		}

		/**
		 * The emitter step after the <code>impulse()</code> call creates a burst of particles.
		 *
		 * @param currentTime Current time used as a reference point for setting next discharge time.
		 * (Note: This parameter is now needed since when time accumulated by the emmiter is not an integer there is
		 * no way to tell whether impulse should be triggered based on emmiter.currentTime % burstInterval, as it used to be done.)
		 */
		public function impulse(currentTime : Number):void {
			if(_cumulativeDischarges>=_dischargeLimit && !isInfinite())
			{
				return;
			}
			_dischargeCount = 0;
			_discharged = false;
			_nextBurstTime = currentTime + _burstInterval;
		}
		
		override public final function getTicks(time:Number):int {
			var ticks:int;
			if (!_discharged) {
				if (_dischargeCount >= repeatCount) {
					_discharged = true;
					ticks = 0;
					_cumulativeDischarges++
					DISCHARGE_COMPLETE.dispatch();
				} else {
					ticks = impulseCount;
					_dischargeCount++;
				}
			} else {
				ticks = 0;
			}
			return ticks;
		}

		private function isInfinite() : Boolean
		{
			return _dischargeLimit<=0;
		}

		public function get dischargeLimit() : int
		{
			return _dischargeLimit;
		}

		public function set dischargeLimit(value : int) : void
		{
			_dischargeLimit = value;
		}

        override public function reset() : void
        {
            _discharged = true;
            _dischargeCount = 0;
	        _nextBurstTime = 0;
	        _cumulativeDischarges = 0;
        }

		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "ImpulseClock";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@impulseCount = impulseCount;
			xml.@repeatCount = repeatCount;
			xml.@burstInterval = burstInterval;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@impulseCount.length()) impulseCount = parseInt(xml.@impulseCount);
			if (xml.@repeatCount.length()) repeatCount = parseInt(xml.@repeatCount);
			if (xml.@burstInterval.length()) burstInterval = parseInt(xml.@burstInterval);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML

}
}