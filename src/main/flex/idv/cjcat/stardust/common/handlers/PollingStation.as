package idv.cjcat.stardust.common.handlers {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleCollection;
	import idv.cjcat.stardust.common.particles.ParticleFastArray;
	
	/**
	 * This handler works as a polling station. Use it as an ordinary particle handler, 
	 * and after each emitter step, you may poll the <code>particlesAdded</code>, <code>particlesRemoved</code>, and <code>particles</code> properties 
	 * in order to traverse the new particles added, the removed dead particles, and the particles that are currently living, 
	 * respectively, after each emitter step.
	 */
	public final class PollingStation extends ParticleHandler {
		
		private var _particlesAdded:ParticleCollection = new ParticleFastArray(false);
		public final function get particlesAdded():ParticleCollection { return _particlesAdded; }
		
		private var _particlesRemoved:ParticleCollection = new ParticleFastArray(false);
		public final function get particlesRemoved():ParticleCollection { return _particlesRemoved;}
		
		private var _emitter:Emitter;
		public final function get particles():ParticleCollection {
			return (Boolean(_emitter))?(_emitter.particles):(null);
		}
		
		public function PollingStation() {
			
		}
		
		override public final function stepBegin(emitter:Emitter, particles:ParticleCollection, time:Number):void {
			_particlesAdded.clear();
			_particlesRemoved.clear();
			_emitter = emitter;
		}
		
		override public final function particleAdded(particle:Particle):void {
			_particlesAdded.add(particle);
		}
		
		override public final function particleRemoved(particle:Particle):void {
			_particlesRemoved.add(particle);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "PollingStation";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}