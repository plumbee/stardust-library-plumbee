package idv.cjcat.stardust.twoD.particles {
	import idv.cjcat.stardust.common.particles.PooledParticleFactory;
	
	/** @private */
	public class PooledParticle2DFactory extends PooledParticleFactory {
		
		public function PooledParticle2DFactory() {
			particlePool = Particle2DPool.getInstance();
		}
	}
}