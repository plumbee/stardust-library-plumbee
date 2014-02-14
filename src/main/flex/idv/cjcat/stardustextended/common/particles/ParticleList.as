package idv.cjcat.stardustextended.common.particles {
	import idv.cjcat.stardustextended.sd;
	
	use namespace sd;
	
	/**
	 * Linked-list implementation of particle collection.
	 */
	public class ParticleList implements ParticleCollection {
		
		/** @private */
		sd var sorter:ParticleListSorter;
		
		/** @private */
		internal var count:int;
		/** @private */
		internal var head:ParticleNode;
		/** @private */
		internal var tail:ParticleNode;

        internal var _iterator : ParticleListIterator;

		public function ParticleList() {
			head = tail = null;
			count = 0;
            _iterator = new ParticleListIterator(this);
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
            _iterator.reset();
			return _iterator;
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