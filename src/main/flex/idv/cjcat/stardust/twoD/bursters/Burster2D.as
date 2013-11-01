package idv.cjcat.stardust.twoD.bursters {
	import idv.cjcat.stardust.common.bursters.Burster;
	import idv.cjcat.stardust.twoD.particles.Particle2DFactory;
	
	/**
	 * Base class for 2D bursters.
	 */
	public class Burster2D extends Burster {
		
		public function Burster2D() {
			factory = new Particle2DFactory();
		}
	}
}