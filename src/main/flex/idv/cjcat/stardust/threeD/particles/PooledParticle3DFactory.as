package idv.cjcat.stardust.threeD.particles {
	import idv.cjcat.stardust.common.particles.PooledParticleFactory;
	
	/** @private */
	public class PooledParticle3DFactory extends PooledParticleFactory {
		
		public function PooledParticle3DFactory() {
			particlePool = Particle3DPool.getInstance();
		}
	}
}