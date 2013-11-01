package idv.cjcat.stardust.common.particles {
	
	/**
	 * Array implementatoin of particle collection, with splicing operation even faster than linked-lists.
	 */
	public class ParticleFastArray implements ParticleCollection {
		
		/** @private */
		internal static const DEFAULT_ARRAY_SIZE:int = 32;
		/** @private */
		internal var internalArray:Array = new Array(DEFAULT_ARRAY_SIZE);
		/** @private */
		internal var index:int = 0; //points at the first null element
		
		public var shrinkInternalArrayOnClear:Boolean;
		
		public function ParticleFastArray(shrinkInternalArrayOnClear:Boolean = true) {
			this.shrinkInternalArrayOnClear = shrinkInternalArrayOnClear;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function add(particle:Particle):void {
			internalArray[index++] = particle;
			
			if (index == (internalArray.length)) {
				internalArray.length *= 2;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public final function getIterator():ParticleIterator {
			return new ParticleFastArrayIterator(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public final function sort():void {
			internalArray.sortOn("x", Array.NUMERIC);
		}
		
		/**
		 * @inheritDoc
		 */
		public final function get size():int {
			return index;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function clear():void {
			for (var i:int = 0, len:int = internalArray.length; i < len; ++i) internalArray[i] = null;
			if (shrinkInternalArrayOnClear) internalArray.length = DEFAULT_ARRAY_SIZE;
			index = 0;
		}
	}
}