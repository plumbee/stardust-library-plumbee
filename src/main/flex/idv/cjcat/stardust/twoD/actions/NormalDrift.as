package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.math.Random;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.Vec2D;
	import idv.cjcat.stardust.twoD.geom.Vec2DPool;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * Applies acceleration normal to a particle's velocity to the particle.
	 */
	public class NormalDrift extends Action2D {
		
		/**
		 * Whether the particles acceleration is divided by their masses before applied to them, true by default. 
		 * When set to true, it simulates a gravity that applies equal acceleration on all particles.
		 */
		public var massless:Boolean;
		/**
		 * The accleration ranges from -max to max.
		 */
		public var max:Number;
		private var _random:Random;
		public function NormalDrift(max:Number = 0.2, random:Random = null) {
			this.massless = true;
			this.max = max;
			this.random = random;
		}
		
		/**
		 * The random object used to generate a random number for the acceleration in the range [-max, max], uniform random by default. 
		 * You don't have to set the ranodm object's range. The range is automatically set each time before the random generation.
		 */
		public function get random():Random { return _random; }
		public function set random(value:Random):void {
			if (!value) value = new UniformRandom();
			_random = value;
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			var p2D:Particle2D = Particle2D(particle);
			var v:Vec2D = Vec2DPool.get(p2D.vy, p2D.vx);
			random.setRange( -max, max);
			v.length = random.random();
			if (!massless) v.length /= p2D.mass;
			p2D.vx += v.x * time;
			p2D.vy += v.y * time;
			Vec2DPool.recycle(v);
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [_random];
		}
		
		override public function getXMLTagName():String {
			return "NormalDrift";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@massless = massless;
			xml.@max = max;
			xml.@random = _random.name;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@massless.length()) massless = (xml.@massless == "true");
			if (xml.@max.length()) max = parseFloat(xml.@max);
			if (xml.@random.length()) random = builder.getElementByName(xml.@random) as Random;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}