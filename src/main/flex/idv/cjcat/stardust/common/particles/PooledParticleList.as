package idv.cjcat.stardust.common.particles {
	
	/** @private */
	public class PooledParticleList extends ParticleList {
		
		public function PooledParticleList() {
			
		}
		
		override protected final function createNode(particle:Particle):ParticleNode {
			return ParticleNodePool.get(particle);
		}
	}
}