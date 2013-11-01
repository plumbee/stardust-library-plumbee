package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * [Abstract Class] This is an abstract class for mutual actions such as collision and mutual gravity.
	 * 
	 * <p>
	 * You can use mask to filter out which particles would interact. 
	 * Only particles whose masks' bitwise AND value is non-zero will interact.
	 * </p>
	 */
	public class MutualAction extends Action2D {
		
		/**
		 * Only when the distance between two particles is less than this value will these particles be processed.
		 */
		public var maxDistance:Number;
		
		public function MutualAction() {
			
		}
		
		private var j:ParticleIterator;
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			var p1:Particle2D = Particle2D(particle);
			var p2:Particle2D;
			var i:ParticleIterator = particle.sortedIndexIterator;
			j = i.clone();
			while (p1 = Particle2D(i.particle())) {
				p1.sortedIndexIterator.dump(j);
				j.next();
				while (p2 = Particle2D(j.particle())) {
					if ((p2.x - p1.x) <= maxDistance) {
						if (p1.mask & p2.mask) doMutualAction(p1, p2, time);
					} else {
						break;
					}
					j.next();
				}
				i.next();
			}
		}
		
		protected function doMutualAction(p1:Particle2D, p2:Particle2D, time:Number):void {
			
		}
		
		/**
		 * Tells the emitter that this action needs sorted particles.
		 */
		override public final function get needsSortedParticles():Boolean {
			return active;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "MutualAction";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@maxDistance = maxDistance;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@maxDistance.length()) maxDistance = parseFloat(xml.@maxDistance);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}