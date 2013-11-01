package idv.cjcat.stardust.common.particles {
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	/**
	 * Linked-list implementatoin of particle collection.
	 */
	public class ParticleList implements ParticleCollection {
		
		public static const TWO_D:Boolean = true;
		public static const THREE_D:Boolean = false;
		
		/** @private */
		sd var sorter:ParticleListSorter;
		
		/** @private */
		internal var count:int;
		/** @private */
		internal var head:ParticleNode;
		/** @private */
		internal var tail:ParticleNode;
		
		/**
		 * Creates a particle linked-list.
		 * @param	particleType Determines whether the particles contained in this list is 2D or 3D. 
		 * Pass in <code>ParticleList.TWO_D</code> for 2D particles, and <code>ParticleList.THREE_D</code> for 3D particles. 
		 * This value only affects the algorithm used for sorting particles. If you don't use actions that required sorted particles, 
		 * this value does not matter at all.
		 */
		public function ParticleList() {
			head = tail = null;
			count = 0;
			
			sorter = ParticleListSorter.getInstance();
		}
		
		private var node:ParticleNode;
		public final function add(particle:Particle):void {
			node = createNode(particle);
			if (head) {
				tail.next = node;
				node.prev = tail;
				tail = node;
			} else {
				head = tail = node;
			}
			count++;
		}
		
		/** @private */
		protected function createNode(particle:Particle):ParticleNode {
			return new ParticleNode(particle);
		}
		
		public final function clear():void {
			var node:ParticleNode;
			var iter:ParticleListIterator = ParticleListIterator(getIterator());
			while (node = iter.node) {
				ParticleNodePool.recycle(node);
				iter.next();
			}
			head = tail = null;
			count = 0;
		}
		
		public final function getIterator():ParticleIterator {
			return new ParticleListIterator(this);
		}
		
		public final function get size():int {
			return count;
		}
		
		public final function isEmpty():Boolean {
			return count == 0;
		}
		
		public final function sort():void {
			sorter.sort(this);
		}
	}
}