package idv.cjcat.stardust.common.clocks {
	import idv.cjcat.stardust.common.StardustElement;
	
	/**
	 * A clock is used by an emitter to determine how frequently particles are created.
	 * 
	 * @see idv.cjcat.stardust.common.emitters.Emitter
	 */
	public class Clock extends StardustElement {
		
		public function Clock() {
			
		}
		
		/**
		 * [Template Method] On each <code>Emitter.step()</code> call, this method is called.
		 * 
		 * <p>
		 * The returned value tells the emitter how many particles it should create.
		 * </p>
		 * @param	time	The timespan of each emitter's step.
		 * @return
		 */
		public function getTicks(time:Number):int {
			return 0;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getElementTypeXMLTag():XML {
			return <clocks/>;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}