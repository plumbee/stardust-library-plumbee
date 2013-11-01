package idv.cjcat.stardust.twoD.geom {
	
	public class Vec2DPool {
		
		private static var _vec:Array = [new Vec2D()];
		private static var _position:int = 0;
		
		public static function get(x:Number = 0, y:Number = 0):Vec2D {
			if (_position == _vec.length) {
				_vec.length <<= 1;
				
				//trace("Vec2DPool expanded");
				
				for (var i:int = _position; i < _vec.length; i++) {
					_vec[i] = new Vec2D();
				}
			}
			_position++;
			var obj:Vec2D = _vec[_position - 1];
			obj.x = x;
			obj.y = y;
			return obj;
		}
		
		public static function recycle(obj:Vec2D):void {
			if (_position == 0) return;
			if (!obj) return;
			
			_vec[_position - 1] = obj;
			if (_position) _position--;
			
			//if (_vec.length >= 16) {
				//
				//if (_position < (_vec.length >> 4)) {
					//
					//trace("Vec2DPool contracted");
					//
					//_vec.length >>= 1;
				//}
			//}
		}
	}
}