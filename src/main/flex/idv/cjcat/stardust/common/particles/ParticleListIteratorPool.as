package idv.cjcat.stardust.common.particles {
	
	/** @private */
	public class ParticleListIteratorPool {
		
		private static var _vec:Array = [new ParticleListIterator()];
		private static var _position:int = 0;
		
		public static function get():ParticleListIterator {
			if (_position == _vec.length) {
				_vec.length <<= 1;
				
				//trace("ParticleListIteratorPool expanded");
				
				for (var i:int = _position; i < _vec.length; i++) {
					_vec[i] = new ParticleListIterator();
				}
			}
			_position++;
			var iter:ParticleListIterator = _vec[_position - 1];
			return iter;
		}
		
		public static function recycle(iter:ParticleListIterator):void {
			if (_position == 0) return;
			iter.list = null;
			iter.node = null;
			_vec[_position - 1] = iter;
			if (_position) _position--;
			
			//if (_vec.length >= 16) {
				//if (_position < (_vec.length >> 4)) {
					//
					//trace("ParticleListIteratorPool contracted");
					//
					//_vec.length >>= 1;
				//}
			//}
		}
	}
}