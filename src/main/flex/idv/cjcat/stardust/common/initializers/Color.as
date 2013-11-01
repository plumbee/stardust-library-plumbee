package idv.cjcat.stardust.common.initializers {
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	
	public class Color extends Initializer {
		
		public var color:uint;
		
		public function Color(color:uint = 0xFFFFFF) {
			this.color = color;
		}
		
		override public final function initialize(particle:Particle):void {
			particle.color = color;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Color";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@color = color.toString(16);
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@color.length()) color = parseInt(xml.@color, 16);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}