package idv.cjcat.stardust.threeD.actions.triggers  {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.threeD.actions.triggers.ActionTrigger3D;
	import idv.cjcat.stardust.threeD.deflectors.Deflector3D;
	
	/**
	 * <p>
	 * Default priority = -6;
	 * </p>
	 */
	public class DeflectorTrigger3D extends ActionTrigger3D {
		
		public var deflector:Deflector3D;
		
		public function DeflectorTrigger3D(deflector:Deflector3D = null) {
			priority = -6;
			
			this.deflector = deflector;
		}
		
		override public final function testTrigger(emitter:Emitter, particle:Particle, time:Number):Boolean {
			return Boolean(particle.dictionary[deflector]);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [deflector];
		}
		
		override public function getXMLTagName():String {
			return "DeflectorTrigger3D";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			if (deflector) xml.@deflector = deflector.name;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@deflector.length()) deflector = builder.getElementByName(xml.@deflector) as Deflector3D;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}