package idv.cjcat.stardust.common.particles {
	import idv.cjcat.stardust.common.initializers.Initializer;
	
	/** @private */
	public class PooledParticleFactory extends ParticleFactory {
		
		protected var particlePool:ParticlePool;
		
		public function PooledParticleFactory() {
			particlePool = ParticlePool.getInstance();
		}
		
		private var p:Particle;
		override protected final function createNewParticle():Particle {
			return particlePool.get();
		}
		
		public final function recycle(particle:Particle):void {
			particlePool.recycle(particle);
		}
	}
}