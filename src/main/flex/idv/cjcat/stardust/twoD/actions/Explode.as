package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.Vec2D;
	import idv.cjcat.stardust.twoD.geom.Vec2DPool;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * Creates a shock wave that spreads out from a single point, applying acceleration to particles along the way of propogation.
	 */
	public class Explode extends Action2D {
		
		/**
		 * The X coordinate of the center.
		 */
		public var x:Number;
		/**
		 * The Y coordinate of the center.
		 */
		public var y:Number;
		/**
		 * The strength of the shockwave.
		 */
		public var strength:Number;
		/**
		 * The speed of shockwave propogation, in pixels per emitter step.
		 */
		public var growSpeed:Number;
		/**
		 * The shockwave would not affect particles beyond this distance.
		 */
		public var maxDistance:Number;
		/**
		 * The attenuation power of the shockwave, in powers per pixel.
		 */
		public var attenuationPower:Number;
		/**
		 * If a particle is closer to the center than this value, it's treated as if it's this distance away from the center. 
		 * This is to prevent the simulation to blow up for particles too close to the center.
		 */
		public var epsilon:Number;
		
		private var _discharged:Boolean;
		private var _currentInnerRadius:Number;
		private var _currentOuterRadius:Number;
		
		public function Explode(x:Number = 0, y:Number = 0, strength:Number = 5, growSpeed:Number = 40, maxDistance:Number = 200, attenuationPower:Number = 0.1, epsilon:Number = 1) {
			this.x = x;
			this.y = y;
			this.strength = strength;
			this.growSpeed = growSpeed;
			this.maxDistance = maxDistance;
			this.attenuationPower = attenuationPower;
			this.epsilon = epsilon;
			
			_discharged = true;
		}
		
		/**
		 * Causes a shockwave to spread out from the center.
		 * @param	e
		 */
		public function explode():void {
			_discharged = false;
			_currentInnerRadius = 0;
			_currentOuterRadius = growSpeed;
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			if (_discharged) return;
			
			var p2D:Particle2D = Particle2D(particle);
			var r:Vec2D = Vec2DPool.get(p2D.x - x, p2D.y - y);
			var len:Number = r.length;
			if (len < epsilon) len = epsilon;
			if ((len >= _currentInnerRadius) && (len < _currentOuterRadius)) {
				r.length = strength * Math.pow(len, -attenuationPower);
				p2D.vx += r.x * time;
				p2D.vy += r.y * time;
			}
			
			Vec2DPool.recycle(r);
		}
		
		override public function postUpdate(emitter:Emitter, time:Number):void {
			if (_discharged) return;
			
			_currentInnerRadius += growSpeed;
			_currentOuterRadius += growSpeed;
			if (_currentInnerRadius > maxDistance) _discharged = true;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Explode";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@x = x;
			xml.@y = y;
			xml.@strength = strength;
			xml.@growSpeed = growSpeed;
			xml.@maxDistance = maxDistance;
			xml.@attenuationPower = attenuationPower;
			xml.@epsilon = epsilon;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@x.length()) x = parseFloat(xml.@x);
			if (xml.@y.length()) y = parseFloat(xml.@y);
			if (xml.@strength.length()) strength = parseFloat(xml.@strength);
			if (xml.@growSpeed.length()) growSpeed = parseFloat(xml.@growSpeed);
			if (xml.@maxDistance.length()) maxDistance = parseFloat(xml.@maxDistance);
			if (xml.@attenuationPower.length()) attenuationPower = parseFloat(xml.@attenuationPower);
			if (xml.@epsilon.length()) epsilon = parseFloat(xml.@epsilon);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}