package idv.cjcat.stardust.common.actions.triggers {
	import idv.cjcat.stardust.common.actions.Action;
	import idv.cjcat.stardust.common.actions.CompositeAction;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	/**
	 * <code>ActionTrigger</code> is a conditional composite action.
	 * 
	 * <p>
	 * Only when the <code>testTrigger()</code> method returns true will the component actions' <code>update()</code> methods be called.
	 * </p>
	 */
	public class ActionTrigger extends CompositeAction {
		
		public var inverted:Boolean;
		
		public function ActionTrigger(inverted:Boolean = false) {
			this.inverted = inverted;
		}
		
		/**
		 * [Abstract Method] If this method returns true, the <code>update()</code> methods of the component actions are called.
		 * @param	emitter
		 * @param	particle
		 * @param	time
		 * @return
		 */
		public function testTrigger(emitter:Emitter, particle:Particle, time:Number):Boolean {
			//abstract method
			return false;
		}
		
		//
		/**
		 * Used if the trigger is added to a composite action.
		 * @param	emitter
		 * @param	particle
		 * @param	time
		 */
		override public final function update(emitter:Emitter, particle:Particle, time:Number):void {
			var aa:Array = actionCollection.actions;
			var testResult:Boolean = testTrigger(emitter, particle, time);
			if (inverted) testResult = !testResult;
			if (testResult) {
				for each (var action:Action in aa) {
					action.update(emitter, particle, time);
				}
			}
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "ActionTrigger";
		}
		
		override public function getElementTypeXMLTag():XML {
			return <triggers/>;
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			if (xml.@inverted.length()) xml.@inverted = inverted;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			inverted = (xml.@inverted == "true");
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}