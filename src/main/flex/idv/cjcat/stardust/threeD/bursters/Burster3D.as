package idv.cjcat.stardust.threeD.bursters {
	import idv.cjcat.stardust.common.bursters.Burster;
	import idv.cjcat.stardust.threeD.particles.Particle3DFactory;
	
	/**
	 * Base class for 3D bursters.
	 */
	public class Burster3D extends Burster {
		
		public function Burster3D() {
			factory = new Particle3DFactory();
		}
	}
}