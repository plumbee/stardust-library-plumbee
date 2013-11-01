package idv.cjcat.stardust.common.events {
	import flash.events.Event;
	import idv.cjcat.stardust.common.particles.ParticleCollection;
	
	/**
	 * Event dispatched by emitters.
	 */
	public class EmitterEvent extends Event {
		
		/**
		 * Dispatched when an emitter is empty (no particles in the particle list).
		 */
		public static const EMITTER_EMPTY:String = "stardustEmitterEmpty";
		
		/**
		 * Dispatched when particles are added or created in an emitter.
		 */
		public static const PARTICLES_ADDED:String = "stardustEmitterParticleAdded";
		/**
		 * Dispatched when particles are removed from an emitter.
		 */
		public static const PARTICLES_REMOVED:String = "stardustEmitterParticleRemoved";
		/**
		 * Dispatched after each <code>Emitter.step()</code> call.
		 */
		public static const STEPPED:String = "stardustEmitterStepped";
		
		private var _particles:ParticleCollection;
		public function EmitterEvent(type:String, particles:ParticleCollection) {
			super(type);
			_particles = particles;
		}
		
		/**
		 * The associated particles.
		 */
		public function get particles():ParticleCollection { return _particles; }
	}
}