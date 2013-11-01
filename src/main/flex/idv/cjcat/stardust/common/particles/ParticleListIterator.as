package idv.cjcat.stardust.common.particles {
	import idv.cjcat.stardust.sd;
	
	public class ParticleListIterator implements ParticleIterator {
		
		/** @private */
		internal var node:ParticleNode;
		/** @private */
		internal var list:ParticleList;
		
		public function ParticleListIterator(list:ParticleList = null) {
			this.list = list;
			reset();
		}
		
		/**
		 * @inheritDoc
		 */
		public final function reset():void {
			if (list) node = list.head;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function next():void {
			if (node) node = node.next;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function particle():Particle {
			return (Boolean(node))?(node.particle):(null);
		}
		
		/**
		 * @inheritDoc
		 */
		public final function remove():void {
			if (node) {
				if (node.prev) node.prev.next = node.next;
				if (node.next) node.next.prev = node.prev;
				if (node == list.head) list.head = node.next;
				if (node == list.tail) list.tail = node.prev;
				var temp:ParticleNode = node;
				node = node.next;
				ParticleNodePool.recycle(temp);
				
				list.count--;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public final function clone():ParticleIterator {
			var iter:ParticleListIterator = new ParticleListIterator(list);
			iter.node = node;
			return iter;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function dump(target:ParticleIterator):ParticleIterator {
			var iter:ParticleListIterator = ParticleListIterator(target);
			if (iter) {
				iter.list = list;
				iter.node = node;
			}
			return iter;
		}
	}
}