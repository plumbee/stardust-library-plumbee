package idv.cjcat.stardust.common.particles {
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	/**
	 * This is an object pool for particle objects.
	 * 
	 * <p>
	 * Be sure to recycle a particle after getting it from the pool.
	 * </p>
	 */
	public class ParticlePool {
		
		private static var _instance:ParticlePool;
		/**
		 * Returns the singleton of the pool.
		 * @return
		 */
		public static function getInstance():ParticlePool {
			if (!_instance) _instance = new ParticlePool();
			return _instance;
		}
		
		sd var particleClass:Class;
		private var _array:Array;
		private var _position:int;
		
		public function ParticlePool() {
			_array = [createNewParticle()];
			_position = 0;
		}
		
		/** @private */
		protected function createNewParticle():Particle {
			return new Particle();
		}
		
		public final function get():Particle {
			if (_position == _array.length) {
				_array.length <<= 1;
				
				//trace("ParticlePool expanded");
				
				for (var i:int = _position; i < _array.length; i++) {
					_array[i] = createNewParticle();
				}
			}
			_position++;
			
			return _array[_position - 1];
		}
		
		public final function recycle(particle:Particle):void {
			if (_position == 0) return;
			_array[_position - 1] = particle;
			if (_position) _position--;
			
			//if (_array.length >= 16) {
				//if (_position < (_array.length >> 4)) {
					
					//trace("ParticlePool contracted");
					
					//_array.length >>= 1;
				//}
			//}
		}
	}
}