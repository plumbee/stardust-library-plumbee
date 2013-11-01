package idv.cjcat.stardust.common.particles {
	import idv.cjcat.stardust.common.initializers.Initializer;
	import idv.cjcat.stardust.common.initializers.InitializerCollection;
	import idv.cjcat.stardust.common.initializers.InitializerCollector;
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	/**
	 * Each emitter has a particle factory for creating new particles. 
	 * This class is also used by bursters to manually create particles with associated initializers.
	 * @see idv.cjcat.stardust.common.bursters.Burster
	 * @see idv.cjcat.stardust.common.emitters.Emitter
	 */
	public class ParticleFactory implements InitializerCollector {
		
		/** @private */
		sd var initializerCollection:InitializerCollection;
		public function ParticleFactory() {
			initializerCollection = new InitializerCollection();
		}
		
		/**
		 * Creates particles with associated initializers.
		 * @param	count
		 * @return
		 */
		public final function createParticles(count:int):ParticleCollection {
			var i:int, len:int;
			var particles:ParticleCollection = new ParticleFastArray();
			for (i = 0; i < count; i++) {
				var particle:Particle = createNewParticle();
				particle.init();
				particles.add(particle);
			}
			
			var initializers:Array = initializerCollection.initializers;
			for (i = 0, len = initializers.length; i < len; ++i) {
				Initializer(initializers[i]).doInitialize(particles);
			}
			
			return particles;
		}
		
		/** @private */
		protected function createNewParticle():Particle {
			return new Particle();
		}
		
		/**
		 * Adds an initializer to the factory.
		 * @param	initializer
		 */
		public function addInitializer(initializer:Initializer):void {
			initializerCollection.addInitializer(initializer);
		}
		
		/**
		 * Removes an initializer from the factory.
		 * @param	initializer
		 */
		public final function removeInitializer(initializer:Initializer):void {
			initializerCollection.removeInitializer(initializer);
		}
		
		/**
		 * Removes all initializers from the factory.
		 */
		public final function clearInitializers():void {
			initializerCollection.clearInitializers();
		}
	}
}