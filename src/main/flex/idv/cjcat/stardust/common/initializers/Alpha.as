package idv.cjcat.stardust.common.initializers {
	import idv.cjcat.stardust.common.initializers.Initializer;
	import idv.cjcat.stardust.common.math.Random;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	
	/**
	 * Sets a particle's alpha value based on the <code>random</code> property.
	 */
	public class Alpha extends Initializer {
		
		private var _random:Random;
		public function Alpha(random:Random = null) {
			this.random = random;
		}
		
		override public final function initialize(particle:Particle):void {
			particle.initAlpha = particle.alpha = random.random();
		}
		
		public function get random():Random { return _random; }
		public function set random(value:Random):void {
			if (!value) value = new UniformRandom(1, 0);
			_random = value;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [_random];
		}
		
		override public function getXMLTagName():String {
			return "Alpha";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@random = _random.name;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@random.length()) random = builder.getElementByName(xml.@random) as Random;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}