package idv.cjcat.stardust.threeD.deflectors {
	import idv.cjcat.stardust.common.StardustElement;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.threeD.geom.MotionData6D;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	
	/**
	 * Used along with the <code>Deflect3D</code> action.
	 * 
	 * @see idv.cjcat.stardust.threeD.actions.Deflect3D
	 */
	public class Deflector3D extends StardustElement {
		
		public var active:Boolean;
		public var bounce:Number;
		
		public function Deflector3D() {
			active = true;
			bounce = 0.8;
		}
		
		public final function getMotionData6D(particle:Particle3D):MotionData6D {
			if (!active) return null;
			return calculateMotionData6D(particle);
		}
		
		/**
		 * [Abstract Method] Returns a <code>MotionData6D</code> object representing the deflected position and velocity coordinates for a particle.
		 * Returns null if no deflection occured. A non-null value can trigger the <code>DeflectorTrigger3D</code> action trigger.
		 * @param	particle
		 * @return
		 * @see idv.cjcat.stardust.threeD.actions.triggers.DeflectorTrigger3D
		 */
		protected function calculateMotionData6D(particle:Particle3D):MotionData6D {
			//abstract method
			return null;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Deflector3D";
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