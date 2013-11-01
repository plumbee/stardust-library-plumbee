package idv.cjcat.stardust.common.particles {
	
	public class ParticleFastArrayIterator implements ParticleIterator {
		
		/** @private */
		internal var index:int;
		/** @private */
		internal var array:ParticleFastArray;
		/** @private */
		internal var internalArray:Array;
		
		public function ParticleFastArrayIterator(array:ParticleFastArray = null) {
			this.array = array;
			this.internalArray = array.internalArray;
			reset();
		}
		
		/**
		 * @inheritDoc
		 */
		public final function reset():void {
			index = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function next():void {
			if (index <= array.index) ++index;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function particle():Particle {
			return internalArray[index];
		}
		
		/**
		 * @inheritDoc
		 */
		public final function remove():void {
			if (index == (array.index - 1)) {
				//remove the last availble particle for this iterator
				internalArray[index] = null;
				--array.index;
			} else {
				//regular particle removal
				internalArray[index] = internalArray[array.index - 1];
				--array.index;
				internalArray[array.index] = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public final function clone():ParticleIterator {
			var iter:ParticleFastArrayIterator = new ParticleFastArrayIterator(array);
			iter.index = index;
			return iter;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function dump(target:ParticleIterator):ParticleIterator {
			var iter:ParticleFastArrayIterator = ParticleFastArrayIterator(target);
			if (iter) {
				iter.array = array;
				iter.internalArray = internalArray;
				iter.index = index;
			}
			return iter;
		}
	}
}