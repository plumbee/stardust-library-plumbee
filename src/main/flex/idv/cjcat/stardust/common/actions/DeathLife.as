package idv.cjcat.stardust.common.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	
	/**
	 * Mark a particle as dead if its life reaches zero.
	 * <p>
	 * Remember to add this action to the emitter if you wish particles to be removed from simulation when their lives reach zero. 
	 * Otherwise, the particles will not be removed.
	 * </p>
	 * 
	 * <p>
	 * Default priority = -1;
	 * </p>
	 */
	public class DeathLife extends Action {
		
		public var threshold:Number;
		public function DeathLife() {
			
		}
		
		override public final function update(emitter:Emitter, particle:Particle, time:Number):void {
			if (particle.life <= 0) {
				particle.isDead = true;
			}
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "DeathLife";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}