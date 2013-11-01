package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.math.Random;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * Applies random acceleration to particles.
	 * 
	 * <p>
	 * Default priority = -3
	 * </p>
	 */
	public class RandomDrift extends Action2D {
		
		/**
		 * Whether the particles acceleration is divided by their masses before applied to them, true by default. 
		 * When set to true, it simulates a gravity that applies equal acceleration on all particles.
		 */
		public var massless:Boolean;
		/**
		 * The accleration's x component ranges from -maxX to maxX.
		 */
		public var maxX:Number;
		/**
		 * The accleration's y component ranges from -maxY to maxY.
		 */
		public var maxY:Number;
		private var _randomX:Random;
		private var _randomY:Random;
		public function RandomDrift(maxX:Number = 0.2, maxY:Number = 0.2, randomX:Random = null, randomY:Random = null) {
			priority = -3;
			
			this.massless = true;
			this.maxX = maxX;
			this.maxY = maxY;
			this.randomX = randomX;
			this.randomY = randomY;
		}
		
		/**
		 * The random object used to generate a random number for the acceleration's x component in the range [-maxX, maxX], uniform random by default. 
		 * You don't have to set the ranodm object's range. The range is automatically set each time before the random generation.
		 */
		public function get randomX():Random { return _randomX; }
		public function set randomX(value:Random):void {
			if (!value) value = new UniformRandom();
			_randomX = value;
		}
		
		/**
		 * The random object used to generate a random number for the acceleration's y component in the range [-maxX, maxX], uniform random by default. 
		 * You don't have to set the ranodm object's range. The range is automatically set each time before the random generation.
		 */
		public function get randomY():Random { return _randomY; }
		public function set randomY(value:Random):void {
			if (!value) value = new UniformRandom();
			_randomY = value;
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			var p2D:Particle2D = Particle2D(particle);
			
			randomX.setRange( -maxX, maxX);
			randomY.setRange( -maxY, maxY);
			var rx:Number = randomX.random();
			var ry:Number = randomY.random();
			
			if (!massless) {
				var factor:Number = 1 / p2D.mask;
				rx *= factor;
				ry *= factor;
			}
			
			p2D.vx += rx * time;
			p2D.vy += ry * time;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [_randomX, _randomY];
		}
		
		override public function getXMLTagName():String {
			return "RandomDrift";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@massless = massless;
			xml.@maxX = maxX;
			xml.@maxY = maxY;
			xml.@randomX = _randomX.name;
			xml.@randomY = _randomY.name;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@massless.length()) massless = (xml.@massless == "true");
			if (xml.@maxX.length()) maxX = parseFloat(xml.@maxX);
			if (xml.@maxY.length()) maxY = parseFloat(xml.@maxY);
			if (xml.@randomX.length()) randomX = builder.getElementByName(xml.@randomX) as Random;
			if (xml.@randomY.length()) randomY = builder.getElementByName(xml.@randomY) as Random;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}