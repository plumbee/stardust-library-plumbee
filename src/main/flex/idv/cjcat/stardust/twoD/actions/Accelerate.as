package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.Vec2D;
	import idv.cjcat.stardust.twoD.geom.Vec2DPool;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * Accelerates particles along their velocity directions.
	 */
	public class Accelerate extends Action2D {
		
		/**
		 * The amount of acceleration in each emitter step.
		 */
		public var acceleration:Number;
		
		public function Accelerate(acceleration:Number = 0.1) {
			this.acceleration = acceleration;
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			var p2D:Particle2D = Particle2D(particle);
			var v:Vec2D = Vec2DPool.get(p2D.vx, p2D.vy);
			if (v.length > 0) {
				v.length += acceleration * time;
				p2D.vx = v.x;
				p2D.vy = v.y;
			}
			Vec2DPool.recycle(v);
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Accelerate";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@acceleration = acceleration;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@acceleration.length()) acceleration = parseFloat(xml.@acceleration);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}