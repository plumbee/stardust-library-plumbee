package idv.cjcat.stardust.twoD.deflectors {
	import idv.cjcat.stardust.common.StardustElement;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.MotionData4D;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * Used along with the <code>Deflect</code> action.
	 * 
	 * @see idv.cjcat.stardust.twoD.actions.Deflect
	 */
	public class Deflector extends StardustElement {
		
		public var active:Boolean;
		public var bounce:Number;
		
		public function Deflector() {
			active = true;
			bounce = 0.8;
		}
		
		public final function getMotionData4D(particle:Particle2D):MotionData4D {
			if (active) {
				return calculateMotionData4D(particle);
			}
			return null;
		}
		
		/**
		 * [Abstract Method] Returns a <code>MotionData4D</code> object representing the deflected position and velocity coordinates for a particle. 
		 * Returns null if no deflection occured. A non-null value can trigger the <code>DeflectorTrigger</code> action trigger.
		 * @param	particle
		 * @return
		 * @see idv.cjcat.stardust.twoD.actions.triggers.DeflectorTrigger
		 */
		protected function calculateMotionData4D(particle:Particle2D):MotionData4D {
			//abstract method
			return null;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Deflector";
		}
		
		override public function getElementTypeXMLTag():XML {
			return <deflectors/>;
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			
			xml.@active = active;
			xml.@bounce = bounce;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@active.length()) active = (xml.@active == "true");
			if (xml.@bounce.length()) bounce = parseFloat(xml.@bounce);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}