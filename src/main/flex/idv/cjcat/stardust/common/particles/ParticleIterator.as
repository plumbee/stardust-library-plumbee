package idv.cjcat.stardust.common.particles {
	
	/**
	 * This interface defines the common operations shared by particle collection iterators. 
	 * An iterator is used to traverse a particle collection or remove particles from the collection.
	 */
	public interface ParticleIterator {
		
		/**
		 * The current particle.
		 */
		function particle():Particle;
		
		/**
		 * Resets the iterator to the first particle.
		 */
		function reset():void;
		
		/**
		 * Moves the iterator to the next particle.
		 */
		function next():void;
		
		function clone():ParticleIterator;
		
		/**
		 * Makes the target iterator to point to the same particle as this iterator.
		 * @param	target The dumped target.
		 */
		function dump(target:ParticleIterator):ParticleIterator;
		
		/**
		 * Removes the current particle from the list and moves the iterator to the next particle.
		 */
		function remove():void;
	}
}